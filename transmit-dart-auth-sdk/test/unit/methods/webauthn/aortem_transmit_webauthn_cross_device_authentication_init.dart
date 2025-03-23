import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'dart:convert';
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_api_client.dart';
import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_errors.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmit_webauthn_cross_device_authentication_init.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late ApiClient apiClient;
  late MockHttpClient mockHttpClient;
  late WebAuthnCrossDeviceAuthInit webAuthnInit;

  const String baseUrl = 'https://api.transmit.security';
  const String apiKey = 'test-api-key';
  const String userIdentifier = 'test-user';

  setUp(() {
    mockHttpClient = MockHttpClient();
    apiClient = ApiClient(
      baseUrl: baseUrl,
      apiKey: apiKey,
      client: mockHttpClient,
    );
    webAuthnInit = WebAuthnCrossDeviceAuthInit(apiClient: apiClient);
  });

  group('WebAuthnCrossDeviceAuthInit', () {
    test('throws ArgumentError when userIdentifier is empty', () {
      expect(
        () => webAuthnInit.initiate(userIdentifier: ''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('returns mock response when useMock is true', () async {
      final result = await webAuthnInit.initiate(
        userIdentifier: userIdentifier,
        useMock: true,
      );

      expect(result, isA<Map<String, dynamic>>());
      expect(result['challenge'], equals('mock-challenge'));
      expect(result['sessionId'], equals('mock-session-id'));
      expect(result['timeout'], equals(300000));
      expect(result['allowedCredentials'], contains('mock-credential-id'));
    });

    test('returns valid response on successful API call', () async {
      final mockResponse = http.Response(
        jsonEncode({
          'challenge': 'test-challenge',
          'sessionId': 'test-session-id',
          'timeout': 300000,
          'allowedCredentials': ['test-credential-id'],
        }),
        200,
      );

      when(
        () => mockHttpClient.post(
          Uri.parse('$baseUrl/webauthn-cross-device-authentication-init'),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => mockResponse);

      final result = await webAuthnInit.initiate(
        userIdentifier: userIdentifier,
      );

      expect(result, isA<Map<String, dynamic>>());
      expect(result['challenge'], equals('test-challenge'));
      expect(result['sessionId'], equals('test-session-id'));
      expect(result['timeout'], equals(300000));
      expect(result['allowedCredentials'], contains('test-credential-id'));
    });

    test('throws ApiException on API failure', () async {
      final mockResponse = http.Response(
        jsonEncode({'error': 'Invalid request'}),
        400,
      );

      when(
        () => mockHttpClient.post(
          Uri.parse('$baseUrl/webauthn-cross-device-authentication-init'),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => mockResponse);

      expect(
        () => webAuthnInit.initiate(userIdentifier: userIdentifier),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
