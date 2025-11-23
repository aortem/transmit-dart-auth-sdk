import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

/// A service for initiating TOTP-based transaction signing flows with Transmit Security's API.
///
/// This class handles the initial request to start a transaction signing process
/// that will require TOTP verification from the user, typically for high-value
/// or sensitive transactions.
///
/// ## Security Considerations
/// - Requires valid API credentials
/// - Handles sensitive transaction data
/// - Should be used with HTTPS only
/// - Implements proper request validation
/// - Log all transaction attempts for audit purposes
///
/// ## Transaction Flow
/// 1. Client initiates transaction with required details
/// 2. Service generates TOTP verification request
/// 3. User verifies with TOTP code
/// 4. Transaction is completed upon successful verification
///
/// ## Example Usage
/// ```dart
/// final transactionService = AortemTransmitStartTransactionTOTP(
///   apiKey: 'your-api-key',
///   baseUrl: 'https://api.transmitsecurity.com',
/// );
///
/// try {
///   final result = await transactionService.startTransactionSigningTOTP(
///     identifier: 'user@example.com',
///     identifierType: 'email',
///     approvalData: {
///       'transaction_id': 'txn_12345',
///       'amount': 100.00,
///       'description': 'Funds transfer',
///     },
///   );
///   print('Transaction initiated: ${result['transaction_id']}');
/// } catch (e) {
///   print('Transaction initiation failed: $e');
/// }
/// ```
class AortemTransmitStartTransactionTOTP {
  /// The API key used for authentication
  final String apiKey;

  /// The base URL for the transaction API endpoint
  final String baseUrl;

  /// The HTTP client used for making requests
  final http.Client httpClient;

  /// Creates a transaction signing service instance
  ///
  /// [apiKey]: Required API key for authentication
  /// [baseUrl]: Required base URL for the API endpoint
  /// [httpClient]: Optional HTTP client for testing or customization
  AortemTransmitStartTransactionTOTP({
    required this.apiKey,
    required this.baseUrl,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  /// Initiates a transaction signing flow requiring TOTP verification
  ///
  /// Parameters:
  /// [identifier]: User's unique identifier (required)
  /// [identifierType]: Type of identifier ('email', 'phone_number', etc.) (required)
  /// [approvalData]: Transaction details including:
  ///   - transaction_id: Unique transaction identifier
  ///   - amount: Transaction amount
  ///   - description: Transaction description
  ///   - Any other relevant transaction metadata (required)
  /// [resource]: Optional audience for the transaction
  /// [claims]: Additional claims to include
  /// [orgId]: Organization identifier
  /// [clientAttributes]: Client-specific attributes
  /// [sessionId]: Existing session identifier
  ///
  /// Returns:
  /// A [Future] that resolves to a Map containing:
  /// - transaction_id: The transaction identifier
  /// - status: Current transaction status
  /// - verification_required: Boolean indicating if TOTP verification is needed
  /// - Other transaction-specific metadata
  ///
  /// Throws:
  /// - [ArgumentError] if any required parameters are empty
  /// - [Exception] if API request fails (contains status code and error details)
  Future<Map<String, dynamic>> startTransactionSigningTOTP({
    required String identifier,
    required String identifierType,
    required Map<String, dynamic> approvalData,
    String? resource,
    Map<String, dynamic>? claims,
    String? orgId,
    Map<String, dynamic>? clientAttributes,
    String? sessionId,
  }) async {
    // Validate input parameters
    if (identifier.isEmpty) {
      throw ArgumentError('Identifier cannot be empty');
    }
    if (identifierType.isEmpty) {
      throw ArgumentError('Identifier type cannot be empty');
    }
    if (approvalData.isEmpty) {
      throw ArgumentError('Approval data cannot be empty');
    }

    try {
      final url = Uri.parse('$baseUrl/v1/auth/totp/transaction/start');

      final headers = {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'X-Request-ID': DateTime.now().millisecondsSinceEpoch.toString(),
      };

      final body = {
        "resource": resource,
        "claims": claims,
        "org_id": orgId,
        "client_attributes": clientAttributes,
        "session_id": sessionId,
        "approval_data": approvalData,
        "identifier_type": identifierType,
        "identifier": identifier,
      }..removeWhere((key, value) => value == null);

      final response = await httpClient.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw _createTransactionException(response);
      }
    } on FormatException catch (e) {
      throw Exception('Failed to parse transaction response: ${e.message}');
    } on http.ClientException catch (e) {
      throw Exception(
        'Network error during transaction initiation: ${e.message}',
      );
    }
  }

  /// Creates a detailed exception from transaction failures
  Exception _createTransactionException(http.Response response) {
    try {
      final error = jsonDecode(response.body) as Map<String, dynamic>;
      final statusCode = response.statusCode;
      final errorCode = error['error'] ?? 'transaction_initiation_failed';
      final description =
          error['error_description'] ?? 'No description provided';

      switch (statusCode) {
        case 400:
          return Exception(
            'Invalid transaction request: $description (code: $errorCode)',
          );
        case 401:
          return Exception(
            'Unauthorized transaction attempt (code: $errorCode)',
          );
        case 403:
          return Exception('Transaction not permitted (code: $errorCode)');
        case 429:
          return Exception('Too many transaction attempts (code: $errorCode)');
        default:
          return Exception(
            'Transaction error ($statusCode): $description (code: $errorCode)',
          );
      }
    } on FormatException {
      return Exception(
        'Transaction failed (${response.statusCode}): ${response.body}',
      );
    }
  }
}
