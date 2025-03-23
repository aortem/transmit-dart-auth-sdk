import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/coumunication/aortem_transmit_send_magic_link.dart';
// Adjust package import as needed

void main() {
  group('sendMagicLinkEmail (HTTP Request Approach) Tests', () {
    final transmitMagicLink = AortemTransmitMagicLink(apiKey: 'valid-api-key');

    test('throws error for empty email', () {
      expect(
        () => transmitMagicLink.sendMagicLinkEmail(''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('sendMagicLinkEmail (Stub/Mock Implementation) Tests', () {
    final transmitMagicLink = AortemTransmitMagicLink(apiKey: 'valid-api-key');
    final email = 'user@example.com';

    test('returns dummy response for valid email', () async {
      final result = await transmitMagicLink.sendMagicLinkEmailStub(email);
      expect(result['email'], equals(email));
      expect(result.containsKey('tempToken'), isTrue);
    });

    test('throws error for empty email (stub)', () {
      expect(
        () => transmitMagicLink.sendMagicLinkEmailStub(''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
