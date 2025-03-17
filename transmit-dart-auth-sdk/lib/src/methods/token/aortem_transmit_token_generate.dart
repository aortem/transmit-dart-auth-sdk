import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service class for handling token issuance via Transmit Security.
class AortemTransmitToken {
  /// The API key required for authentication with Transmit Security.
  final String apiKey;

  /// The base URL of the Transmit Security API.
  ///
  /// Defaults to `'https://api.transmitsecurity.com'`.
  final String baseUrl;

  /// Creates an instance of [AortemTransmitToken].
  ///
  /// - Requires a non-empty [apiKey].
  /// - Optionally accepts a custom [baseUrl] for API calls.
  ///
  /// Throws an [ArgumentError] if [apiKey] is empty.
  AortemTransmitToken({
    required this.apiKey,
    this.baseUrl = 'https://api.transmitsecurity.com',
  }) {
    if (apiKey.isEmpty) {
      throw ArgumentError('API key cannot be empty.');
    }
  }

  /// Issues a new authentication token using the provided [clientId] and [clientSecret].
  ///
  /// This method sends a request to the Transmit Security API to generate a new access token.
  ///
  /// Returns a `Map<String, dynamic>` containing:
  /// - `token`: The issued access token.
  /// - `tokenType`: The type of the token (e.g., `Bearer`).
  /// - `expiresIn`: The expiration duration of the token in seconds.
  /// - `issuedAt`: The timestamp of issuance.
  ///
  /// Throws:
  /// - [ArgumentError] if [clientId] or [clientSecret] is empty.
  /// - [Exception] if the API request fails with a non-200 status code.
  Future<Map<String, dynamic>> issueToken(String clientId, String clientSecret) async {
    if (clientId.isEmpty || clientSecret.isEmpty) {
      throw ArgumentError('Client ID and Client Secret cannot be empty.');
    }

    final url = Uri.parse('$baseUrl/token/issue');
    final body = {
      'clientId': clientId,
      'clientSecret': clientSecret,
      // Optionally, specify token type or other parameters.
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
      throw Exception('Token issuance failed: ${response.statusCode} ${response.body}');
    }
  }

  /// A stub implementation that simulates token issuance.
  ///
  /// This method does not make an actual API request. Instead, it returns
  /// pre-defined mock data to mimic a valid response.
  ///
  /// Returns a `Map<String, dynamic>` containing:
  /// - `token`: A mock issued token.
  /// - `tokenType`: The type of the token (`Bearer`).
  /// - `expiresIn`: The duration in seconds before expiration.
  /// - `issuedAt`: The timestamp of issuance.
  ///
  /// Throws:
  /// - [ArgumentError] if [clientId] or [clientSecret] is empty.
  Future<Map<String, dynamic>> issueTokenStub(String clientId, String clientSecret) async {
    if (clientId.isEmpty || clientSecret.isEmpty) {
      throw ArgumentError('Client ID and Client Secret cannot be empty.');
    }

    // Simulate network latency.
    await Future.delayed(Duration(milliseconds: 100));

    // Return mock token issuance data.
    return {
      'token': 'dummy-issued-token',
      'tokenType': 'Bearer',
      'expiresIn': 3600, // e.g., 1 hour in seconds.
      'issuedAt': DateTime.now().toIso8601String(),
    };
  }
}
