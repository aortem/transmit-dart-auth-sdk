import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/authentication/transmit_authenticate_session.dart';

void main() {
  group('AortemTransmitAuthenticateSession', () {
    late AortemTransmitAuthenticateSession sessionAuth;

    setUp(() {
      sessionAuth = AortemTransmitAuthenticateSession(
        apiKey: 'dummy-api-key',
        baseUrl: 'https://dummy.url',
      );
    });

    test('mockAuthenticateSession returns expected mock tokens', () async {
      final sessionId = 'user-session-12345';

      final result = await sessionAuth.mockAuthenticateSession(
        sessionId: sessionId,
      );

      expect(result['access_token'], contains('mock_access_token'));
      expect(result['id_token'], contains('mock_id_token'));
      expect(result['token_type'], equals('Bearer'));
      expect(result['expires_in'], equals(3600));
      expect(result['session_id'], equals(sessionId));
    });

    test(
      'mockAuthenticateSession throws ArgumentError for empty sessionId',
      () {
        expect(
          () => sessionAuth.mockAuthenticateSession(sessionId: ''),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });
}
