import 'dart:convert';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:transmit_dart_auth_sdk/src/core/transmit_errors.dart';

/// A generic API client for making HTTP requests.
///
/// This client supports GET, POST, and DELETE requests with authentication.
class ApiClient {
  /// The base URL of the API.
  final String baseUrl;

  /// The API key used for authentication.
  final String apiKey;

  /// The HTTP client used for making requests.
  final http.Client httpClient;

  /// Creates an instance of [ApiClient].
  ///
  /// If no HTTP client is provided, a default client is used.
  ApiClient({required this.baseUrl, required this.apiKey, http.Client? client})
    : httpClient = client ?? http.Client();

  /// Sends a POST request to the specified [endpoint] with the given [body].
  Future<http.Response> post({
    required String endpoint,
    required String body,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await httpClient.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: body,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw ApiException(
          errorData['error'] ?? 'Unknown error',
          response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  /// Sends a GET request to the specified [endpoint].
  Future<http.Response> get({required String endpoint}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await httpClient.get(
        url,
        headers: {'Authorization': 'Bearer $apiKey'},
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw ApiException(
          errorData['error'] ?? 'Unknown error',
          response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  /// Sends a DELETE request to the specified [endpoint].
  Future<http.Response> delete({
    required String endpoint,
    String? body, // Optional body parameter
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final request = http.Request("DELETE", url)
        ..headers.addAll({'Authorization': 'Bearer $apiKey'})
        ..body = body ?? ''; // Only add body if provided

      final streamedResponse = await httpClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw ApiException(
          errorData['error'] ?? 'Unknown error',
          response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }
}
