import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Handles initialization of external WebAuthn registration for cross-device flows
/// specifically designed for logged-out users.
///
/// This class manages the first step in a cross-device WebAuthn registration flow
/// where the user isn't currently authenticated. It generates a cross-device ticket
/// that can be used to complete registration on a secondary device.
///
/// The flow enables secure credential registration across devices while maintaining:
/// - User privacy through external user identifiers
/// - Security through time-limited tickets
/// - Flexibility for various device combinations
///
/// Typical usage flow:
/// 1. Call [initRegistration] to get a cross-device ticket
/// 2. Transfer ticket to secondary device (QR code, link, etc.)
/// 3. Complete registration on secondary device using the ticket
///
/// Example:
/// ```dart
/// final externalRegInit = AortemTransmitWebAuthnCrossDeviceExternalRegistrationInit(
///   apiKey: 'your_api_key_here',
///   baseUrl: 'https://api.authservice.com',
/// );
///
/// final initResponse = await externalRegInit.initRegistration(
///   externalUserId: 'user_123',
///   username: 'user@example.com',
/// );
/// ```
class AortemTransmitWebAuthnCrossDeviceExternalRegistrationInit {
  /// The API key used to authenticate requests to the Transmit API
  final String apiKey;

  /// The base URL for all API endpoints (e.g., 'https://api.transmitsecurity.io')
  final String baseUrl;

  /// Creates a new instance for managing external cross-device WebAuthn registration.
  ///
  /// [apiKey]: The authentication key for API requests (required)
  /// [baseUrl]: The root URL for the API service (required)
  AortemTransmitWebAuthnCrossDeviceExternalRegistrationInit({
    required this.apiKey,
    required this.baseUrl,
  });

  /// Initiates a cross-device WebAuthn registration flow for external/unauthenticated users.
  ///
  /// This method:
  /// - Validates required user identifiers
  /// - Creates a new cross-device registration ticket
  /// - Returns the ticket ID and metadata needed for secondary device registration
  ///
  /// Throws:
  /// - [ArgumentError] if validation fails
  /// - [Exception] for API errors with descriptive messages
  ///
  /// [externalUserId]: Your system's unique identifier for the user (required)
  /// [username]: Human-readable account identifier (required)
  ///
  /// Returns [Future<Map<String, dynamic>>] containing:
  /// - cross_device_ticket_id: The ticket for secondary device registration
  /// - username: Echo of provided username
  /// - external_user_id: Echo of provided external ID
  /// - expires_in: Ticket validity duration in seconds
  /// - message: Optional status message
  Future<Map<String, dynamic>> initRegistration({
    required String externalUserId,
    required String username,
  }) async {
    // Validate inputs
    if (externalUserId.trim().isEmpty) {
      throw ArgumentError("External user ID must not be empty.");
    }
    if (username.trim().isEmpty) {
      throw ArgumentError("Username must not be empty.");
    }

    final url = Uri.parse(
      '$baseUrl/v1/webauthn/cross-device/external-registration/init',
    );

    // Make API request
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'external_user_id': externalUserId,
        'username': username,
      }),
    );

    // Handle response
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 400) {
      throw Exception(
        "Invalid input for cross-device external registration init.",
      );
    } else {
      throw Exception(
        "Failed to initialize cross-device external registration "
        "[${response.statusCode}]: ${response.body}",
      );
    }
  }

  /// Mock implementation that simulates successful registration initialization.
  ///
  /// This version:
  /// - Validates inputs identically to the real implementation
  /// - Returns realistic mock data
  /// - Never makes actual network calls
  ///
  /// Ideal for:
  /// - Unit testing
  /// - Development without API access
  /// - CI/CD pipelines
  ///
  /// Parameters and validation match [initRegistration].
  ///
  /// Returns [Future<Map<String, dynamic>>] with mock response data
  Future<Map<String, dynamic>> mockInitRegistration({
    required String externalUserId,
    required String username,
  }) async {
    // Validate (same as real implementation)
    if (externalUserId.trim().isEmpty) {
      throw ArgumentError("External user ID must not be empty.");
    }
    if (username.trim().isEmpty) {
      throw ArgumentError("Username must not be empty.");
    }

    // Return mock data
    return {
      "cross_device_ticket_id":
          "mock_ticket_${DateTime.now().millisecondsSinceEpoch}",
      "username": username,
      "external_user_id": externalUserId,
      "expires_in": 300,
      "message": "Mock external registration init successful.",
      "mock_data": true, // Flag indicating this is mock data
    };
  }
}
