import 'dart:convert';
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_api_client.dart';
import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_errors.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmit_webauthn_cross_device_status.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late ApiClient apiClient;
  late MockHttpClient mockHttpClient;
  late WebAuthnCrossDeviceStatus statusMethod;

  const String baseUrl = 'https://api.transmit.security';
  const String apiKey = 'test-api-key';
  const String userIdentifier = 'test-user';
  const String sessionId = 'test-session';

  setUp(() {
    mockHttpClient = MockHttpClient();
    apiClient = ApiClient(
      baseUrl: baseUrl,
      apiKey: apiKey,
      client: mockHttpClient,
    );
    statusMethod = WebAuthnCrossDeviceStatus(apiClient: apiClient);
  });

  group('WebAuthnCrossDeviceStatus', () {
    test('throws ArgumentError when userIdentifier is empty', () {
      expect(
        () => statusMethod.getStatus(userIdentifier: ''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('returns mock response when useMock is true', () async {
      final result = await statusMethod.getStatus(
        userIdentifier: userIdentifier,
        useMock: true,
      );

      expect(result, isA<Map<String, dynamic>>());
      expect(result['sessionId'], equals('mock-session-id'));
      expect(result['status'], equals('pending'));
      expect(result['expiresIn'], equals(300));
      expect(result['message'], equals('Waiting for user authentication'));
    });

    test('returns valid response on successful API call', () async {
      final mockResponse = http.Response(
        jsonEncode({
          'sessionId': 'test-session-id',
          'status': 'completed',
          'expiresIn': 0,
          'message': 'Authentication completed successfully',
        }),
        200,
      );

      when(
        () => mockHttpClient.get(
          Uri.parse(
            '$baseUrl/webauthn-cross-device-status?userIdentifier=$userIdentifier&sessionId=$sessionId',
          ),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => mockResponse);

      final result = await statusMethod.getStatus(
        userIdentifier: userIdentifier,
        sessionId: sessionId,
      );

      expect(result, isA<Map<String, dynamic>>());
      expect(result['sessionId'], equals('test-session-id'));
      expect(result['status'], equals('completed'));
      expect(result['expiresIn'], equals(0));
      expect(
        result['message'],
        equals('Authentication completed successfully'),
      );
    });

    test('throws ApiException on API failure', () async {
      final mockResponse = http.Response(
        jsonEncode({'error': 'Session not found'}),
        404,
      );

      when(
        () => mockHttpClient.get(
          Uri.parse(
            '$baseUrl/webauthn-cross-device-status?userIdentifier=$userIdentifier&sessionId=$sessionId',
          ),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => mockResponse);

      expect(
        () => statusMethod.getStatus(
          userIdentifier: userIdentifier,
          sessionId: sessionId,
        ),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
