import 'package:ds_tools_testing/ds_tools_testing.dart';

import 'package:transmit_dart_auth_sdk/src/methods/communication/aortem_transmit_send_otp.dart';

void main() {
  group('AortemTransmitSendOTP', () {
    late AortemTransmitSendOTP service;

    setUp(() {
      service = AortemTransmitSendOTP(apiKey: 'dummy-key');
    });

    test('sendOTPStub returns expected mock data', () async {
      final result = await service.sendOTPStub(
        channel: 'sms',
        identifierType: 'phone_number',
        identifier: '+1234567890',
      );

      expect(result['message'], contains('OTP sent'));
      expect(result['code'], equals('123456'));
      expect(result['identifier'], '+1234567890');
    });

    test('sendOTPStub works with email identifier', () async {
      final result = await service.sendOTPStub(
        channel: 'email',
        identifierType: 'email',
        identifier: 'user@example.com',
      );

      expect(result['identifier'], 'user@example.com');
    });
  });
}
