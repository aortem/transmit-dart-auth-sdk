import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/authentication/aortem_transmit_authenticate_otp.dart';

void main() {
  group('AortemTransmitAuthenticateOTP', () {
    late AortemTransmitAuthenticateOTP otpService;

    setUp(() {
      otpService = AortemTransmitAuthenticateOTP(apiKey: 'test-api-key');
    });

    test('authenticateOTPStub returns dummy token data', () async {
      final result = await otpService.authenticateOTPStub(
        passcode: '123456',
        identifierType: 'phone',
        identifier: '+123456789',
      );

      expect(result['access_token'], equals('dummy-access-token'));
      expect(result['token_type'], equals('Bearer'));
      expect(result['expires_in'], equals(3600));
      expect(result, containsPair('session_id', 'dummy-session-id'));
    });

    test('authenticateOTPStub throws ArgumentError for empty passcode', () {
      expect(
        () => otpService.authenticateOTPStub(
          passcode: '',
          identifierType: 'phone',
          identifier: '+123456789',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('authenticateOTPStub throws ArgumentError for empty identifier', () {
      expect(
        () => otpService.authenticateOTPStub(
          passcode: '123456',
          identifierType: 'phone',
          identifier: '',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
