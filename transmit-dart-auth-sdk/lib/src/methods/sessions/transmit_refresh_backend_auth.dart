import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for refreshing backend authentication tokens using Transmit Security's API.
///
/// This class handles the secure refresh of authentication tokens, allowing for
/// continued API access without requiring full re-authentication.
///
/// ## Security Considerations
/// - Requires valid API credentials
/// - Handles sensitive refresh tokens
/// - Should be used with HTTPS only
/// - Refresh tokens should be securely stored
///
/// ## Token Refresh Flow
/// 1. Client provides expired access token and valid refresh token
/// 2. Service validates refresh token
/// 3. New tokens are issued if validation succeeds
/// 4. Old refresh token is invalidated (refresh token rotation)
///
/// ## Example Usage
/// ```dart
/// final tokenService = AortemTransmitRefreshBackendAuthToken(
///   apiKey: 'your-api-key',
///   baseUrl: 'https://api.transmitsecurity.com',
/// );
///
/// try {
///   final tokens = await tokenService.refresh(
///     refreshToken: 'user-refresh-token-123',
///   );
///   print('New access token: ${tokens['access_token']}');
/// } catch (e) {
///   print('Token refresh failed: $e');
/// }
/// ```
class AortemTransmitRefreshBackendAuthToken {
  /// The API key used for service authentication
  final String apiKey;

  /// The base URL for the token refresh API endpoint
  final String baseUrl;

  /// Creates a token refresh service instance
  ///
  /// [apiKey]: Required API key for service authentication
  /// [baseUrl]: Required base URL for the API endpoint
  AortemTransmitRefreshBackendAuthToken({
    required this.apiKey,
    required this.baseUrl,
  });

  /// Refreshes authentication tokens using a valid refresh token
  ///
  /// Parameters:
  /// [refreshToken]: The refresh token to use for obtaining new tokens (must not be empty)
  ///
  /// Returns:
  /// A [Future] that resolves to a Map containing:
  /// - `access_token`: New short-lived access token
  /// - `id_token`: New ID token (when applicable)
  /// - `refresh_token`: New refresh token (refresh token rotation)
  /// - `token_type`: Typically "Bearer"
  /// - `expires_in`: Access token validity in seconds
  ///
  /// Throws:
  /// - [ArgumentError] if refreshToken is empty
  /// - [Exception] if refresh fails (contains status code and error details)
  Future<Map<String, dynamic>> refresh({required String refreshToken}) async {
    if (refreshToken.isEmpty) {
      throw ArgumentError('Refresh token must not be empty');
    }

    try {
      final url = Uri.parse('$baseUrl/v1/auth/token/refresh');

      final headers = {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'X-Request-ID': DateTime.now().millisecondsSinceEpoch.toString(),
      };

      final body = jsonEncode({
        'refresh_token': refreshToken,
        'grant_type': 'refresh_token',
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw _createRefreshException(response);
      }
    } on FormatException catch (e) {
      throw Exception('Failed to parse token response: ${e.message}');
    } on http.ClientException catch (e) {
      throw Exception('Network error during token refresh: ${e.message}');
    }
  }

  /// Mock implementation for testing token refresh
  ///
  /// Simulates successful token refresh without making API calls.
  Future<Map<String, dynamic>> mockRefresh({
    required String refreshToken,
  }) async {
    if (refreshToken.isEmpty) {
      throw ArgumentError('Refresh token must not be empty');
    }

    await Future.delayed(
      const Duration(milliseconds: 100),
    ); // Simulate network delay

    return {
      'access_token':
          'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
      'id_token': 'mock_id_token_${DateTime.now().millisecondsSinceEpoch}',
      'refresh_token':
          'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      'token_type': 'Bearer',
      'expires_in': 3600,
      'scope': 'openid profile email',
    };
  }

  /// Creates a detailed exception from refresh failures
  Exception _createRefreshException(http.Response response) {
    try {
      final error = jsonDecode(response.body) as Map<String, dynamic>;
      return Exception(
        'Token refresh failed (${response.statusCode}): '
        '${error['error'] ?? 'Unknown error'} - '
        '${error['error_description'] ?? 'No description provided'}',
      );
    } on FormatException {
      return Exception(
        'Token refresh failed (${response.statusCode}): ${response.body}',
      );
    }
  }
}
