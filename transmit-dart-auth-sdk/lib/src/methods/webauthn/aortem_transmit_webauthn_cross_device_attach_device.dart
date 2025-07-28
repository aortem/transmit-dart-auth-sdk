import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Handles attaching a device to an ongoing WebAuthn cross-device session.
class AortemTransmitWebAuthnCrossDeviceAttachDevice {
  final String apiKey;
  final String baseUrl;

  AortemTransmitWebAuthnCrossDeviceAttachDevice({
    required this.apiKey,
    required this.baseUrl,
  });

  /// Attaches a device to a WebAuthn cross-device session.
  ///
  /// - [crossDeviceTicketId]: The ticket ID of the ongoing cross-device session.
  ///
  /// Returns the backend response containing updated session status and metadata.
  ///
  /// Throws:
  /// - `ArgumentError` if [crossDeviceTicketId] is empty.
  /// - `Exception` if the API request fails.
  Future<Map<String, dynamic>> attachDevice({
    required String crossDeviceTicketId,
  }) async {
    if (crossDeviceTicketId.isEmpty) {
      throw ArgumentError("crossDeviceTicketId must not be empty.");
    }

    final String url = "$baseUrl/webauthn-cross-device-attach-device";
    final headers = {
      "Authorization": "Bearer $apiKey",
      "Content-Type": "application/json",
    };

    final body = jsonEncode({"cross_device_ticket_id": crossDeviceTicketId});

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          "Failed to attach device: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e) {
      throw Exception("Error while attaching device: $e");
    }
  }
}
