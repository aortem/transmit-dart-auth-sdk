 import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/auth/aortem_transmit_authorization_service.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  group('AortemTransmitAuthorization Tests', () {
    final apiKey = 'valid-api-key';
    final baseUrl = 'https://api.transmitsecurity.com';
    final auth = AortemTransmitAuthorization(apiKey: apiKey, baseUrl: baseUrl);

    test('authorizes with valid access token and required scopes', () async {
      final accessToken = 'valid-access-token';
      final requiredScopes = ['read', 'write'];

      // Mock HTTP response
      final mockResponse = {
        'valid': true,
        'userId': 'valid-user-id',
        'scopes': requiredScopes,
      };
      http.Response response = http.Response(json.encode(mockResponse), 200);

      // Mock the http.post method to return the mock response
      http.post = (Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
        return response;
      };

      // Call the authorize method
      final result = await auth.authorize(accessToken, requiredScopes: requiredScopes);

      // Verify the result
      expect(result, isA<Map<String, dynamic>>());
      expect(result['valid'], isTrue);
      expect(result['userId'], equals('valid-user-id'));
      expect(result['scopes'], equals(requiredScopes));
    });

    test('throws ArgumentError for empty access token', () {
      expect(() => auth.authorize(''), throwsA(isA<ArgumentError>()));
    });

    test('throws Exception for authorization failure', () async {
      final accessToken = 'invalid-access-token';
      final requiredScopes = ['read', 'write'];

      // Mock HTTP response
      http.Response response = http.Response('Authorization failed', 401);

      // Mock the http.post method to return the mock response
      http.post = (Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
        return response;
      };

      // Call the authorize method and verify the exception
      expect(() async => await auth.authorize(accessToken, requiredScopes: requiredScopes), throwsException);
    });
  });
}
