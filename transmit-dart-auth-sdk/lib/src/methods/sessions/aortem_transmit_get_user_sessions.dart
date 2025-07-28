import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Provides comprehensive session management capabilities for user authentication sessions.
///
/// This class enables:
/// - Retrieval of all active sessions for a user
/// - Revocation of user sessions (single or all)
/// - Both production and mock implementations for testing
///
/// The implementation follows security best practices including:
/// - Input validation
/// - Proper error handling
/// - Clear response parsing
///
/// Example usage:
/// ```dart
/// final sessionManager = AortemTransmitGetUserSessions(
///   apiKey: 'your_api_key',
///   baseUrl: 'https://api.authservice.com',
/// );
///
/// // Get active sessions
/// final sessions = await sessionManager.getUserSessions(userId: 'user_123');
///
/// // Revoke all sessions
/// final result = await sessionManager.revokeUserSessions(userId: 'user_123');
/// ```
class AortemTransmitGetUserSessions {
  /// The API key used for authenticating requests
  final String apiKey;

  /// The base URL for the session management API
  final String baseUrl;

  /// Creates a new session manager instance.
  ///
  /// [apiKey]: The authentication key for API requests
  /// [baseUrl]: The root URL for the session service
  AortemTransmitGetUserSessions({required this.apiKey, required this.baseUrl});

  /// Retrieves all active sessions for the specified user.
  ///
  /// This method:
  /// - Validates the user ID
  /// - Makes an authenticated GET request
  /// - Returns a list of session objects containing:
  ///   - Session ID
  ///   - Device information
  ///   - IP address
  ///   - Last activity timestamp
  ///
  /// Throws [ArgumentError] if userId is empty.
  /// Throws [Exception] for API errors or malformed responses.
  ///
  /// [userId]: The unique identifier of the user (required)
  ///
  /// Returns [Future<List<Map<String, dynamic>>>] containing session details
  Future<List<Map<String, dynamic>>> getUserSessions({
    required String userId,
  }) async {
    _validateUserId(userId);

    final url = Uri.parse('$baseUrl/v1/sessions/$userId');
    final response = await http.get(url, headers: _buildHeaders());

    return _handleListResponse(response, 'Failed to retrieve user sessions');
  }

  /// Revokes all active sessions for the specified user.
  ///
  /// This method:
  /// - Validates the user ID
  /// - Makes an authenticated DELETE request
  /// - Returns a confirmation object containing:
  ///   - Success status
  ///   - Operation details
  ///   - Timestamp
  ///
  /// Throws [ArgumentError] if userId is empty.
  /// Throws [Exception] for API errors or malformed responses.
  ///
  /// [userId]: The unique identifier of the user (required)
  ///
  /// Returns [Future<Map<String, dynamic>>] containing revocation confirmation
  Future<Map<String, dynamic>> revokeUserSessions({
    required String userId,
  }) async {
    _validateUserId(userId);

    final url = Uri.parse('$baseUrl/v1/sessions/$userId');
    final response = await http.delete(url, headers: _buildHeaders());

    return _handleMapResponse(response, 'Failed to revoke user sessions');
  }

  /// Mock implementation for retrieving user sessions (testing purposes).
  ///
  /// Simulates the API response with realistic mock data:
  /// - Two sample sessions with different devices
  /// - Current timestamps
  /// - Valid session IDs
  ///
  /// Validates input identically to the real implementation.
  ///
  /// [userId]: The mock user identifier (must not be empty)
  ///
  /// Returns [Future<List<Map<String, dynamic>>>] with mock session data
  Future<List<Map<String, dynamic>>> mockGetUserSessions({
    required String userId,
  }) async {
    _validateUserId(userId);

    return [
      {
        'session_id': 'abc123',
        'device': 'iPhone 14',
        'ip_address': '192.168.1.1',
        'last_active': DateTime.now().toIso8601String(),
      },
      {
        'session_id': 'xyz789',
        'device': 'MacBook Pro',
        'ip_address': '192.168.1.2',
        'last_active': DateTime.now().toIso8601String(),
      },
    ];
  }

  /// Mock implementation for revoking sessions (testing purposes).
  ///
  /// Simulates successful session revocation with:
  /// - Success status
  /// - Mock count of revoked sessions
  /// - Current timestamp
  ///
  /// Validates input identically to the real implementation.
  ///
  /// [userId]: The mock user identifier (must not be empty)
  ///
  /// Returns [Future<Map<String, dynamic>>] with mock revocation confirmation
  Future<Map<String, dynamic>> mockRevokeUserSessions({
    required String userId,
  }) async {
    _validateUserId(userId);

    return {
      'success': true,
      'message': 'All sessions revoked successfully.',
      'revoked_sessions': 3,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  // =============================================
  // 🔹 Private Helper Methods
  // =============================================

  /// Builds standard request headers with authentication.
  Map<String, String> _buildHeaders() => {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
  };

  /// Validates that a user ID is not empty.
  ///
  /// Throws [ArgumentError] if validation fails.
  void _validateUserId(String userId) {
    if (userId.trim().isEmpty) {
      throw ArgumentError('User ID must not be empty.');
    }
  }

  /// Handles list-type API responses with proper error checking.
  ///
  /// [response]: The HTTP response to process
  /// [errorPrefix]: Custom prefix for error messages
  ///
  /// Throws [Exception] for non-200 status or malformed responses.
  /// Returns parsed list of maps for successful responses.
  List<Map<String, dynamic>> _handleListResponse(
    http.Response response,
    String errorPrefix,
  ) {
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is List) {
        return List<Map<String, dynamic>>.from(decoded);
      }
      throw Exception('$errorPrefix: Unexpected response format');
    }
    throw Exception(
      '$errorPrefix (Status ${response.statusCode}): ${response.body}',
    );
  }

  /// Handles map-type API responses with proper error checking.
  ///
  /// [response]: The HTTP response to process
  /// [errorPrefix]: Custom prefix for error messages
  ///
  /// Throws [Exception] for non-200 status or malformed responses.
  /// Returns parsed map for successful responses.
  Map<String, dynamic> _handleMapResponse(
    http.Response response,
    String errorPrefix,
  ) {
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      throw Exception('$errorPrefix: Unexpected response format');
    }
    throw Exception(
      '$errorPrefix (Status ${response.statusCode}): ${response.body}',
    );
  }
}
