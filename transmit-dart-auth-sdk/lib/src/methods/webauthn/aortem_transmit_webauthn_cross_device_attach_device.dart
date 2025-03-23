import 'dart:convert';
import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_api_client.dart';
import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_errors.dart';

/// A service class for attaching a registered device to an ongoing WebAuthn cross-device session.
///
/// This class facilitates linking a device to a session for WebAuthn-based authentication.
/// It communicates with the API client to send the required data and receive responses.
///
/// Example usage:
/// ```dart
/// final apiClient = ApiClient(apiKey: 'your-api-key');
/// final webAuthn = WebAuthnCrossDeviceAttachDevice(apiClient: apiClient);
///
/// final response = await webAuthn.attachDevice(
///   userIdentifier: 'user_123',
///   deviceId: 'device_456',
/// );
/// print(response);
/// ```
class WebAuthnCrossDeviceAttachDevice {
  /// The API client responsible for making HTTP requests.
  final ApiClient apiClient;

  /// The API endpoint for attaching a device.
  static const String endpoint = '/webauthn-cross-device-attach-device';

  /// Creates an instance of [WebAuthnCrossDeviceAttachDevice] with a required [apiClient].
  WebAuthnCrossDeviceAttachDevice({required this.apiClient});

  /// Attaches a registered device to an ongoing WebAuthn cross-device session.
  ///
  /// - [userIdentifier]: The unique identifier of the user.
  /// - [deviceId]: The unique identifier of the device.
  /// - [useMock]: If `true`, returns a mock response instead of making an actual API request.
  ///
  /// Throws an [ArgumentError] if `userIdentifier` or `deviceId` is empty.
  /// Throws an [ApiException] if the API request fails.
  ///
  /// Example:
  /// ```dart
  /// final response = await webAuthn.attachDevice(
  ///   userIdentifier: 'user_123',
  ///   deviceId: 'device_456',
  /// );
  /// print(response);
  /// ```
  Future<Map<String, dynamic>> attachDevice({
    required String userIdentifier,
    required String deviceId,
    bool useMock = false,
  }) async {
    if (userIdentifier.isEmpty || deviceId.isEmpty) {
      throw ArgumentError('User identifier and device ID cannot be empty');
    }

    if (useMock) {
      return _mockResponse();
    }

    final payload = jsonEncode({
      'userIdentifier': userIdentifier,
      'deviceId': deviceId,
    });

    try {
      final response = await apiClient.post(endpoint: endpoint, body: payload);
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw ApiException('Failed to attach device: $e');
    }
  }

  /// Returns a mock response for testing without making an actual API call.
  ///
  /// This method simulates a successful device attachment for WebAuthn cross-device authentication.
  ///
  /// Example response:
  /// ```json
  /// {
  ///   "sessionId": "mock-session-id",
  ///   "deviceId": "mock-device-id",
  ///   "status": "attached",
  ///   "message": "Device successfully attached to the session"
  /// }
  /// ```
  Map<String, dynamic> _mockResponse() {
    return {
      'sessionId': 'mock-session-id',
      'deviceId': 'mock-device-id',
      'status': 'attached',
      'message': 'Device successfully attached to the session',
    };
  }
}
