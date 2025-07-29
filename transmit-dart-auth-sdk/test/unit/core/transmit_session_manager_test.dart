import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/core/transmit_session_manager.dart';

void main() {
  group('UserSessionManager (Mock Tests)', () {
    late UserSessionManager sessionManager;

    setUp(() {
      sessionManager = UserSessionManager(
        apiKey: 'test-api-key',
        baseUrl: 'https://api.example.com',
      );
    });

    test('mockGetUserSessions returns a list of sessions', () async {
      final result = await sessionManager.mockGetUserSessions(
        userId: 'user123',
      );

      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.length, greaterThan(0));

      // Check first session fields
      final session = result.first;
      expect(session.containsKey('session_id'), isTrue);
      expect(session.containsKey('device'), isTrue);
      expect(session.containsKey('ip_address'), isTrue);
      expect(session.containsKey('last_active'), isTrue);
    });

    test('mockGetUserSessions throws error for empty userId', () async {
      expect(
        () => sessionManager.mockGetUserSessions(userId: ''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('mockRevokeUserSessions returns success response', () async {
      final result = await sessionManager.mockRevokeUserSessions(
        userId: 'user123',
      );

      expect(result['success'], isTrue);
      expect(result['message'], contains('revoked'));
      expect(result['revoked_sessions'], greaterThan(0));
      expect(result['user_id'], equals('user123'));
    });

    test('mockRevokeUserSessions throws error for empty userId', () async {
      expect(
        () => sessionManager.mockRevokeUserSessions(userId: ''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
