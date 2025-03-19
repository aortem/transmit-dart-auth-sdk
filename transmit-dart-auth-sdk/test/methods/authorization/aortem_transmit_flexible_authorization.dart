import 'dart:convert';
import 'package:http/http.dart'
    as http; // Ensure the correct HTTP package is used

/// A service class for handling authorization with the Transmit Security API.
///
/// This class allows verification of access tokens and scopes to ensure
/// proper authorization when interacting with the Transmit Security platform.
class AortemTransmitAuthorization {
  /// The API key required for authentication with the Transmit Security API.
  final String apiKey;

  /// The base URL of the Transmit Security API.
  ///
  /// Defaults to `'https://api.transmitsecurity.com'`.
  final String baseUrl;

  /// Creates an instance of [AortemTransmitAuthorization].
  ///
  /// - Requires a non-empty [apiKey] for authentication.
  /// - Optionally accepts a custom [baseUrl] for API calls.
  ///
  /// Throws an [ArgumentError] if [apiKey] is empty.
  AortemTransmitAuthorization(
      {required this.apiKey,
      this.baseUrl = 'https://api.transmitsecurity.com'}) {
    if (apiKey.isEmpty) {
      throw ArgumentError('API key cannot be empty.');
    }
  }

  /// Authorizes a user by verifying their access token.
  ///
  /// Sends a request to the Transmit Security API to check if the provided
  /// [accessToken] is valid. Optionally, required [requiredScopes] can be
  /// provided to ensure the token grants permission for specific actions.
  ///
  /// Returns a `Map<String, dynamic>` containing:
  /// - `valid`: A boolean indicating if the token is valid.
  /// - `userId`: The ID of the authenticated user (if applicable).
  /// - `scopes`: A list of scopes granted to the user.
  ///
  /// Throws:
  /// - [ArgumentError] if [accessToken] is empty.
  /// - [Exception] if authorization fails due to invalid credentials or API errors.
  Future<Map<String, dynamic>> authorize(String accessToken,
      {List<String>? requiredScopes}) async {
    if (accessToken.isEmpty) {
      throw ArgumentError('Access token cannot be empty.');
    }

    final url = Uri.parse('$baseUrl/authorize');
    final body = {
      'accessToken': accessToken,
      if (requiredScopes != null) 'scopes': requiredScopes,
    };

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
          'Authorization failed: ${response.statusCode} ${response.body}');
    }
  }
}
