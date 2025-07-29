import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/sessions/aortem_transmit_refresh_backend_auth.dart';

void main() {
  group('AortemTransmitRefreshBackendAuthToken (Mock)', () {
    late AortemTransmitRefreshBackendAuthToken tokenService;

    setUp(() {
      tokenService = AortemTransmitRefreshBackendAuthToken(
        apiKey: 'dummy-api-key',
        baseUrl: 'https://api.example.com',
      );
    });

    test('mockRefresh returns valid token structure', () async {
      final result = await tokenService.mockRefresh(
        refreshToken: 'refresh_123',
      );

      expect(result['access_token'], isA<String>());
      expect(result['id_token'], isA<String>());
      expect(result['refresh_token'], isA<String>());
      expect(result['token_type'], equals('Bearer'));
      expect(result['expires_in'], equals(3600));
      expect(result['scope'], contains('openid'));
    });

    test('mockRefresh throws ArgumentError for empty refresh token', () {
      expect(
        () => tokenService.mockRefresh(refreshToken: ''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
