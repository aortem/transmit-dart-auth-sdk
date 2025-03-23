import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Manages password authentication, including user login and token retrieval.
class PasswordAuthManager {
  /// API key for authenticating requests.
  final String apiKey;

  /// Base URL for the Transmit Security API.
  final String baseUrl;

  /// Constructs an instance of `UserSessionManager`.
  ///
  /// - [apiKey]: Required for API authentication.
  /// - [baseUrl]: The API's base URL.

  /// Constructs an instance of `PasswordAuthManager`.
  ///
  /// [apiKey] is required for authenticating API requests.
  /// [baseUrl] is the base URL for the Transmit Security API.
  PasswordAuthManager({required this.apiKey, required this.baseUrl});

  /// Authenticates a user using their password.
  ///
  /// - [userIdentifier] (String): The user's email or username.
  /// - [password] (String): The user's password.
  /// - Returns a map containing authentication tokens and metadata.
  ///
  /// Throws:
  /// - `ArgumentError` if [userIdentifier] or [password] is empty.
  /// - `Exception` if the HTTP request fails.
  Future<Map<String, dynamic>> authenticatePassword({
    required String userIdentifier,
    required String password,
  }) async {
    if (userIdentifier.isEmpty || password.isEmpty) {
      throw ArgumentError("User identifier and password must not be empty.");
    }

    final String url = '$baseUrl/authenticatePassword';
    final Map<String, String> headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };
    final Map<String, String> body = {
      'userIdentifier': userIdentifier,
      'password': password,
    };

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
          "Failed to authenticate password: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (error) {
      throw Exception("Error authenticating password: $error");
    }
  }

  /// Mock implementation for local testing.
  ///
  /// Simulates password authentication by returning dummy authentication data.
  Future<Map<String, dynamic>> mockAuthenticatePassword({
    required String userIdentifier,
    required String password,
  }) async {
    if (userIdentifier.isEmpty || password.isEmpty) {
      throw ArgumentError("User identifier and password must not be empty.");
    }

    return {
      'success': true,
      'userId': 'mock-user-12345',
      'authTokens': {
        'accessToken': 'mock-access-token-abc',
        'refreshToken': 'mock-refresh-token-def',
        'expiresAt': DateTime.now().add(Duration(hours: 1)).toIso8601String(),
      },
    };
  }
}
