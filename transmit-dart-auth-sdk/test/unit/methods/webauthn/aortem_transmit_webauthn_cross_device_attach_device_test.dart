import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmit_webauthn_cross_device_attach_device.dart';

void main() {
  group('AortemTransmitWebAuthnCrossDeviceAttachDevice', () {
    test('mockAttachDevice returns correct mock data', () async {
      final attachDevice = AortemTransmitWebAuthnCrossDeviceAttachDevice(
        apiKey: 'dummy-key',
        baseUrl: 'https://api.example.com',
      );

      final result = await attachDevice.mockAttachDevice(
        crossDeviceTicketId: 'ticket_123',
      );

      expect(result['session_status'], equals('device_attached'));
      expect(result['attached_devices'], isA<List>());
      expect(
        result['attached_devices'][0]['device_id'],
        equals('mock_device_123'),
      );
    });

    test('mockAttachDevice throws ArgumentError for empty id', () async {
      final attachDevice = AortemTransmitWebAuthnCrossDeviceAttachDevice(
        apiKey: 'dummy-key',
        baseUrl: 'https://api.example.com',
      );

      expect(
        () => attachDevice.mockAttachDevice(crossDeviceTicketId: ''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
