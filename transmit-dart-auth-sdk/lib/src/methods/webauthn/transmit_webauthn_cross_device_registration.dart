import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Handles completion of WebAuthn cross-device credential registration.
///
/// This class calls the Transmit `webauthn-cross-device-registration`
/// endpoint to finalize credential enrollment on a secondary device.
class AortemTransmitWebAuthnCrossDeviceRegistration {
  /// API key for authenticating requests.
  final String apiKey;

  /// Base URL for the Transmit Security API.
  final String baseUrl;

  ///Completes the WebAuthn credential registration for cross-device scenarios.
  AortemTransmitWebAuthnCrossDeviceRegistration({
    required this.apiKey,
    required this.baseUrl,
  });

  /// Completes the WebAuthn credential registration for cross-device scenarios.
  ///
  /// [webauthnEncodedResult] – Base64-encoded WebAuthn attestation data
  ///
  /// Returns a [Map] containing credential details and tokens.
  Future<Map<String, dynamic>> completeRegistration({
    required String webauthnEncodedResult,
  }) async {
    if (webauthnEncodedResult.trim().isEmpty) {
      throw ArgumentError("WebAuthn encoded result must not be empty.");
    }

    final url = Uri.parse('$baseUrl/v1/webauthn/cross-device/registration');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'webauthn_encoded_result': webauthnEncodedResult}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 400) {
      throw Exception("Invalid input for cross-device WebAuthn registration.");
    } else {
      throw Exception(
        "Failed to complete cross-device WebAuthn registration "
        "[${response.statusCode}]: ${response.body}",
      );
    }
  }

  /// Mock version for local testing without API calls.
  Future<Map<String, dynamic>> mockCompleteRegistration({
    required String webauthnEncodedResult,
  }) async {
    if (webauthnEncodedResult.trim().isEmpty) {
      throw ArgumentError("WebAuthn encoded result must not be empty.");
    }

    return {
      "success": true,
      "message": "Cross-device WebAuthn credential registered successfully.",
      "credential_id": "mock_credential_cross_device_123",
      "access_token": "mock_access_token_456",
      "id_token": "mock_id_token_789",
      "expires_in": 3600,
    };
  }
}
