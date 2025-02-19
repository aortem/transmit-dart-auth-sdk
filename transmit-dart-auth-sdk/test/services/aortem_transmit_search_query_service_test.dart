import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/services/aortem_transmit_search_query_service.dart';
import 'package:transmit_dart_auth_sdk/services/aortem_transmit_search_query_service_stub.dart';

void main() {
  group('SearchQueryService', () {
    late AortemTransmitSearchQueryService searchQueryService;
    late AortemTransmitSearchQueryServiceStub searchQueryServiceStub;

    const String apiKey = 'validApiKey123';
    const String validSearchCriteriaKey = 'role';
    const String validSearchCriteriaValue = 'admin';

    setUp(() {
      searchQueryService = AortemTransmitSearchQueryService(apiKey: apiKey);
      searchQueryServiceStub =
          AortemTransmitSearchQueryServiceStub(apiKey: apiKey);
    });

    

    test('search query stub returns dummy results', () async {
      final searchCriteria = {
        validSearchCriteriaKey: validSearchCriteriaValue,
      };

      // Simulate a search stub
      final searchResults = await searchQueryServiceStub.search(searchCriteria);

      expect(searchResults.isNotEmpty, true);
      expect(searchResults.first['name'], 'Dummy User 1');
    });

    test('throws error for empty search criteria in search query', () async {
      try {
        await searchQueryService.search({});
        fail('ArgumentError should have been thrown');
      } catch (e) {
        expect(e, isA<ArgumentError>());
        expect(e.toString(), contains('Search criteria cannot be empty.'));
      }
    });
  });
}
