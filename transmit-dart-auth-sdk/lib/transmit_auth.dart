import 'src/models/tansmit_region.dart';
import 'src/transmit_sdk.dart';

/// Clear public-facing SDK entry point that mirrors [TransmitSDK].
final class TransmitAuth extends TransmitSDK {
  /// Creates a [TransmitAuth] instance using API key authentication.
  TransmitAuth.withApiKey({
    required super.apiKey,
    required super.serviceId,
    super.region = TransmitRegion.global,
    super.client,
  }) : super.withApiKey();

  /// Creates a [TransmitAuth] instance from a prebuilt configuration object.
  TransmitAuth.fromConfig({
    required super.config,
    super.client,
  }) : super.fromConfig();
}

/// Alternative naming alias for consumers that prefer a client-oriented entry point.
final class TransmitClient extends TransmitSDK {
  /// Creates a [TransmitClient] instance using API key authentication.
  TransmitClient.withApiKey({
    required super.apiKey,
    required super.serviceId,
    super.region = TransmitRegion.global,
    super.client,
  }) : super.withApiKey();

  /// Creates a [TransmitClient] instance from a prebuilt configuration object.
  TransmitClient.fromConfig({
    required super.config,
    super.client,
  }) : super.fromConfig();
}
