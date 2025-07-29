import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmit_webauthn_registration.dart';

void main() {
  group('AortemTransmitWebAuthnRegistration', () {
    late AortemTransmitWebAuthnRegistration registration;

    setUp(() {
      registration = AortemTransmitWebAuthnRegistration(
        apiKey: 'dummy-key',
        baseUrl: 'https://dummy-url.com',
      );
    });

    test('mockRegisterCredential returns correct mock data', () async {
      final result = await registration.mockRegisterCredential(
        webauthnEncodedResult: 'dummy-attestation-data',
      );

      expect(result['success'], true);
      expect(result['credential_id'], 'mock_credential_123');
      expect(result['message'], contains('successfully'));
      expect(result['created_at'], isA<String>());
    });

    test('mockRegisterCredential throws ArgumentError when input is empty', () {
      expect(
        () => registration.mockRegisterCredential(webauthnEncodedResult: ''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
