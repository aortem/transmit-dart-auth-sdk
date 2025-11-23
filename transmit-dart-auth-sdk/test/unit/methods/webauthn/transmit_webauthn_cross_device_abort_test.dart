import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/transmit_webauthn_cross_device_abort.dart';

void main() {
  group('AortemTransmitWebAuthnCrossDeviceAbort', () {
    test('mockAbortCrossDeviceSession completes without error', () async {
      final abortHandler = AortemTransmitWebAuthnCrossDeviceAbort(
        apiKey: 'dummy-key',
        baseUrl: 'https://api.example.com',
      );

      // Should complete successfully without throwing
      await abortHandler.mockAbortCrossDeviceSession(
        crossDeviceTicketId: 'ticket_123',
      );
    });

    test(
      'mockAbortCrossDeviceSession throws ArgumentError for empty id',
      () async {
        final abortHandler = AortemTransmitWebAuthnCrossDeviceAbort(
          apiKey: 'dummy-key',
          baseUrl: 'https://api.example.com',
        );

        expect(
          () =>
              abortHandler.mockAbortCrossDeviceSession(crossDeviceTicketId: ''),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });
}
