import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Handles checking the status of a WebAuthn cross-device operation.
class AortemTransmitWebAuthnCrossDeviceStatus {
  final String apiKey;
  final String baseUrl;

  AortemTransmitWebAuthnCrossDeviceStatus({
    required this.apiKey,
    required this.baseUrl,
  });

  /// Checks the status of a cross-device WebAuthn operation.
  ///
  /// [crossDeviceTicketId] – Ticket ID obtained from the init or start method.
  Future<Map<String, dynamic>> getStatus({
    required String crossDeviceTicketId,
  }) async {
    if (crossDeviceTicketId.isEmpty) {
      throw ArgumentError("crossDeviceTicketId must not be empty.");
    }

    final url =
        '$baseUrl/v1/auth/webauthn/cross-device/status?cross_device_ticket_id=$crossDeviceTicketId';

    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      throw Exception("Invalid crossDeviceTicketId provided.");
    } else if (response.statusCode == 404) {
      throw Exception("Cross-device operation not found.");
    } else {
      throw Exception(
        "Failed to get cross-device status [${response.statusCode}]: ${response.body}",
      );
    }
  }

  /// Mock method for testing without API calls.
  Future<Map<String, dynamic>> mockGetStatus({
    required String crossDeviceTicketId,
  }) async {
    if (crossDeviceTicketId.isEmpty) {
      throw ArgumentError("crossDeviceTicketId must not be empty.");
    }

    return {
      'status': 'pending',
      'cross_device_ticket_id': crossDeviceTicketId,
      'expires_in': 30000,
      'last_updated': DateTime.now().toIso8601String(),
    };
  }
}
