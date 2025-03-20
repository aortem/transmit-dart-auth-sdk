import 'dart:convert';
import '../../core/aortem_transmit_api_client.dart';
import '../../core/aortem_transmit_errors.dart';

/// A service class for retrieving the status of a WebAuthn cross-device authentication or registration operation.
///
/// This class communicates with the API client to check the current status of an ongoing
/// WebAuthn authentication or registration session.
///
/// Example usage:
/// ```dart
/// final apiClient = ApiClient(apiKey: 'your-api-key');
/// final webAuthnStatus = WebAuthnCrossDeviceStatus(apiClient: apiClient);
///
/// final response = await webAuthnStatus.getStatus(userIdentifier: 'user_123');
/// print(response);
/// ```
class WebAuthnCrossDeviceStatus {
  /// The API client responsible for making HTTP requests.
  final ApiClient apiClient;

  /// The API endpoint for retrieving WebAuthn cross-device authentication status.
  static const String endpoint = '/webauthn-cross-device-status';

  /// Creates an instance of [WebAuthnCrossDeviceStatus] with a required [apiClient].
  WebAuthnCrossDeviceStatus({required this.apiClient});

  /// Retrieves the current status of a WebAuthn cross-device authentication or registration operation.
  ///
  /// - [userIdentifier]: The unique identifier of the user.
  /// - [sessionId]: (Optional) The session ID for a specific authentication process.
  /// - [useMock]: If `true`, returns a mock response instead of making an actual API request.
  ///
  /// Throws an [ArgumentError] if `userIdentifier` is empty.
  /// Throws an [ApiException] if the API request fails.
  ///
  /// Example:
  /// ```dart
  /// final response = await webAuthnStatus.getStatus(
  ///   userIdentifier: 'user_123',
  ///   sessionId: 'session_456',
  /// );
  /// print(response);
  /// ```
  Future<Map<String, dynamic>> getStatus({
    required String userIdentifier,
    String? sessionId,
    bool useMock = false,
  }) async {
    if (userIdentifier.isEmpty) {
      throw ArgumentError('User identifier cannot be empty');
    }

    if (useMock) {
      return _mockResponse();
    }

    final queryParams = {
      'userIdentifier': userIdentifier,
      if (sessionId != null) 'sessionId': sessionId,
    };

    final url = '$endpoint?${Uri(queryParameters: queryParams).query}';

    try {
      final response = await apiClient.get(endpoint: url);
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw ApiException('Failed to retrieve cross-device status: $e');
    }
  }

  /// Returns a mock response for testing without making an actual API call.
  ///
  /// This method simulates the response for an ongoing WebAuthn cross-device authentication process.
  ///
  /// Example response:
  /// ```json
  /// {
  ///   "sessionId": "mock-session-id",
  ///   "status": "pending",
  ///   "expiresIn": 300,
  ///   "message": "Waiting for user authentication"
  /// }
  /// ```
  Map<String, dynamic> _mockResponse() {
    return {
      'sessionId': 'mock-session-id',
      'status': 'pending',
      'expiresIn': 300,
      'message': 'Waiting for user authentication',
    };
  }
}
