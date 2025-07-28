enum TransmitRegion { global, eu, ca, au, sandbox }

extension TransmitRegionExtension on TransmitRegion {
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
}
