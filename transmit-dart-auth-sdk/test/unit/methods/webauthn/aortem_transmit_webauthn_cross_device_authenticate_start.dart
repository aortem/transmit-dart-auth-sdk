import 'dart:convert';
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_api_client.dart';
import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_errors.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmit_webauthn_cross_device_authenticate_start.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late WebAuthnCrossDeviceAuthenticateStart webAuthnStart;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    webAuthnStart = WebAuthnCrossDeviceAuthenticateStart(mockApiClient);
  });

  group('WebAuthnCrossDeviceAuthenticateStart', () {
    const String userId = 'user@example.com';
    const String endpoint = '/webauthn-cross-device-authenticate-start';

    test('should throw ArgumentError if userId is empty', () {
      expect(
        () => webAuthnStart.startAuthentication(userId: ''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should return a mock response when mock is enabled', () async {
      final response = await webAuthnStart.startAuthentication(
        userId: userId,
        mock: true,
      );

      expect(response['status'], equals('success'));
      expect(response, contains('challenge'));
      expect(response, contains('sessionId'));
      expect(response, contains('timeout'));
      expect(response, contains('allowedCredentials'));
    });

    test('should return success response on valid API request', () async {
      final mockResponse = {
        'status': 'success',
        'challenge': 'xyz123',
        'sessionId': 'session-789',
        'timeout': 60000,
        'allowedCredentials': ['credential-abc'],
      };

      when(
        () => mockApiClient.post(
          endpoint: endpoint,
          body: jsonEncode({'userId': userId}),
        ),
      ).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      final response = await webAuthnStart.startAuthentication(userId: userId);

      expect(response, equals(mockResponse));
    });

    test('should throw ApiException on API failure', () async {
      when(
        () => mockApiClient.post(
          endpoint: endpoint,
          body: jsonEncode({'userId': userId}),
        ),
      ).thenAnswer(
        (_) async => http.Response(jsonEncode({'error': 'Invalid user'}), 400),
      );

      expect(
        () => webAuthnStart.startAuthentication(userId: userId),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
