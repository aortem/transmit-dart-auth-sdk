import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Handles the initiation of WebAuthn cross-device authentication processes.
///
/// This class manages the starting point for authenticating users across devices
/// using WebAuthn credentials. It provides both production and mock implementations
/// for starting cross-device authentication flows.
///
/// Key Features:
/// - Starts cross-device authentication flows
/// - Returns WebAuthn credential request options
/// - Validates input parameters
/// - Handles API errors gracefully
/// - Provides mock implementation for testing
///
/// Typical Flow:
/// 1. Initialize cross-device authentication (gets ticket ID)
/// 2. Call [startAuthentication] with the ticket ID
/// 3. Use returned options with WebAuthn API to authenticate
///
/// Example Usage:
/// ```dart
/// final authStarter = AortemTransmitWebAuthnCrossDeviceAuthenticateStart(
///   apiKey: 'your_api_key',
///   baseUrl: 'https://api.authservice.com',
/// );
///
/// final authOptions = await authStarter.startAuthentication(
///   crossDeviceTicketId: 'ticket_123',
/// );
/// ```
class AortemTransmitWebAuthnCrossDeviceAuthenticateStart {
  /// The API key used for authenticating requests to the service
  final String apiKey;

  /// The base URL for the authentication API endpoints
  final String baseUrl;

  /// Creates a new instance for managing WebAuthn cross-device authentication.
  ///
  /// [apiKey]: Required authentication key for API requests
  /// [baseUrl]: Required root URL for the authentication service
  AortemTransmitWebAuthnCrossDeviceAuthenticateStart({
    required this.apiKey,
    required this.baseUrl,
  });

  /// Initiates a WebAuthn cross-device authentication process.
  ///
  /// This method:
  /// - Validates the cross-device ticket ID
  /// - Makes an authenticated API request
  /// - Returns WebAuthn credential request options including:
  ///   - Challenge value
  ///   - Timeout duration
  ///   - Allowed credentials
  ///   - Session identifier
  ///
  /// Throws:
  /// - [ArgumentError] if [crossDeviceTicketId] is empty
  /// - [Exception] for API errors with specific status codes
  ///
  /// [crossDeviceTicketId]: The unique identifier for the cross-device flow
  ///                        (received from initialization)
  ///
  /// Returns [Future<Map<String, dynamic>>] containing:
  /// - credential_request_options: WebAuthn authentication options
  /// - session_id: The authentication session identifier
  Future<Map<String, dynamic>> startAuthentication({
    required String crossDeviceTicketId,
  }) async {
    // Validate required parameter
    if (crossDeviceTicketId.isEmpty) {
      throw ArgumentError("crossDeviceTicketId must not be empty.");
    }

    final url = '$baseUrl/v1/auth/webauthn/cross-device/authenticate/start';

    // Configure request headers
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    // Prepare request body
    final body = {'cross_device_ticket_id': crossDeviceTicketId};

    // Execute API request
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    // Handle response
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      throw Exception("Invalid crossDeviceTicketId provided.");
    } else if (response.statusCode == 404) {
      throw Exception("Cross-device ticket not found.");
    } else {
      throw Exception(
        "Failed to start WebAuthn cross-device authentication "
        "[${response.statusCode}]: ${response.body}",
      );
    }
  }

  /// Mock implementation that simulates authentication initiation.
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
  /// Parameters and validation match [startAuthentication].
  ///
  /// Returns [Future<Map<String, dynamic>>] with mock authentication options:
  /// - credential_request_options: Mock WebAuthn options
  /// - session_id: Mock session identifier
  Future<Map<String, dynamic>> mockStartAuthentication({
    required String crossDeviceTicketId,
  }) async {
    // Validate input (consistent with real implementation)
    if (crossDeviceTicketId.isEmpty) {
      throw ArgumentError("crossDeviceTicketId must not be empty.");
    }

    // Return mock response structure
    return {
      'credential_request_options': {
        'challenge': 'mock_challenge_${DateTime.now().millisecondsSinceEpoch}',
        'timeout': 60000,
        'rpId': 'example.com',
        'allowCredentials': [
          {
            'id': 'mock_credential_id_123',
            'type': 'public-key',
            'transports': ['usb', 'nfc', 'ble'],
          },
        ],
        'userVerification': 'preferred',
      },
      'session_id': 'mock-session-${DateTime.now().millisecondsSinceEpoch}',
      'mock_data': true, // Explicit flag indicating mock response
    };
  }
}
