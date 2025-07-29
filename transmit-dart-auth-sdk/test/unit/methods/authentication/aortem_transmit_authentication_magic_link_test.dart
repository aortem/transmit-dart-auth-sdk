import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/authentication/aortem_transmit_authentication_magic_link.dart';

void main() {
  group('AortemTransmitAuthenticateMagicLink', () {
    late AortemTransmitAuthenticateMagicLink service;

    setUp(() {
      service = AortemTransmitAuthenticateMagicLink(apiKey: 'dummy-key');
    });

    test('authenticateMagicLinkStub returns mock data', () async {
      final result = await service.authenticateMagicLinkStub('dummy-token');

      expect(result['accessToken'], equals('mock-access-token'));
      expect(result['idToken'], equals('mock-id-token'));
      expect(result['expiresIn'], equals(3600));
      expect(result['message'], contains('successful'));
    });

    test('throws error when token is empty', () {
      expect(
        () => service.authenticateMagicLinkStub(''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('mockCall function', () {
    test('mockCall returns expected mock data', () async {
      final result = await mockCall(credentialResponse: {'id': '123'});

      expect(result['access_token'], isNotEmpty);
      expect(result['id_token'], isNotEmpty);
      expect(result['refresh_token'], isNotEmpty);
      expect(result['expires_in'], equals(3600));
    });

    test('mockCall throws error when credentialResponse is empty', () {
      expect(
        () => mockCall(credentialResponse: {}),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
