import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmit_webauthn_cross_device_status.dart';

void main() {
  group('AortemTransmitWebAuthnCrossDeviceStatus', () {
    late AortemTransmitWebAuthnCrossDeviceStatus service;

    setUp(() {
      service = AortemTransmitWebAuthnCrossDeviceStatus(
        apiKey: 'dummy-api-key',
        baseUrl: 'https://dummy-url.com',
      );
    });

    test('mockGetStatus returns correct mock data', () async {
      final result = await service.mockGetStatus(
        crossDeviceTicketId: 'ticket123',
      );

      expect(result['status'], 'pending');
      expect(result['cross_device_ticket_id'], 'ticket123');
      expect(result['expires_in'], 30000);
      expect(result.containsKey('last_updated'), true);
      expect(result['mock_data'], true);
    });

    test('mockGetStatus throws ArgumentError when ticket ID is empty', () {
      expect(
        () => service.mockGetStatus(crossDeviceTicketId: ''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
