import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A class responsible for sending magic link authentication emails
/// through Transmit Security.
///
/// This class allows users to authenticate using a magic link sent to their email.
/// It provides both a real API request and a stub implementation for testing.
class AortemTransmitMagicLink {
  /// The API key required for authentication with Transmit Security.
  final String apiKey;

  /// The base URL of the Transmit Security API.
  /// Defaults to `'https://api.transmitsecurity.com'`.
  final String baseUrl;

  /// Creates an instance of [AortemTransmitMagicLink].
  ///
  /// Throws an [ArgumentError] if the provided [apiKey] is empty.
  AortemTransmitMagicLink({
    required this.apiKey,
    this.baseUrl = 'https://api.transmitsecurity.com',
  }) {
    if (apiKey.isEmpty) {
      throw ArgumentError('API key cannot be empty.');
    }
  }

  /// Sends a magic link email to the user.
  ///
  /// The [email] parameter represents the recipient's email address.
  /// Returns a [Future] containing a `Map<String, dynamic>` with
  /// confirmation details, such as a temporary token and message.
  ///
  /// Throws an [ArgumentError] if the email is empty.
  /// Throws an [Exception] if the API request fails.
  Future<Map<String, dynamic>> sendMagicLinkEmail(String email) async {
    if (email.isEmpty) {
      throw ArgumentError('Email cannot be empty.');
    }

    // API endpoint for sending the magic link email.
    final url = Uri.parse('$baseUrl/backend-one-time-login/sendMagicLinkEmail');

    final body = json.encode({'email': email});

    // Make the HTTP POST request.
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    // Process the response.
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
        'Send Magic Link Email failed: ${response.statusCode} ${response.body}',
      );
    }
  }

  /// Simulated version of [sendMagicLinkEmail] for testing and debugging.
  ///
  /// This method does not make a real API call. Instead, it returns a
  /// mock response after a small delay.
  ///
  /// The [email] parameter represents the recipient's email address.
  /// Returns a `Map<String, dynamic>` containing a mock temporary token and message.
  ///
  /// Throws an [ArgumentError] if the email is empty.
  Future<Map<String, dynamic>> sendMagicLinkEmailStub(String email) async {
    if (email.isEmpty) {
      throw ArgumentError('Email cannot be empty.');
    }

    // Simulate network latency.
    await Future.delayed(const Duration(milliseconds: 100));

    // Return a stubbed response.
    return {
      'email': email,
      'tempToken': 'dummy-temp-token',
      'message': 'Magic link email sent successfully (stub).',
    };
  }
}
