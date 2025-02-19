/// Stub implementation for search queries.
class AortemTransmitSearchQueryServiceStub {
  final String apiKey;

  /// Initializes the SearchQueryServiceStub instance.
  /// [apiKey] is required for authenticating the requests.
  AortemTransmitSearchQueryServiceStub({required this.apiKey}) {
    if (apiKey.isEmpty) {
      throw ArgumentError('API key cannot be empty.');
    }
  }

  /// Simulates a search by returning dummy search results.
  Future<List<Map<String, dynamic>>> search(
      Map<String, dynamic> searchCriteria) async {
    if (searchCriteria.isEmpty) {
      throw ArgumentError('Search criteria cannot be empty.');
    }

    // Simulate a delay (as if performing a network request)
    await Future.delayed(Duration(milliseconds: 100));

    // Return dummy search results
    return [
      {
        'id': 1,
        'name': 'Dummy User 1',
        'role': 'admin',
      },
      {
        'id': 2,
        'name': 'Dummy User 2',
        'role': 'user',
      },
    ];
  }
}
