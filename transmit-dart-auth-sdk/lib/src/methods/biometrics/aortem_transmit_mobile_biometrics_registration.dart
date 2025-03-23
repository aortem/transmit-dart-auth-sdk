import 'dart:convert';
import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_api_client.dart';
import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_errors.dart';

/// Handles user registration for mobile biometrics authentication.
///
/// This class enables registering a user’s biometric data with the Transmit Security API.
class MobileBiometricsRegistration {
  /// API client instance for making HTTP requests.
  final ApiClient apiClient;

  /// Constructs an instance of [MobileBiometricsRegistration].
  ///
  /// - [apiClient]: The API client responsible for handling network requests.
  MobileBiometricsRegistration({required this.apiClient});

  /// Registers a user for mobile biometrics authentication.
  ///
  /// - [userId]: The unique identifier for the user (e.g., email or user ID).
  /// - [biometricData]: A JSON object containing biometric registration data.
  /// - [mock]: If `true`, returns a stub response for testing purposes.
  ///
  /// Returns a `Map<String, dynamic>` containing registration confirmation details.
  ///
  /// Throws:
  /// - `ArgumentError` if [userId] or [biometricData] is empty.
  /// - `ApiException` if the API request fails.
  Future<Map<String, dynamic>> register({
    required String userId,
    required Map<String, dynamic> biometricData,
    bool mock = false,
  }) async {
    if (userId.isEmpty) {
      throw ArgumentError('User ID must not be empty.');
    }

    if (biometricData.isEmpty) {
      throw ArgumentError('Biometric data must not be empty.');
    }

    if (mock) {
      return _mockResponse(userId);
    }

    final String endpoint = '/mobile-biometrics-registration';
    final String body = jsonEncode({
      'userId': userId,
      'biometricData': biometricData,
    });

    try {
      final response = await apiClient.post(endpoint: endpoint, body: body);
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw ApiException(
          responseData['error'] ?? 'Failed to register biometrics',
          response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException('Unexpected error during biometrics registration: $e');
    }
  }

  /// Generates a mock response for testing.
  ///
  /// Returns a `Map<String, dynamic>` with simulated biometric registration details.
  Map<String, dynamic> _mockResponse(String userId) {
    return {
      'status': 'success',
      'message': 'Biometric registration completed (mock mode).',
      'userId': userId,
      'registeredAt': DateTime.now().toIso8601String(),
    };
  }
}
