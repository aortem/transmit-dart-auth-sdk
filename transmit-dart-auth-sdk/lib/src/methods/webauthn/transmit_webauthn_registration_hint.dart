import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Handles retrieval of registration hints for hosted WebAuthn authentication.
///
/// This class provides functionality to:
/// - Retrieve registration hints needed for WebAuthn credential creation
/// - Handle both production and mock scenarios
/// - Validate input parameters
/// - Process API responses and errors
///
/// Example usage:
/// ```dart
/// final registrationHint = AortemTransmitHostedWebAuthnRegistrationHint(
///   apiKey: 'your_api_key',
///   baseUrl: 'https://api.example.com',
/// );
///
/// final hint = await registrationHint.getHint(
///   webauthnIdentifier: 'user@example.com',
///   redirectUri: 'https://app.example.com/callback',
/// );
/// ```
class AortemTransmitHostedWebAuthnRegistrationHint {
  /// The API key used for authentication
  final String apiKey;

  /// The base URL for the API endpoint
  final String baseUrl;

  /// Creates a new instance for handling WebAuthn registration hints.
  ///
  /// [apiKey]: The API key for authentication
  /// [baseUrl]: The base URL for the API endpoint
  AortemTransmitHostedWebAuthnRegistrationHint({
    required this.apiKey,
    required this.baseUrl,
  });

  /// Retrieves a hosted WebAuthn registration hint from the API.
  ///
  /// This method makes an authenticated API call to get the necessary information
  /// to initiate a WebAuthn registration process, including:
  /// - Registration token
  /// - Challenge value
  /// - Expiration time
  ///
  /// Throws [ArgumentError] if required parameters are empty.
  /// Throws [Exception] for API errors with specific status codes.
  ///
  /// [webauthnIdentifier]: The WebAuthn username/account name (required)
  /// [redirectUri]: URI to redirect after completing registration (required)
  /// [webauthnDisplayName]: Optional display name for the user account
  /// [externalUserId]: Optional external user ID in the tenant system
  ///
  /// Returns a [Future<Map<String, dynamic>>] containing the registration hint data
  Future<Map<String, dynamic>> getHint({
    required String webauthnIdentifier,
    required String redirectUri,
    String? webauthnDisplayName,
    String? externalUserId,
  }) async {
    // Validate required parameters
    if (webauthnIdentifier.isEmpty) {
      throw ArgumentError("webauthnIdentifier must not be empty.");
    }
    if (redirectUri.isEmpty) {
      throw ArgumentError("redirectUri must not be empty.");
    }

    final url = '$baseUrl/v1/auth/webauthn/hosted/registration/hint';

    // Set up request headers
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    // Prepare request body
    final body = {
      'webauthn_identifier': webauthnIdentifier,
      'redirect_uri': redirectUri,
      if (webauthnDisplayName != null)
        'webauthn_display_name': webauthnDisplayName,
      if (externalUserId != null) 'external_user_id': externalUserId,
    };

    // Make API call
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    // Handle response
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      throw Exception("Invalid input provided for WebAuthn registration hint.");
    } else if (response.statusCode == 404) {
      throw Exception("Hosted WebAuthn registration endpoint not found.");
    } else {
      throw Exception(
        "Failed to retrieve WebAuthn registration hint [${response.statusCode}]: ${response.body}",
      );
    }
  }

  /// Mock implementation for testing without making actual API calls.
  ///
  /// This method simulates the API response with mock data, useful for:
  /// - Unit testing
  /// - Development without API access
  /// - CI/CD pipelines
  ///
  /// Parameters and validation behave the same as [getHint].
  ///
  /// Returns a [Future<Map<String, dynamic>>] with mock registration hint data
  Future<Map<String, dynamic>> mockGetHint({
    required String webauthnIdentifier,
    required String redirectUri,
    String? webauthnDisplayName,
    String? externalUserId,
  }) async {
    // Validate required parameters (same as real implementation)
    if (webauthnIdentifier.isEmpty) {
      throw ArgumentError("webauthnIdentifier must not be empty.");
    }
    if (redirectUri.isEmpty) {
      throw ArgumentError("redirectUri must not be empty.");
    }

    // Return mock data structure
    return {
      'registration_token': 'mock_registration_token_123',
      'challenge': 'mock_challenge_value',
      'redirect_uri': redirectUri,
      'expires_in': 300,
      'display_name': webauthnDisplayName ?? webauthnIdentifier,
    };
  }
}
