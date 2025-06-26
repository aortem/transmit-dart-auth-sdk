import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for handling access token refresh operations with the Transmit Security API.
///
/// This class provides functionality to refresh expired access tokens using a valid refresh token.
class AortemTransmitTokenRefresh {
  /// The API key used for authentication with the Transmit Security API.
  final String apiKey;

  /// The base URL of the Transmit Security API.
  ///
  /// Defaults to `'https://api.transmitsecurity.com'`.
  final String baseUrl;

  /// Creates an instance of [AortemTransmitTokenRefresh].
  ///
  /// - Requires a non-empty [apiKey] for authentication.
  /// - Optionally accepts a custom [baseUrl] for API calls.
  ///
  /// Throws an [ArgumentError] if [apiKey] is empty.
  AortemTransmitTokenRefresh({
    required this.apiKey,
    this.baseUrl = 'https://api.transmitsecurity.com',
  }) {
    if (apiKey.isEmpty) {
      throw ArgumentError('API key cannot be empty.');
    }
  }

  /// Refreshes the access token using the provided [refreshToken].
  ///
  /// This method sends a request to the Transmit API to generate a new access token
  /// using a valid refresh token.
  ///
  /// Returns a `Map<String, dynamic>` containing:
  /// - `accessToken`: The new access token.
  /// - `refreshToken`: A new refresh token (if provided by the API).
  /// - `expiresIn`: The validity period of the access token in seconds.
  /// - `issuedAt`: The timestamp when the token was issued.
  ///
  /// Throws:
  /// - [ArgumentError] if [refreshToken] is empty.
  /// - [Exception] if the API request fails.
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    if (refreshToken.isEmpty) {
      throw ArgumentError('Refresh token cannot be empty.');
    }

    final url = Uri.parse('$baseUrl/token/refresh');
    final body = {'refreshToken': refreshToken};

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
        'Token refresh failed: ${response.statusCode} ${response.body}',
      );
    }
  }

  /// Simulates the token refresh process without making an actual API call.
  ///
  /// This method is useful for testing purposes and returns a dummy response
  /// representing a refreshed access token.
  ///
  /// Returns a `Map<String, dynamic>` with:
  /// - `accessToken`: A placeholder new access token.
  /// - `refreshToken`: A placeholder new refresh token.
  /// - `expiresIn`: Token expiration time in seconds (e.g., `3600` for 1 hour).
  /// - `issuedAt`: The timestamp when the new token was issued.
  ///
  /// Throws an [ArgumentError] if [refreshToken] is empty.
  Future<Map<String, dynamic>> refreshTokenStub(String refreshToken) async {
    if (refreshToken.isEmpty) {
      throw ArgumentError('Refresh token cannot be empty.');
    }

    // Simulate network latency.
    await Future.delayed(Duration(milliseconds: 100));

    // Return dummy token refresh data.
    return {
      'accessToken': 'dummy-new-access-token',
      'refreshToken': 'dummy-new-refresh-token',
      'expiresIn': 3600, // e.g., 1 hour in seconds.
      'issuedAt': DateTime.now().toIso8601String(),
    };
  }
}
