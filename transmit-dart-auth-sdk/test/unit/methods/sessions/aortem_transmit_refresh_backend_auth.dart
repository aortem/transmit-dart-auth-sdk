import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/sessions/aortem_transmit_refresh_backend_auth.dart';

void main() {
  group('BackendAuthManager Tests', () {
    final authManager = BackendAuthManager(
      apiKey: 'test-api-key',
      baseUrl: 'https://api.example.com',
    );

    test('Should throw ArgumentError if refreshToken is empty', () async {
      expect(
        () => authManager.refreshBackendAuthToken(refreshToken: ''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Should return a mock refresh token response successfully', () async {
      final response = await authManager.mockRefreshBackendAuthToken(
        refreshToken: 'valid-refresh-token',
      );
      expect(response['success'], true);
      expect(response.containsKey('newAuthToken'), true);
      expect(response.containsKey('expiresAt'), true);
    });

    test('Should handle API failure gracefully', () async {
      final authManagerWithInvalidUrl = BackendAuthManager(
        apiKey: 'test-api-key',
        baseUrl:
            'https://invalid-api.example.com', // Invalid URL to simulate failure
      );

      expect(
        () async => await authManagerWithInvalidUrl.refreshBackendAuthToken(
          refreshToken: 'valid-refresh-token',
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
