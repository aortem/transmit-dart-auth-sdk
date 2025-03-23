import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/authentication/aortem_transmit_authenticate_password.dart';

void main() {
  group('PasswordAuthManager Tests', () {
    final passwordManager = PasswordAuthManager(
      apiKey: 'test-api-key',
      baseUrl: 'https://api.example.com',
    );

    test(
      'Should throw ArgumentError if userIdentifier or password is empty',
      () async {
        expect(
          () => passwordManager.authenticatePassword(
            userIdentifier: '',
            password: 'test123',
          ),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => passwordManager.authenticatePassword(
            userIdentifier: 'user@example.com',
            password: '',
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );

    test('Should return a mock authentication response successfully', () async {
      final response = await passwordManager.mockAuthenticatePassword(
        userIdentifier: 'valid-user@example.com',
        password: 'validPassword',
      );
      expect(response['success'], true);
      expect(response.containsKey('userId'), true);
      expect(response['authTokens'].containsKey('accessToken'), true);
      expect(response['authTokens'].containsKey('refreshToken'), true);
    });

    test('Should handle API failure gracefully', () async {
      final passwordManagerWithInvalidUrl = PasswordAuthManager(
        apiKey: 'test-api-key',
        baseUrl:
            'https://invalid-api.example.com', // Invalid URL to simulate failure
      );

      expect(
        () async => await passwordManagerWithInvalidUrl.authenticatePassword(
          userIdentifier: 'valid-user@example.com',
          password: 'validPassword',
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
