import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Manages user sessions: retrieving and revoking active sessions.
class AortemTransmitGetUserSessions {
  final String apiKey;
  final String baseUrl;

  AortemTransmitGetUserSessions({required this.apiKey, required this.baseUrl});

  /// ✅ Retrieves all active sessions for a given user.
  Future<List<Map<String, dynamic>>> getUserSessions({
    required String userId,
  }) async {
    _validateUserId(userId);

    final url = Uri.parse('$baseUrl/v1/sessions/$userId');
    final response = await http.get(url, headers: _buildHeaders());

    return _handleListResponse(response, 'Failed to retrieve user sessions');
  }

  /// ✅ Revokes all active sessions for a given user.
  Future<Map<String, dynamic>> revokeUserSessions({
    required String userId,
  }) async {
    _validateUserId(userId);

    final url = Uri.parse('$baseUrl/v1/sessions/$userId');
    final response = await http.delete(url, headers: _buildHeaders());

    return _handleMapResponse(response, 'Failed to revoke user sessions');
  }

  /// ✅ Mock for testing: returns dummy sessions
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

  /// ✅ Mock for testing: simulates revoking sessions
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

  // 🔹 Helpers
  Map<String, String> _buildHeaders() => {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
  };

  void _validateUserId(String userId) {
    if (userId.trim().isEmpty) {
      throw ArgumentError('User ID must not be empty.');
    }
  }

  List<Map<String, dynamic>> _handleListResponse(
    http.Response response,
    String errorPrefix,
  ) {
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is List) {
        return List<Map<String, dynamic>>.from(decoded);
      } else {
        throw Exception('$errorPrefix: Unexpected response format');
      }
    }
    throw Exception(
      '$errorPrefix (Status ${response.statusCode}): ${response.body}',
    );
  }

  Map<String, dynamic> _handleMapResponse(
    http.Response response,
    String errorPrefix,
  ) {
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      } else {
        throw Exception('$errorPrefix: Unexpected response format');
      }
    }
    throw Exception(
      '$errorPrefix (Status ${response.statusCode}): ${response.body}',
    );
  }
}
