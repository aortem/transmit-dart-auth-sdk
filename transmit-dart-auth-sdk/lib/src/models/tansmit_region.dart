/// Enumerates the available regional endpoints for the Transmit Security API.
///
/// This enum provides type-safe access to all supported API regions,
/// ensuring correct endpoint configuration for global deployments.
///
/// Regional considerations:
/// - Choose the region closest to your user base for best performance
/// - Data residency requirements may dictate region selection
/// - All regions offer the same API capabilities
///
/// Example usage:
/// ```dart
/// final region = TransmitRegion.eu;
/// print(region.host); // "api.eu.transmitsecurity.io"
/// ```
enum TransmitRegion {
  /// Global endpoint (default) - routes to nearest available region
  global,

  /// European Union endpoint - for EU data residency
  eu,

  /// Canada endpoint - for Canadian data residency
  ca,

  /// Australia endpoint - for APAC optimized access
  au,

  /// Sandbox endpoint - for testing and development
  sandbox,
}

/// Provides extensions for the [TransmitRegion] enum to access region-specific properties.
extension TransmitRegionExtension on TransmitRegion {
  /// Gets the base hostname for the API endpoint in the selected region.
  ///
  /// This returns the fully qualified domain name that should be used as the base
  /// for all API requests in the specified region.
  ///
  /// Example:
  /// ```dart
  /// final host = TransmitRegion.global.host;
  /// // "api.transmitsecurity.io"
  /// ```
  String get host {
    switch (this) {
      case TransmitRegion.global:
        return "api.transmitsecurity.io";
      case TransmitRegion.eu:
        return "api.eu.transmitsecurity.io";
      case TransmitRegion.ca:
        return "api.ca.transmitsecurity.io";
      case TransmitRegion.au:
        return "api.au.transmitsecurity.io";
      case TransmitRegion.sandbox:
        return "api.sbx.transmitsecurity.io";
    }
  }

  /// Gets the human-readable name of the region.
  ///
  /// Useful for display purposes in UI or logs.
  ///
  /// Example:
  /// ```dart
  /// print(TransmitRegion.sandbox.displayName); // "Sandbox"
  /// ```
  String get displayName {
    switch (this) {
      case TransmitRegion.global:
        return "Global";
      case TransmitRegion.eu:
        return "European Union";
      case TransmitRegion.ca:
        return "Canada";
      case TransmitRegion.au:
        return "Australia";
      case TransmitRegion.sandbox:
        return "Sandbox";
    }
  }

  /// Gets the base URL for API requests in this region.
  ///
  /// Returns the full HTTPS URL including protocol.
  ///
  /// Example:
  /// ```dart
  /// print(TransmitRegion.eu.baseUrl);
  /// // "https://api.eu.transmitsecurity.io"
  /// ```
  String get baseUrl => "https://$host";
}
