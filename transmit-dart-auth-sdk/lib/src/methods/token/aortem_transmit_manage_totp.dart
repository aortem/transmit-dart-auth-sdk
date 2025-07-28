import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for administrative revocation of Time-based One-Time Password (TOTP)
/// enrollments through Transmit Security's management API.
///
/// This high-privilege operation allows system administrators to forcibly revoke
/// TOTP enrollments for users, typically for security or compliance reasons.
///
/// ## Security Considerations
/// - Requires elevated management API credentials
/// - Should be restricted to administrative interfaces
/// - Log all revocation operations for audit purposes
/// - Consider implementing multi-factor authentication for this operation
class AortemTransmitRevokeTOTPManagement {
  /// The management-level API key with elevated privileges
  final String apiKey;

  /// The base URL for the management API endpoint
  final String baseUrl;

  /// The HTTP client instance used for requests
  final http.Client _client;

  /// Creates a management-level TOTP revocation service instance
  ///
  /// [apiKey]: Management API key with elevated privileges (required)
  /// [baseUrl]: Base URL for the management API (required)
  /// [client]: Optional HTTP client for testing or customization
  AortemTransmitRevokeTOTPManagement({
    required this.apiKey,
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  /// Forcibly revokes a user's TOTP enrollment at management level
  ///
  /// This administrative operation immediately disables TOTP authentication
  /// for the specified user. Use with caution as this bypasses normal
  /// authentication flows.
  ///
  /// Parameters:
  /// [userId]: The unique identifier of the target user (required, non-empty)
  ///
  /// Returns:
  /// A [Future] that resolves to a response map containing:
  /// - Standard success message if response has no body
  /// - Full API response body when available
  ///
  /// Throws:
  /// - [ArgumentError] if userId is empty
  /// - [Exception] with detailed error message if revocation fails
  Future<Map<String, dynamic>> revoke({required String userId}) async {
    // Validate input parameters
    if (userId.isEmpty) {
      throw ArgumentError('User ID must not be empty');
    }

    try {
      final url = Uri.parse('$baseUrl/v1/users/$userId/totp/revoke-management');

      final response = await _client.post(
        url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
          'X-Request-ID': DateTime.now().millisecondsSinceEpoch.toString(),
        },
      );

      // Handle successful responses (200 OK or 204 No Content)
      if (response.statusCode == 200 || response.statusCode == 204) {
        return response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : {
                'status': 'success',
                'message': 'TOTP revoked successfully',
                'timestamp': DateTime.now().toIso8601String(),
              };
      }

      // Handle error responses
      final errorResponse = jsonDecode(response.body) as Map<String, dynamic>;
      throw _createManagementException(response.statusCode, errorResponse);
    } on FormatException catch (e) {
      throw Exception('Failed to parse API response: ${e.message}');
    } on http.ClientException catch (e) {
      throw Exception('Network error during TOTP revocation: ${e.message}');
    }
  }

  /// Creates a detailed exception for management API errors
  Exception _createManagementException(
    int statusCode,
    Map<String, dynamic> errorResponse,
  ) {
    final errorCode = errorResponse['code'] ?? 'unknown_error';
    final errorMessage =
        errorResponse['message'] ?? 'No error message provided';

    return Exception(
      'Management API error ($statusCode - $errorCode): $errorMessage',
    );
  }
}
