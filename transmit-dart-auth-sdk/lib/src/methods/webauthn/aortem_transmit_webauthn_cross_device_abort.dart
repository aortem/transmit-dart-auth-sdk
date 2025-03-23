import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_tranmit_webauth_exception.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmt_webauthn_endpoints.dart';
import 'package:transmit_dart_auth_sdk/src/models/aortem_transmit_webauthn_data.dart';

/// Handles WebAuthn cross-device authentication operations.
class WebAuthnService {
  /// API key for authenticating requests.
  final String apiKey;

  /// Base URL for the Transmit Security API.
  final String baseUrl;

  ///
  /// - [apiKey]: Required for API authentication.
  /// - [baseUrl]: The API's base URL.

  WebAuthnService({required this.baseUrl, required this.apiKey});

  /// **WebAuthn Cross Device Status Method**
  Future<WebAuthnStatusResponse> checkCrossDeviceStatus({
    required String userId,
    String? sessionToken,
  }) async {
    if (userId.isEmpty) {
      throw ArgumentError("User ID cannot be empty.");
    }

    final Uri url = Uri.parse("$baseUrl${WebAuthnEndpoints.crossDeviceStatus}");
    final Map<String, String> headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };
    final Map<String, String> queryParams = {'user_id': userId};
    if (sessionToken != null) {
      queryParams['session_token'] = sessionToken;
    }

    final response = await http.get(
      url.replace(queryParameters: queryParams),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return WebAuthnStatusResponse.fromJson(json.decode(response.body));
    } else {
      throw WebAuthnException("Failed to get status: ${response.body}");
    }
  }

  /// **WebAuthn Cross Device Abort Method**
  Future<WebAuthnAbortResponse> abortCrossDeviceOperation({
    required String userId,
    String? sessionToken,
  }) async {
    if (userId.isEmpty) {
      throw ArgumentError("User ID cannot be empty.");
    }

    final Uri url = Uri.parse("$baseUrl${WebAuthnEndpoints.crossDeviceAbort}");
    final Map<String, String> headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> body = {'user_id': userId};
    if (sessionToken != null) {
      body['session_token'] = sessionToken;
    }

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return WebAuthnAbortResponse.fromJson(json.decode(response.body));
    } else {
      throw WebAuthnException("Failed to abort operation: ${response.body}");
    }
  }
}
