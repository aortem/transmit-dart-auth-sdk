import 'package:test/test.dart';
import 'package:transmit_dart_auth_sdk/src/methods/token/aortem_transmit_token_reset.dart';
// Adjust package import as needed

void main() {
  group('resetPassword (HTTP Request Approach) Tests', () {
    final transmitPasswordReset =
        AortemTransmitTokenReset(apiKey: 'valid-api-key');
    final resetToken = 'valid-reset-token';
    final newPassword = 'newSecurePassword123';

    test('throws error for empty reset token or new password', () {
      expect(() => transmitPasswordReset.resetPassword('', newPassword),
          throwsA(isA<ArgumentError>()));
      expect(() => transmitPasswordReset.resetPassword(resetToken, ''),
          throwsA(isA<ArgumentError>()));
    });
  });

  group('resetPasswordStub (Stub/Mock Implementation) Tests', () {
    final transmitPasswordReset =
        AortemTransmitTokenReset(apiKey: 'valid-api-key');
    final resetToken = 'valid-reset-token';
    final newPassword = 'newSecurePassword123';

    test('returns dummy reset confirmation for valid inputs', () async {
      final result = await transmitPasswordReset.resetPasswordStub(
          resetToken, newPassword);
      expect(result['status'], equals('password_reset_successful'));
      expect(result.containsKey('timestamp'), isTrue);
    });

    test('throws error for empty inputs (stub)', () {
      expect(() => transmitPasswordReset.resetPasswordStub('', newPassword),
          throwsA(isA<ArgumentError>()));
      expect(() => transmitPasswordReset.resetPasswordStub(resetToken, ''),
          throwsA(isA<ArgumentError>()));
    });
  });
}
