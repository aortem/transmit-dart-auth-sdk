

import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/services/aortem_transmit_token_refresh.dart';

void main() {
  group('refreshToken (HTTP Request Approach) Tests', () {
    final transmitTokenRefresh = AortemTransmitTokenRefresh(apiKey: 'valid-api-key');



    test('throws error for empty refresh token', () {
      expect(() => transmitTokenRefresh.refreshToken(''), throwsA(isA<ArgumentError>()));
    });
  });

  group('refreshTokenStub (Stub/Mock Implementation) Tests', () {
    final transmitTokenRefresh = AortemTransmitTokenRefresh(apiKey: 'valid-api-key');
    final refreshToken = 'valid-refresh-token';

    test('returns dummy token for valid refresh token', () async {
      final tokenData = await transmitTokenRefresh.refreshTokenStub(refreshToken);
      expect(tokenData['accessToken'], isNotEmpty);
      expect(tokenData['refreshToken'], isNotEmpty);
    });

    test('throws error for empty refresh token (stub)', () {
      expect(() => transmitTokenRefresh.refreshTokenStub(''), throwsA(isA<ArgumentError>()));
    });
  });
}
