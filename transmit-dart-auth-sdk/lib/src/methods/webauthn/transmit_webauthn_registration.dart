import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Handles completion of WebAuthn credential registration for a logged-in user.
///
/// This class calls the Transmit `webauthn-registration` endpoint to finalize
/// WebAuthn credential enrollment for users who are already authenticated.
///
/// Example:
/// ```dart
/// final webauthnRegistration = AortemTransmitWebAuthnRegistration(
///   apiKey: 'your_api_key',
///   baseUrl: 'https://api.transmitsecurity.io',
/// );
///
/// final result = await webauthnRegistration.registerCredential(
///   webauthnEncodedResult: 'base64_encoded_attestation_data',
/// );
/// ```
class AortemTransmitWebAuthnRegistration {
  /// API key for authenticating requests
  final String apiKey;

  /// Base URL for the Transmit Security API
  final String baseUrl;

  /// Creates a new instance of the WebAuthn registration handler.
  AortemTransmitWebAuthnRegistration({
    required this.apiKey,
    required this.baseUrl,
  });

  /// Completes the WebAuthn credential registration for a logged-in user.
  ///
  /// This method:
  /// - Validates input parameters
  /// - Makes an authenticated POST request to `/v1/webauthn/registration`
  /// - Returns a structured response containing credential details
  ///
  /// Throws [ArgumentError] if required inputs are missing.
  /// Throws [Exception] for HTTP or API errors.
  ///
  /// [webauthnEncodedResult] – Base64 encoded WebAuthn attestation data
  ///
  /// Returns a [Map] with registration result details.
  Future<Map<String, dynamic>> registerCredential({
    required String webauthnEncodedResult,
  }) async {
    _validateInputs(webauthnEncodedResult);

    final url = Uri.parse('$baseUrl/v1/webauthn/registration');
    final payload = {"webauthn_encoded_result": webauthnEncodedResult};

    final response = await http.post(
      url,
      headers: _buildHeaders(),
      body: jsonEncode(payload),
    );

    return _handleMapResponse(
      response,
      'Failed to complete WebAuthn registration',
    );
  }

  /// Mock implementation for testing purposes.
  Future<Map<String, dynamic>> mockRegisterCredential({
    required String webauthnEncodedResult,
  }) async {
    _validateInputs(webauthnEncodedResult);

    return {
      "success": true,
      "message": "WebAuthn credential registered successfully.",
      "credential_id": "mock_credential_123",
      "created_at": DateTime.now().toIso8601String(),
    };
  }

  // ================================
  // 🔹 Private Helpers
  // ================================

  Map<String, String> _buildHeaders() => {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
  };

  void _validateInputs(String webauthnEncodedResult) {
    if (webauthnEncodedResult.trim().isEmpty) {
      throw ArgumentError('WebAuthn encoded result must not be empty.');
    }
  }

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
