import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Handles backend session management, including logging out user sessions.
class BackendSessionManager {
  /// API key for authenticating requests.
  final String apiKey;

  /// Base URL for the Transmit Security API.
  final String baseUrl;

  /// - [apiKey]: Required for API authentication.
  /// - [baseUrl]: The API's base URL.

  /// Constructs an instance of `BackendSessionManager`.
  ///
  /// [apiKey] is required for authenticating API requests.
  /// [baseUrl] is the base URL for the Transmit Security API.
  BackendSessionManager({required this.apiKey, required this.baseUrl});

  /// Logs out a backend session by invalidating the session token.
  ///
  /// This method sends a POST request to the "logoutBackendSession" endpoint.
  ///
  /// - [sessionToken] (String): The session token to be invalidated.
  /// - Returns a map containing confirmation details such as a success flag and logout timestamp.
  ///
  /// Throws:
  /// - `ArgumentError` if [sessionToken] is empty or null.
  /// - `Exception` if the HTTP request fails.
  Future<Map<String, dynamic>> logoutBackendSession({
    required String sessionToken,
  }) async {
    if (sessionToken.isEmpty) {
      throw ArgumentError("Session token must not be empty.");
    }

    final String url = '$baseUrl/logoutBackendSession';
    final Map<String, String> headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };
    final Map<String, String> body = {'sessionToken': sessionToken};

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 400) {
        throw Exception("Invalid session token provided.");
      } else if (response.statusCode == 404) {
        throw Exception("Session not found or already logged out.");
      } else {
        throw Exception(
          "Failed to logout session: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (error) {
      throw Exception("Error logging out backend session: $error");
    }
  }

  /// Mock implementation for local testing.
  ///
  /// Simulates logging out a backend session by returning a dummy response.
  Future<Map<String, dynamic>> mockLogoutBackendSession({
    required String sessionToken,
  }) async {
    if (sessionToken.isEmpty) {
      throw ArgumentError("Session token must not be empty.");
    }

    return {
      'success': true,
      'message': 'Session logged out successfully.',
      'logoutTimestamp': DateTime.now().toIso8601String(),
    };
  }
}
