/// An exception that represents API-related errors.
///
/// This exception is thrown when an API request fails or returns an error response.
///
/// Example usage:
/// ```dart
/// throw ApiException('Unauthorized access', 401);
/// ```
///
/// The [message] provides details about the error, and [statusCode] (if available)
/// indicates the HTTP status code of the response.
class ApiException implements Exception {
  /// The error message describing the API failure.
  final String message;

  /// The optional HTTP status code associated with the error.
  final int? statusCode;

  /// Creates an instance of [ApiException] with the given [message] and an optional [statusCode].
  ApiException(this.message, [this.statusCode]);

  @override
  String toString() {
    return 'ApiException: $message (Status Code: ${statusCode ?? 'Unknown'})';
  }
}
