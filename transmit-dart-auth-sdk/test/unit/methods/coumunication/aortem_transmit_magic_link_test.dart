import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/communication/aortem_transmit_send_magic_link.dart';

void main() {
  group('AortemTransmitSendMagicLink', () {
    late AortemTransmitSendMagicLink service;

    setUp(() {
      service = AortemTransmitSendMagicLink(apiKey: 'dummy-key');
    });

    test('sendMagicLinkEmailStub returns expected mock data', () async {
      final result = await service.sendMagicLinkEmailStub('user@example.com');

      expect(result['email'], 'user@example.com');
      expect(result['tempToken'], 'dummy-temp-token');
      expect(result['message'], contains('Magic link email sent successfully'));
    });

    test('throws ArgumentError when email is empty', () async {
      expect(
        () => service.sendMagicLinkEmailStub(''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
