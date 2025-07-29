import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmit_webauthn_cross_device_registration.dart';

void main() {
  group('AortemTransmitWebAuthnCrossDeviceRegistration', () {
    late AortemTransmitWebAuthnCrossDeviceRegistration service;

    setUp(() {
      service = AortemTransmitWebAuthnCrossDeviceRegistration(
        apiKey: 'dummy-api-key',
        baseUrl: 'https://dummy-url.com',
      );
    });

    test('mockCompleteRegistration returns correct mock data', () async {
      final result = await service.mockCompleteRegistration(
        webauthnEncodedResult: 'encoded-data-123',
      );

      expect(result['success'], true);
      expect(result['credential_id'], 'mock_credential_cross_device_123');
      expect(result['access_token'], 'mock_access_token_456');
      expect(result['id_token'], 'mock_id_token_789');
      expect(result['expires_in'], 3600);
    });

    test(
      'mockCompleteRegistration throws ArgumentError if input is empty',
      () async {
        expect(
          () => service.mockCompleteRegistration(webauthnEncodedResult: ''),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });
}
