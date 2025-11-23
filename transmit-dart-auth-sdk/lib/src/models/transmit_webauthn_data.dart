/// Represents the response from a WebAuthn cross-device authentication status request.
///
/// This class holds information about the current status of an ongoing WebAuthn authentication session,
/// including an optional message and metadata.
///
/// Example usage:
/// ```dart
/// final response = WebAuthnStatusResponse.fromJson(apiResponse);
/// print(response.status);
/// ```
class WebAuthnStatusResponse {
  /// The status of the WebAuthn authentication session (e.g., "pending", "completed", "failed").
  final String status;

  /// An optional message providing additional details about the authentication status.
  final String? message;

  /// Additional metadata related to the authentication session, if available.
  final Map<String, dynamic>? metadata;

  /// Creates an instance of [WebAuthnStatusResponse].
  WebAuthnStatusResponse({required this.status, this.message, this.metadata});

  /// Creates an instance of [WebAuthnStatusResponse] from a JSON map.
  ///
  /// - [json]: A map containing the response data.
  ///
  /// Example:
  /// ```dart
  /// final response = WebAuthnStatusResponse.fromJson({
  ///   "status": "pending",
  ///   "message": "Authentication in progress",
  ///   "metadata": {"expiresIn": 300}
  /// });
  /// ```
  factory WebAuthnStatusResponse.fromJson(Map<String, dynamic> json) {
    return WebAuthnStatusResponse(
      status: json['status'],
      message: json['message'],
      metadata: json['metadata'],
    );
  }
}

/// Represents the response from a WebAuthn cross-device authentication abort request.
///
/// This class indicates whether an ongoing WebAuthn authentication session was successfully aborted
/// and provides an optional message with additional details.
///
/// Example usage:
/// ```dart
/// final response = WebAuthnAbortResponse.fromJson(apiResponse);
/// print(response.success);
/// ```
class WebAuthnAbortResponse {
  /// Indicates whether the WebAuthn authentication session was successfully aborted.
  final bool success;

  /// An optional message providing additional details about the abort request.
  final String? message;

  /// Creates an instance of [WebAuthnAbortResponse].
  WebAuthnAbortResponse({required this.success, this.message});

  /// Creates an instance of [WebAuthnAbortResponse] from a JSON map.
  ///
  /// - [json]: A map containing the response data.
  ///
  /// Example:
  /// ```dart
  /// final response = WebAuthnAbortResponse.fromJson({
  ///   "success": true,
  ///   "message": "Authentication session aborted successfully."
  /// });
  /// ```
  factory WebAuthnAbortResponse.fromJson(Map<String, dynamic> json) {
    return WebAuthnAbortResponse(
      success: json['success'] ?? false,
      message: json['message'],
    );
  }
}
