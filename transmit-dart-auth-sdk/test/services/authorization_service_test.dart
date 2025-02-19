import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/auth/aortem_transmit_authorization_service.dart'; // Assuming the package is correctly imported

void main() {
  group('AuthorizationService', () {
    late AortemTransmitAuthorizationService authService;

    // Mocked responses to simulate backend calls.
    const String validAccessToken = 'validToken123';
    const String invalidAccessToken = 'invalidToken123';
    const String apiKey = 'validApiKey123';
    const String validBaseUrl = 'https://api.transmitsecurity.com';

    // Mock response data
    final Map<String, dynamic> mockValidResponse = {
      'authorized': true,
      'accessToken': validAccessToken,
      'grantedScopes': ['read', 'write'],
      'message': 'Authorization successful.',
    };

    final Map<String, dynamic> mockInvalidResponse = {
      'authorized': false,
      'message': 'Invalid access token.',
    };

    setUp(() {
      // Initialize the AuthorizationService with a valid API key
      authService = AortemTransmitAuthorizationService(
          apiKey: apiKey, baseUrl: validBaseUrl);
    });

    test('authorize returns valid response for valid access token', () async {
      // Mock HTTP POST response for a valid access token
      final http.Response mockResponse = http.Response(
        json.encode(mockValidResponse),
        200,
        headers: {'Content-Type': 'application/json'},
      );

      // Simulate the network call response
      when(() => http.post(any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'))).thenAnswer((_) async => mockResponse);

      final result = await authService.authorize(validAccessToken);

      expect(result['authorized'], true);
      expect(result['accessToken'], validAccessToken);
      expect(result['message'], 'Authorization successful.');
    });

    test('authorize throws error for invalid access token', () async {
      // Mock HTTP POST response for an invalid access token
      final http.Response mockResponse = http.Response(
        json.encode(mockInvalidResponse),
        401, // Unauthorized status code
        headers: {'Content-Type': 'application/json'},
      );

      // Simulate the network call response
      when(() => http.post(any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'))).thenAnswer((_) async => mockResponse);

      try {
        await authService.authorize(invalidAccessToken);
        fail('Exception should have been thrown');
      } catch (e) {
        expect(e, isA<Exception>());
        expect(e.toString(), contains('Authorization failed'));
      }
    });

    test('authorize throws error if access token is empty', () async {
      try {
        await authService.authorize('');
        fail('ArgumentError should have been thrown');
      } catch (e) {
        expect(e, isA<ArgumentError>());
        expect(e.toString(), contains('Access token cannot be empty.'));
      }
    });

    test('authorize returns valid response when required scopes are provided',
        () async {
      final List<String> requiredScopes = ['read', 'write'];
      final http.Response mockResponse = http.Response(
        json.encode(mockValidResponse),
        200,
        headers: {'Content-Type': 'application/json'},
      );

      // Simulate the network call response
      when(() => http.post(any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'))).thenAnswer((_) async => mockResponse);

      final result = await authService.authorize(validAccessToken,
          requiredScopes: requiredScopes);

      expect(result['authorized'], true);
      expect(result['grantedScopes'], requiredScopes);
    });
  });
}
