import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/transmit_webauthn_registration_hint.dart';

void main() {
  group('AortemTransmitHostedWebAuthnRegistrationHint', () {
    late AortemTransmitHostedWebAuthnRegistrationHint service;

    setUp(() {
      service = AortemTransmitHostedWebAuthnRegistrationHint(
        apiKey: 'dummy-key',
        baseUrl: 'https://dummy-url.com',
      );
    });

    test('mockGetHint returns correct mock data', () async {
      final result = await service.mockGetHint(
        webauthnIdentifier: 'user@example.com',
        redirectUri: 'https://callback.com',
      );

      expect(result['registration_token'], 'mock_registration_token_123');
      expect(result['challenge'], 'mock_challenge_value');
      expect(result['redirect_uri'], 'https://callback.com');
      expect(result['expires_in'], 300);
      expect(result['display_name'], 'user@example.com');
    });

    test('mockGetHint throws ArgumentError when identifier is empty', () {
      expect(
        () => service.mockGetHint(
          webauthnIdentifier: '',
          redirectUri: 'https://callback.com',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('mockGetHint throws ArgumentError when redirectUri is empty', () {
      expect(
        () => service.mockGetHint(
          webauthnIdentifier: 'user@example.com',
          redirectUri: '',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
