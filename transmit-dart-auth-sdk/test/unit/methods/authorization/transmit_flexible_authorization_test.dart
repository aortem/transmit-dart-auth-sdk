import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/authorization/transmit_flexible_authorization.dart';

void main() {
  group('AortemTransmitAuthorization', () {
    late AortemTransmitAuthorization service;

    setUp(() {
      service = AortemTransmitAuthorization(apiKey: 'dummy-key');
    });

    test('mockAuthorize returns mock authorization data', () async {
      final result = await service.mockAuthorize(
        'dummy-access-token',
        requiredScopes: ['read:profile'],
      );

      expect(result['success'], true);
      expect(result['valid'], true);
      expect(result['authorized'], true);
      expect(result['userId'], 'mock-user-12345');
      expect(result['grantedScopes'], ['read:profile']);
      expect(result['expiresAt'], isNotNull);
    });

    test('throws error when access token is empty', () {
      expect(() => service.mockAuthorize(''), throwsA(isA<ArgumentError>()));
    });
  });
}
