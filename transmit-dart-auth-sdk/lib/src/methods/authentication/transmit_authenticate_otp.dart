import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for authenticating One-Time Passcodes (OTP) via Transmit Security's API.
///
/// This class handles OTP verification by communicating with Transmit Security's
/// authentication endpoint. It supports both production and testing environments.
///
/// Example Usage:
/// ```dart
/// final otpService = AortemTransmitAuthenticateOTP(
///   apiKey: 'your-api-key-here',
/// );
///
/// try {
///   final authResult = await otpService.authenticateOTP(
///     passcode: '123456',
///     identifierType: 'phone',
///     identifier: '+15551234567',
///   );
///   print('Authentication successful: ${authResult['access_token']}');
/// } catch (e) {
///   print('Authentication failed: $e');
/// }
/// ```
class AortemTransmitAuthenticateOTP {
  /// The API key used for authenticating with Transmit Security's services
  final String apiKey;

  /// The base URL for the OTP authentication endpoint
  ///
  /// Defaults to Transmit Security's production endpoint:
  /// 'https://api.transmitsecurity.io/cis/v1/auth/otp/authenticate'
  final String baseUrl;

  /// The HTTP client used for making requests
  ///
  /// Uses a default client if none is provided
  final http.Client httpClient;

  /// Creates an OTP authentication service instance
  ///
  /// Parameters:
  /// - [apiKey]: Required API key for authentication
  /// - [baseUrl]: Optional custom base URL (defaults to production endpoint)
  /// - [httpClient]: Optional custom HTTP client
  AortemTransmitAuthenticateOTP({
    required this.apiKey,
    this.baseUrl =
        'https://api.transmitsecurity.io/cis/v1/auth/otp/authenticate',
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  /// Authenticates a user using a one-time passcode (OTP)
  ///
  /// This method verifies the OTP passcode against the provided identifier
  /// (phone number, email, etc.) and returns authentication tokens if successful.
  ///
  /// Parameters:
  /// - [passcode]: The OTP code to verify (6-8 digits typically)
  /// - [identifierType]: The type of identifier ('phone', 'email', etc.)
  /// - [identifier]: The actual identifier value (phone number, email address)
  /// - [resource]: Optional resource parameter for scoped authentication
  ///
  /// Returns:
  /// - A [Future] that resolves to a [Map] containing:
  ///   - access_token: Bearer token for API access
  ///   - id_token: User identity token
  ///   - refresh_token: Token for obtaining new access tokens
  ///   - token_type: Typically 'Bearer'
  ///   - expires_in: Token validity in seconds
  ///   - session_id: Unique session identifier
  ///
  /// Throws:
  /// - [ArgumentError] if passcode or identifier are empty
  /// - [Exception] if authentication fails (contains status code and error details)
  Future<Map<String, dynamic>> authenticateOTP({
    required String passcode,
    required String identifierType,
    required String identifier,
    String? resource,
  }) async {
    if (passcode.isEmpty || identifier.isEmpty) {
      throw ArgumentError('Passcode and identifier cannot be empty');
    }

    final url = Uri.parse(baseUrl);

    final payload = json.encode({
      "passcode": passcode,
      "identifier_type": identifierType,
      "identifier": identifier,
      if (resource != null) "resource": resource,
    });

    final response = await httpClient.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: payload,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
        'Authenticate OTP failed: ${response.statusCode} ${response.body}',
      );
    }
  }

  /// Testing stub that simulates OTP authentication
  ///
  /// This method mimics the production authentication flow without making
  /// actual API calls. Useful for unit testing and development.
  ///
  /// Parameters:
  /// - [passcode]: The OTP code (must not be empty)
  /// - [identifierType]: The identifier type (must not be empty)
  /// - [identifier]: The identifier value (must not be empty)
  ///
  /// Returns:
  /// - A [Future] that resolves after a short delay with mock authentication data:
  ///   - access_token: 'dummy-access-token'
  ///   - id_token: 'dummy-id-token'
  ///   - refresh_token: 'dummy-refresh-token'
  ///   - token_type: 'Bearer'
  ///   - expires_in: 3600
  ///   - session_id: 'dummy-session-id'
  ///
  /// Throws:
  /// - [ArgumentError] if any required parameter is empty
  Future<Map<String, dynamic>> authenticateOTPStub({
    required String passcode,
    required String identifierType,
    required String identifier,
  }) async {
    if (passcode.isEmpty || identifier.isEmpty) {
      throw ArgumentError('Passcode and identifier cannot be empty');
    }

    await Future.delayed(const Duration(milliseconds: 200));

    return {
      "access_token": "dummy-access-token",
      "id_token": "dummy-id-token",
      "refresh_token": "dummy-refresh-token",
      "token_type": "Bearer",
      "expires_in": 3600,
      "session_id": "dummy-session-id",
    };
  }
}
