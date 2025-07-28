import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/sessions/aortem_transmit_get_user_sessions.dart';

import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'dart:convert';

// Mock HTTP Client using mocktail
class MockClient extends Mock implements http.Client {}

void main() {
  group('UserSessionManager - Get and Revoke User Sessions', () {
    const String testApiKey = 'test-api-key';
    const String testBaseUrl = 'https://api.transmitsecurity.com';
    const String testUserId = 'user_123';
    late AortemTransmitGetUserSessions sessionManager;
    late MockClient mockClient;

    setUp(() {
      sessionManager = AortemTransmitGetUserSessions(
        apiKey: testApiKey,
        baseUrl: testBaseUrl,
      );
      mockClient = MockClient();
    });

    test('throws ArgumentError if userId is empty (getUserSessions)', () {
      expect(
        () => sessionManager.getUserSessions(userId: ''),
        throwsArgumentError,
      );
    });

    test(
      'returns list of active sessions when API call is successful (getUserSessions)',
      () async {
        final mockResponse = jsonEncode([
          {
            'sessionId': 'abc123',
            'device': 'iPhone 14',
            'ipAddress': '192.168.1.1',
            'lastActive': '2025-03-14T12:00:00Z',
          },
        ]);

        when(
          () => mockClient.get(
            Uri.parse('$testBaseUrl/getUserSessions?userId=$testUserId'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => http.Response(mockResponse, 200));

        final result = await sessionManager.mockGetUserSessions(
          userId: testUserId,
        );
        expect(result, isA<List<Map<String, dynamic>>>());
        expect(result.length, equals(1));
        expect(result.first['sessionId'], equals('abc123'));
      },
    );

    test('throws ArgumentError if userId is empty (revokeUserSessions)', () {
      expect(
        () => sessionManager.revokeUserSessions(userId: ''),
        throwsArgumentError,
      );
    });

    test(
      'returns success message when API call is successful (revokeUserSessions)',
      () async {
        final mockResponse = jsonEncode({
          'success': true,
          'message': 'User sessions revoked successfully.',
          'revokedSessions': 3,
          'timestamp': '2025-03-14T12:00:00Z',
        });

        when(
          () => mockClient.post(
            Uri.parse('$testBaseUrl/revokeUserSessions'),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) async => http.Response(mockResponse, 200));

        final result = await sessionManager.mockRevokeUserSessions(
          userId: testUserId,
        );
        expect(result['success'], equals(true));
        expect(result['revokedSessions'], equals(3));
      },
    );
  });
}
