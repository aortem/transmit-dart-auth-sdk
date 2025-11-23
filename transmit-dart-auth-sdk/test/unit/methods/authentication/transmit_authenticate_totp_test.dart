import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/authentication/transmit_authenticate_totp.dart';

void main() {
  group('AortemTransmitAuthenticateTOTP', () {
    late AortemTransmitAuthenticateTOTP totpAuth;

    setUp(() {
      totpAuth = AortemTransmitAuthenticateTOTP(
        apiKey: 'dummy-api-key',
        baseUrl: 'https://dummy.url',
      );
    });

    test('authenticateTOTPStub returns expected mock tokens', () async {
      final result = await totpAuth.authenticateTOTPStub(
        identifier: 'user@example.com',
        totpCode: '123456',
      );

      expect(result['access_token'], equals('dummy-access-token'));
      expect(result['id_token'], equals('dummy-id-token'));
      expect(result['refresh_token'], equals('dummy-refresh-token'));
      expect(result['token_type'], equals('Bearer'));
      expect(result['expires_in'], equals(3600));
      expect(result['message'], contains('successful'));
    });

    test('authenticateTOTPStub throws error when identifier is empty', () {
      expect(
        () => totpAuth.authenticateTOTPStub(identifier: '', totpCode: '123456'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('authenticateTOTPStub throws error when totpCode is empty', () {
      expect(
        () => totpAuth.authenticateTOTPStub(
          identifier: 'user@example.com',
          totpCode: '',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
