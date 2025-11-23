import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for authenticating transaction signing with Time-based One-Time Password (TOTP)
/// through the Transmit Security API.
///
/// This class handles the verification step of a transaction signing flow,
/// where a user provides a TOTP code to authorize a transaction.
///
/// ## Features
/// - Verifies TOTP codes for transaction authorization
/// - Supports multiple identifier types (email, phone, etc.)
/// - Allows customization with optional parameters
/// - Validates all required input parameters
///
/// ## Example Usage
/// ```dart
/// final authService = AortemTransmitAuthenticateTransactionTOTP(
///   apiKey: 'your-api-key',
///   baseUrl: 'https://api.transmitsecurity.com',
/// );
///
/// try {
///   final result = await authService(
///     token: 'user-totp-code-123456',
///     identifier: 'user@example.com',
///   );
///   print('Transaction authorized: ${result['status']}');
/// } catch (e) {
///   print('Transaction authorization failed: $e');
/// }
/// ```
class AortemTransmitAuthenticateTransactionTOTP {
  /// The API key used for authenticating with Transmit Security's services
  final String apiKey;

  /// The base URL for the transaction authentication API endpoint
  final String baseUrl;

  /// Creates a transaction authentication service instance
  ///
  /// ## Parameters
  /// - [apiKey]: Required API key for authentication
  /// - [baseUrl]: Required base URL for the API endpoint
  AortemTransmitAuthenticateTransactionTOTP({
    required this.apiKey,
    required this.baseUrl,
  });

  /// Authenticates a transaction using a TOTP code
  ///
  /// This method verifies the provided TOTP code to authorize a previously
  /// initiated transaction signing flow.
  ///
  /// ## Required Parameters
  /// - [token]: The TOTP code provided by the user
  /// - [identifier]: User's unique identifier (email, phone number, etc.)
  ///
  /// ## Optional Parameters
  /// - [identifierType]: Type of identifier (defaults to 'email')
  /// - [resource]: Audience for the transaction
  /// - [claims]: Additional claims to include
  /// - [orgId]: Organization identifier
  /// - [clientAttributes]: Client-specific attributes
  /// - [sessionId]: Existing session identifier
  ///
  /// ## Returns
  /// A [Future] that resolves to a [Map] containing:
  /// - status: The transaction authorization status
  /// - transaction_id: The transaction identifier
  /// - user_id: The authenticated user identifier
  /// - Other transaction-specific metadata
  ///
  /// ## Throws
  /// - [ArgumentError] if required parameters are empty
  /// - [Exception] if the API request fails (contains status code and error details)
  Future<Map<String, dynamic>> call({
    required String token,
    required String identifier,
    String identifierType = "email",
    String? resource,
    Map<String, dynamic>? claims,
    String? orgId,
    Map<String, dynamic>? clientAttributes,
    String? sessionId,
  }) async {
    if (token.isEmpty || identifier.isEmpty) {
      throw ArgumentError("token and identifier cannot be empty");
    }

    final url = Uri.parse('$baseUrl/v1/auth/totp/transaction/authenticate');

    final body = {
      "token": token,
      "identifier": identifier,
      "identifier_type": identifierType,
      if (resource != null) "resource": resource,
      if (claims != null) "claims": claims,
      if (orgId != null) "org_id": orgId,
      if (clientAttributes != null) "client_attributes": clientAttributes,
      if (sessionId != null) "session_id": sessionId,
    };

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        "Failed to authenticate transaction signing TOTP: ${response.statusCode} ${response.body}",
      );
    }
  }
}
