import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for sending magic link authentication emails via Transmit Security's API.
///
/// This class handles the communication with Transmit Security's backend to send
/// one-time login magic links to users' email addresses. It includes both the
/// production implementation and a stub version for testing purposes.
///
/// Example usage:
/// ```dart
/// final magicLinkService = AortemTransmitSendMagicLink(
///   apiKey: 'your-secure-api-key',
/// );
///
/// try {
///   final result = await magicLinkService.sendMagicLinkEmail('user@example.com');
///   print('Magic link sent: ${result['message']}');
/// } catch (e) {
///   print('Error sending magic link: $e');
/// }
/// ```
class AortemTransmitSendMagicLink {
  /// The API key used for authenticating with Transmit Security's services.
  ///
  /// Must be a non-empty string. The constructor will throw an [ArgumentError]
  /// if this is empty.
  final String apiKey;

  /// The base URL for the Transmit Security API endpoints.
  ///
  /// Defaults to the production endpoint 'https://api.transmitsecurity.com'
  /// if not specified. Can be overridden for testing or different environments.
  final String baseUrl;

  /// Creates a new [AortemTransmitSendMagicLink] instance.
  ///
  /// Parameters:
  /// [apiKey] - Required API key for authentication (must not be empty)
  /// [baseUrl] - Optional base URL for the API (defaults to production endpoint)
  ///
  /// Throws:
  /// [ArgumentError] if the apiKey is empty
  AortemTransmitSendMagicLink({
    required this.apiKey,
    this.baseUrl = 'https://api.transmitsecurity.com',
  }) {
    if (apiKey.isEmpty) {
      throw ArgumentError('API key cannot be empty.');
    }
  }

  /// Sends a magic link authentication email to the specified email address.
  ///
  /// This method makes an authenticated POST request to Transmit Security's
  /// magic link endpoint with the provided email address.
  ///
  /// Parameters:
  /// [email] - The recipient's email address (must not be empty)
  ///
  /// Returns:
  /// A [Future] that completes with a [Map] containing the API response data
  ///
  /// Throws:
  /// [ArgumentError] if the email is empty
  /// [Exception] if the API request fails (includes status code and response body)
  Future<Map<String, dynamic>> sendMagicLinkEmail(String email) async {
    if (email.isEmpty) {
      throw ArgumentError('Email cannot be empty.');
    }

    final url = Uri.parse('$baseUrl/backend-one-time-login/sendMagicLinkEmail');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode({'email': email}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
        'Send Magic Link Email failed: ${response.statusCode} ${response.body}',
      );
    }
  }

  /// Testing stub that simulates sending a magic link email.
  ///
  /// This method mimics the behavior of [sendMagicLinkEmail] without making
  /// actual API calls. It introduces a small delay to simulate network latency
  /// and returns consistent mock data.
  ///
  /// Parameters:
  /// [email] - The recipient's email address (must not be empty)
  ///
  /// Returns:
  /// A [Future] that completes after a short delay with mock response data
  ///
  /// Throws:
  /// [ArgumentError] if the email is empty
  Future<Map<String, dynamic>> sendMagicLinkEmailStub(String email) async {
    if (email.isEmpty) {
      throw ArgumentError('Email cannot be empty.');
    }

    await Future.delayed(const Duration(milliseconds: 100));

    return {
      'email': email,
      'tempToken': 'dummy-temp-token',
      'message': 'Magic link email sent successfully (stub).',
    };
  }
}
