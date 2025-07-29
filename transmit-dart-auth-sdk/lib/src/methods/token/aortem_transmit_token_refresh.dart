import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for handling access token refresh operations with the Transmit Security API.
///
/// This class provides functionality to refresh expired access tokens using a valid refresh token.
/// It supports both real API calls and a mock implementation for testing.
class AortemTransmitTokenRefresh {
  /// The API key used for authentication with the Transmit Security API.
  final String apiKey;

  /// The base URL of the Transmit Security API.
  final String baseUrl;

  /// The HTTP client used for making requests (dependency injection supported).
  final http.Client httpClient;

  /// Creates an instance of [AortemTransmitTokenRefresh].
  ///
  /// - Requires a non-empty [apiKey] for authentication.
  /// - Optionally accepts a custom [baseUrl] for API calls.
  /// - Optionally accepts a custom [httpClient] for testing.
  ///
  /// Throws an [ArgumentError] if [apiKey] is empty.
  AortemTransmitTokenRefresh({
    required this.apiKey,
    this.baseUrl = 'https://api.transmitsecurity.com',
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client() {
    if (apiKey.isEmpty) {
      throw ArgumentError('API key cannot be empty.');
    }
  }

  /// Refreshes the access token using the provided [refreshToken].
  ///
  /// Sends a request to the Transmit API to generate a new access token
  /// using a valid refresh token.
  ///
  /// Returns a [Map] containing:
  /// - `access_token`: The new access token
  /// - `refresh_token`: A new refresh token (if provided by the API)
  /// - `expires_in`: Token validity period in seconds
  /// - `issued_at`: The timestamp when the token was issued
  ///
  /// Throws [ArgumentError] if [refreshToken] is empty.
  /// Throws [Exception] if the API request fails.
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    if (refreshToken.isEmpty) {
      throw ArgumentError('Refresh token cannot be empty.');
    }

    final url = Uri.parse('$baseUrl/token/refresh');
    final body = json.encode({'refreshToken': refreshToken});

    final response = await httpClient.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
        'Token refresh failed (Status: ${response.statusCode}) - ${response.body}',
      );
    }
  }

  /// Mock implementation for token refresh (for testing without API calls).
  ///
  /// Returns a simulated response with:
  /// - `access_token`
  /// - `refresh_token`
  /// - `expires_in`
  /// - `issued_at`
  Future<Map<String, dynamic>> refreshTokenStub(String refreshToken) async {
    if (refreshToken.isEmpty) {
      throw ArgumentError('Refresh token cannot be empty.');
    }

    await Future.delayed(const Duration(milliseconds: 150));

    return {
      'access_token':
          'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
      'refresh_token':
          'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      'token_type': 'Bearer',
      'expires_in': 3600,
      'issued_at': DateTime.now().toIso8601String(),
    };
  }
}
