import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/token/transmit_journey_token.dart';

void main() {
  group('AortemTransmitJourneyToken - processJourneyTokenStub', () {
    late AortemTransmitJourneyToken service;

    setUp(() {
      service = AortemTransmitJourneyToken(apiKey: 'test-api-key');
    });

    test('returns valid mock journey token data', () async {
      const token = 'test-token';
      final result = await service.processJourneyTokenStub(token);

      expect(result['journeyToken'], equals(token));
      expect(result['status'], equals('valid'));
      expect(result['progress'], equals('completed'));
      expect(result['sessionData'], isA<Map<String, dynamic>>());
      expect(result['expiresIn'], equals(3600));
    });

    test('throws ArgumentError if journeyToken is empty', () {
      expect(
        () => service.processJourneyTokenStub(''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
