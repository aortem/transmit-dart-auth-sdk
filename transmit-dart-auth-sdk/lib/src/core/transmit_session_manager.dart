import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for managing user authentication sessions including retrieval and revocation.
///
/// This class provides functionality to:
/// - List all active sessions for a user
/// - Revoke all active sessions for security purposes
/// - Mock implementations for testing environments
///
/// ## Security Considerations
/// - Requires valid API credentials
/// - Performs sensitive session operations
/// - Should be used with HTTPS only
/// - Log all session management operations
///
/// ## Example Usage
/// ```dart
/// final sessionManager = UserSessionManager(
///   apiKey: 'your-api-key',
///   baseUrl: 'https://api.example.com',
/// );
///
/// // Get active sessions
/// final sessions = await sessionManager.getUserSessions(userId: 'user123');
///
/// // Revoke all sessions
/// final result = await sessionManager.revokeUserSessions(userId: 'user123');
/// ```
class UserSessionManager {
  /// The API key used for authentication
  final String apiKey;

  /// The base URL for the session management API
  final String baseUrl;

  /// Creates a session manager instance
  ///
  /// [apiKey]: Required API key for authentication
  /// [baseUrl]: Required base URL for the API endpoints
  UserSessionManager({required this.apiKey, required this.baseUrl});

  /// Retrieves all active sessions for a specified user
  ///
  /// Parameters:
  /// [userId]: The unique identifier of the target user (required)
  ///
  /// Returns:
  /// A [Future] that resolves to a List of session Maps containing:
  /// - `session_id`: Unique session identifier
  /// - `device`: Device information
  /// - `ip_address`: Last known IP address
  /// - `last_active`: ISO-8601 timestamp of last activity
  /// - Additional session metadata
  ///
  /// Throws:
  /// - [ArgumentError] if userId is empty
  /// - [Exception] if retrieval fails (contains status and error details)
  Future<List<Map<String, dynamic>>> getUserSessions({
    required String userId,
  }) async {
    _validateUserId(userId);

    final url = Uri.parse('$baseUrl/v1/sessions/$userId');
    final response = await http.get(url, headers: _buildHeaders());

    return _handleListResponse(response, 'Failed to retrieve user sessions');
  }

  /// Revokes all active sessions for a specified user
  ///
  /// Parameters:
  /// [userId]: The unique identifier of the target user (required)
  ///
  /// Returns:
  /// A [Future] that resolves to a Map containing:
  /// - `success`: Operation status
  /// - `message`: Human-readable result message
  /// - `revoked_sessions`: Count of sessions revoked
  /// - `timestamp`: When revocation occurred
  ///
  /// Throws:
  /// - [ArgumentError] if userId is empty
  /// - [Exception] if revocation fails (contains status and error details)
  Future<Map<String, dynamic>> revokeUserSessions({
    required String userId,
  }) async {
    _validateUserId(userId);

    final url = Uri.parse('$baseUrl/v1/sessions/$userId');
    final response = await http.delete(url, headers: _buildHeaders());

    return _handleMapResponse(response, 'Failed to revoke user sessions');
  }

  /// Mock implementation for retrieving user sessions (testing only)
  Future<List<Map<String, dynamic>>> mockGetUserSessions({
    required String userId,
  }) async {
    _validateUserId(userId);

    await Future.delayed(
      const Duration(milliseconds: 150),
    ); // Simulate network delay

    return [
      {
        'session_id': 'abc123',
        'device': 'iPhone 14',
        'ip_address': '192.168.1.1',
        'last_active': DateTime.now()
            .subtract(const Duration(hours: 2))
            .toIso8601String(),
        'location': 'San Francisco, CA',
      },
      {
        'session_id': 'xyz789',
        'device': 'MacBook Pro',
        'ip_address': '192.168.1.2',
        'last_active': DateTime.now()
            .subtract(const Duration(minutes: 30))
            .toIso8601String(),
        'location': 'New York, NY',
      },
    ];
  }

  /// Mock implementation for revoking sessions (testing only)
  Future<Map<String, dynamic>> mockRevokeUserSessions({
    required String userId,
  }) async {
    _validateUserId(userId);

    await Future.delayed(
      const Duration(milliseconds: 200),
    ); // Simulate network delay

    return {
      'success': true,
      'message': 'All sessions revoked successfully',
      'revoked_sessions': 2,
      'timestamp': DateTime.now().toIso8601String(),
      'user_id': userId,
    };
  }

  // ┌──────────────────────────────────────────────────────────────────────────┐
  // │                                HELPERS                                  │
  // └──────────────────────────────────────────────────────────────────────────┘

  /// Builds standard request headers
  Map<String, String> _buildHeaders() => {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
    'X-Request-ID': DateTime.now().millisecondsSinceEpoch.toString(),
  };

  /// Validates that a user ID is not empty
  void _validateUserId(String userId) {
    if (userId.trim().isEmpty) {
      throw ArgumentError('User ID must not be empty.');
    }
  }

  /// Handles list-type API responses
  List<Map<String, dynamic>> _handleListResponse(
    http.Response response,
    String errorPrefix,
  ) {
    if (response.statusCode == 200) {
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return List<Map<String, dynamic>>.from(decoded);
        }
        throw FormatException('Expected List but got ${decoded.runtimeType}');
      } on FormatException catch (e) {
        throw Exception('$errorPrefix: ${e.message}');
      }
    }
    throw Exception(
      '$errorPrefix (Status ${response.statusCode}): ${response.body}',
    );
  }

  /// Handles map-type API responses
  Map<String, dynamic> _handleMapResponse(
    http.Response response,
    String errorPrefix,
  ) {
    if (response.statusCode == 200) {
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
        throw FormatException('Expected Map but got ${decoded.runtimeType}');
      } on FormatException catch (e) {
        throw Exception('$errorPrefix: ${e.message}');
      }
    }
    throw Exception(
      '$errorPrefix (Status ${response.statusCode}): ${response.body}',
    );
  }
}
