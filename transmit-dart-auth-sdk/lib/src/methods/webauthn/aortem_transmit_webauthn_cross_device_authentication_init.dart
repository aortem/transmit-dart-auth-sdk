import 'dart:convert';

import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_api_client.dart';
import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_errors.dart';

/// Handles the initiation of WebAuthn cross-device authentication.
///
/// This class interacts with the Transmit Security API to begin the WebAuthn
/// authentication flow for a user across different devices.
class WebAuthnCrossDeviceAuthInit {
  /// API client used to make HTTP requests.
  final ApiClient apiClient;

  /// API endpoint for WebAuthn cross-device authentication initialization.
  static const String endpoint = '/webauthn-cross-device-authentication-init';

  /// Constructs a new instance of [WebAuthnCrossDeviceAuthInit].
  ///
  /// - [apiClient]: An instance of `ApiClient` responsible for making requests.
  WebAuthnCrossDeviceAuthInit({required this.apiClient});

  /// Initiates WebAuthn cross-device authentication for a user.
  ///
  /// Sends a request to the Transmit Security API to start the authentication process.
  ///
  /// - [userIdentifier]: A unique identifier for the user (e.g., user ID or email).
  /// - [useMock]: If `true`, returns a mock authentication response instead of calling the API.
  ///
  /// Returns a `Map<String, dynamic>` containing the authentication challenge and session details.
  ///
  /// Throws:
  /// - `ArgumentError` if [userIdentifier] is empty.
  /// - `ApiException` if the API request fails.
  Future<Map<String, dynamic>> initiate({
    required String userIdentifier,
    bool useMock = false,
  }) async {
    if (userIdentifier.isEmpty) {
      throw ArgumentError('User identifier cannot be empty');
    }

    if (useMock) {
      return _mockResponse();
    }

    final payload = jsonEncode({'userIdentifier': userIdentifier});

    try {
      final response = await apiClient.post(endpoint: endpoint, body: payload);
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw ApiException(
        'Failed to initiate WebAuthn cross-device authentication: $e',
      );
    }
  }

  /// Generates a mock response for WebAuthn cross-device authentication.
  ///
  /// Used for testing purposes when [useMock] is enabled.
  ///
  /// Returns a `Map<String, dynamic>` containing a simulated authentication challenge.
  Map<String, dynamic> _mockResponse() {
    return {
      'challenge': 'mock-challenge',
      'sessionId': 'mock-session-id',
      'timeout': 300000, // Timeout in milliseconds (5 minutes)
      'allowedCredentials': ['mock-credential-id'],
    };
  }
}
