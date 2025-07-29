import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/sessions/aortem_transmit_revoke_user_sessions.dart';

void main() {
  group('AortemTransmitRefreshBackendAuthToken - mockRefresh', () {
    late AortemTransmitRefreshUserSession service;

    setUp(() {
      service = AortemTransmitRefreshUserSession(
        apiKey: 'test-api-key',
        baseUrl: 'https://example.com',
      );
    });

    test('mockRefresh returns valid token data', () async {
      final result = await service.mockRefresh(
        refreshToken: 'test-refresh-token',
      );

      expect(result, contains('access_token'));
      expect(result, contains('id_token'));
      expect(result, contains('refresh_token'));
      expect(result['token_type'], equals('Bearer'));
      expect(result['expires_in'], equals(3600));
      expect(result['scope'], contains('openid'));
    });

    test('mockRefresh throws ArgumentError when refreshToken is empty', () {
      expect(
        () => service.mockRefresh(refreshToken: ''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
