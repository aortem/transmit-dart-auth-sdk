import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/transmit_webauthn_registration_start.dart';

void main() {
  group('AortemTransmitWebAuthnRegistrationStart', () {
    late AortemTransmitWebAuthnRegistrationStart service;

    setUp(() {
      service = AortemTransmitWebAuthnRegistrationStart(
        apiKey: 'dummy-key',
        baseUrl: 'https://dummy-url.com',
      );
    });

    test('mockStartRegistration returns correct mock data', () async {
      final result = await service.mockStartRegistration(
        clientId: 'client123',
        username: 'test@example.com',
        displayName: 'Test User',
        timeout: 400,
        limitSingleCredentialToDevice: true,
      );

      expect(result['session_id'], 'mock_session_id_123');
      expect(result['credential_creation_options'], isA<Map>());
      expect(
        result['credential_creation_options']['challenge'],
        'mock_challenge_base64',
      );
      expect(result['credential_creation_options']['timeout'], 400);
      expect(
        result['credential_creation_options']['user']['displayName'],
        'Test User',
      );
    });

    test(
      'mockStartRegistration throws ArgumentError when clientId is empty',
      () {
        expect(
          () => service.mockStartRegistration(
            clientId: '',
            username: 'user@example.com',
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test(
      'mockStartRegistration throws ArgumentError when username is empty',
      () {
        expect(
          () => service.mockStartRegistration(
            clientId: 'client123',
            username: '',
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });
}
