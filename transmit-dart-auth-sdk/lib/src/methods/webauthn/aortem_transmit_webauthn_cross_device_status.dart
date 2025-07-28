import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Handles monitoring the status of ongoing WebAuthn cross-device operations.
///
/// This class provides functionality to:
/// - Check the current state of cross-device authentication/registration flows
/// - Monitor operation expiration times
/// - Track progress of pending operations
/// - Support both production and testing environments
///
/// Security Considerations:
/// - Status checks don't modify the operation state
/// - Ticket IDs should be treated as sensitive data
/// - Expiration times should be respected client-side
///
/// Typical Usage:
/// ```dart
/// final statusChecker = AortemTransmitWebAuthnCrossDeviceStatus(
///   apiKey: 'your_api_key',
///   baseUrl: 'https://api.authservice.com',
/// );
///
/// final status = await statusChecker.getStatus(
///   crossDeviceTicketId: 'ticket_123',
/// );
/// ```
class AortemTransmitWebAuthnCrossDeviceStatus {
  /// The API key used for authenticating status requests
  final String apiKey;

  /// The base URL for the WebAuthn cross-device API endpoints
  final String baseUrl;

  /// Creates a new cross-device status checker instance.
  ///
  /// [apiKey]: Required authentication key for API requests
  /// [baseUrl]: Required root URL for the service
  AortemTransmitWebAuthnCrossDeviceStatus({
    required this.apiKey,
    required this.baseUrl,
  });

  /// Retrieves the current status of a cross-device WebAuthn operation.
  ///
  /// This method:
  /// - Validates the cross-device ticket ID
  /// - Makes an authenticated API request to check status
  /// - Returns operation metadata including:
  ///   - Current status (pending, completed, expired, etc.)
  ///   - Time remaining until expiration
  ///   - Last update timestamp
  ///
  /// Throws:
  /// - [ArgumentError] if [crossDeviceTicketId] is empty
  /// - [Exception] for API errors with specific status codes
  ///
  /// [crossDeviceTicketId]: The unique identifier for the ongoing operation
  ///                        (obtained during flow initialization)
  ///
  /// Returns [Future<Map<String, dynamic>>] containing:
  /// - status: String indicating current operation state
  /// - cross_device_ticket_id: Echo of provided ticket ID
  /// - expires_in: Milliseconds remaining until expiration
  /// - last_updated: ISO-8601 timestamp of last status change
  Future<Map<String, dynamic>> getStatus({
    required String crossDeviceTicketId,
  }) async {
    // Validate required parameter
    if (crossDeviceTicketId.isEmpty) {
      throw ArgumentError("crossDeviceTicketId must not be empty.");
    }

    final url =
        '$baseUrl/v1/auth/webauthn/cross-device/status'
        '?cross_device_ticket_id=$crossDeviceTicketId';

    // Configure request headers
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    // Execute API request
    final response = await http.get(Uri.parse(url), headers: headers);

    // Handle response
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

  /// Mock implementation for testing status checks.
  ///
  /// Simulates status responses with:
  /// - Input validation identical to real implementation
  /// - No network calls
  /// - Realistic mock data including timestamps
  ///
  /// [crossDeviceTicketId]: The mock ticket identifier (must not be empty)
  ///
  /// Returns [Future<Map<String, dynamic>>] with mock status data:
  /// - status: Always returns 'pending' for mock
  /// - cross_device_ticket_id: Echo of provided ID
  /// - expires_in: Fixed 30 second expiration
  /// - last_updated: Current timestamp
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
      'mock_data': true, // Explicit flag indicating mock response
    };
  }
}
