import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/authentication/transmit_authenticate_password.dart';

void main() {
  group('AortemTransmitAuthenticatePassword', () {
    late AortemTransmitAuthenticatePassword authService;

    setUp(() {
      authService = AortemTransmitAuthenticatePassword(
        apiKey: 'dummy-api-key',
        baseUrl: 'https://dummy.url',
      );
    });

    test('mockAuthenticatePassword returns expected mock tokens', () async {
      final result = await authService.mockAuthenticatePassword(
        username: 'user@example.com',
        password: 'password123',
      );

      expect(result['access_token'], contains('mock_access_token'));
      expect(result['id_token'], contains('mock_id_token'));
      expect(result['token_type'], equals('Bearer'));
      expect(result['expires_in'], equals(3600));
      expect(result, containsPair('scope', 'openid profile email'));
    });

    test(
      'mockAuthenticatePassword throws ArgumentError for empty username',
      () {
        expect(
          () => authService.mockAuthenticatePassword(
            username: '',
            password: 'password123',
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'mockAuthenticatePassword throws ArgumentError for empty password',
      () {
        expect(
          () => authService.mockAuthenticatePassword(
            username: 'user@example.com',
            password: '',
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });
}
