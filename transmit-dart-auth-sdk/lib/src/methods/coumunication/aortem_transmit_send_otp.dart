import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for sending One-Time Passwords (OTP) using Transmit Security.
///
/// This class handles OTP requests by making HTTP POST requests to the
/// Transmit Security backend API. It allows dependency injection of an
/// `http.Client` for testing purposes.
class AortemTransmitOTP {
  /// API key for authentication with Transmit Security.
  final String apiKey;

  /// HTTP client used for making network requests. Defaults to `http.Client`.
  final http.Client httpClient;

  /// Creates an instance of [AortemTransmitOTP].
  ///
  /// - [apiKey] is required to authenticate the requests.
  /// - [httpClient] is optional and can be injected for testing purposes.
  AortemTransmitOTP({required this.apiKey, http.Client? httpClient})
    : httpClient = httpClient ?? http.Client();

  /// Sends an OTP to the specified [identifier] (e.g., email or phone number).
  ///
  /// - Throws an [ArgumentError] if the [identifier] is empty.
  /// - Returns a [Map<String, dynamic>] containing the OTP response data.
  /// - Throws an [Exception] if the API request fails.
  ///
  /// Example usage:
  /// ```dart
  /// final otpService = AortemTransmitOTP(apiKey: 'your-api-key');
  /// final response = await otpService.sendOTP('user@example.com');
  /// print(response);
  /// ```
  Future<Map<String, dynamic>> sendOTP(String identifier) async {
    if (identifier.isEmpty) {
      throw ArgumentError('Identifier cannot be empty');
    }

    final response = await httpClient.post(
      Uri.parse(
        'https://api.transmitsecurity.com/backend-one-time-login/sendOTP',
      ),
      headers: {'Authorization': 'Bearer $apiKey'},
      body: {'identifier': identifier},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to send OTP');
    }
  }
}
