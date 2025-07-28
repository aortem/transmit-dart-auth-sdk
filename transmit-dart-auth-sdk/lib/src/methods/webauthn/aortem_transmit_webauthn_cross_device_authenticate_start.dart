import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Handles starting a WebAuthn cross-device authentication process.
class AortemTransmitWebAuthnCrossDeviceAuthenticateStart {
  final String apiKey;
  final String baseUrl;

  AortemTransmitWebAuthnCrossDeviceAuthenticateStart({
    required this.apiKey,
    required this.baseUrl,
  });

  /// Starts WebAuthn cross-device authentication.
  ///
  /// Required:
  /// - [crossDeviceTicketId] – ID returned when initializing the cross-device flow.
  ///
  /// Returns authentication initiation options (challenge, session ID, allowed credentials).
  Future<Map<String, dynamic>> startAuthentication({
    required String crossDeviceTicketId,
  }) async {
    if (crossDeviceTicketId.isEmpty) {
      throw ArgumentError("crossDeviceTicketId must not be empty.");
    }

    final url = '$baseUrl/v1/auth/webauthn/cross-device/authenticate/start';
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };
    final body = {'cross_device_ticket_id': crossDeviceTicketId};

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      throw Exception("Invalid crossDeviceTicketId provided.");
    } else if (response.statusCode == 404) {
      throw Exception("Cross-device ticket not found.");
    } else {
      throw Exception(
        "Failed to start WebAuthn cross-device authentication [${response.statusCode}]: ${response.body}",
      );
    }
  }

  /// Mock version for testing.
  Future<Map<String, dynamic>> mockStartAuthentication({
    required String crossDeviceTicketId,
  }) async {
    if (crossDeviceTicketId.isEmpty) {
      throw ArgumentError("crossDeviceTicketId must not be empty.");
    }

    return {
      'credential_request_options': {
        'challenge': 'dummyChallenge123',
        'timeout': 60000,
        'allowCredentials': [
          {'id': 'cred123', 'type': 'public-key'},
        ],
      },
      'session_id': 'mock-session-123',
    };
  }
}
