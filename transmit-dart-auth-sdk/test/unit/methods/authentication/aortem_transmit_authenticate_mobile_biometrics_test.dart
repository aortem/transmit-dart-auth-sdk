import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/authentication/aortem_transmit_authenticate_mobile_biometrics.dart';

void main() {
  group('AortemTransmitAuthenticateNativeMobileBiometrics', () {
    late AortemTransmitAuthenticateNativeMobileBiometrics biometricsAuth;

    setUp(() {
      biometricsAuth = AortemTransmitAuthenticateNativeMobileBiometrics(
        apiKey: 'test-api-key',
        baseUrl: 'https://api.example.com',
      );
    });

    test('mockAuthenticateNativeMobileBiometrics returns mock data', () async {
      final result = await biometricsAuth
          .mockAuthenticateNativeMobileBiometrics(
            userId: 'user123',
            signature: 'sig',
            challenge: 'challenge',
            keyId: 'key123',
          );

      expect(result, containsPair('access_token', isA<String>()));
      expect(result['token_type'], equals('Bearer'));
      expect(result['biometric_verified'], isTrue);
    });

    test('throws ArgumentError when required fields are empty', () {
      expect(
        () => biometricsAuth.authenticateNativeMobileBiometrics(
          userId: '',
          signature: '',
          challenge: '',
          keyId: '',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
