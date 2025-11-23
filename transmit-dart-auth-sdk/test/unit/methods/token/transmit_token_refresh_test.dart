import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/token/transmit_token_refresh.dart';

void main() {
  group('AortemTransmitTokenRefresh', () {
    test('refreshTokenStub returns dummy token data', () async {
      final service = AortemTransmitTokenRefresh(
        apiKey: 'dummy-key',
        baseUrl: 'https://api.transmitsecurity.com',
      );

      final result = await service.refreshTokenStub('dummy-refresh-token');

      expect(result['accessToken'], isNotEmpty);
      expect(result['refreshToken'], isNotEmpty);
      expect(result['expiresIn'], equals(3600));
      expect(result.containsKey('issuedAt'), isTrue);
    });

    test('refreshTokenStub throws ArgumentError for empty token', () async {
      final service = AortemTransmitTokenRefresh(
        apiKey: 'dummy-key',
        baseUrl: 'https://api.transmitsecurity.com',
      );

      expect(() => service.refreshTokenStub(''), throwsA(isA<ArgumentError>()));
    });
  });
}
