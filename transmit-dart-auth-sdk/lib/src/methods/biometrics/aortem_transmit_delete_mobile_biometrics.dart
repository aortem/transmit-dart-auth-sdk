import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_api_client.dart';
import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_errors.dart';

/// Handles mobile biometrics deletion for authentication.
class MobileBiometricsDeletion {
  final ApiClient _apiClient;

  /// Deletes a user's registered biometric enrollment.
  MobileBiometricsDeletion(this._apiClient);

  ///
  /// - [userId]: Unique identifier for the user (e.g., email or user ID).
  /// - [biometricId]: Identifier of the biometric enrollment to be deleted.
  /// - [mock]: If `true`, returns a stub response for testing.
  ///
  /// Returns a structured response confirming the deletion.
  Future<Map<String, dynamic>> delete({
    required String userId,
    required String biometricId,
    bool mock = false,
  }) async {
    if (userId.isEmpty || biometricId.isEmpty) {
      throw ArgumentError('User ID and biometric ID must not be empty.');
    }

    // Mock implementation for local testing
    if (mock) {
      return {
        'status': 'success',
        'message': 'Biometric enrollment deleted (mock mode).',
        'userId': userId,
        'biometricId': biometricId,
        'deletedAt': DateTime.now().toIso8601String(),
      };
    }

    // Construct the request payload
    final Map<String, dynamic> payload = {
      'userId': userId,
      'biometricId': biometricId,
    };

    try {
      final http.Response response = await _apiClient.delete(
        endpoint: '/mobile-biometrics-deletion',
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ApiException('Failed to delete biometrics', response.statusCode);
      }
    } catch (e) {
      throw ApiException('Unexpected error during biometrics deletion: $e');
    }
  }
}
