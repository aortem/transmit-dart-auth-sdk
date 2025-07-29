import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/search/aortem_transmit_search_query_service.dart';

void main() {
  group('AortemTransmitSearchQueryService', () {
    late AortemTransmitSearchQueryService service;

    setUp(() {
      service = AortemTransmitSearchQueryService(apiKey: 'dummy-key');
    });

    test('mockSearch returns a list of results', () async {
      final criteria = {'query': 'test@example.com', 'type': 'email'};
      final results = await service.mockSearch(criteria);

      expect(results, isA<List<Map<String, dynamic>>>());
      expect(results.length, greaterThan(0));
      expect(results.first['email'], contains('@example.com'));
    });

    test('mockSearch throws error if criteria is empty', () {
      expect(() => service.mockSearch({}), throwsA(isA<ArgumentError>()));
    });
  });
}
