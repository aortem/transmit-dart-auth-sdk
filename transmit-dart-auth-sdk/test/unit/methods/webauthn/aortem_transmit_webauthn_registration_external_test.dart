import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/transmit_webauthn_registration_external.dart';

void main() {
  group('AortemTransmitWebAuthnRegistrationExternal', () {
    late AortemTransmitWebAuthnRegistrationExternal service;

    setUp(() {
      service = AortemTransmitWebAuthnRegistrationExternal(
        apiKey: 'dummy-api-key',
        baseUrl: 'https://dummy-url.com',
      );
    });

    test('mockRegisterExternal returns correct mock data', () async {
      final result = await service.mockRegisterExternal(
        externalUserId: 'user123',
        webauthnEncodedResult: 'encodedData123',
      );

      expect(result['external_user_id'], 'user123');
      expect(result['access_token'], 'mock-access-token');
      expect(result['id_token'], 'mock-id-token');
      expect(result['expires_in'], 3600);
      expect(
        result['message'],
        contains('External WebAuthn registration completed successfully'),
      );
    });

    test('mockRegisterExternal throws ArgumentError for empty userId', () {
      expect(
        () => service.mockRegisterExternal(
          externalUserId: '',
          webauthnEncodedResult: 'encodedData123',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test(
      'mockRegisterExternal throws ArgumentError for empty encoded result',
      () {
        expect(
          () => service.mockRegisterExternal(
            externalUserId: 'user123',
            webauthnEncodedResult: '',
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });
}
