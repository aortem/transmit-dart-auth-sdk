import 'dart:convert';
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:http/http.dart' as http;
import 'package:ds_standard_features/ds_standard_features.dart' as http;

import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_api_client.dart';
import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_errors.dart';
import 'package:transmit_dart_auth_sdk/src/methods/biometrics/aortem_transmit_delete_mobile_biometrics.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MobileBiometricsDeletion biometricsDeletion;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    biometricsDeletion = MobileBiometricsDeletion(mockApiClient);
  });

  group('MobileBiometricsDeletion', () {
    const String userId = 'user@example.com';
    const String biometricId = 'fingerprint-12345';
    const String endpoint = '/mobile-biometrics-deletion';

    test('should throw ArgumentError if userId is empty', () {
      expect(
        () => biometricsDeletion.delete(userId: '', biometricId: biometricId),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw ArgumentError if biometricId is empty', () {
      expect(
        () => biometricsDeletion.delete(userId: userId, biometricId: ''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should return a mock response when mock is enabled', () async {
      final response = await biometricsDeletion.delete(
        userId: userId,
        biometricId: biometricId,
        mock: true,
      );

      expect(response['status'], equals('success'));
      expect(response['userId'], equals(userId));
      expect(response['biometricId'], equals(biometricId));
      expect(response, contains('deletedAt'));
    });

    test('should return success response on valid API request', () async {
      final mockResponse = {
        'status': 'success',
        'message': 'Biometric enrollment deleted successfully',
      };

      when(
        () => mockApiClient.delete(
          endpoint: endpoint,
          body: jsonEncode({'userId': userId, 'biometricId': biometricId}),
        ),
      ).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      final response = await biometricsDeletion.delete(
        userId: userId,
        biometricId: biometricId,
      );

      expect(response, equals(mockResponse));
    });

    test('should throw ApiException on API failure', () async {
      when(
        () => mockApiClient.delete(
          endpoint: endpoint,
          body: jsonEncode({'userId': userId, 'biometricId': biometricId}),
        ),
      ).thenAnswer((_) async => http.Response('Server error', 500));

      expect(
        () =>
            biometricsDeletion.delete(userId: userId, biometricId: biometricId),
        throwsA(isA<ApiException>()),
      );
    });

    test('should throw ApiException on unexpected exception', () async {
      when(
        () => mockApiClient.delete(
          endpoint: endpoint,
          body: jsonEncode({'userId': userId, 'biometricId': biometricId}),
        ),
      ).thenThrow(Exception('Unexpected error'));

      expect(
        () =>
            biometricsDeletion.delete(userId: userId, biometricId: biometricId),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
