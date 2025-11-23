import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for managing backend authentication sessions including logout functionality.
///
/// This class provides secure session termination capabilities through Transmit Security's API,
/// allowing for explicit invalidation of backend authentication sessions.
///
/// ## Security Considerations
/// - Requires both session token and API key for authentication
/// - Immediately invalidates the session on successful logout
/// - Should be used with HTTPS only
/// - Log all logout operations for audit purposes
///
/// ## Example Usage
/// ```dart
/// final sessionManager = BackendSessionManager(
///   apiKey: 'your-api-key',
///   baseUrl: 'https://api.transmitsecurity.com',
/// );
///
/// try {
///   final result = await sessionManager.logoutBackendSession(
///     sessionToken: 'user-session-token-123',
///   );
///   print('Logout successful: ${result['message']}');
/// } catch (e) {
///   print('Logout failed: $e');
/// }
/// ```
class AortemTransmitLogoutBackendSession {
  /// The API key used for service authentication
  final String apiKey;

  /// The base URL for the session management API
  final String baseUrl;

  /// Creates a backend session manager instance
  ///
  /// [apiKey]: Required API key for service authentication
  /// [baseUrl]: Required base URL for the API endpoints
  AortemTransmitLogoutBackendSession({
    required this.apiKey,
    required this.baseUrl,
  });

  /// Terminates a backend authentication session
  ///
  /// This operation immediately invalidates the specified session token,
  /// preventing any further use of that token for authentication.
  ///
  /// Parameters:
  /// [sessionToken]: The session token to invalidate (must not be empty)
  ///
  /// Returns:
  /// A [Future] that resolves to a Map containing:
  /// - `success`: Operation status boolean
  /// - `message`: Human-readable result message
  /// - `logoutTimestamp`: ISO-8601 timestamp of logout
  /// - Additional service-specific metadata
  ///
  /// Throws:
  /// - [ArgumentError] if sessionToken is empty
  /// - [Exception] if logout fails (contains status code and error details)
  Future<Map<String, dynamic>> logoutBackendSession({
    required String sessionToken,
  }) async {
    if (sessionToken.isEmpty) {
      throw ArgumentError('Session token must not be empty');
    }

    try {
      final url = Uri.parse('$baseUrl/v1/auth/sessions/logout');

      final headers = {
        'Authorization': 'Bearer $sessionToken',
        'x-api-key': apiKey,
        'Content-Type': 'application/json',
        'X-Request-ID': DateTime.now().millisecondsSinceEpoch.toString(),
      };

      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw _createLogoutException(response);
      }
    } on FormatException catch (e) {
      throw Exception('Failed to parse logout response: ${e.message}');
    } on http.ClientException catch (e) {
      throw Exception('Network error during logout: ${e.message}');
    }
  }

  /// Mock implementation for testing backend session logout
  ///
  /// Simulates successful logout without making actual API calls.
  Future<Map<String, dynamic>> mockLogoutBackendSession({
    required String sessionToken,
  }) async {
    if (sessionToken.isEmpty) {
      throw ArgumentError('Session token must not be empty');
    }

    await Future.delayed(
      const Duration(milliseconds: 150),
    ); // Simulate network delay

    return {
      'success': true,
      'message': 'Session logged out successfully (mock)',
      'logoutTimestamp': DateTime.now().toIso8601String(),
      'session_id': 'mock-session-${sessionToken.substring(0, 5)}',
    };
  }

  /// Creates a detailed exception from logout failures
  Exception _createLogoutException(http.Response response) {
    try {
      final error = jsonDecode(response.body) as Map<String, dynamic>;
      return Exception(
        'Logout failed (${response.statusCode}): '
        '${error['error'] ?? 'Unknown error'} - '
        '${error['error_description'] ?? 'No description provided'}',
      );
    } on FormatException {
      return Exception(
        'Logout failed (${response.statusCode}): ${response.body}',
      );
    }
  }
}
