import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// Handles user authentication using native biometrics.
class MobileBiometricsAuth {
  /// The API endpoint for biometric authentication.
  static const String _endpoint =
      "https://api.transmitsecurity.com/authenticateMobileBiometrics";

  /// Authenticates a user using biometric data.
  ///
  /// This method sends a request to the Transmit Security API to authenticate
  /// a user based on their biometric data.
  ///
  /// - [userId]: The unique identifier of the user.
  /// - [biometricData]: A map containing the biometric data.
  /// - [apiKey]: The API key required for authorization.
  ///
  /// Returns a `Map<String, dynamic>` containing the authentication response.
  ///
  /// Throws:
  /// - `ArgumentError` if [userId] or [biometricData] is empty.
  /// - `Exception` if authentication fails.
  static Future<Map<String, dynamic>> authenticate({
    required String userId,
    required Map<String, dynamic> biometricData,
    required String apiKey,
  }) async {
    if (userId.isEmpty || biometricData.isEmpty) {
      throw ArgumentError("User ID and biometric data must be provided.");
    }

    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({"userId": userId, "biometricData": biometricData}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Biometric authentication failed: ${response.body}");
    }
  }

  /// Simulates biometric authentication for testing purposes.
  ///
  /// This mock method returns a sample authentication response without making
  /// an actual API request.
  ///
  /// Returns a `Map<String, dynamic>` containing mock authentication data.
  static Future<Map<String, dynamic>> mockAuthenticate() async {
    return {
      "accessToken": "mock_access_token",
      "idToken": "mock_id_token",
      "expiresIn": 3600,
    };
  }
}
