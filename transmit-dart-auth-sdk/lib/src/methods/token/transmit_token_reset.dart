import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service class for handling password resets via Transmit Security.
class AortemTransmitTokenReset {
  /// The API key required for authentication with Transmit Security.
  final String apiKey;

  /// The base URL of the Transmit Security API.
  ///
  /// Defaults to `'https://api.transmitsecurity.com'`.
  final String baseUrl;

  /// Creates an instance of [AortemTransmitTokenReset].
  ///
  /// - Requires a non-empty [apiKey].
  /// - Optionally accepts a custom [baseUrl] for API calls.
  ///
  /// Throws an [ArgumentError] if [apiKey] is empty.
  AortemTransmitTokenReset({
    required this.apiKey,
    this.baseUrl = 'https://api.transmitsecurity.com',
  }) {
    if (apiKey.isEmpty) {
      throw ArgumentError('API key cannot be empty.');
    }
  }

  /// Resets the user's password using the provided [resetToken] and [newPassword].
  ///
  /// This method sends a request to the Transmit Security API to reset the password.
  ///
  /// Returns a `Map<String, dynamic>` containing:
  /// - `resetToken`: The provided reset token.
  /// - `status`: The result of the reset attempt (`password_reset_successful`).
  /// - `message`: A confirmation message.
  ///
  /// Throws:
  /// - [ArgumentError] if [resetToken] or [newPassword] is empty.
  /// - [Exception] if the API request fails with a non-200 status code.
  Future<Map<String, dynamic>> resetPassword(
    String resetToken,
    String newPassword,
  ) async {
    if (resetToken.isEmpty || newPassword.isEmpty) {
      throw ArgumentError('Reset token and new password cannot be empty.');
    }

    // Construct the API endpoint for password reset.
    final url = Uri.parse('$baseUrl/token/reset');

    final body = {'resetToken': resetToken, 'newPassword': newPassword};

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
        'Password reset failed: ${response.statusCode} ${response.body}',
      );
    }
  }

  /// A stub implementation that simulates a password reset request.
  ///
  /// This method does not make an actual API request. Instead, it returns
  /// pre-defined mock data to mimic a valid response.
  ///
  /// Returns a `Map<String, dynamic>` containing:
  /// - `resetToken`: The provided reset token.
  /// - `status`: A status indicator (`password_reset_successful`).
  /// - `message`: A confirmation message.
  /// - `timestamp`: The timestamp of the reset attempt.
  ///
  /// Throws:
  /// - [ArgumentError] if [resetToken] or [newPassword] is empty.
  Future<Map<String, dynamic>> resetPasswordStub(
    String resetToken,
    String newPassword,
  ) async {
    if (resetToken.isEmpty || newPassword.isEmpty) {
      throw ArgumentError('Reset token and new password cannot be empty.');
    }

    // Simulate network latency.
    await Future.delayed(Duration(milliseconds: 100));

    // Return mock reset confirmation data.
    return {
      'resetToken': resetToken,
      'status': 'password_reset_successful',
      'message': 'Password has been reset successfully (stub).',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
