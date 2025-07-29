import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_token_manager.dart';

void main() {
  group('AortemTransmitTokenManager', () {
    late AortemTransmitTokenManager tokenManager;

    setUp(() {
      tokenManager = AortemTransmitTokenManager(
        apiKey: 'test-api-key',
        baseUrl: 'https://api.transmitsecurity.com',
      );
    });

    test('mockTokenDetails returns expected mock data', () async {
      final token = 'test-token';
      final result = await tokenManager.mockTokenDetails(token);

      expect(result['token'], equals(token));
      expect(result['active'], isTrue);
      expect(result['type'], equals('user_access_token'));
      expect(result['userId'], isNotEmpty);
      expect(result['scopes'], contains('read:users'));
    });

    test('mockTokenDetails throws error for empty token', () async {
      expect(
        () => tokenManager.mockTokenDetails(''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
