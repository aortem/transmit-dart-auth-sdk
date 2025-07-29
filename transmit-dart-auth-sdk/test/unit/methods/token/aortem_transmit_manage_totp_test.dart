import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/token/aortem_transmit_manage_totp.dart';

void main() {
  group('AortemTransmitRevokeTOTPManagement - mockRevoke', () {
    late AortemTransmitRevokeTOTPManagement service;

    setUp(() {
      service = AortemTransmitRevokeTOTPManagement(
        apiKey: 'test-api-key',
        baseUrl: 'https://api.test.com',
      );
    });

    test('returns mock success response', () async {
      const userId = 'user-123';
      final result = await service.mockRevoke(userId: userId);

      expect(result['status'], equals('success'));
      expect(result['message'], contains('mock'));
      expect(result['userId'], equals(userId));
      expect(result['timestamp'], isA<String>());
    });

    test('throws ArgumentError if userId is empty', () async {
      expect(
        () => service.mockRevoke(userId: ''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
