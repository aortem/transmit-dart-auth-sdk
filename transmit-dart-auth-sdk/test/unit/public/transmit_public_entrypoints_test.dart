import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/transmit_dart_auth_sdk.dart';

void main() {
  group('transmit_dart_auth_sdk public entrypoints', () {
    test('exports the central SDK and friendly aliases', () {
      final sdk = TransmitSDK.withApiKey(
        apiKey: 'test-api-key',
        serviceId: 'service-123',
      );
      final auth = TransmitAuth.withApiKey(
        apiKey: 'test-api-key',
        serviceId: 'service-123',
      );
      final client = TransmitClient.withApiKey(
        apiKey: 'test-api-key',
        serviceId: 'service-123',
      );

      expect(sdk, isA<TransmitSDK>());
      expect(auth, isA<TransmitSDK>());
      expect(client, isA<TransmitSDK>());
      expect(auth.authenticatePassword, isNotNull);
      expect(client.tokenManager, isNotNull);
    });
  });
}
