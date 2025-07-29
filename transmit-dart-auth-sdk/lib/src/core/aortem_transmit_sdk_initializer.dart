import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:transmit_dart_auth_sdk/src/models/tansmit_region.dart';

import 'transmit_api_client.dart';

/// Configuration class for Transmit Authentication Service.
///
/// This class holds the necessary configuration parameters to initialize
/// and communicate with the Transmit Authentication API.
///
/// Example:
/// ```dart
/// final config = TransmitAuthConfig(
///   apiKey: 'your-api-key',
///   serviceId: 'your-service-id',
///   region: TransmitRegion.global,
/// );
/// ```
class TransmitAuthConfig {
  /// The API key used for authenticating requests to the Transmit service.
  ///
  /// This key should be kept secure and not exposed in client-side code.
  final String apiKey;

  /// The unique identifier for your service within the Transmit platform.
  final String serviceId;

  /// The region where your Transmit service is hosted.
  ///
  /// Defaults to [TransmitRegion.global] if not specified.
  final TransmitRegion region;

  /// Creates a new [TransmitAuthConfig] instance.
  ///
  /// [apiKey]: Required API key for authentication
  /// [serviceId]: Required service identifier
  /// [region]: Optional region specification (defaults to global)
  const TransmitAuthConfig({
    required this.apiKey,
    required this.serviceId,
    this.region = TransmitRegion.global,
  });

  /// Computes the base URL for API requests based on the configured region and service ID.
  ///
  /// The URL follows the format: `https://{region-host}/{serviceId}/v1`
  ///
  /// Returns the fully constructed base URL as a String.
  String get baseUrl => "https://${region.host}/$serviceId/v1";

  /// Creates an [ApiClient] instance configured with this authentication setup.
  ///
  /// [client]: Optional custom HTTP client. If not provided, the default client
  ///           from the underlying HTTP package will be used.
  ///
  /// Returns a new [ApiClient] instance ready to make authenticated requests.
  ApiClient createClient({http.Client? client}) {
    return ApiClient(
      baseUrl: baseUrl, // ✅ FIX: Added baseUrl here
      apiKey: apiKey,
      client: client,
    );
  }
}
