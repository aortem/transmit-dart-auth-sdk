import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service class for handling journey token validation and processing
/// in the Transmit Security authentication flow.
class AortemTransmitJourneyToken {
  /// The API key required for authentication with Transmit Security.
  final String apiKey;

  /// The base URL of the Transmit Security API.
  ///
  /// Defaults to `'https://api.transmitsecurity.com'`.
  final String baseUrl;

  /// Creates an instance of [AortemTransmitJourneyToken].
  ///
  /// - Requires a non-empty [apiKey].
  /// - Optionally accepts a custom [baseUrl] for API calls.
  ///
  /// Throws an [ArgumentError] if [apiKey] is empty.
  AortemTransmitJourneyToken({
    required this.apiKey,
    this.baseUrl = 'https://api.transmitsecurity.com',
  }) {
    if (apiKey.isEmpty) {
      throw ArgumentError('API key cannot be empty.');
    }
  }

  /// Processes the given [journeyToken] by making an HTTP request to the
  /// Transmit Security API.
  ///
  /// This method retrieves details related to the token, such as its validity,
  /// progress, and session metadata.
  ///
  /// Returns a `Map<String, dynamic>` containing journey token details.
  ///
  /// Throws:
  /// - [ArgumentError] if the [journeyToken] is empty.
  /// - [Exception] if the API request fails with a non-200 status code.
  Future<Map<String, dynamic>> processJourneyToken(String journeyToken) async {
    if (journeyToken.isEmpty) {
      throw ArgumentError('Journey token must not be empty.');
    }

    // Construct the API endpoint for processing the journey token.
    final url = Uri.parse('$baseUrl/token/journey/$journeyToken');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
        'Journey token processing failed: ${response.statusCode} ${response.body}',
      );
    }
  }

  /// A stub implementation that simulates processing of a journey token.
  ///
  /// This method does not make an actual API request. Instead, it returns
  /// pre-defined mock data to mimic a valid response.
  ///
  /// Returns a `Map<String, dynamic>` containing:
  /// - `journeyToken`: The provided journey token.
  /// - `status`: A status indicator (`valid`, `invalid`, etc.).
  /// - `progress`: The completion state of the journey (`completed`, `in_progress`).
  /// - `sessionData`: Dummy session-related metadata.
  /// - `expiresIn`: The expiration time in seconds.
  ///
  /// Throws:
  /// - [ArgumentError] if the [journeyToken] is empty.
  Future<Map<String, dynamic>> processJourneyTokenStub(
    String journeyToken,
  ) async {
    if (journeyToken.isEmpty) {
      throw ArgumentError('Journey token must not be empty.');
    }

    // Simulate network latency.
    await Future.delayed(Duration(milliseconds: 100));

    // Return mock journey token details.
    return {
      'journeyToken': journeyToken,
      'status': 'valid',
      'progress': 'completed', // Example progress state.
      'sessionData': {
        'userId': 'dummy-user-id',
        'sessionStart': DateTime.now().toIso8601String(),
      },
      'expiresIn': 3600, // 1 hour in seconds.
    };
  }
}
