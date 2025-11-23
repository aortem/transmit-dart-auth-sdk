import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/authentication/transmit_authenticate_transaction_totp.dart';

void main() {
  group('AortemTransmitAuthenticateTransactionTOTP', () {
    late AortemTransmitAuthenticateTransactionTOTP totpAuth;

    setUp(() {
      totpAuth = AortemTransmitAuthenticateTransactionTOTP(
        apiKey: 'dummy-api-key',
        baseUrl: 'https://dummy.url',
      );
    });

    test('throws ArgumentError when token is empty', () async {
      expect(
        () => totpAuth(token: '', identifier: 'user@example.com'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws ArgumentError when identifier is empty', () async {
      expect(
        () => totpAuth(token: '123456', identifier: ''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
