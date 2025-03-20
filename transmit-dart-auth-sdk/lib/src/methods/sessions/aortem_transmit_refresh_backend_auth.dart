import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Handles backend authentication, including refreshing auth tokens.
class BackendAuthManager {
  /// API key for authenticating requests.
  final String apiKey;

  /// Base URL for the Transmit Security API.
  final String baseUrl;

  /// Constructs an instance of `UserSessionManager`.
  ///
  /// - [apiKey]: Required for API authentication.
  /// - [baseUrl]: The API's base URL.

  /// Constructs an instance of `BackendAuthManager`.
  ///
  /// [apiKey] is required for authenticating API requests.
  /// [baseUrl] is the base URL for the Transmit Security API.
  BackendAuthManager({required this.apiKey, required this.baseUrl});

  /// Refreshes the backend authentication token using a valid refresh token.
  ///
  /// - [refreshToken] (String): The token used to request a new auth token.
  /// - Returns a map containing the new authentication token and expiration time.
  ///
  /// Throws:
  /// - `ArgumentError` if [refreshToken] is empty or null.
  /// - `Exception` if the HTTP request fails.
  Future<Map<String, dynamic>> refreshBackendAuthToken({
    required String refreshToken,
  }) async {
    if (refreshToken.isEmpty) {
      throw ArgumentError("Refresh token must not be empty.");
    }

    final String url = '$baseUrl/refreshBackendAuthToken';
    final Map<String, String> headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };
    final Map<String, String> body = {'refreshToken': refreshToken};

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
          "Failed to refresh token: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (error) {
      throw Exception("Error refreshing backend auth token: $error");
    }
  }

  /// Mock implementation for local testing.
  ///
  /// Simulates token refresh by returning dummy data.
  Future<Map<String, dynamic>> mockRefreshBackendAuthToken({
    required String refreshToken,
  }) async {
    if (refreshToken.isEmpty) {
      throw ArgumentError("Refresh token must not be empty.");
    }

    return {
      'success': true,
      'newAuthToken': 'mock-auth-token-12345',
      'expiresAt': DateTime.now().add(Duration(hours: 1)).toIso8601String(),
    };
  }
}
