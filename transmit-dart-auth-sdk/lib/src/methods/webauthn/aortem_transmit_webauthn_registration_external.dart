import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Handles completing an external WebAuthn registration flow.
///
/// This class interacts with the Transmit Security API to finalize
/// WebAuthn credential registration for users that are not yet logged in.
class AortemTransmitWebAuthnRegistrationExternal {
  /// - [apiKey]: API key for authenticating requests.
  final String apiKey;

  /// - [baseUrl]: The API's base URL.
  final String baseUrl;

  /// Creates an instance for completing external WebAuthn registration.
  ///

  AortemTransmitWebAuthnRegistrationExternal({
    required this.apiKey,
    required this.baseUrl,
  });

  /// Completes external WebAuthn registration by submitting the credential response.
  ///
  /// - [externalUserId] – Unique identifier of the user in your system.
  /// - [webauthnEncodedResult] – Base64 encoded attestation data from the authenticator.
  /// - [userEmail] – (Optional) The user's primary email address.
  ///
  /// Returns a Map containing registration confirmation, final tokens, and metadata.
  ///
  /// Throws:
  /// - [ArgumentError] if required inputs are empty.
  /// - [Exception] if the API request fails.
  Future<Map<String, dynamic>> registerExternal({
    required String externalUserId,
    required String webauthnEncodedResult,
    String? userEmail,
  }) async {
    if (externalUserId.isEmpty) {
      throw ArgumentError('externalUserId must not be empty.');
    }
    if (webauthnEncodedResult.isEmpty) {
      throw ArgumentError('webauthnEncodedResult must not be empty.');
    }

    final url = Uri.parse('$baseUrl/v1/auth/webauthn/registration/external');

    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final body = {
      'external_user_id': externalUserId,
      'webauthn_encoded_result': webauthnEncodedResult,
      if (userEmail != null) 'user_email': userEmail,
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
        'Failed to complete external WebAuthn registration '
        '[${response.statusCode}]: ${response.body}',
      );
    }
  }

  /// Mock implementation for local testing without an API call.
  Future<Map<String, dynamic>> mockRegisterExternal({
    required String externalUserId,
    required String webauthnEncodedResult,
    String? userEmail,
  }) async {
    if (externalUserId.isEmpty) {
      throw ArgumentError('externalUserId must not be empty.');
    }
    if (webauthnEncodedResult.isEmpty) {
      throw ArgumentError('webauthnEncodedResult must not be empty.');
    }

    return {
      'external_user_id': externalUserId,
      'access_token': 'mock-access-token',
      'id_token': 'mock-id-token',
      'expires_in': 3600,
      'message':
          'External WebAuthn registration completed successfully (mock).',
    };
  }
}
