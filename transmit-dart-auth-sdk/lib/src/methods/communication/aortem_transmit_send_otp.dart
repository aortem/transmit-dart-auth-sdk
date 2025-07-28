import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for sending One-Time Passwords (OTP) using Transmit Security.
///
/// This class handles OTP requests by making HTTP POST requests to the
/// Transmit Security backend API. It allows dependency injection of an
/// `http.Client` for testing purposes.
class AortemTransmitSendOTP {
  /// API key for authentication with Transmit Security.
  final String apiKey;

  /// Base URL of the Transmit Security API.
  final String baseUrl;

  /// HTTP client used for making network requests. Defaults to `http.Client`.
  final http.Client httpClient;

  /// Creates an instance of [AortemTransmitSendOTP].
  AortemTransmitSendOTP({
    required this.apiKey,
    this.baseUrl = 'https://api.transmitsecurity.io/cis/v1/auth/otp/send',
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  /// Sends an OTP to the specified [identifier] (e.g., email or phone number).
  ///
  /// [channel] must be `"sms"` or `"email"`.
  /// [identifierType] must be `"email"` or `"phone_number"`.
  ///
  /// Throws [ArgumentError] if identifier is empty.
  /// Returns [Map<String, dynamic>] with OTP response data.
  Future<Map<String, dynamic>> sendOTP({
    required String channel,
    required String identifierType,
    required String identifier,
  }) async {
    if (identifier.isEmpty) {
      throw ArgumentError('Identifier cannot be empty');
    }

    final url = Uri.parse(baseUrl);

    final payload = json.encode({
      "channel": channel,
      "identifier_type": identifierType,
      "identifier": identifier,
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
        'Send OTP failed: ${response.statusCode} ${response.body}',
      );
    }
  }

  /// Stub implementation for testing (does not call the API).
  Future<Map<String, dynamic>> sendOTPStub({
    required String channel,
    required String identifierType,
    required String identifier,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return {
      "message": "OTP sent (stub)",
      "code": "123456",
      "identifier": identifier,
    };
  }
}
