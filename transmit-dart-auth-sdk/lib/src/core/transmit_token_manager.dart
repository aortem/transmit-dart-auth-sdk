import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for managing token reference operations with the Transmit Security API.
///
/// This class provides methods to interact with Transmit Security's token management
/// endpoints, including retrieving token details and validating tokens through
/// introspection. It also includes a mock implementation for testing purposes.
///
/// Example usage:
/// ```dart
/// final tokenManager = AortemTransmitTokenManager(
///   apiKey: 'your-api-key-here',
///   baseUrl: 'https://api.transmitsecurity.com',
/// );
///
/// final details = await tokenManager.getTokenDetails('user-token-123');
/// ```
class AortemTransmitTokenManager {
  /// The API key used for authenticating with Transmit Security's services.
  ///
  /// This key should be kept secure and not exposed in client-side code.
  /// The constructor will throw an [ArgumentError] if this is empty.
  final String apiKey;

  /// The base URL for the Transmit Security API endpoints.
  ///
  /// Defaults to 'https://api.transmitsecurity.com' if not specified.
  final String baseUrl;

  /// Creates a new [AortemTransmitTokenManager] instance.
  ///
  /// Throws an [ArgumentError] if the [apiKey] is empty.
  ///
  /// [apiKey]: Required API key for authentication
  /// [baseUrl]: Optional base URL for the API (defaults to production endpoint)
  AortemTransmitTokenManager({
    required this.apiKey,
    this.baseUrl = 'https://api.transmitsecurity.com',
  }) {
    if (apiKey.isEmpty) {
      throw ArgumentError("API key cannot be empty.");
    }
  }

  /// Retrieves metadata and details about a specific token.
  ///
  /// This method calls the Transmit Security API to fetch information about
  /// the provided token. The token must be a valid, non-empty string.
  ///
  /// Throws:
  /// - [ArgumentError] if the token is empty
  /// - [Exception] if the API request fails
  ///
  /// [token]: The token to retrieve details for
  /// Returns: A [Map] containing the token details
  Future<Map<String, dynamic>> getTokenDetails(String token) async {
    if (token.isEmpty) {
      throw ArgumentError("Token must not be empty.");
    }

    final url = Uri.parse('$baseUrl/tokens/$token');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        "Failed to retrieve token details: ${response.statusCode} - ${response.body}",
      );
    }
  }

  /// Validates a token and returns its claims through introspection.
  ///
  /// This method verifies whether a token is still valid and returns its
  /// associated claims. The token must be a valid, non-empty string.
  ///
  /// Throws:
  /// - [ArgumentError] if the token is empty
  /// - [Exception] if the API request fails
  ///
  /// [token]: The token to introspect
  /// Returns: A [Map] containing the token claims and validity status
  Future<Map<String, dynamic>> introspectToken(String token) async {
    if (token.isEmpty) {
      throw ArgumentError("Token must not be empty.");
    }

    final url = Uri.parse('$baseUrl/tokens/introspect');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'token': token}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        "Failed to introspect token: ${response.statusCode} - ${response.body}",
      );
    }
  }

  /// Provides mock token details for local development and testing.
  ///
  /// This method returns a consistent set of mock data that simulates a valid
  /// token response without making actual API calls.
  ///
  /// Throws:
  /// - [ArgumentError] if the token is empty
  ///
  /// [token]: The token to mock details for
  /// Returns: A [Map] containing mock token details
  Future<Map<String, dynamic>> mockTokenDetails(String token) async {
    if (token.isEmpty) {
      throw ArgumentError("Token must not be empty.");
    }

    return {
      'token': token,
      'active': true,
      'type': 'user_access_token',
      'userId': 'mock-user-123',
      'expiresAt': DateTime.now().add(Duration(hours: 1)).toIso8601String(),
      'scopes': ['read:users', 'write:users'],
    };
  }
}
