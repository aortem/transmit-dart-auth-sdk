import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/biometrics/aortem_transmit_delete_mobile_biometrics.dart';

void main() {
  group('AortemTransmitMobileBiometricsDeletion', () {
    late AortemTransmitMobileBiometricsDeletion service;

    setUp(() {
      service = AortemTransmitMobileBiometricsDeletion(
        apiKey: 'dummy-key',
        baseUrl: 'https://api.example.com',
      );
    });

    test('mockDeleteMobileBiometrics returns expected mock data', () async {
      final result = await service.mockDeleteMobileBiometrics(
        publicKeyId: 'key_123',
      );

      expect(result['success'], true);
      expect(result['message'], contains('Mock'));
      expect(result['publicKeyId'], equals('key_123'));
      expect(result['deletedAt'], isNotNull);
      expect(result['mock'], true);
    });

    test('throws error when publicKeyId is empty', () {
      expect(
        () => service.mockDeleteMobileBiometrics(publicKeyId: ''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
