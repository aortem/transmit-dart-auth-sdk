import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_api_client.dart';

import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_errors.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late ApiClient apiClient;
  late MockHttpClient mockHttpClient;
  const String baseUrl = 'https://api.transmit.security';
  const String apiKey = 'test-api-key';
  const String endpoint = '/test-endpoint';

  setUp(() {
    mockHttpClient = MockHttpClient();
    apiClient = ApiClient(
      baseUrl: baseUrl,
      apiKey: apiKey,
      client: mockHttpClient,
    );
  });

  group('ApiClient', () {
    test('POST request returns valid response on success', () async {
      final mockResponse = http.Response(
        jsonEncode({'message': 'Success'}),
        200,
      );

      when(
        () => mockHttpClient.post(
          Uri.parse('$baseUrl$endpoint'),
          headers: any(named: 'headers'),
          body: jsonEncode({'test': 'data'}),
        ),
      ).thenAnswer((_) async => mockResponse);

      final response = await apiClient.post(
        endpoint: endpoint,
        body: jsonEncode({'test': 'data'}),
      );

      expect(response.statusCode, equals(200));
      expect(jsonDecode(response.body)['message'], equals('Success'));
    });

    test('POST request throws ApiException on failure', () async {
      final mockResponse = http.Response(
        jsonEncode({'error': 'Invalid request'}),
        400,
      );

      when(
        () => mockHttpClient.post(
          Uri.parse('$baseUrl$endpoint'),
          headers: any(named: 'headers'),
          body: jsonEncode({'test': 'data'}),
        ),
      ).thenAnswer((_) async => mockResponse);

      expect(
        () => apiClient.post(
          endpoint: endpoint,
          body: jsonEncode({'test': 'data'}),
        ),
        throwsA(isA<ApiException>()),
      );
    });

    test('GET request returns valid response on success', () async {
      final mockResponse = http.Response(jsonEncode({'data': 'valid'}), 200);

      when(
        () => mockHttpClient.get(
          Uri.parse('$baseUrl$endpoint'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => mockResponse);

      final response = await apiClient.get(endpoint: endpoint);

      expect(response.statusCode, equals(200));
      expect(jsonDecode(response.body)['data'], equals('valid'));
    });

    test('GET request throws ApiException on failure', () async {
      final mockResponse = http.Response(
        jsonEncode({'error': 'Unauthorized'}),
        401,
      );

      when(
        () => mockHttpClient.get(
          Uri.parse('$baseUrl$endpoint'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => mockResponse);

      expect(
        () => apiClient.get(endpoint: endpoint),
        throwsA(isA<ApiException>()),
      );
    });

    test('POST request throws ApiException on network error', () async {
      when(
        () => mockHttpClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenThrow(Exception('Network failure'));

      expect(
        () => apiClient.post(
          endpoint: endpoint,
          body: jsonEncode({'test': 'data'}),
        ),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
