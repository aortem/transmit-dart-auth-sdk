import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for handling authorization requests with Transmit Security's API.
///
/// This class provides functionality to:
/// - Validate access tokens
/// - Check scope permissions
/// - Mock authorization for testing
///
/// Example Usage:
/// ```dart
/// final authService = AortemTransmitAuthorization(
///   apiKey: 'your-api-key-here',
/// );
///
/// try {
///   final result = await authService.authorize(
///     'user-access-token',
///     requiredScopes: ['read:profile', 'write:settings'],
///   );
///   print('Authorization successful: ${result['authorized']}');
/// } catch (e) {
///   print('Authorization failed: $e');
/// }
/// ```
class AortemTransmitAuthorization {
  /// The API key used for authenticating with Transmit Security's services
  ///
  /// Must be a non-empty string. The constructor will throw an [ArgumentError]
  /// if this is empty.
  final String apiKey;

  /// The base URL for the authorization API endpoint
  ///
  /// Defaults to 'https://api.transmitsecurity.com' but can be customized
  /// for testing or different environments.
  final String baseUrl;

  /// Creates an authorization service instance
  ///
  /// Parameters:
  /// - [apiKey]: Required API key for authentication
  /// - [baseUrl]: Optional base URL (defaults to production endpoint)
  ///
  /// Throws:
  /// - [ArgumentError] if apiKey is empty
  AortemTransmitAuthorization({
    required this.apiKey,
    this.baseUrl = 'https://api.transmitsecurity.com',
  }) {
    if (apiKey.isEmpty) {
      throw ArgumentError('API key cannot be empty.');
    }
  }

  /// Validates an access token and checks required permissions
  ///
  /// This method verifies:
  /// - Token validity
  /// - Token expiration
  /// - Required scope permissions (if specified)
  ///
  /// Parameters:
  /// - [accessToken]: The access token to validate (must not be empty)
  /// - [requiredScopes]: Optional list of required scopes to check
  ///
  /// Returns:
  /// - A [Future] that resolves to a [Map] containing:
  ///   - success: bool indicating overall success
  ///   - valid: bool indicating token validity
  ///   - authorized: bool indicating scope authorization
  ///   - userId: string identifier of authenticated user
  ///   - grantedScopes: list of authorized scopes
  ///   - expiresAt: ISO-8601 timestamp of token expiration
  ///
  /// Throws:
  /// - [ArgumentError] if accessToken is empty
  /// - [Exception] with details if authorization fails (403 for insufficient permissions)
  Future<Map<String, dynamic>> authorize(
    String accessToken, {
    List<String>? requiredScopes,
  }) async {
    if (accessToken.isEmpty) {
      throw ArgumentError('Access token cannot be empty.');
    }

    final url = Uri.parse('$baseUrl/authorize');
    final body = {
      'accessToken': accessToken,
      if (requiredScopes != null && requiredScopes.isNotEmpty)
        'requiredScopes': requiredScopes,
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
    } else if (response.statusCode == 403) {
      throw Exception(
        'Authorization failed: Insufficient permissions or token expired. ${response.body}',
      );
    } else {
      throw Exception(
        'Authorization failed: ${response.statusCode} ${response.body}',
      );
    }
  }

  /// Mock implementation for testing authorization flows
  ///
  /// Simulates successful authorization with configurable scopes.
  /// Includes a simulated delay to mimic network latency.
  ///
  /// Parameters:
  /// - [accessToken]: The access token to validate (must not be empty)
  /// - [requiredScopes]: Optional list of scopes to return in response
  ///
  /// Returns:
  /// - A [Future] that resolves after a short delay with mock authorization data:
  ///   - success: true
  ///   - valid: true
  ///   - authorized: true
  ///   - userId: 'mock-user-12345'
  ///   - grantedScopes: the requiredScopes or ['default:scope'] if none provided
  ///   - expiresAt: 1 hour from current time
  ///
  /// Throws:
  /// - [ArgumentError] if accessToken is empty
  Future<Map<String, dynamic>> mockAuthorize(
    String accessToken, {
    List<String>? requiredScopes,
  }) async {
    if (accessToken.isEmpty) {
      throw ArgumentError('Access token cannot be empty.');
    }

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 150));

    return {
      'success': true,
      'valid': true,
      'authorized': true,
      'userId': 'mock-user-12345',
      'grantedScopes': requiredScopes ?? ['default:scope'],
      'expiresAt': DateTime.now()
          .add(const Duration(hours: 1))
          .toIso8601String(),
    };
  }
}
