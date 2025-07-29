import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for initiating WebAuthn authentication flows via Transmit Security's API.
///
/// This class handles the first step of WebAuthn authentication by generating
/// the necessary challenge and options that will be used by the client-side
/// authenticator (browser/device).
///
/// ## Security Considerations
/// - Requires valid API credentials
/// - Generates time-sensitive challenges
/// - Should be used with HTTPS only
///
/// ## Flow Overview
/// 1. Client calls start() to get challenge and options
/// 2. Browser uses these to call navigator.credentials.get()
/// 3. Client submits the resulting assertion to the authenticate/complete endpoint
class AortemTransmitAuthenticationStartWebAuthn {
  /// The API key used for authentication
  final String apiKey;

  /// The base URL for the WebAuthn API endpoints
  final String baseUrl;

  /// The HTTP client instance used for requests
  final http.Client _client;

  /// Creates a WebAuthn authentication starter instance
  ///
  /// [apiKey]: Required API key for authentication
  /// [baseUrl]: Required base URL for the API endpoints
  /// [client]: Optional HTTP client for testing or customization
  AortemTransmitAuthenticationStartWebAuthn({
    required this.apiKey,
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  /// Initiates a WebAuthn authentication ceremony
  ///
  /// This generates the cryptographic challenge and options needed to start
  /// a WebAuthn authentication flow on the client side.
  ///
  /// Parameters:
  /// [clientId] - The application's client identifier (required)
  /// [username] - Optional user identifier for resident key discovery
  /// [timeout] - Optional timeout in milliseconds (default: 300000)
  /// [approvalData] - Optional transaction details for conditional UI
  ///
  /// Returns:
  /// A [Future] that resolves to a Map containing:
  /// - `challenge`: Base64URL-encoded cryptographic challenge
  /// - `session_id`: Unique session identifier
  /// - `options`: WebAuthn authentication options
  /// - `rpId`: Relying party identifier
  ///
  /// Throws:
  /// - [ArgumentError] if clientId is empty
  /// - [Exception] if API request fails (contains status and error details)
  Future<Map<String, dynamic>> start({
    required String clientId,
    String? username,
    int? timeout,
    Map<String, dynamic>? approvalData,
  }) async {
    // Validate required parameters
    if (clientId.isEmpty) {
      throw ArgumentError('clientId is required and cannot be empty');
    }

    try {
      final uri = Uri.parse('$baseUrl/v1/auth/webauthn/authenticate/start');

      final body = <String, dynamic>{
        'client_id': clientId,
        if (timeout != null) 'timeout': timeout,
        if (username != null && username.isNotEmpty) 'username': username,
        if (approvalData != null) 'approval_data': approvalData,
      };

      final response = await _client.post(
        uri,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
          'X-Request-ID': DateTime.now().millisecondsSinceEpoch.toString(),
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw _createWebAuthnException(response);
      }
    } on FormatException catch (e) {
      throw Exception('Failed to parse API response: ${e.message}');
    } on http.ClientException catch (e) {
      throw Exception('Network error during WebAuthn initiation: ${e.message}');
    }
  }

  /// Creates a detailed exception from API error responses
  Exception _createWebAuthnException(http.Response response) {
    try {
      final error = jsonDecode(response.body) as Map<String, dynamic>;
      return Exception(
        'WebAuthn error (${response.statusCode}): '
        '${error['error'] ?? 'Unknown error'} - '
        '${error['error_description'] ?? 'No description provided'}',
      );
    } on FormatException {
      return Exception(
        'WebAuthn error (${response.statusCode}): ${response.body}',
      );
    }
  }
}
