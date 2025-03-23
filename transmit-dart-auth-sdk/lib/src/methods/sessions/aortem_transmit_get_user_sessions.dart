import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Manages user sessions, including retrieving and revoking active sessions.
class UserSessionManager {
  /// API key for authenticating requests.
  final String apiKey;

  /// Base URL for the Transmit Security API.
  final String baseUrl;

  /// Constructs an instance of `UserSessionManager`.
  ///
  /// - [apiKey]: Required for API authentication.
  /// - [baseUrl]: The API's base URL.
  UserSessionManager({required this.apiKey, required this.baseUrl});

  /// Retrieves all active sessions for a given user.
  ///
  /// - [userId]: Unique identifier of the user whose sessions should be fetched.
  ///
  /// Returns a list of session details, including timestamps and device information.
  ///
  /// Throws:
  /// - `ArgumentError` if [userId] is empty.
  /// - `Exception` if the API request fails.
  Future<List<Map<String, dynamic>>> getUserSessions({
    required String userId,
  }) async {
    if (userId.isEmpty) {
      throw ArgumentError("User ID must not be empty.");
    }

    final String url = '$baseUrl/getUserSessions?userId=$userId';
    final headers = _buildHeaders();

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        throw Exception(
          "Failed to retrieve user sessions: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (error) {
      throw Exception("Error retrieving user sessions: $error");
    }
  }

  /// Revokes all active sessions for a given user.
  ///
  /// - [userId]: Unique identifier of the user whose sessions should be revoked.
  ///
  /// Returns a confirmation response containing details about revoked sessions.
  ///
  /// Throws:
  /// - `ArgumentError` if [userId] is empty.
  /// - `Exception` if the API request fails.
  Future<Map<String, dynamic>> revokeUserSessions({
    required String userId,
  }) async {
    if (userId.isEmpty) {
      throw ArgumentError("User ID must not be empty.");
    }

    final String url = '$baseUrl/revokeUserSessions';
    final headers = _buildHeaders();
    final body = jsonEncode({'userId': userId});

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          "Failed to revoke sessions: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (error) {
      throw Exception("Error revoking user sessions: $error");
    }
  }

  /// Mock implementation for retrieving user sessions (for testing purposes).
  Future<List<Map<String, dynamic>>> mockGetUserSessions({
    required String userId,
  }) async {
    _validateUserId(userId);

    return [
      {
        'sessionId': 'abc123',
        'device': 'iPhone 14',
        'ipAddress': '192.168.1.1',
        'lastActive': DateTime.now().toIso8601String(),
      },
      {
        'sessionId': 'xyz789',
        'device': 'MacBook Pro',
        'ipAddress': '192.168.1.2',
        'lastActive': DateTime.now().toIso8601String(),
      },
    ];
  }

  /// Mock implementation for revoking user sessions (for testing purposes).
  Future<Map<String, dynamic>> mockRevokeUserSessions({
    required String userId,
  }) async {
    _validateUserId(userId);

    return {
      'success': true,
      'message': 'User sessions revoked successfully.',
      'revokedSessions': 3,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Helper method to construct request headers.
  Map<String, String> _buildHeaders() => {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
  };

  /// Helper method to validate user ID input.
  void _validateUserId(String userId) {
    if (userId.isEmpty) {
      throw ArgumentError("User ID must not be empty.");
    }
  }
}
