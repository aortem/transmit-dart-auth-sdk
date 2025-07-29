import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Handles the termination of ongoing WebAuthn cross-device authentication or registration flows.
///
/// This class provides functionality to:
/// - Abort active cross-device WebAuthn operations
/// - Clean up server-side resources
/// - Prevent dangling authentication states
///
/// Security Considerations:
/// - Always call abort for incomplete flows to prevent resource leaks
/// - Tickets become invalid after aborting
/// - No sensitive data is returned from abort operations
///
/// Typical Usage:
/// ```dart
/// final abortHandler = AortemTransmitWebAuthnCrossDeviceAbort(
///   apiKey: 'your_api_key',
///   baseUrl: 'https://api.authservice.com',
/// );
///
/// await abortHandler.abortCrossDeviceSession(
///   crossDeviceTicketId: 'ticket_123',
/// );
/// ```
class AortemTransmitWebAuthnCrossDeviceAbort {
  /// The API key used for authenticating abort requests
  final String apiKey;

  /// The base URL for the WebAuthn cross-device API endpoints
  final String baseUrl;

  /// Creates a new cross-device abort handler instance.
  ///
  /// [apiKey]: Required authentication key for API requests
  /// [baseUrl]: Required root URL for the service
  AortemTransmitWebAuthnCrossDeviceAbort({
    required this.apiKey,
    required this.baseUrl,
  });

  /// Aborts an ongoing WebAuthn cross-device operation.
  ///
  /// This method:
  /// - Validates the cross-device ticket ID
  /// - Makes an authenticated API request to abort the session
  /// - Cleans up server-side resources
  /// - Returns nothing on success (204 No Content)
  ///
  /// Throws:
  /// - [ArgumentError] if [crossDeviceTicketId] is empty
  /// - [Exception] for API errors or network failures
  ///
  /// [crossDeviceTicketId]: The unique identifier for the ongoing cross-device session
  ///                        (obtained during flow initialization)
  Future<void> abortCrossDeviceSession({
    required String crossDeviceTicketId,
  }) async {
    // Validate required parameter
    if (crossDeviceTicketId.isEmpty) {
      throw ArgumentError("crossDeviceTicketId must not be empty.");
    }

    final String url = "$baseUrl/webauthn-cross-device-abort";

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

      // Handle successful abort (204 No Content)
      if (response.statusCode != 204) {
        throw Exception(
          "Failed to abort cross-device session: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e) {
      throw Exception("Error while aborting cross-device session: $e");
    }
  }

  /// Mock implementation for testing abort functionality.
  ///
  /// Simulates successful session abortion with:
  /// - Input validation identical to real implementation
  /// - No network calls
  /// - Immediate success response
  ///
  /// [crossDeviceTicketId]: The mock ticket identifier (must not be empty)
  Future<void> mockAbortCrossDeviceSession({
    required String crossDeviceTicketId,
  }) async {
    if (crossDeviceTicketId.isEmpty) {
      throw ArgumentError("crossDeviceTicketId must not be empty.");
    }
    // Simulate successful abort with no return value
    return;
  }
}
