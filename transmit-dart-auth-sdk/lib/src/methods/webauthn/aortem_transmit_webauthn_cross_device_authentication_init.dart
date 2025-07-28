import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for initializing WebAuthn cross-device authentication flows.
///
/// This class handles the first step of cross-device WebAuthn authentication,
/// generating the necessary challenge and configuration that will be used
/// by authenticator devices.
///
/// ## Security Considerations
/// - Requires valid API credentials
/// - Generates time-sensitive challenges
/// - Should be used with HTTPS only
/// - Implements proper request validation
///
/// ## Authentication Flow
/// 1. Client calls initAuthentication() to get challenge and options
/// 2. User scans QR code or enters code on secondary device
/// 3. Secondary device completes authentication ceremony
/// 4. Client polls for completion status
///
/// ## Example Usage
/// ```dart
/// final authService = AortemTransmitWebAuthnCrossDeviceAuthenticationInit(
///   apiKey: 'your-api-key',
///   baseUrl: 'https://api.transmitsecurity.com',
/// );
///
/// try {
///   final initData = await authService.initAuthentication(
///     clientId: 'your-client-id',
///     username: 'user@example.com',
///   );
///   print('Authentication ticket: ${initData['cross_device_ticket_id']}');
/// } catch (e) {
///   print('Initialization failed: $e');
/// }
/// ```
class AortemTransmitWebAuthnCrossDeviceAuthenticationInit {
  /// The API key used for authentication
  final String apiKey;

  /// The base URL for the authentication API endpoint
  final String baseUrl;

  /// Creates a cross-device authentication service instance
  ///
  /// [apiKey]: Required API key for authentication
  /// [baseUrl]: Required base URL for the API endpoint
  AortemTransmitWebAuthnCrossDeviceAuthenticationInit({
    required this.apiKey,
    required this.baseUrl,
  });

  /// Initializes a cross-device WebAuthn authentication flow
  ///
  /// Parameters:
  /// [clientId]: Application client identifier (required)
  /// [username]: Optional user identifier for contextual authentication
  /// [approvalData]: Optional transaction details for conditional UI
  ///
  /// Returns:
  /// A [Future] that resolves to a Map containing:
  /// - `cross_device_ticket_id`: Unique identifier for this authentication flow
  /// - `challenge`: Cryptographic challenge string
  /// - `timeout`: Duration in milliseconds until challenge expires
  /// - `allowCredentials`: List of allowed credential descriptors
  /// - Additional WebAuthn options
  ///
  /// Throws:
  /// - [ArgumentError] if clientId is empty
  /// - [Exception] if initialization fails (contains status code and error details)
  Future<Map<String, dynamic>> initAuthentication({
    required String clientId,
    String? username,
    Map<String, dynamic>? approvalData,
  }) async {
    if (clientId.isEmpty) {
      throw ArgumentError('clientId must not be empty');
    }

    try {
      final url = Uri.parse(
        '$baseUrl/v1/auth/webauthn/cross-device/authentication/init',
      );

      final headers = {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'X-Request-ID': DateTime.now().millisecondsSinceEpoch.toString(),
      };

      final body = <String, dynamic>{
        'client_id': clientId,
        if (username != null && username.isNotEmpty) 'username': username,
        if (approvalData != null && approvalData.isNotEmpty)
          'approval_data': approvalData,
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw _createInitException(response);
      }
    } on FormatException catch (e) {
      throw Exception('Failed to parse initialization response: ${e.message}');
    } on http.ClientException catch (e) {
      throw Exception('Network error during initialization: ${e.message}');
    }
  }

  /// Mock implementation for testing cross-device authentication initialization
  ///
  /// Simulates successful initialization without making API calls.
  Future<Map<String, dynamic>> mockInitAuthentication({
    required String clientId,
    String? username,
    Map<String, dynamic>? approvalData,
  }) async {
    if (clientId.isEmpty) {
      throw ArgumentError('clientId must not be empty');
    }

    await Future.delayed(
      const Duration(milliseconds: 150),
    ); // Simulate network delay

    return {
      'cross_device_ticket_id':
          'mock-ticket-${DateTime.now().millisecondsSinceEpoch}',
      'challenge': 'mock-challenge-${clientId.hashCode}',
      'timeout': 60000,
      'allowCredentials': [
        {
          'id': 'cred-${username?.hashCode ?? 'mock'}',
          'type': 'public-key',
          'transports': ['internal', 'hybrid'],
        },
      ],
      'rpId': 'mock.example.com',
      'userVerification': 'required',
      'mock': true,
    };
  }

  /// Creates a detailed exception from initialization failures
  Exception _createInitException(http.Response response) {
    try {
      final error = jsonDecode(response.body) as Map<String, dynamic>;
      final statusCode = response.statusCode;
      final errorCode = error['error'] ?? 'initialization_failed';
      final description =
          error['error_description'] ?? 'No description provided';

      switch (statusCode) {
        case 400:
          return Exception(
            'Invalid initialization request: $description (code: $errorCode)',
          );
        case 401:
          return Exception(
            'Unauthorized initialization attempt (code: $errorCode)',
          );
        case 404:
          return Exception('Client or user not found (code: $errorCode)');
        case 409:
          return Exception(
            'Existing authentication in progress (code: $errorCode)',
          );
        default:
          return Exception(
            'Initialization error ($statusCode): $description (code: $errorCode)',
          );
      }
    } on FormatException {
      return Exception(
        'Initialization failed (${response.statusCode}): ${response.body}',
      );
    }
  }
}
