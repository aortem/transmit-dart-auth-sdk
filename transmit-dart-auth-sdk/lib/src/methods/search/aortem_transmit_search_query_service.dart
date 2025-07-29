import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for performing search queries against Transmit Security's API.
///
/// This class provides functionality to execute complex searches across
/// various security entities while supporting both production and testing
/// environments.
///
/// ## Security Considerations
/// - Requires valid API credentials
/// - Implements proper parameter encoding
/// - Should be used with HTTPS only
/// - Search results may contain sensitive data
///
/// ## Search Capabilities
/// - Flexible query parameter support
/// - Type-safe result parsing
/// - Comprehensive error handling
/// - Mock implementation for testing
///
/// ## Example Usage
/// ```dart
/// final searchService = AortemTransmitSearchQueryService(
///   apiKey: 'your-api-key',
///   baseUrl: 'https://api.transmitsecurity.com',
/// );
///
/// try {
///   final results = await searchService.search({
///     'query': 'user@example.com',
///     'type': 'email',
///     'limit': '10',
///   });
///   print('Found ${results.length} matching records');
/// } catch (e) {
///   print('Search failed: $e');
/// }
/// ```
class AortemTransmitSearchQueryService {
  /// The API key used for authentication
  final String apiKey;

  /// The base URL for the search API endpoint
  final String baseUrl;

  /// Creates a search query service instance
  ///
  /// [apiKey]: Required API key for authentication (must not be empty)
  /// [baseUrl]: Optional base URL (defaults to production endpoint)
  ///
  /// Throws:
  /// - [ArgumentError] if apiKey is empty
  AortemTransmitSearchQueryService({
    required this.apiKey,
    this.baseUrl = 'https://api.transmitsecurity.com',
  }) {
    if (apiKey.isEmpty) {
      throw ArgumentError('API key cannot be empty.');
    }
  }

  /// Executes a search query with the provided criteria
  ///
  /// Parameters:
  /// [searchCriteria]: A map of key-value pairs representing search parameters
  ///   - Common parameters include:
  ///     - 'query': The search term
  ///     - 'type': The entity type to search (user, device, etc.)
  ///     - 'limit': Maximum number of results to return
  ///     - 'offset': Pagination offset
  ///
  /// Returns:
  /// A [Future] that resolves to a List of result Maps containing:
  /// - Entity identifiers
  /// - Relevant attributes
  /// - Match scores (when applicable)
  ///
  /// Throws:
  /// - [ArgumentError] if searchCriteria is empty
  /// - [Exception] if search fails (contains status code and error details)
  Future<List<Map<String, dynamic>>> search(
    Map<String, dynamic> searchCriteria,
  ) async {
    if (searchCriteria.isEmpty) {
      throw ArgumentError('Search criteria cannot be empty.');
    }

    try {
      final uri = Uri.parse('$baseUrl/search').replace(
        queryParameters: searchCriteria.map(
          (k, v) => MapEntry(k, v?.toString() ?? ''),
        ),
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
          'X-Request-ID': DateTime.now().millisecondsSinceEpoch.toString(),
        },
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw _createSearchException(response);
      }
    } on FormatException catch (e) {
      throw Exception('Failed to parse search results: ${e.message}');
    } on http.ClientException catch (e) {
      throw Exception('Network error during search: ${e.message}');
    }
  }

  /// Mock implementation for testing search functionality
  ///
  /// Simulates search results without making API calls.
  Future<List<Map<String, dynamic>>> mockSearch(
    Map<String, dynamic> searchCriteria,
  ) async {
    if (searchCriteria.isEmpty) {
      throw ArgumentError('Search criteria cannot be empty.');
    }

    await Future.delayed(
      const Duration(milliseconds: 100),
    ); // Simulate network delay

    return [
      {
        'id': 'mock-${DateTime.now().millisecondsSinceEpoch}',
        'name': 'Mock User ${searchCriteria['query'] ?? '1'}',
        'email': 'mock${searchCriteria['query']?.hashCode ?? '1'}@example.com',
        'criteriaUsed': searchCriteria,
        'matchScore': 0.95,
        'lastActive': DateTime.now().toIso8601String(),
      },
      {
        'id': 'mock-${DateTime.now().millisecondsSinceEpoch + 1}',
        'name': 'Mock User ${searchCriteria['query'] ?? '2'}',
        'email': 'mock${searchCriteria['query']?.hashCode ?? '2'}@example.com',
        'criteriaUsed': searchCriteria,
        'matchScore': 0.85,
        'lastActive': DateTime.now().toIso8601String(),
      },
    ];
  }

  /// Creates a detailed exception from search failures
  Exception _createSearchException(http.Response response) {
    try {
      final error = jsonDecode(response.body) as Map<String, dynamic>;
      return Exception(
        'Search failed (${response.statusCode}): '
        '${error['error'] ?? 'Unknown error'} - '
        '${error['error_description'] ?? 'No description provided'}',
      );
    } on FormatException {
      return Exception(
        'Search failed (${response.statusCode}): ${response.body}',
      );
    }
  }
}
