import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Handles authentication using Transmit Security's magic link tokens.
///
/// This service verifies magic link tokens and exchanges them for
/// access tokens that can be used to authenticate users.
/// Includes both production and stub implementations for testing.
///
/// Example Usage:
/// ```dart
/// final authService = AortemTransmitAuthenticateMagicLink(
///   apiKey: 'your-api-key-here',
/// );
///
/// try {
///   final authResult = await authService.authenticateMagicLink('token-from-email');
///   print('Authenticated! Access token: ${authResult['accessToken']}');
/// } catch (e) {
///   print('Authentication failed: $e');
/// }
/// ```
class AortemTransmitAuthenticateMagicLink {
  /// The API key used to authenticate with Transmit Security's services.
  ///
  /// Must be a non-empty string. The constructor will throw an [ArgumentError]
  /// if this is empty.
  final String apiKey;

  /// The base URL for Transmit Security's API endpoints.
  ///
  /// Defaults to 'https://api.transmitsecurity.com' but can be customized
  /// for testing or different environments.
  final String baseUrl;

  /// Creates a magic link authentication service instance.
  ///
  /// Parameters:
  /// - [apiKey]: Required API key for authentication (must not be empty)
  /// - [baseUrl]: Optional base URL (defaults to production endpoint)
  ///
  /// Throws:
  /// - [ArgumentError] if apiKey is empty
  AortemTransmitAuthenticateMagicLink({
    required this.apiKey,
    this.baseUrl = 'https://api.transmitsecurity.com',
  }) {
    if (apiKey.isEmpty) {
      throw ArgumentError('API key cannot be empty.');
    }
  }

  /// Authenticates a user using a magic link token.
  ///
  /// This method verifies the provided token with Transmit Security's backend
  /// and returns authentication tokens if successful.
  ///
  /// Parameters:
  /// - [magicLinkToken]: The one-time use token from the magic link email
  ///
  /// Returns:
  /// - A [Future] that resolves to a [Map] containing:
  ///   - accessToken: The bearer token for API requests
  ///   - idToken: The user identity token
  ///   - expiresIn: Token validity duration in seconds
  ///   - Other authentication metadata
  ///
  /// Throws:
  /// - [ArgumentError] if magicLinkToken is empty
  /// - [Exception] if authentication fails (contains status code and error details)
  Future<Map<String, dynamic>> authenticateMagicLink(
    String magicLinkToken,
  ) async {
    if (magicLinkToken.isEmpty) {
      throw ArgumentError('Magic link token cannot be empty.');
    }

    final url = Uri.parse(
      '$baseUrl/backend-one-time-login/authenticateMagicLink',
    );
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode({'magicLinkToken': magicLinkToken}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
        'Authenticate Magic Link failed: ${response.statusCode} ${response.body}',
      );
    }
  }

  /// Testing stub that simulates magic link authentication.
  ///
  /// Mimics the production flow without making actual API calls:
  /// - Validates input parameters
  /// - Simulates network latency
  /// - Returns consistent mock authentication data
  ///
  /// Parameters:
  /// - [magicLinkToken]: The token to validate (must not be empty)
  ///
  /// Returns:
  /// - A [Future] that resolves after a short delay with mock auth data:
  ///   - accessToken: 'mock-access-token'
  ///   - idToken: 'mock-id-token'
  ///   - expiresIn: 3600
  ///   - message: Success confirmation
  ///
  /// Throws:
  /// - [ArgumentError] if magicLinkToken is empty
  Future<Map<String, dynamic>> authenticateMagicLinkStub(
    String magicLinkToken,
  ) async {
    if (magicLinkToken.isEmpty) {
      throw ArgumentError('Magic link token cannot be empty.');
    }

    await Future.delayed(const Duration(milliseconds: 100));

    return {
      'accessToken': 'mock-access-token',
      'idToken': 'mock-id-token',
      'expiresIn': 3600,
      'message': 'Magic link authentication successful (stub).',
    };
  }
}

/// Simple stub for testing without API calls
Future<Map<String, dynamic>> mockCall({
  required Map<String, dynamic> credentialResponse,
}) async {
  if (credentialResponse.isEmpty) {
    throw ArgumentError('Credential response cannot be empty');
  }

  await Future.delayed(const Duration(milliseconds: 200));

  return {
    'access_token': 'mock_access_token',
    'id_token': 'mock_id_token',
    'refresh_token': 'mock_refresh_token',
    'expires_in': 3600,
  };
}
