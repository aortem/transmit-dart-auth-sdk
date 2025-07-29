import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/core/transmit_sdk_initializer.dart';
import 'package:transmit_dart_auth_sdk/src/models/tansmit_region.dart';

void main() {
  group('TransmitAuthConfig', () {
    test('constructor initializes values correctly', () {
      final config = TransmitAuthConfig(
        apiKey: 'test-api-key',
        serviceId: 'service123',
        region: TransmitRegion.global,
      );

      expect(config.apiKey, 'test-api-key');
      expect(config.serviceId, 'service123');
      expect(config.region, TransmitRegion.global);
    });

    test('baseUrl is computed correctly', () {
      final config = TransmitAuthConfig(
        apiKey: 'key',
        serviceId: 'service123',
        region: TransmitRegion
            .eu, // Assume TransmitRegion.eu.host = "eu.api.transmitsecurity.com"
      );

      expect(config.baseUrl, 'https://${TransmitRegion.eu.host}/service123/v1');
    });

    test('createClient returns ApiClient with correct properties', () {
      final config = TransmitAuthConfig(
        apiKey: 'test-key',
        serviceId: 'my-service',
      );

      final client = config.createClient();

      expect(client.baseUrl, config.baseUrl);
      expect(client.apiKey, config.apiKey);
    });
  });
}
