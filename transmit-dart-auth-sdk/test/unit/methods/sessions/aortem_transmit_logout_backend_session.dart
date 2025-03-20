import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/sessions/aortem_transmit_logout_backend_session.dart';

void main() {
  group('BackendSessionManager Tests', () {
    final sessionManager = BackendSessionManager(
      apiKey: 'test-api-key',
      baseUrl: 'https://api.example.com',
    );

    test('Should throw ArgumentError if sessionToken is empty', () async {
      expect(
        () => sessionManager.logoutBackendSession(sessionToken: ''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Should return a mock logout response successfully', () async {
      final response = await sessionManager.mockLogoutBackendSession(
        sessionToken: 'valid-token',
      );
      expect(response['success'], true);
      expect(response.containsKey('logoutTimestamp'), true);
    });

    test('Should handle API failure gracefully', () async {
      final sessionManagerWithInvalidUrl = BackendSessionManager(
        apiKey: 'test-api-key',
        baseUrl:
            'https://invalid-api.example.com', // Invalid URL to simulate failure
      );

      expect(
        () async => await sessionManagerWithInvalidUrl.logoutBackendSession(
          sessionToken: 'valid-token',
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
