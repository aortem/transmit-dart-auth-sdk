import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_errors.dart';

void main() {
  group('ApiException', () {
    test('should store and return correct message and status code', () {
      final exception = ApiException('Invalid API Key', 401);

      expect(exception.message, equals('Invalid API Key'));
      expect(exception.statusCode, equals(401));
    });

    test('should return correct string representation', () {
      final exception = ApiException('Server error', 500);

      expect(
        exception.toString(),
        equals('ApiException: Server error (Status Code: 500)'),
      );
    });

    test('should handle missing status code gracefully', () {
      final exception = ApiException('Unknown error');

      expect(
        exception.toString(),
        equals('ApiException: Unknown error (Status Code: Unknown)'),
      );
    });
  });
}
