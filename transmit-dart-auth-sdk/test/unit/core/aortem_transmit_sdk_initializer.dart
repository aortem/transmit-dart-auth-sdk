import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart'
    as http; // Ensure the correct HTTP package is used

/// A service class for handling authentication with the Transmit Security API.
///
/// This class provides methods to authenticate users using an API key.
/// It sends credentials to the authentication endpoint and retrieves an
/// authentication token upon successful login.
class AortemTransmitAuth {
  /// The API key required for authentication with the Transmit Security API.
  final String apiKey;

  /// The base URL of the Transmit Security API.
  ///
  /// Defaults to `'https://api.transmitsecurity.com'`.
  final String baseUrl;

  /// The HTTP client used for making requests.
  ///
  /// This allows dependency injection for testing and flexibility.
  final http.Client client;

  /// Creates an instance of [AortemTransmitAuth].
  ///
  /// - Requires a non-empty [apiKey] for authentication.
  /// - Optionally accepts a custom [baseUrl] for API calls.
  /// - Allows dependency injection of an HTTP [client] for testing.
  ///
  /// Throws an [ArgumentError] if [apiKey] is empty.
  AortemTransmitAuth({
    required this.apiKey,
    this.baseUrl = 'https://api.transmitsecurity.com',
    http.Client? client, // Optional client for mocking in tests
  }) : client = client ?? http.Client() {
    if (apiKey.isEmpty) {
      throw ArgumentError('API key cannot be empty.');
    }
  }

  /// Authenticates a user with the provided [username] and [password].
  ///
  /// Sends a POST request to the Transmit Security authentication endpoint
  /// and returns a `Map<String, dynamic>` containing authentication details:
  /// - `token`: The authentication token upon successful login.
  /// - `userId`: The ID of the authenticated user.
  /// - Other metadata related to authentication.
  ///
  /// Throws:
  /// - [ArgumentError] if [username] or [password] is empty.
  /// - [Exception] if authentication fails (e.g., invalid credentials or API errors).
  Future<Map<String, dynamic>> authenticate(
    String username,
    String password,
  ) async {
    if (username.isEmpty || password.isEmpty) {
      throw ArgumentError('Username and password cannot be empty.');
    }

    final url = Uri.parse('$baseUrl/authenticate');
    final response = await client.post(
      // Use client.post instead of http.post to allow mocking
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Authentication failed: ${response.body}');
    }
  }
}
