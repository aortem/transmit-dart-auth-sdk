import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_auth_manager.dart';

void main() {
  group('SessionAuthManager Tests', () {
    final sessionManager = SessionAuthManager(
      apiKey: 'test-api-key',
      baseUrl: 'https://api.example.com',
    );

    test('Should throw ArgumentError if sessionToken is empty', () async {
      expect(
        () => sessionManager.authenticateSession(sessionToken: ''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test(
      'Should return a mock session authentication response successfully',
      () async {
        final response = await sessionManager.mockAuthenticateSession(
          sessionToken: 'valid-session-token',
        );
        expect(response['success'], true);
        expect(response.containsKey('userId'), true);
        expect(response.containsKey('sessionId'), true);
        expect(response['authTokens'].containsKey('accessToken'), true);
        expect(response['authTokens'].containsKey('refreshToken'), true);
      },
    );

    test('Should handle API failure gracefully', () async {
      final sessionManagerWithInvalidUrl = SessionAuthManager(
        apiKey: 'test-api-key',
        baseUrl:
            'https://invalid-api.example.com', // Invalid URL to simulate failure
      );

      expect(
        () async => await sessionManagerWithInvalidUrl.authenticateSession(
          sessionToken: 'valid-session-token',
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
