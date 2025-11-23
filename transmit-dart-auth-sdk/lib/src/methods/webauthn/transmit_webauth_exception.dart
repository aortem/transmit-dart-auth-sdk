/// Exception class for handling WebAuthn-related errors.
///
/// This class represents errors that occur during WebAuthn authentication processes.
class WebAuthnException implements Exception {
  /// Error message describing the exception.
  final String message;

  /// Creates a new [WebAuthnException] with the provided error [message].
  WebAuthnException(this.message);

  @override
  String toString() => "WebAuthnException: $message";
}
