import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for revoking Time-based One-Time Password (TOTP) authenticators
/// registered with Transmit Security's API.
///
/// This class handles the revocation of existing TOTP authenticators for users,
/// effectively disabling TOTP authentication for the specified user.
///
/// ## Features
/// - Revokes existing TOTP registrations
/// - Requires administrative privileges (via API key)
/// - Returns standardized success/failure responses
/// - Supports dependency injection for testing
///
/// ## Example Usage
/// ```dart
/// final totpRevoker = AortemTransmitRevokeTOTP(
///   apiKey: 'your-admin-api-key',
///   baseUrl: 'https://api.transmitsecurity.com',
/// );
///
/// try {
///   final result = await totpRevoker.revokeTOTP(userId: 'user_12345');
///   print(result['message']); // "TOTP revoked successfully"
/// } catch (e) {
///   print('Failed to revoke TOTP: $e');
/// }
/// ```
class AortemTransmitRevokeTOTP {
  /// The administrative API key used for authentication
  final String apiKey;

  /// The base URL for the TOTP revocation API endpoint
  final String baseUrl;

  /// The HTTP client used for making requests
  final http.Client _client;

  /// Creates a TOTP revocation service instance
  ///
  /// ## Parameters
  /// - [apiKey]: Required administrative API key
  /// - [baseUrl]: Required base URL for the API endpoint
  /// - [client]: Optional HTTP client (uses default if not provided)
  AortemTransmitRevokeTOTP({
    required this.apiKey,
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  /// Revokes a user's registered TOTP authenticator
  ///
  /// This method permanently disables TOTP authentication for the specified user.
  /// Requires administrative privileges.
  ///
  /// ## Parameters
  /// - [userId]: The unique identifier of the user whose TOTP should be revoked
  ///   (must not be empty)
  ///
  /// ## Returns
  /// A [Future] that resolves to a [Map] containing:
  /// - `status`: "success" on successful revocation
  /// - `message`: Human-readable status message
  /// - `timestamp`: ISO-8601 timestamp of revocation
  ///
  /// ## Throws
  /// - [ArgumentError] if userId is empty
  /// - [Exception] if revocation fails (contains status code and error details)
  Future<Map<String, dynamic>> revokeTOTP({required String userId}) async {
    if (userId.isEmpty) {
      throw ArgumentError('userId cannot be empty');
    }

    final url = Uri.parse('$baseUrl/v1/users/$userId/totp/revoke');

    final response = await _client.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 204) {
      return {
        'status': 'success',
        'message': 'TOTP revoked successfully',
        'timestamp': DateTime.now().toIso8601String(),
      };
    } else {
      throw Exception(
        'Failed to revoke TOTP (Status: ${response.statusCode}) - ${response.body}',
      );
    }
  }
}
