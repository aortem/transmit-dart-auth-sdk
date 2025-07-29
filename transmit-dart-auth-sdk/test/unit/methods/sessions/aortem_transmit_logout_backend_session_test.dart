import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/sessions/aortem_transmit_logout_backend_session.dart';

void main() {
  group('AortemTransmitLogoutBackendSession (Mock)', () {
    late AortemTransmitLogoutBackendSession service;

    setUp(() {
      service = AortemTransmitLogoutBackendSession(
        apiKey: 'dummy-api-key',
        baseUrl: 'https://api.example.com',
      );
    });

    test('mockLogoutBackendSession returns success response', () async {
      final result = await service.mockLogoutBackendSession(
        sessionToken: 'abc123token',
      );

      expect(result['success'], isTrue);
      expect(result['message'], contains('logged out'));
      expect(result['logoutTimestamp'], isA<String>());
      expect(result['session_id'], contains('mock-session-'));
    });

    test('mockLogoutBackendSession throws ArgumentError for empty token', () {
      expect(
        () => service.mockLogoutBackendSession(sessionToken: ''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
