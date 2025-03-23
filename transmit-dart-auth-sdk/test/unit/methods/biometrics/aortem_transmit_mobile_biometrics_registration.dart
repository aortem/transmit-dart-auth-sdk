import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_api_client.dart';
import 'package:transmit_dart_auth_sdk/src/methods/biometrics/aortem_transmit_mobile_biometrics_registration.dart';
import 'dart:convert';

import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_errors.dart';

class MockApiClient implements ApiClient {
  @override
  final String baseUrl = 'https://mockapi.com';

  @override
  final String apiKey = 'mock_api_key';

  @override
  Future<http.Response> post({
    required String endpoint,
    required String body,
  }) async {
    if (endpoint == '/mobile-biometrics-registration') {
      final mockResponse = {
        'status': 'success',
        'message': 'Biometric registration completed.',
        'userId': jsonDecode(body)['userId'],
        'registeredAt': DateTime.now().toIso8601String(),
      };
      return Future.value(http.Response(jsonEncode(mockResponse), 200));
    }
    return Future.value(http.Response('Error', 400));
  }

  @override
  Future<http.Response> get({required String endpoint}) async {
    return Future.value(http.Response('{}', 200));
  }

  @override
  Future<http.Response> delete({required String endpoint, String? body}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  // TODO: implement httpClient
  http.Client get httpClient => throw UnimplementedError();
}

void main() {
  late MockApiClient mockApiClient;
  late MobileBiometricsRegistration biometricsRegistration;

  setUp(() {
    mockApiClient = MockApiClient();
    biometricsRegistration = MobileBiometricsRegistration(
      apiClient: mockApiClient,
    );
  });

  test('register should return success response on valid input', () async {
    final userId = 'testUser123';
    final biometricData = {'fingerprint': 'sample_data'};

    final result = await biometricsRegistration.register(
      userId: userId,
      biometricData: biometricData,
    );

    expect(result['status'], 'success');
    expect(result['userId'], userId);
  });

  test('register should throw ArgumentError if inputs are empty', () async {
    expect(
      () => biometricsRegistration.register(userId: '', biometricData: {}),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('register should throw ApiException on failure response', () async {
    expect(
      () async => biometricsRegistration.register(
        userId: 'invalidUser',
        biometricData: {},
      ),
      throwsA(isA<ApiException>()),
    );
  });

  test(
    'register should return mock response when mock mode is enabled',
    () async {
      final userId = 'testUser123';
      final biometricData = {'fingerprint': 'sample_data'};

      final result = await biometricsRegistration.register(
        userId: userId,
        biometricData: biometricData,
        mock: true,
      );

      expect(result['status'], 'success');
      expect(result['userId'], userId);
      expect(result.containsKey('registeredAt'), isTrue);
    },
  );
}
