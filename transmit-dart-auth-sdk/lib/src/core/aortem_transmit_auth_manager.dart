import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Manages session authentication, including session validation and updates.
class SessionAuthManager {
  /// The API key used for authenticating API requests.
  final String apiKey;

  /// The base URL for the Transmit Security API.
  final String baseUrl;

  /// Constructs an instance of `SessionAuthManager`.
  ///
  /// - [apiKey] is required for API authentication.
  /// - [baseUrl] is the base URL of the API.
  SessionAuthManager({required this.apiKey, required this.baseUrl});

  /// Authenticates an existing session using a valid session token.
  ///
  /// This method sends a request to the authentication API endpoint
  /// to validate and update the session.
  ///
  /// - [sessionToken] (String): The session token to validate.
  /// - Returns a `Map<String, dynamic>` containing the updated session
  ///   data and authentication tokens.
  ///
  /// Throws:
  /// - `ArgumentError` if [sessionToken] is empty.
  /// - `Exception` if the HTTP request fails due to network issues
  ///   or API errors.
  Future<Map<String, dynamic>> authenticateSession({
    required String sessionToken,
  }) async {
    if (sessionToken.isEmpty) {
      throw ArgumentError("Session token must not be empty.");
    }

    final String url = '$baseUrl/authenticateSession';
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
      } else {
        throw Exception(
          "Failed to authenticate session: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (error) {
      throw Exception("Error authenticating session: $error");
    }
  }

  /// Mocks the session authentication process for testing purposes.
  ///
  /// This method simulates a session authentication response, providing
  /// dummy session and authentication token data.
  ///
  /// - [sessionToken] (String): The session token used for mock authentication.
  /// - Returns a `Map<String, dynamic>` representing a mock authenticated session.
  ///
  /// Throws:
  /// - `ArgumentError` if [sessionToken] is empty.
  Future<Map<String, dynamic>> mockAuthenticateSession({
    required String sessionToken,
  }) async {
    if (sessionToken.isEmpty) {
      throw ArgumentError("Session token must not be empty.");
    }

    return {
      'success': true,
      'userId': 'mock-user-12345',
      'sessionId': 'mock-session-67890',
      'authTokens': {
        'accessToken': 'mock-access-token-abc',
        'refreshToken': 'mock-refresh-token-def',
        'expiresAt': DateTime.now().add(Duration(hours: 1)).toIso8601String(),
      },
    };
  }
}
