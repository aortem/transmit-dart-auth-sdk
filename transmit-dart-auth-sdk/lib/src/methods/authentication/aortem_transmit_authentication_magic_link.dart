import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A class responsible for authenticating users via magic link tokens.
///
/// This class provides methods to send authentication requests to the
/// Transmit Security API using a magic link token.
///
/// Example usage:
/// ```dart
/// final auth = TransmitMagicLinkAuth(apiKey: 'your-api-key');
/// final response = await auth.authenticateMagicLink('your-magic-link-token');
/// print(response);
/// ```
class TransmitMagicLinkAuth {
  /// The API key used for authenticating requests.
  final String apiKey;

  /// The base URL of the Transmit Security API.
  ///
  /// Defaults to `'https://api.transmitsecurity.com'`.
  final String baseUrl;

  /// The HTTP client used for making requests.
  ///
  /// This allows dependency injection for testing purposes.
  final http.Client httpClient;

  /// Creates an instance of `TransmitMagicLinkAuth`.
  ///
  /// - [apiKey]: The API key for authentication (required).
  /// - [baseUrl]: The base URL of the API (optional, defaults to Transmit Security API).
  /// - [httpClient]: A custom HTTP client for testing (optional).
  ///
  /// Throws an [ArgumentError] if the provided [apiKey] is empty.
  TransmitMagicLinkAuth({
    required this.apiKey,
    this.baseUrl = 'https://api.transmitsecurity.com',
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client() {
    if (apiKey.isEmpty) {
      throw ArgumentError('API key cannot be empty.');
    }
  }

  /// Authenticates a user using a magic link token.
  ///
  /// Sends a `POST` request to the Transmit Security API to verify the magic link token
  /// and retrieve authentication details.
  ///
  /// - [magicLinkToken]: The magic link token received via email (required).
  ///
  /// Returns a `Map<String, dynamic>` containing authentication details,
  /// including access tokens and session metadata.
  ///
  /// Example response:
  /// ```json
  /// {
  ///   "accessToken": "mock-access-token",
  ///   "idToken": "mock-id-token",
  ///   "expiresIn": 3600,
  ///   "message": "Magic link authentication successful."
  /// }
  /// ```
  ///
  /// Throws an [ArgumentError] if the [magicLinkToken] is empty.
  /// Throws an [Exception] if the API request fails with an error response.
  Future<Map<String, dynamic>> authenticateMagicLink(
    String magicLinkToken,
  ) async {
    if (magicLinkToken.isEmpty) {
      throw ArgumentError('Magic link token cannot be empty.');
    }

    final url = Uri.parse(
      '$baseUrl/backend-one-time-login/authenticateMagicLink',
    );

    final response = await httpClient.post(
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
        'Authentication failed: ${response.statusCode} ${response.body}',
      );
    }
  }
}
