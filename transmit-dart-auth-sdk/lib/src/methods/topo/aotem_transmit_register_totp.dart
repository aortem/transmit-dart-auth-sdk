import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for registering Time-based One-Time Password (TOTP) authenticators
/// with Transmit Security's API.
///
/// This class handles the registration of new TOTP authenticators for users,
/// generating secrets that can be used with authenticator apps like Google Authenticator
/// or Authy.
///
/// ## Features
/// - Generates new TOTP secrets for user enrollment
/// - Supports custom labels for authenticator apps
/// - Allows overriding existing registrations
/// - Returns enrollment URI for easy QR code generation
///
/// ## Example Usage
/// ```dart
/// final totpService = AortemTransmitRegisterTOTP(
///   apiKey: 'your-api-key',
///   baseUrl: 'https://api.transmitsecurity.com',
/// );
///
/// try {
///   final enrollment = await totpService.registerTOTP(
///     label: 'MyApp:user@example.com',
///     allowOverride: true,
///   );
///   print('TOTP Secret: ${enrollment['secret']}');
///   print('Enrollment URI: ${enrollment['uri']}');
/// } catch (e) {
///   print('Failed to register TOTP: $e');
/// }
/// ```
class AortemTransmitRegisterTOTP {
  /// The API key used for authenticating with Transmit Security's services
  final String apiKey;

  /// The base URL for the TOTP registration API endpoint
  final String baseUrl;

  /// Creates a TOTP registration service instance
  ///
  /// ## Parameters
  /// - [apiKey]: Required API key for authentication
  /// - [baseUrl]: Required base URL for the API endpoint
  AortemTransmitRegisterTOTP({required this.apiKey, required this.baseUrl});

  /// Registers a new TOTP authenticator for the current user
  ///
  /// Generates a new TOTP secret that can be used with authenticator apps.
  /// The user must be authenticated (via the API key) to use this endpoint.
  ///
  /// ## Parameters
  /// - [label]: Optional human-readable label for the authenticator app
  ///   (e.g., 'MyApp:user@example.com')
  /// - [allowOverride]: Whether to replace an existing TOTP registration
  ///   (defaults to false)
  ///
  /// ## Returns
  /// A [Future] that resolves to a [Map] containing:
  /// - `secret`: The TOTP shared secret (base32 encoded)
  /// - `uri`: The otpauth URI for QR code generation
  /// - `algorithm`: The hashing algorithm (typically SHA1)
  /// - `digits`: The number of digits in the code (typically 6)
  /// - `period`: The validity period in seconds (typically 30)
  ///
  /// ## Throws
  /// - [Exception] if registration fails (contains status code and error details)
  Future<Map<String, dynamic>> registerTOTP({
    String? label,
    bool allowOverride = false,
  }) async {
    final url = Uri.parse('$baseUrl/v1/users/me/totp');

    final payload = <String, dynamic>{
      if (label != null && label.isNotEmpty) 'label': label,
      'allow_override': allowOverride,
    };

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to register TOTP: ${response.statusCode} ${response.body}',
      );
    }
  }
}
