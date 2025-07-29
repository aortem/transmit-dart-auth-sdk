import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Handles the initialization of cross-device WebAuthn registration flows.
///
/// This class provides functionality to:
/// - Initiate cross-device WebAuthn credential registration
/// - Generate registration options for secondary devices
/// - Support both production and testing environments
///
/// The cross-device registration flow allows users to register credentials
/// on one device that can be used for authentication on other devices.
///
/// Typical flow:
/// 1. Start cross-device registration (gets ticket ID)
/// 2. Initialize registration on secondary device (this endpoint)
/// 3. Complete registration with generated credential
///
/// Example usage:
/// ```dart
/// final registrationInit = AortemTransmitWebAuthnCrossDeviceRegistrationInit(
///   apiKey: 'your_api_key',
///   baseUrl: 'https://api.authservice.com',
/// );
///
/// final options = await registrationInit.initRegistration(
///   crossDeviceTicketId: 'ticket_123456',
/// );
/// ```
class AortemTransmitWebAuthnCrossDeviceRegistrationInit {
  /// The API key used for authenticating requests to the service
  final String apiKey;

  /// The base URL for the WebAuthn cross-device API endpoints
  final String baseUrl;

  /// Creates a new instance for managing cross-device WebAuthn registration.
  ///
  /// [apiKey]: The authentication key for API requests
  /// [baseUrl]: The root URL for the registration service
  AortemTransmitWebAuthnCrossDeviceRegistrationInit({
    required this.apiKey,
    required this.baseUrl,
  });

  /// Initiates a cross-device WebAuthn registration process on a secondary device.
  ///
  /// This method:
  /// - Validates the cross-device ticket ID
  /// - Makes an authenticated API request to initialize registration
  /// - Returns credential creation options including:
  ///   - Challenge value
  ///   - Relying Party information
  ///   - User details
  ///   - Timeout configuration
  ///
  /// Throws:
  /// - [ArgumentError] if [crossDeviceTicketId] is empty
  /// - [Exception] for API errors with specific status codes
  ///
  /// [crossDeviceTicketId]: The unique identifier for the ongoing cross-device session
  ///                        (obtained from the initial registration start call)
  ///
  /// Returns [Future<Map<String, dynamic>>] containing:
  /// - credential_creation_options: WebAuthn registration options
  /// - expires_in: Time until options expire (seconds)
  Future<Map<String, dynamic>> initRegistration({
    required String crossDeviceTicketId,
  }) async {
    // Validate required parameter
    if (crossDeviceTicketId.trim().isEmpty) {
      throw ArgumentError("crossDeviceTicketId must not be empty.");
    }

    final url = Uri.parse(
      '$baseUrl/v1/webauthn/cross-device/registration/init',
    );

    // Execute API request
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'cross_device_ticket_id': crossDeviceTicketId}),
    );

    // Handle response
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 400) {
      throw Exception(
        "Invalid input for WebAuthn cross-device registration init.",
      );
    } else if (response.statusCode == 404) {
      throw Exception("Cross-device registration init endpoint not found.");
    } else {
      throw Exception(
        "Failed to initiate cross-device registration "
        "[${response.statusCode}]: ${response.body}",
      );
    }
  }

  /// Mock implementation for testing registration initialization.
  ///
  /// Simulates successful registration initialization with:
  /// - Mock challenge value
  /// - Sample Relying Party information
  /// - Example user details
  /// - Standard timeout
  ///
  /// Validates input identically to the real implementation.
  ///
  /// [crossDeviceTicketId]: The mock ticket identifier (must not be empty)
  ///
  /// Returns [Future<Map<String, dynamic>>] with mock registration options
  Future<Map<String, dynamic>> mockInitRegistration({
    required String crossDeviceTicketId,
  }) async {
    if (crossDeviceTicketId.trim().isEmpty) {
      throw ArgumentError("crossDeviceTicketId must not be empty.");
    }

    return {
      "credential_creation_options": {
        "challenge": "mock_base64_challenge",
        "timeout": 60000,
        "rp": {"name": "Example RP", "id": "example.com"},
        "user": {
          "id": "mock_user_id",
          "name": "mock_user@example.com",
          "displayName": "Mock User",
        },
        "pubKeyCredParams": [
          {"type": "public-key", "alg": -7}, // ES256
          {"type": "public-key", "alg": -257}, // RS256
        ],
        "authenticatorSelection": {
          "authenticatorAttachment": "cross-platform",
          "requireResidentKey": false,
          "userVerification": "preferred",
        },
        "attestation": "none",
      },
      "expires_in": 300,
    };
  }
}
