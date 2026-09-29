import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/core/transmit_api_client.dart';
import 'package:transmit_dart_auth_sdk/src/core/transmit_errors.dart';

void main() {
  group('ApiClient', () {
    test('constructor assigns values correctly', () {
      final client = ApiClient(
        baseUrl: 'https://api.example.com',
        apiKey: 'test-key',
      );
      addTearDown(client.httpClient.close);

      expect(client.baseUrl, 'https://api.example.com');
      expect(client.apiKey, 'test-key');
      expect(client.httpClient, isNotNull); // Default client should be created
    });

    for (final method in ['POST', 'GET', 'DELETE']) {
      test(
        '$method sends the authenticated request and returns its response',
        () async {
          final requests = <http.Request>[];
          final transport = MockClient((request) async {
            requests.add(request);
            return http.Response('{"ok":true}', 200);
          });
          addTearDown(transport.close);
          final client = ApiClient(
            baseUrl: 'https://api.example.com',
            apiKey: 'key',
            client: transport,
          );

          final response = await send(client, method);

          expect(response.statusCode, 200);
          expect(response.body, '{"ok":true}');
          expect(requests, hasLength(1));
          final request = requests.single;
          expect(request.method, method);
          expect(request.url, Uri.parse('https://api.example.com/test'));
          expect(request.headers['Authorization'], 'Bearer key');
          expect(request.body, method == 'GET' ? '' : '{}');
          if (method == 'POST') {
            expect(request.headers['Content-Type'], 'application/json');
          }
        },
      );

      test(
        '$method reports transport errors through its returned future',
        () async {
          final transport = MockClient((_) async {
            throw http.ClientException('network unavailable');
          });
          addTearDown(transport.close);
          final client = ApiClient(
            baseUrl: 'https://api.example.com',
            apiKey: 'key',
            client: transport,
          );

          await expectLater(
            send(client, method),
            throwsA(
              isA<ApiException>().having(
                (error) => error.message,
                'message',
                contains('network unavailable'),
              ),
            ),
          );
        },
      );
    }
  });
}

Future<http.Response> send(ApiClient client, String method) => switch (method) {
  'POST' => client.post(endpoint: '/test', body: '{}'),
  'GET' => client.get(endpoint: '/test'),
  'DELETE' => client.delete(endpoint: '/test', body: '{}'),
  _ => throw ArgumentError.value(method),
};
