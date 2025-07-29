import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for authenticating and validating backend sessions using Transmit Security's API.
///
/// This class handles session authentication by validating existing session tokens
/// and returning updated authentication tokens with extended metadata.
///
/// ## Security Considerations
/// - Requires valid API credentials
/// - Validates session integrity server-side
/// - Implements token rotation for security
/// - Should be used with HTTPS only
/// - Session IDs should be securely stored
///
/// ## Session Authentication Flow
/// 1. Client provides valid session ID
/// 2. Service validates session and issues new tokens
/// 3. Previous tokens are invalidated (optional)
/// 4. Client receives fresh tokens with updated expiration
///
/// ## Example Usage
/// ```dart
/// final sessionAuth = AortemTransmitAuthenticateSession(
///   apiKey: 'your-api-key',
///   baseUrl: 'https://api.transmitsecurity.com',
/// );
///
/// try {
///   final tokens = await sessionAuth.authenticateSession(
///     sessionId: 'user-session-123',
///     resource: 'https://api.example.com',
///   );
///   print('New access token expires in: ${tokens['expires_in']} seconds');
/// } catch (e) {
///   print('Session authentication failed: $e');
/// }
/// ```
class AortemTransmitAuthenticateSession {
  /// The API key used for service authentication
  final String apiKey;

  /// The base URL for the session authentication API endpoint
  final String baseUrl;

  /// Creates a session authentication service instance
  ///
  /// [apiKey]: Required API key for service authentication
  /// [baseUrl]: Required base URL for the API endpoint
  AortemTransmitAuthenticateSession({
    required this.apiKey,
    required this.baseUrl,
  });

  /// Authenticates and validates an existing backend session
  ///
  /// Parameters:
  /// [sessionId]: The session identifier to authenticate (required)
  /// [resource]: Optional audience for the tokens
  /// [claims]: Additional claims to include in tokens
  /// [orgId]: Organization identifier for multi-tenant systems
  /// [clientAttributes]: Client-specific metadata
  ///
  /// Returns:
  /// A [Future] that resolves to a Map containing:
  /// - `access_token`: New short-lived access token
  /// - `id_token`: New ID token with claims
  /// - `refresh_token`: New refresh token (when applicable)
  /// - `token_type`: Typically "Bearer"
  /// - `expires_in`: Access token validity in seconds
  /// - `session_id`: Confirmed session identifier
  /// - Additional service-specific metadata
  ///
  /// Throws:
  /// - [ArgumentError] if sessionId is empty
  /// - [Exception] if authentication fails (contains status code and error details)
  Future<Map<String, dynamic>> authenticateSession({
    required String sessionId,
    String? resource,
    Map<String, dynamic>? claims,
    String? orgId,
    Map<String, dynamic>? clientAttributes,
  }) async {
    if (sessionId.isEmpty) {
      throw ArgumentError('Session ID must not be empty');
    }

    try {
      final url = Uri.parse('$baseUrl/v1/auth/session/authenticate');

      final headers = {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'X-Request-ID': DateTime.now().millisecondsSinceEpoch.toString(),
      };

      final body = <String, dynamic>{
        'session_id': sessionId,
        if (resource != null) 'resource': resource,
        if (claims != null) 'claims': claims,
        if (orgId != null) 'org_id': orgId,
        if (clientAttributes != null) 'client_attributes': clientAttributes,
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw _createAuthException(response);
      }
    } on FormatException catch (e) {
      throw Exception('Failed to parse authentication response: ${e.message}');
    } on http.ClientException catch (e) {
      throw Exception(
        'Network error during session authentication: ${e.message}',
      );
    }
  }

  /// Mock implementation for testing session authentication
  ///
  /// Simulates successful session validation without API calls.
  Future<Map<String, dynamic>> mockAuthenticateSession({
    required String sessionId,
  }) async {
    if (sessionId.isEmpty) {
      throw ArgumentError('Session ID must not be empty');
    }

    await Future.delayed(
      const Duration(milliseconds: 150),
    ); // Simulate network delay

    return {
      'access_token': 'mock_access_token_${sessionId.substring(0, 8)}',
      'id_token': 'mock_id_token_${DateTime.now().millisecondsSinceEpoch}',
      'refresh_token': 'mock_refresh_token_${sessionId.substring(0, 8)}',
      'token_type': 'Bearer',
      'expires_in': 3600,
      'session_id': sessionId,
      'scope': 'openid profile email',
    };
  }

  /// Creates a detailed exception from authentication failures
  Exception _createAuthException(http.Response response) {
    try {
      final error = jsonDecode(response.body) as Map<String, dynamic>;
      return Exception(
        'Session authentication failed (${response.statusCode}): '
        '${error['error'] ?? 'Unknown error'} - '
        '${error['error_description'] ?? 'No description provided'}',
      );
    } on FormatException {
      return Exception(
        'Session authentication failed (${response.statusCode}): ${response.body}',
      );
    }
  }
}
