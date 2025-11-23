import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for deleting registered mobile biometric authenticators from Transmit Security's API.
///
/// This class handles the secure removal of previously registered biometric authenticators,
/// revoking their ability to authenticate and removing associated cryptographic keys.
///
/// ## Security Considerations
/// - Requires valid API credentials
/// - Performs sensitive security operations
/// - Should be used with HTTPS only
/// - Log all deletion operations for audit purposes
/// - Consider multi-factor authentication for this operation
///
/// ## Deletion Flow
/// 1. System identifies biometric authenticator to revoke
/// 2. Service verifies authorization to delete
/// 3. Cryptographic key material is securely removed
/// 4. Confirmation is returned upon successful deletion
///
/// ## Example Usage
/// ```dart
/// final biometricDeletion = AortemTransmitMobileBiometricsDeletion(
///   apiKey: 'your-api-key',
///   baseUrl: 'https://api.transmitsecurity.com',
/// );
///
/// try {
///   final result = await biometricDeletion.deleteMobileBiometrics(
///     publicKeyId: 'key_123',
///   );
///   print('Deletion successful at ${result['deletedAt']}');
/// } catch (e) {
///   print('Deletion failed: $e');
/// }
/// ```
class AortemTransmitMobileBiometricsDeletion {
  /// The API key used for service authentication
  final String apiKey;

  /// The base URL for the biometric deletion API endpoint
  final String baseUrl;

  /// Creates a biometric deletion service instance
  ///
  /// [apiKey]: Required API key for service authentication
  /// [baseUrl]: Required base URL for the API endpoint
  AortemTransmitMobileBiometricsDeletion({
    required this.apiKey,
    required this.baseUrl,
  });

  /// Deletes a registered mobile biometric authenticator
  ///
  /// Parameters:
  /// [publicKeyId]: The unique identifier of the biometric key to delete (required)
  ///
  /// Returns:
  /// A [Future] that resolves to a Map containing:
  /// - `success`: Operation status boolean
  /// - `message`: Human-readable result message
  /// - `deletedAt`: ISO-8601 timestamp of deletion
  /// - Additional service-specific metadata
  ///
  /// Throws:
  /// - [ArgumentError] if publicKeyId is empty
  /// - [Exception] if deletion fails (contains status code and error details)
  Future<Map<String, dynamic>> deleteMobileBiometrics({
    required String publicKeyId,
  }) async {
    if (publicKeyId.isEmpty) {
      throw ArgumentError('publicKeyId must not be empty');
    }

    try {
      final url = Uri.parse('$baseUrl/v1/auth/biometrics/native/delete');

      final headers = {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'X-Request-ID': DateTime.now().millisecondsSinceEpoch.toString(),
        'X-Operation-Type': 'biometric_deletion',
      };

      final body = {'publicKeyId': publicKeyId};

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 204) {
        return {
          'success': true,
          'message': 'Mobile biometrics deleted successfully',
          'deletedAt': DateTime.now().toIso8601String(),
          'publicKeyId': publicKeyId,
        };
      } else {
        throw _createDeletionException(response);
      }
    } on FormatException catch (e) {
      throw Exception('Failed to parse deletion response: ${e.message}');
    } on http.ClientException catch (e) {
      throw Exception('Network error during biometric deletion: ${e.message}');
    }
  }

  /// Mock implementation for testing biometric deletion
  ///
  /// Simulates successful deletion without making API calls.
  Future<Map<String, dynamic>> mockDeleteMobileBiometrics({
    required String publicKeyId,
  }) async {
    if (publicKeyId.isEmpty) {
      throw ArgumentError('publicKeyId must not be empty');
    }

    await Future.delayed(
      const Duration(milliseconds: 150),
    ); // Simulate network delay

    return {
      'success': true,
      'message': 'Mock: Mobile biometrics deleted successfully',
      'deletedAt': DateTime.now().toIso8601String(),
      'publicKeyId': publicKeyId,
      'mock': true,
    };
  }

  /// Creates a detailed exception from deletion failures
  Exception _createDeletionException(http.Response response) {
    try {
      final error = jsonDecode(response.body) as Map<String, dynamic>;
      final statusCode = response.statusCode;
      final errorCode = error['error'] ?? 'deletion_failed';
      final description =
          error['error_description'] ?? 'No description provided';

      switch (statusCode) {
        case 400:
          return Exception(
            'Invalid deletion request: $description (code: $errorCode)',
          );
        case 401:
          return Exception('Unauthorized deletion attempt (code: $errorCode)');
        case 403:
          return Exception('Deletion not permitted (code: $errorCode)');
        case 404:
          return Exception('Biometric key not found (code: $errorCode)');
        default:
          return Exception(
            'Deletion error ($statusCode): $description (code: $errorCode)',
          );
      }
    } on FormatException {
      return Exception(
        'Deletion failed (${response.statusCode}): ${response.body}',
      );
    }
  }
}
