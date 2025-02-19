import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

import '../model/aortem_transmit_token_metadata.dart';

/// A service for handling token-related operations with the Transmit Security API.
/// 
/// This service provides functionality to retrieve metadata about authentication
/// tokens, ensuring they are valid and checking their associated permissions.
class AortemTransmitTokenService {
  /// The API key used for authentication with the Transmit Security API.
  final String apiKey;

  /// The base URL of the Transmit Security API.
  ///
  /// Defaults to `'https://api.transmitsecurity.com'`.
  final String baseUrl;

  /// Creates an instance of [AortemTransmitTokenService].
  ///
  /// - Requires a non-empty [apiKey] for authentication.
  /// - Optionally accepts a custom [baseUrl] for API calls.
  ///
  /// Throws an [ArgumentError] if [apiKey] is empty.
  AortemTransmitTokenService({
    required this.apiKey,
    this.baseUrl = 'https://api.transmitsecurity.com',
  }) {
    if (apiKey.isEmpty) {
      throw ArgumentError('API key cannot be empty.');
    }
  }

  /// Retrieves token metadata from the Transmit API.
  ///
  /// This method sends a request to the Transmit API to fetch details about
  /// the given [token], including its validity, expiration, and associated scopes.
  ///
  /// Returns an [AortemTransmitTokenMetadata] object containing:
  /// - `tokenType`: The type of token (e.g., "Bearer").
  /// - `expiresAt`: The expiration time of the token.
  /// - `userId`: The associated user ID.
  /// - `active`: A boolean indicating whether the token is active.
  /// - `scopes`: A list of granted permissions.
  ///
  /// Throws:
  /// - [ArgumentError] if [token] is empty.
  /// - [Exception] if the API request fails.
  Future<AortemTransmitTokenMetadata> getTokenDetails(String token) async {
    if (token.isEmpty) {
      throw ArgumentError('Token cannot be empty.');
    }

    final url = Uri.parse('$baseUrl/token/introspect');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'token': token}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AortemTransmitTokenMetadata.fromJson(data);
    } else {
      throw Exception(
          'Failed to retrieve token details: ${response.statusCode} ${response.body}');
    }
  }

  /// Returns a stubbed token metadata response for testing purposes.
  ///
  /// This method provides a simulated response to be used in testing environments
  /// without making actual API calls.
  ///
  /// Returns a sample [AortemTransmitTokenMetadata] object with:
  /// - A token type of `"Bearer"`.
  /// - An expiration time one hour from now.
  /// - A user ID of `"test-user"`.
  /// - The token marked as active (`true`).
  /// - Example scopes `["read", "write"]`.
  ///
  /// Throws an [ArgumentError] if [token] is empty.
  Future<AortemTransmitTokenMetadata> getTokenDetailsStub(String token) async {
    if (token.isEmpty) {
      throw ArgumentError('Token cannot be empty.');
    }

    return AortemTransmitTokenMetadata(
      tokenType: "Bearer",
      expiresAt: DateTime.now().add(Duration(hours: 1)),
      userId: "test-user",
      active: true,
      scopes: ["read", "write"],
    );
  }
}
