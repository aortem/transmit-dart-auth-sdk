import 'dart:convert';
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:transmit_dart_auth_sdk/auth/aortem_transmit_auth.dart';

void main() {
  group('AortemTransmitAuth Tests', () {
    final apiKey = 'valid-api-key';
    final baseUrl = 'https://api.transmitsecurity.com';

    test('authenticates with valid username and password', () async {
      final mockClient = MockClient((request) async {
        if (request.url.toString() == '$baseUrl/authenticate' && request.method == 'POST') {
          return http.Response(json.encode({'token': 'valid-token', 'userId': 'valid-user-id'}), 200);
        }
        return http.Response('Unauthorized', 401);
      });

      final auth = AortemTransmitAuth(apiKey: apiKey, baseUrl: baseUrl, client: mockClient);

      final result = await auth.authenticate('valid-username', 'valid-password');

      expect(result, isA<Map<String, dynamic>>());
      expect(result['token'], equals('valid-token'));
      expect(result['userId'], equals('valid-user-id'));
    });

    test('throws ArgumentError for empty username', () {
      final auth = AortemTransmitAuth(apiKey: apiKey, baseUrl: baseUrl);
      expect(() => auth.authenticate('', 'valid-password'), throwsA(isA<ArgumentError>()));
    });

    test('throws ArgumentError for empty password', () {
      final auth = AortemTransmitAuth(apiKey: apiKey, baseUrl: baseUrl);
      expect(() => auth.authenticate('valid-username', ''), throwsA(isA<ArgumentError>()));
    });

    test('throws Exception for authentication failure', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Authentication failed', 401);
      });

      final auth = AortemTransmitAuth(apiKey: apiKey, baseUrl: baseUrl, client: mockClient);

      expect(() async => await auth.authenticate('invalid-username', 'invalid-password'), throwsException);
    });
  });
}
