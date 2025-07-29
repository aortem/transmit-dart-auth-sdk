import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/authentication/transmit_authenticate_webauthn.dart';

void main() {
  group('AortemTransmitAuthenticateWebAuthnCredential', () {
    late AortemTransmitAuthenticateWebAuthnCredential webAuthn;

    setUp(() {
      webAuthn = AortemTransmitAuthenticateWebAuthnCredential(
        apiKey: 'dummy-key',
        baseUrl: 'https://dummy.url',
      );
    });

    test('throws ArgumentError when credentialResponse is empty', () async {
      expect(
        () => webAuthn(credentialResponse: {}),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
