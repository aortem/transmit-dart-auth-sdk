import "package:ds_tools_testing/ds_tools_testing.dart";
import "package:transmit_dart_auth_sdk/src/methods/token/aortem_transmit_token_generate.dart";

void main() {
  group('issueToken (HTTP Request Approach) Tests', () {
    final transmitToken = AortemTransmitToken(apiKey: 'valid-api-key');
    final clientId = 'your-client-id';
    final clientSecret = 'your-client-secret';

    test('throws error for empty client ID or secret', () {
      expect(() => transmitToken.issueToken('', clientSecret),
          throwsA(isA<ArgumentError>()));
      expect(() => transmitToken.issueToken(clientId, ''),
          throwsA(isA<ArgumentError>()));
    });
  });

  group('issueTokenStub (Stub/Mock Implementation) Tests', () {
    final transmitToken = AortemTransmitToken(apiKey: 'valid-api-key');
    final clientId = 'your-client-id';
    final clientSecret = 'your-client-secret';

    test('returns dummy token for valid credentials', () async {
      final tokenData =
          await transmitToken.issueTokenStub(clientId, clientSecret);
      expect(tokenData['token'], isNotEmpty);
      expect(tokenData['tokenType'], equals('Bearer'));
    });

    test('throws error for empty client ID or secret (stub)', () {
      expect(() => transmitToken.issueTokenStub('', clientSecret),
          throwsA(isA<ArgumentError>()));
      expect(() => transmitToken.issueTokenStub(clientId, ''),
          throwsA(isA<ArgumentError>()));
    });
  });
}
