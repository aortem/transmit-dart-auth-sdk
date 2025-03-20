import 'dart:convert';

import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_api_client.dart';
import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_errors.dart';

/// Initiates WebAuthn cross-device authentication for a user.
///
/// This class sends a request to the Transmit Security API to begin
/// the WebAuthn authentication process for a given user.
class WebAuthnCrossDeviceAuthenticateStart {
  /// API client used for making HTTP requests.
  final ApiClient apiClient;

  /// Constructs an instance of [WebAuthnCrossDeviceAuthenticateStart].
  ///
  /// - [apiClient]: An instance of `ApiClient` for API communication.
  WebAuthnCrossDeviceAuthenticateStart(this.apiClient);

  /// Starts the WebAuthn cross-device authentication process.
  ///
  /// - [userId]: The unique identifier of the user.
  /// - [mock]: If `true`, returns a mock authentication response.
  ///
  /// Returns a `Map<String, dynamic>` containing the authentication challenge,
  /// session details, and allowed credentials.
  ///
  /// Throws:
  /// - `ArgumentError` if [userId] is empty.
  /// - `ApiException` if the API request fails.
  Future<Map<String, dynamic>> startAuthentication({
    required String userId,
    bool mock = false,
  }) async {
    if (userId.isEmpty) {
      throw ArgumentError('User ID cannot be empty.');
    }

    if (mock) {
      return _mockResponse();
    }

    const String endpoint = '/webauthn-cross-device-authenticate-start';
    final String body = jsonEncode({'userId': userId});

    try {
      final response = await apiClient.post(endpoint: endpoint, body: body);
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw ApiException(
          responseData['error'] ?? 'Unknown error occurred',
          response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException('Failed to start WebAuthn authentication: $e');
    }
  }

  /// Generates a mock response for WebAuthn authentication.
  ///
  /// Used for testing purposes when [mock] is enabled.
  ///
  /// Returns a `Map<String, dynamic>` containing a simulated authentication challenge.
  Map<String, dynamic> _mockResponse() {
    return {
      'status': 'success',
      'challenge': 'mock-challenge-123',
      'sessionId': 'mock-session-456',
      'timeout': 60000, // Timeout in milliseconds (1 minute)
      'allowedCredentials': ['mock-credential-789'],
    };
  }
}
