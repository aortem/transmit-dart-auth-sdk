/// Defines API endpoint constants for WebAuthn cross-device authentication.
///
/// This class provides static constants for various WebAuthn-related API endpoints
/// used in the authentication process.
class WebAuthnEndpoints {
  /// Endpoint for retrieving the status of a WebAuthn cross-device authentication session.
  static const String crossDeviceStatus = "/webauthn-cross-device-status";

  /// Endpoint for aborting an ongoing WebAuthn cross-device authentication session.
  static const String crossDeviceAbort = "/webauthn-cross-device-abort";
}
