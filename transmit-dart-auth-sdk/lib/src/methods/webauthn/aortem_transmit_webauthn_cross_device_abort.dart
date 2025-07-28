import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Handles aborting an ongoing WebAuthn cross-device operation.
class AortemTransmitWebAuthnCrossDeviceAbort {
  final String apiKey;
  final String baseUrl;

  AortemTransmitWebAuthnCrossDeviceAbort({
    required this.apiKey,
    required this.baseUrl,
  });

  /// Aborts an ongoing WebAuthn cross-device session.
  ///
  /// - [crossDeviceTicketId]: The ticket ID of the ongoing cross-device session.
  ///
  /// Returns a confirmation response (empty for 204 No Content).
  ///
  /// Throws:
  /// - `ArgumentError` if [crossDeviceTicketId] is empty.
  /// - `Exception` if the API request fails.
  Future<void> abortCrossDeviceSession({
    required String crossDeviceTicketId,
  }) async {
    if (crossDeviceTicketId.isEmpty) {
      throw ArgumentError("crossDeviceTicketId must not be empty.");
    }

    final String url = "$baseUrl/webauthn-cross-device-abort";
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

      if (response.statusCode != 204) {
        throw Exception(
          "Failed to abort cross-device session: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e) {
      throw Exception("Error while aborting cross-device session: $e");
    }
  }
}
