import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for registering mobile biometric authenticators with Transmit Security's API.
///
/// This class handles the secure registration of biometric authenticators by:
/// - Storing public keys for cryptographic verification
/// - Validating device attestation (when available)
/// - Establishing trusted communication channels
///
/// ## Security Considerations
/// - Requires valid API credentials
/// - Verifies cryptographic attestation when available
/// - Implements secure key storage
/// - Should be used with HTTPS only
/// - Biometric data never leaves the device
///
/// ## Registration Flow
/// 1. Device generates cryptographic key pair
/// 2. Client collects attestation data (platform-dependent)
/// 3. Service registers public key and verifies attestation
/// 4. System enables biometric authentication for user
///
/// ## Example Usage
/// ```dart
/// final biometricReg = AortemTransmitMobileBiometricsRegistration(
///   apiKey: 'your-api-key',
///   baseUrl: 'https://api.transmitsecurity.com',
/// );
///
/// try {
///   final result = await biometricReg.registerMobileBiometrics(
///     publicKey: 'generated_public_key',
///     publicKeyId: 'key_123',
///     os: 'ios',
///     attestationEncodedResult: 'attestation_data',
///   );
///   print('Biometric registration successful: ${result['publicKeyId']}');
/// } catch (e) {
///   print('Registration failed: $e');
/// }
/// ```
class AortemTransmitMobileBiometricsRegistration {
  /// The API key used for service authentication
  final String apiKey;

  /// The base URL for the biometric registration API endpoint
  final String baseUrl;

  /// Creates a biometric registration service instance
  ///
  /// [apiKey]: Required API key for service authentication
  /// [baseUrl]: Required base URL for the API endpoint
  AortemTransmitMobileBiometricsRegistration({
    required this.apiKey,
    required this.baseUrl,
  });

  /// Registers a mobile biometric authenticator for secure authentication
  ///
  /// Parameters:
  /// [publicKey]: Base64-encoded public key (required)
  /// [publicKeyId]: Unique identifier for the key (required)
  /// [os]: Operating system type ('android' or 'ios') (required)
  /// [encryptionType]: Cryptographic algorithm ('rsa' or 'ec') (default: 'rsa')
  /// [challenge]: Server-generated challenge for attestation
  /// [attestationEncodedResult]: Platform-specific attestation data
  ///
  /// Returns:
  /// A [Future] that resolves to a Map containing:
  /// - `status`: Registration status
  /// - `publicKeyId`: Registered key identifier
  /// - `registeredAt`: ISO-8601 timestamp of registration
  /// - Additional verification metadata
  ///
  /// Throws:
  /// - [ArgumentError] if required parameters are empty
  /// - [Exception] if registration fails (contains status code and error details)
  Future<Map<String, dynamic>> registerMobileBiometrics({
    required String publicKey,
    required String publicKeyId,
    required String os,
    String encryptionType = "rsa",
    String? challenge,
    String? attestationEncodedResult,
  }) async {
    if (publicKey.isEmpty || publicKeyId.isEmpty || os.isEmpty) {
      throw ArgumentError('publicKey, publicKeyId, and os must not be empty');
    }

    try {
      final url = Uri.parse('$baseUrl/v1/auth/biometrics/native/register');

      final headers = {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'X-Request-ID': DateTime.now().millisecondsSinceEpoch.toString(),
      };

      final body = <String, dynamic>{
        'publicKey': publicKey,
        'publicKeyId': publicKeyId,
        'os': os.toLowerCase(),
        'encryptionType': encryptionType.toLowerCase(),
        if (challenge != null) 'challenge': challenge,
        if (attestationEncodedResult != null)
          'attestation_encoded_result': attestationEncodedResult,
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw _createRegistrationException(response);
      }
    } on FormatException catch (e) {
      throw Exception('Failed to parse registration response: ${e.message}');
    } on http.ClientException catch (e) {
      throw Exception(
        'Network error during biometric registration: ${e.message}',
      );
    }
  }

  /// Mock implementation for testing biometric registration
  ///
  /// Simulates successful registration without API calls.
  Future<Map<String, dynamic>> mockRegisterMobileBiometrics({
    required String publicKey,
    required String publicKeyId,
    required String os,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: 150),
    ); // Simulate network delay

    return {
      'status': 'success',
      'message': 'Biometrics registered successfully (mock)',
      'publicKeyId': publicKeyId,
      'registeredAt': DateTime.now().toIso8601String(),
      'os': os,
      'encryptionType': 'rsa',
      'mock': true,
    };
  }

  /// Creates a detailed exception from registration failures
  Exception _createRegistrationException(http.Response response) {
    try {
      final error = jsonDecode(response.body) as Map<String, dynamic>;
      final statusCode = response.statusCode;
      final errorCode = error['error'] ?? 'registration_failed';
      final description =
          error['error_description'] ?? 'No description provided';

      switch (statusCode) {
        case 400:
          return Exception(
            'Invalid registration: $description (code: $errorCode)',
          );
        case 401:
          return Exception(
            'Unauthorized registration attempt (code: $errorCode)',
          );
        case 403:
          return Exception('Registration not permitted (code: $errorCode)');
        case 404:
          return Exception(
            'User not found for registration (code: $errorCode)',
          );
        case 409:
          return Exception('Key already registered (code: $errorCode)');
        default:
          return Exception(
            'Registration error ($statusCode): $description (code: $errorCode)',
          );
      }
    } on FormatException {
      return Exception(
        'Registration failed (${response.statusCode}): ${response.body}',
      );
    }
  }
}
