import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmit_webauthn_cross_device_authentication_init.dart';

void main() {
  group('AortemTransmitWebAuthnCrossDeviceAuthenticationInit', () {
    test('mockInitAuthentication returns correct mock data', () async {
      final service = AortemTransmitWebAuthnCrossDeviceAuthenticationInit(
        apiKey: 'dummy-key',
        baseUrl: 'https://api.example.com',
      );

      final result = await service.mockInitAuthentication(
        clientId: 'client_123',
        username: 'test@example.com',
      );

      expect(result.containsKey('cross_device_ticket_id'), true);
      expect(result.containsKey('challenge'), true);
      expect(result['timeout'], 60000);
      expect(result['mock'], true);
    });

    test(
      'mockInitAuthentication throws ArgumentError when clientId is empty',
      () async {
        final service = AortemTransmitWebAuthnCrossDeviceAuthenticationInit(
          apiKey: 'dummy-key',
          baseUrl: 'https://api.example.com',
        );

        expect(
          () => service.mockInitAuthentication(clientId: ''),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });
}
