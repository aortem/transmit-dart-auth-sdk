import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Handles the initiation of WebAuthn registration processes for users.
///
/// This class provides functionality to:
/// - Start WebAuthn credential registration flows
/// - Retrieve registration options (challenge, user info, timeout)
/// - Support both production and testing environments
///
/// The registration process follows the WebAuthn specification, providing
/// the necessary options for credential creation on the client side.
///
/// Typical flow:
/// 1. Call [startRegistration] to get credential creation options
/// 2. Use the options with the WebAuthn browser API
/// 3. Complete registration with the generated credential
///
/// Example usage:
/// ```dart
/// final registrationStarter = AortemTransmitWebAuthnRegistrationStart(
///   apiKey: 'your_api_key_here',
///   baseUrl: 'https://api.authservice.com',
/// );
///
/// final registrationOptions = await registrationStarter.startRegistration(
///   clientId: 'your_client_id',
///   username: 'user@example.com',
///   displayName: 'Example User',
/// );
/// ```
class AortemTransmitWebAuthnRegistrationStart {
  /// The API key used for authenticating with the registration service
  final String apiKey;

  /// The base URL for the WebAuthn registration endpoints
  final String baseUrl;

  /// Creates a new WebAuthn registration starter instance.
  ///
  /// [apiKey]: The authentication key for API requests
  /// [baseUrl]: The root URL for the registration service
  AortemTransmitWebAuthnRegistrationStart({
    required this.apiKey,
    required this.baseUrl,
  });

  /// Initiates a WebAuthn registration process for a user.
  ///
  /// This method:
  /// - Validates required input parameters
  /// - Makes an authenticated API request to start registration
  /// - Returns credential creation options including:
  ///   - Challenge value
  ///   - User information
  ///   - Timeout duration
  ///   - Session identifier
  ///
  /// Throws [ArgumentError] if required parameters are empty.
  /// Throws [Exception] for API errors with specific status codes.
  ///
  /// [clientId]: The application's client identifier (required)
  /// [username]: The user's unique identifier (required)
  /// [displayName]: Human-readable name for the user account (optional)
  /// [timeout]: Registration timeout in seconds (30-600, optional)
  /// [limitSingleCredentialToDevice]: Restricts credentials to single device
  ///
  /// Returns a [Future<Map<String, dynamic>>] containing:
  /// - credential_creation_options: WebAuthn registration options
  /// - session_id: The registration session identifier
  Future<Map<String, dynamic>> startRegistration({
    required String clientId,
    required String username,
    String? displayName,
    int? timeout,
    bool limitSingleCredentialToDevice = false,
  }) async {
    // Validate required parameters
    if (clientId.isEmpty) {
      throw ArgumentError("clientId must not be empty.");
    }
    if (username.isEmpty) {
      throw ArgumentError("username must not be empty.");
    }

    final url = '$baseUrl/v1/auth/webauthn/registration/start';

    // Configure request headers
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    // Prepare request body
    final body = {
      'client_id': clientId,
      'username': username,
      if (displayName != null) 'display_name': displayName,
      if (timeout != null) 'timeout': timeout,
      'limit_single_credential_to_device': limitSingleCredentialToDevice,
    };

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
      throw Exception("Invalid input for WebAuthn registration start.");
    } else if (response.statusCode == 404) {
      throw Exception("WebAuthn registration endpoint not found.");
    } else {
      throw Exception(
        "Failed to start WebAuthn registration [${response.statusCode}]: ${response.body}",
      );
    }
  }

  /// Provides mock registration options for testing purposes.
  ///
  /// This method:
  /// - Simulates the API response without network calls
  /// - Validates inputs identically to the real method
  /// - Returns realistic mock data structure
  ///
  /// Useful for:
  /// - Unit tests
  /// - Development without API access
  /// - CI/CD pipelines
  ///
  /// Parameters match [startRegistration] with identical validation.
  ///
  /// Returns a [Future<Map<String, dynamic>>] with mock registration options:
  /// - credential_creation_options: Mock WebAuthn options
  /// - session_id: Mock session identifier
  Future<Map<String, dynamic>> mockStartRegistration({
    required String clientId,
    required String username,
    String? displayName,
    int? timeout,
    bool limitSingleCredentialToDevice = false,
  }) async {
    // Validate inputs (consistent with real implementation)
    if (clientId.isEmpty) {
      throw ArgumentError("clientId must not be empty.");
    }
    if (username.isEmpty) {
      throw ArgumentError("username must not be empty.");
    }

    // Return mock response structure
    return {
      'credential_creation_options': {
        'challenge': 'mock_challenge_base64',
        'user': {
          'id': 'mock_user_id_base64',
          'name': username,
          'displayName': displayName ?? username,
        },
        'timeout': timeout ?? 300,
      },
      'session_id': 'mock_session_id_123',
    };
  }
}
