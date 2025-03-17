import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for performing search queries using Transmit Security’s backend API.
///
/// This class allows searching for data based on specified criteria and
/// returns the search results in a structured format.
class AortemTransmitSearchQueryService {
  /// The API key used for authenticating requests.
  final String apiKey;

  /// The base URL of the Transmit Security API.
  ///
  /// Defaults to `'https://api.transmitsecurity.com'`.
  final String baseUrl;

  /// Creates an instance of [AortemTransmitSearchQueryService].
  ///
  /// - Requires a non-empty [apiKey] for authentication.
  /// - Optionally accepts a custom [baseUrl] for API calls.
  ///
  /// Throws an [ArgumentError] if [apiKey] is empty.
  AortemTransmitSearchQueryService(
      {required this.apiKey,
      this.baseUrl = 'https://api.transmitsecurity.com'}) {
    if (apiKey.isEmpty) {
      throw ArgumentError('API key cannot be empty.');
    }
  }

  /// Performs a search query on the Transmit Security API.
  ///
  /// - [searchCriteria] is a `Map<String, dynamic>` containing the search parameters.
  /// - Returns a `Future<List<Map<String, dynamic>>>`, which represents the search results.
  ///
  /// Throws:
  /// - [ArgumentError] if [searchCriteria] is empty.
  /// - [Exception] if the API request fails.
  Future<List<Map<String, dynamic>>> search(
      Map<String, dynamic> searchCriteria) async {
    if (searchCriteria.isEmpty) {
      throw ArgumentError('Search criteria cannot be empty.');
    }

    final uri = Uri.parse('$baseUrl/search');
    final queryParams = Uri(queryParameters: searchCriteria.map((key, value) {
      return MapEntry(key, value.toString());
    }));

    final url = uri.replace(queryParameters: queryParams.queryParameters);

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception(
          'Search query failed: ${response.statusCode} ${response.body}');
    }
  }
}
