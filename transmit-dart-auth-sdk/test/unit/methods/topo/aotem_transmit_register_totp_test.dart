import 'dart:convert';

import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/topo/aotem_transmit_register_totp.dart';

void main() {
  group('AortemTransmitRegisterTOTP', () {
    test('registerTOTP posts payload and returns enrollment data', () async {
      final client = MockClient((request) async {
        expect(
          request.url.toString(),
          equals('https://api.test.com/v1/users/me/totp'),
        );
        expect(request.method, equals('POST'));
        expect(request.headers['Authorization'], equals('Bearer test-api-key'));
        expect(request.headers['Content-Type'], equals('application/json'));

        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['label'], equals('Example:user@example.com'));
        expect(body['allow_override'], isTrue);

        return http.Response(
          jsonEncode({
            'secret': 'JBSWY3DPEHPK3PXP',
            'uri': 'otpauth://totp/Example:user@example.com',
            'algorithm': 'SHA1',
            'digits': 6,
            'period': 30,
          }),
          201,
        );
      });

      final service = AortemTransmitRegisterTOTP(
        apiKey: 'test-api-key',
        baseUrl: 'https://api.test.com',
        httpClient: client,
      );

      final result = await service.registerTOTP(
        label: 'Example:user@example.com',
        allowOverride: true,
      );

      expect(result['secret'], equals('JBSWY3DPEHPK3PXP'));
      expect(result['digits'], equals(6));
    });

    test('registerTOTP throws on non-created response', () async {
      final client = MockClient(
        (_) async => http.Response('{"error":"unauthorized"}', 401),
      );
      final service = AortemTransmitRegisterTOTP(
        apiKey: 'test-api-key',
        baseUrl: 'https://api.test.com',
        httpClient: client,
      );

      expect(() => service.registerTOTP(), throwsA(isA<Exception>()));
    });
  });
}
