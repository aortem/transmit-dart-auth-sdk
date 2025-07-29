import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Service for issuing new tokens via Transmit Security API.
class AortemTransmitTokenService {
  /// The base URL of the Transmit Security API.
  final String baseUrl;

  /// Creates an instance of [AortemTransmitTokenService].
  const AortemTransmitTokenService({
    this.baseUrl = 'https://api.transmitsecurity.com',
  });

  /// Issues a new client access token.
  ///
  /// - Requires [clientId] and [clientSecret].
  /// - Returns a `Map<String, dynamic>` containing `access_token`, `token_type`, `expires_in`.
  Future<Map<String, dynamic>> issueToken({
    required String clientId,
    required String clientSecret,
    String resource = "https://verify.identity.security",
  }) async {
    if (clientId.isEmpty || clientSecret.isEmpty) {
      throw ArgumentError("Client ID and Client Secret cannot be empty.");
    }

    final url = Uri.parse('$baseUrl/oidc/token');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'grant_type': 'client_credentials',
        'resource': resource,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
        "Token issuance failed: ${response.statusCode} ${response.body}",
      );
    }
  }

  /// Mock token issuance for local testing.
  Future<Map<String, dynamic>> issueTokenStub({
    required String clientId,
    required String clientSecret,
  }) async {
    if (clientId.isEmpty || clientSecret.isEmpty) {
      throw ArgumentError("Client ID and Client Secret cannot be empty.");
    }

    await Future.delayed(const Duration(milliseconds: 150));

    return {
      "access_token": "mock-client-token",
      "token_type": "Bearer",
      "expires_in": 3600,
      "issued_at": DateTime.now().toIso8601String(),
    };
  }
}
