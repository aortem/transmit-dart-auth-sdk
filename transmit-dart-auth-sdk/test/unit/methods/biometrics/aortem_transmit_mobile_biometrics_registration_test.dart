import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/biometrics/transmit_mobile_biometrics_registration.dart';

void main() {
  group('AortemTransmitMobileBiometricsRegistration', () {
    late AortemTransmitMobileBiometricsRegistration service;

    setUp(() {
      service = AortemTransmitMobileBiometricsRegistration(
        apiKey: 'dummy-key',
        baseUrl: 'https://api.example.com',
      );
    });

    test('mockRegisterMobileBiometrics returns expected mock data', () async {
      final result = await service.mockRegisterMobileBiometrics(
        publicKey: 'test-public-key',
        publicKeyId: 'key_123',
        os: 'ios',
      );

      expect(result['status'], 'success');
      expect(result['message'], contains('mock'));
      expect(result['publicKeyId'], equals('key_123'));
      expect(result['os'], 'ios');
      expect(result['mock'], true);
      expect(result['registeredAt'], isNotNull);
    });

    test('throws ArgumentError when required params are empty', () {
      expect(
        () => service.mockRegisterMobileBiometrics(
          publicKey: '',
          publicKeyId: '',
          os: '',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
