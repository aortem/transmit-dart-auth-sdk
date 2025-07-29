import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for authenticating users via password using Transmit Security's API.
///
/// This class handles username/password authentication, returning JWT tokens
/// upon successful verification. It supports multiple username types and
/// optional parameters for advanced authentication scenarios.
///
/// ## Security Considerations
/// - Requires valid API credentials
/// - Handles sensitive password data (should use HTTPS)
/// - Implements secure token rotation
/// - Supports multi-factor authentication workflows
/// - Password should be hashed before transmission (handled by client)
///
/// ## Authentication Flow
/// 1. Client provides username/email/phone and password
/// 2. Service validates credentials against identity store
/// 3. Returns fresh tokens if authentication succeeds
/// 4. Invalidates previous tokens (optional)
///
/// ## Example Usage
/// ```dart
/// final authService = AortemTransmitAuthenticatePassword(
///   apiKey: 'your-api-key',
///   baseUrl: 'https://api.transmitsecurity.com',
/// );
///
/// try {
///   final tokens = await authService.authenticatePassword(
///     username: 'user@example.com',
///     password: 'securePassword123!',
///     usernameType: 'email',
///   );
///   print('Authentication successful. Token expires in: ${tokens['expires_in']}s');
/// } catch (e) {
///   print('Authentication failed: $e');
/// }
/// ```
class AortemTransmitAuthenticatePassword {
  /// The API key used for service authentication
  final String apiKey;

  /// The base URL for the authentication API endpoint
  final String baseUrl;

  /// Creates a password authentication service instance
  ///
  /// [apiKey]: Required API key for service authentication
  /// [baseUrl]: Required base URL for the API endpoint
  AortemTransmitAuthenticatePassword({
    required this.apiKey,
    required this.baseUrl,
  });

  /// Authenticates a user using username and password credentials
  ///
  /// Parameters:
  /// [username]: User identifier (email, username, or phone number) (required)
  /// [password]: User's password (required)
  /// [usernameType]: Type of identifier ('username', 'email', or 'phone') (default: 'username')
  /// [resource]: Optional audience for the tokens
  /// [claims]: Additional claims to include in tokens
  /// [orgId]: Organization identifier for multi-tenant systems
  /// [clientAttributes]: Client-specific metadata
  /// [sessionId]: Existing session identifier to associate with
  ///
  /// Returns:
  /// A [Future] that resolves to a Map containing:
  /// - `access_token`: Short-lived JWT access token
  /// - `id_token`: JWT containing user identity claims
  /// - `refresh_token`: Long-lived refresh token
  /// - `token_type`: Typically "Bearer"
  /// - `expires_in`: Access token validity in seconds
  /// - `session_id`: Session identifier
  /// - Additional service-specific metadata
  ///
  /// Throws:
  /// - [ArgumentError] if username or password is empty
  /// - [Exception] with detailed error message if authentication fails
  Future<Map<String, dynamic>> authenticatePassword({
    required String username,
    required String password,
    String? resource,
    Map<String, dynamic>? claims,
    String? orgId,
    Map<String, dynamic>? clientAttributes,
    String? sessionId,
    String usernameType = "username",
  }) async {
    if (username.isEmpty || password.isEmpty) {
      throw ArgumentError('Username and password must not be empty');
    }

    try {
      final url = Uri.parse('$baseUrl/v1/auth/password/authenticate');

      final headers = {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'X-Request-ID': DateTime.now().millisecondsSinceEpoch.toString(),
      };

      final body = <String, dynamic>{
        'username': username,
        'password': password,
        'username_type': usernameType,
        if (resource != null) 'resource': resource,
        if (claims != null) 'claims': claims,
        if (orgId != null) 'org_id': orgId,
        if (clientAttributes != null) 'client_attributes': clientAttributes,
        if (sessionId != null) 'session_id': sessionId,
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
      throw Exception('Network error during authentication: ${e.message}');
    }
  }

  /// Mock implementation for testing password authentication
  ///
  /// Simulates successful authentication without API calls.
  Future<Map<String, dynamic>> mockAuthenticatePassword({
    required String username,
    required String password,
  }) async {
    if (username.isEmpty || password.isEmpty) {
      throw ArgumentError('Username and password must not be empty');
    }

    await Future.delayed(
      const Duration(milliseconds: 150),
    ); // Simulate network delay

    return {
      'access_token': 'mock_access_token_${username.hashCode}',
      'id_token': 'mock_id_token_${DateTime.now().millisecondsSinceEpoch}',
      'refresh_token': 'mock_refresh_token_${username.hashCode}',
      'token_type': 'Bearer',
      'expires_in': 3600,
      'session_id': 'mock_session_${username.hashCode}',
      'scope': 'openid profile email',
    };
  }

  /// Creates a detailed exception from authentication failures
  Exception _createAuthException(http.Response response) {
    try {
      final error = jsonDecode(response.body) as Map<String, dynamic>;
      final statusCode = response.statusCode;
      final errorCode = error['error'] ?? 'authentication_failed';
      final description =
          error['error_description'] ?? 'No description provided';

      switch (statusCode) {
        case 400:
          return Exception('Invalid request: $description (code: $errorCode)');
        case 401:
          return Exception(
            'Authentication failed: $description (code: $errorCode)',
          );
        case 403:
          return Exception('Access denied: $description (code: $errorCode)');
        case 429:
          return Exception(
            'Too many requests: $description (code: $errorCode)',
          );
        default:
          return Exception(
            'Authentication error ($statusCode): $description (code: $errorCode)',
          );
      }
    } on FormatException {
      return Exception(
        'Authentication failed (${response.statusCode}): ${response.body}',
      );
    }
  }
}
