import 'dart:convert';

import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/services/aortem_transmit_magic_link_auth.dart';

// Mock class for HTTP client
class MockHttpClient extends Mock implements http.Client {}

// Fake class for Uri to prevent `Bad state` errors
class FakeUri extends Fake implements Uri {}

void main() {
  late MockHttpClient mockHttpClient;
  late TransmitMagicLinkAuth transmitMagicLinkAuth;

  setUpAll(() {
    registerFallbackValue(FakeUri()); // Register fallback for Uri
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    transmitMagicLinkAuth = TransmitMagicLinkAuth(
      apiKey: 'valid-api-key',
      httpClient: mockHttpClient, // Inject mocked client
    );
  });

  test('authenticates with valid magic link token (mocked response)', () async {
    final magicLinkToken = 'valid-magic-link-token';
    final fakeResponse = json.encode({
      'accessToken': 'mock-access-token',
      'idToken': 'mock-id-token',
      'expiresIn': 3600,
      'message': 'Mocked Magic Link Authentication Successful',
    });

    when(() => mockHttpClient.post(
          any(), // Any URI
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        )).thenAnswer((_) async => http.Response(fakeResponse, 200));

    final result = await transmitMagicLinkAuth.authenticateMagicLink(magicLinkToken);

    expect(result['accessToken'], equals('mock-access-token'));
    expect(result['message'], equals('Mocked Magic Link Authentication Successful'));
  });

  test('throws error for empty magic link token', () {
    expect(() => transmitMagicLinkAuth.authenticateMagicLink(''), throwsA(isA<ArgumentError>()));
  });
}
