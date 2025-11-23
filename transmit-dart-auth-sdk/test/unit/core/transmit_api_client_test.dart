import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/core/transmit_api_client.dart';

void main() {
  group('ApiClient', () {
    test('constructor assigns values correctly', () {
      final client = ApiClient(
        baseUrl: 'https://api.example.com',
        apiKey: 'test-key',
      );

      expect(client.baseUrl, 'https://api.example.com');
      expect(client.apiKey, 'test-key');
      expect(client.httpClient, isNotNull); // Default client should be created
    });

    test('post, get, delete methods exist', () {
      final client = ApiClient(
        baseUrl: 'https://api.example.com',
        apiKey: 'key',
      );

      // Just checking that methods return Future<http.Response>
      expect(client.post(endpoint: '/test', body: '{}'), isA<Future>());
      expect(client.get(endpoint: '/test'), isA<Future>());
      expect(client.delete(endpoint: '/test'), isA<Future>());
    });
  });
}
