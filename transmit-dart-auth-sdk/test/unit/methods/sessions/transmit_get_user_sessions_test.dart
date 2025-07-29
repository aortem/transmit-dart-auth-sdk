import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/sessions/transmit_get_user_sessions.dart';

void main() {
  group('AortemTransmitGetUserSessions (Mock)', () {
    late AortemTransmitGetUserSessions service;

    setUp(() {
      service = AortemTransmitGetUserSessions(
        apiKey: 'dummy-key',
        baseUrl: 'https://api.example.com',
      );
    });

    test('mockGetUserSessions returns a list of sessions', () async {
      final sessions = await service.mockGetUserSessions(userId: 'user_123');

      expect(sessions, isA<List<Map<String, dynamic>>>());
      expect(sessions.length, greaterThan(0));
      expect(sessions.first, contains('session_id'));
    });

    test('mockRevokeUserSessions returns success response', () async {
      final result = await service.mockRevokeUserSessions(userId: 'user_123');

      expect(result['success'], isTrue);
      expect(result['message'], contains('revoked'));
      expect(result['revoked_sessions'], isNonZero);
    });

    test('mock methods throw error if userId is empty', () {
      expect(
        () => service.mockGetUserSessions(userId: ''),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => service.mockRevokeUserSessions(userId: ''),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
