import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Handles the initiation of WebAuthn cross-device authentication processes.
///
/// This class provides functionality to:
/// - Start a WebAuthn cross-device authentication flow
/// - Retrieve authentication options (challenge, allowed credentials)
/// - Handle both production and test environments
///
/// Typical flow:
/// 1. Initialize cross-device authentication
/// 2. Call [startAuthentication] with the received ticket ID
/// 3. Use returned options to perform client-side WebAuthn authentication
///
/// Example usage:
/// ```dart
/// final authStarter = AortemTransmitWebAuthnCrossDeviceAuthenticateStart(
///   apiKey: 'your_api_key',
///   baseUrl: 'https://api.example.com',
/// );
///
/// final authOptions = await authStarter.startAuthentication(
///   crossDeviceTicketId: 'ticket_123',
/// );
/// ```
class AortemTransmitWebAuthnCrossDeviceAuthenticateStart {
  /// The API key used for authenticating requests
  final String apiKey;

  /// The base URL for the authentication API endpoints
  final String baseUrl;

  /// Creates a new instance for WebAuthn cross-device authentication.
  ///
  /// [apiKey]: The authentication key for API requests
  /// [baseUrl]: The root URL for the authentication service
  AortemTransmitWebAuthnCrossDeviceAuthenticateStart({
    required this.apiKey,
    required this.baseUrl,
  });

  /// Initiates a WebAuthn cross-device authentication process.
  ///
  /// This method:
  /// - Validates the input ticket ID
  /// - Makes an authenticated API request
  /// - Returns authentication options including:
  ///   - Challenge value
  ///   - Timeout duration
  ///   - Allowed credentials
  ///   - Session identifier
  ///
  /// Throws [ArgumentError] if [crossDeviceTicketId] is empty.
  /// Throws [Exception] for API errors with specific status codes.
  ///
  /// [crossDeviceTicketId]: The unique identifier for the cross-device flow
  ///                        (received from initialization)
  ///
  /// Returns a [Future<Map<String, dynamic>>] containing:
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
        "Failed to start WebAuthn cross-device authentication [${response.statusCode}]: ${response.body}",
      );
    }
  }

  /// Provides mock authentication options for testing purposes.
  ///
  /// This method:
  /// - Simulates the API response without network calls
  /// - Validates inputs identically to the real method
  /// - Returns realistic mock data structure
  ///
  /// Useful for:
  /// - Unit tests
  /// - Development without API access
  /// - Demonstration purposes
  ///
  /// [crossDeviceTicketId]: The mock ticket identifier (must not be empty)
  ///
  /// Returns a [Future<Map<String, dynamic>>] with mock authentication options
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
