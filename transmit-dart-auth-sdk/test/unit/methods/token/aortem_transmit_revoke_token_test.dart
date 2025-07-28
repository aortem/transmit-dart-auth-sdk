import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/token/aortem_transmit_revoke_token.dart';

void main() {
  group('AortemTransmitRevokeTOTP - revokeTOTPStub', () {
    late AortemTransmitRevokeTOTP service;

    setUp(() {
      service = AortemTransmitRevokeTOTP(
        apiKey: 'test-api-key',
        baseUrl: 'https://api.test.com',
      );
    });

    test('returns mock success response', () async {
      const userId = 'user-123';
      final result = await service.revokeTOTPStub(userId: userId);

      expect(result['status'], equals('success'));
      expect(result['message'], contains('stub'));
      expect(result['timestamp'], isA<String>());
    });

    test('throws ArgumentError when userId is empty', () async {
      expect(
        () => service.revokeTOTPStub(userId: ''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
