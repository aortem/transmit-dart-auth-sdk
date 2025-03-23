import 'dart:convert';

import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_api_client.dart';
import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_errors.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmit_webauthn_cross_device_attach_device.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late ApiClient apiClient;
  late MockHttpClient mockHttpClient;
  late WebAuthnCrossDeviceAttachDevice attachDeviceMethod;

  const String baseUrl = 'https://api.transmit.security';
  const String apiKey = 'test-api-key';
  const String userIdentifier = 'test-user';
  const String deviceId = 'test-device';

  setUp(() {
    mockHttpClient = MockHttpClient();
    apiClient = ApiClient(
      baseUrl: baseUrl,
      apiKey: apiKey,
      client: mockHttpClient,
    );
    attachDeviceMethod = WebAuthnCrossDeviceAttachDevice(apiClient: apiClient);
  });

  group('WebAuthnCrossDeviceAttachDevice', () {
    test('throws ArgumentError when userIdentifier or deviceId is empty', () {
      expect(
        () => attachDeviceMethod.attachDevice(
          userIdentifier: '',
          deviceId: deviceId,
        ),
        throwsA(isA<ArgumentError>()),
      );

      expect(
        () => attachDeviceMethod.attachDevice(
          userIdentifier: userIdentifier,
          deviceId: '',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('returns mock response when useMock is true', () async {
      final result = await attachDeviceMethod.attachDevice(
        userIdentifier: userIdentifier,
        deviceId: deviceId,
        useMock: true,
      );

      expect(result, isA<Map<String, dynamic>>());
      expect(result['sessionId'], equals('mock-session-id'));
      expect(result['deviceId'], equals('mock-device-id'));
      expect(result['status'], equals('attached'));
      expect(
        result['message'],
        equals('Device successfully attached to the session'),
      );
    });

    test('returns valid response on successful API call', () async {
      final mockResponse = http.Response(
        jsonEncode({
          'sessionId': 'test-session-id',
          'deviceId': 'test-device-id',
          'status': 'attached',
          'message': 'Device successfully attached',
        }),
        200,
      );

      when(
        () => mockHttpClient.post(
          Uri.parse('$baseUrl/webauthn-cross-device-attach-device'),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => mockResponse);

      final result = await attachDeviceMethod.attachDevice(
        userIdentifier: userIdentifier,
        deviceId: deviceId,
      );

      expect(result, isA<Map<String, dynamic>>());
      expect(result['sessionId'], equals('test-session-id'));
      expect(result['deviceId'], equals('test-device-id'));
      expect(result['status'], equals('attached'));
      expect(result['message'], equals('Device successfully attached'));
    });

    test('throws ApiException on API failure', () async {
      final mockResponse = http.Response(
        jsonEncode({'error': 'Invalid request'}),
        400,
      );

      when(
        () => mockHttpClient.post(
          Uri.parse('$baseUrl/webauthn-cross-device-attach-device'),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => mockResponse);

      expect(
        () => attachDeviceMethod.attachDevice(
          userIdentifier: userIdentifier,
          deviceId: deviceId,
        ),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
