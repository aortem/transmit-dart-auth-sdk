import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/transmit_webauthn_cross_device_authenticate_start.dart';

void main() {
  group('AortemTransmitWebAuthnCrossDeviceAuthenticateStart', () {
    test('mockStartAuthentication returns correct mock data', () async {
      final authStarter = AortemTransmitWebAuthnCrossDeviceAuthenticateStart(
        apiKey: 'dummy-key',
        baseUrl: 'https://api.example.com',
      );

      final result = await authStarter.mockStartAuthentication(
        crossDeviceTicketId: 'ticket_123',
      );

      expect(result.containsKey('credential_request_options'), true);
      expect(result.containsKey('session_id'), true);
      expect(result['mock_data'], true);

      final options = result['credential_request_options'];
      expect(options['challenge'], contains('mock_challenge_'));
      expect(options['timeout'], 60000);
    });

    test(
      'mockStartAuthentication throws ArgumentError when id is empty',
      () async {
        final authStarter = AortemTransmitWebAuthnCrossDeviceAuthenticateStart(
          apiKey: 'dummy-key',
          baseUrl: 'https://api.example.com',
        );

        expect(
          () => authStarter.mockStartAuthentication(crossDeviceTicketId: ''),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });
}
