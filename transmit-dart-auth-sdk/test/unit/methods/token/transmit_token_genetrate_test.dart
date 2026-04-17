import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/token/transmit_token_generate.dart';

void main() {
  group('AortemTransmitTokenService', () {
    const service = AortemTransmitTokenService();

    test('issueTokenStub returns the documented token shape', () async {
      final result = await service.issueTokenStub(
        clientId: 'client-id',
        clientSecret: 'client-secret',
      );

      expect(result['access_token'], equals('mock-client-token'));
      expect(result['token_type'], equals('Bearer'));
      expect(result['expires_in'], equals(3600));
      expect(result.containsKey('issued_at'), isTrue);
    });

    test('issueTokenStub throws when client credentials are empty', () {
      expect(
        () => service.issueTokenStub(clientId: '', clientSecret: ''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
