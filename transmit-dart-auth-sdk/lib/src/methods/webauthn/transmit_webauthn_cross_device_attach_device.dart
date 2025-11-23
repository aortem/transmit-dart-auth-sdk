import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Handles the attachment of devices to ongoing WebAuthn cross-device authentication sessions.
///
/// This class provides functionality to:
/// - Attach additional devices to existing cross-device authentication flows
/// - Validate input parameters
/// - Handle API communication with proper error management
///
/// The cross-device WebAuthn flow allows users to authenticate on one device
/// using credentials stored on another device. This endpoint facilitates adding
/// new devices to such ongoing authentication sessions.
///
/// Example usage:
/// ```dart
/// final attachDevice = AortemTransmitWebAuthnCrossDeviceAttachDevice(
///   apiKey: 'your_api_key',
///   baseUrl: 'https://api.authservice.com',
/// );
///
/// final result = await attachDevice.attachDevice(
///   crossDeviceTicketId: 'ticket_123456',
/// );
/// ```
class AortemTransmitWebAuthnCrossDeviceAttachDevice {
  /// The API key used for authenticating requests to the service
  final String apiKey;

  /// The base URL for the WebAuthn cross-device API endpoints
  final String baseUrl;

  /// Creates a new instance for managing WebAuthn cross-device attachments.
  ///
  /// [apiKey]: The authentication key for API requests
  /// [baseUrl]: The root URL for the cross-device service
  AortemTransmitWebAuthnCrossDeviceAttachDevice({
    required this.apiKey,
    required this.baseUrl,
  });

  /// Attaches a device to an ongoing WebAuthn cross-device authentication session.
  ///
  /// This method:
  /// - Validates the cross-device ticket ID
  /// - Makes an authenticated API request to attach the device
  /// - Returns the updated session status containing:
  ///   - Session metadata
  ///   - Device information
  ///   - Authentication status
  ///
  /// Throws:
  /// - [ArgumentError] if [crossDeviceTicketId] is empty
  /// - [Exception] for API errors or network failures
  ///
  /// [crossDeviceTicketId]: The unique identifier for the ongoing cross-device session
  ///                        (obtained during session initialization)
  ///
  /// Returns [Future<Map<String, dynamic>>] containing:
  /// - session_status: Current state of the authentication session
  /// - attached_devices: List of connected devices
  /// - expiration: Session expiration timestamp
  Future<Map<String, dynamic>> attachDevice({
    required String crossDeviceTicketId,
  }) async {
    // Validate required parameter
    if (crossDeviceTicketId.isEmpty) {
      throw ArgumentError("crossDeviceTicketId must not be empty.");
    }

    final String url = "$baseUrl/webauthn-cross-device-attach-device";

    // Configure request headers
    final headers = {
      "Authorization": "Bearer $apiKey",
      "Content-Type": "application/json",
    };

    // Prepare request body
    final body = jsonEncode({"cross_device_ticket_id": crossDeviceTicketId});

    try {
      // Execute API request
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      // Handle successful response
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // Handle API errors
        throw Exception(
          "Failed to attach device: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e) {
      // Handle network/parsing errors
      throw Exception("Error while attaching device: $e");
    }
  }

  /// Mock implementation for testing device attachment without API calls.
  ///
  /// Simulates successful device attachment with:
  /// - Mock session status
  /// - Sample device information
  /// - Future expiration timestamp
  ///
  /// Validates input identically to the real implementation.
  ///
  /// [crossDeviceTicketId]: The mock ticket identifier (must not be empty)
  ///
  /// Returns [Future<Map<String, dynamic>>] with mock attachment confirmation
  Future<Map<String, dynamic>> mockAttachDevice({
    required String crossDeviceTicketId,
  }) async {
    if (crossDeviceTicketId.isEmpty) {
      throw ArgumentError("crossDeviceTicketId must not be empty.");
    }

    return {
      "session_status": "device_attached",
      "attached_devices": [
        {
          "device_id": "mock_device_123",
          "device_type": "mobile",
          "attached_at": DateTime.now().toIso8601String(),
        },
      ],
      "expiration": DateTime.now().add(Duration(minutes: 5)).toIso8601String(),
    };
  }
}
