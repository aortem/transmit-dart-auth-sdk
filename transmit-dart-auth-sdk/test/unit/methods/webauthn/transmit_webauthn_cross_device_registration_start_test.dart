import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/transmit_webauthn_cross_device_registration_start.dart';

void main() {
  group('AortemTransmitWebAuthnCrossDeviceAuthenticateStart', () {
    late AortemTransmitWebAuthnCrossDeviceAuthenticateStart service;

    setUp(() {
      service = AortemTransmitWebAuthnCrossDeviceAuthenticateStart(
        apiKey: 'dummy-api-key',
        baseUrl: 'https://dummy-url.com',
      );
    });

    test('mockStartAuthentication returns correct mock data', () async {
      final result = await service.mockStartAuthentication(
        crossDeviceTicketId: 'ticket123',
      );

      expect(result.containsKey('credential_request_options'), true);
      expect(
        result['credential_request_options']['challenge'],
        'dummyChallenge123',
      );
      expect(result['session_id'], 'mock-session-123');
    });

    test(
      'mockStartAuthentication throws ArgumentError if ticket ID is empty',
      () async {
        expect(
          () => service.mockStartAuthentication(crossDeviceTicketId: ''),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });
}
