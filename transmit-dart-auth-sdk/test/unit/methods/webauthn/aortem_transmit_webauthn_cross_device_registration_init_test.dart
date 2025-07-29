import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmit_webauthn_cross_device_external_registration_init.dart';

void main() {
  group('AortemTransmitWebAuthnCrossDeviceExternalRegistrationInit', () {
    late AortemTransmitWebAuthnCrossDeviceExternalRegistrationInit service;

    setUp(() {
      service = AortemTransmitWebAuthnCrossDeviceExternalRegistrationInit(
        apiKey: 'dummy-api-key',
        baseUrl: 'https://dummy-url.com',
      );
    });

    test('mockInitRegistration returns mock data with correct keys', () async {
      final result = await service.mockInitRegistration(
        externalUserId: 'user123',
        username: 'test@example.com',
      );

      expect(result['username'], 'test@example.com');
      expect(result['external_user_id'], 'user123');
      expect(result.containsKey('cross_device_ticket_id'), true);
      expect(result['mock_data'], true);
    });

    test(
      'mockInitRegistration throws ArgumentError if externalUserId is empty',
      () async {
        expect(
          () => service.mockInitRegistration(
            externalUserId: '',
            username: 'test@example.com',
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'mockInitRegistration throws ArgumentError if username is empty',
      () async {
        expect(
          () => service.mockInitRegistration(
            externalUserId: 'user123',
            username: '',
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });
}
