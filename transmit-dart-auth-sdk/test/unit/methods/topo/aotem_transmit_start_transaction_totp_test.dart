import 'dart:convert';

import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/topo/aotem_transmit_start_transaction_totp.dart';

void main() {
  group('AortemTransmitStartTransactionTOTP', () {
    test('startTransactionSigningTOTP posts transaction payload', () async {
      final client = MockClient((request) async {
        expect(
          request.url.toString(),
          equals('https://api.test.com/v1/auth/totp/transaction/start'),
        );
        expect(request.method, equals('POST'));
        expect(request.headers['Authorization'], equals('Bearer test-api-key'));

        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['identifier'], equals('user@example.com'));
        expect(body['identifier_type'], equals('email'));
        expect(body['approval_data'], containsPair('amount', 100));
        expect(body.containsKey('resource'), isFalse);

        return http.Response(
          jsonEncode({
            'transaction_id': 'txn_123',
            'status': 'pending',
            'verification_required': true,
          }),
          200,
        );
      });

      final service = AortemTransmitStartTransactionTOTP(
        apiKey: 'test-api-key',
        baseUrl: 'https://api.test.com',
        httpClient: client,
      );

      final result = await service.startTransactionSigningTOTP(
        identifier: 'user@example.com',
        identifierType: 'email',
        approvalData: {'amount': 100},
      );

      expect(result['transaction_id'], equals('txn_123'));
      expect(result['verification_required'], isTrue);
    });

    test('startTransactionSigningTOTP validates required inputs', () {
      final service = AortemTransmitStartTransactionTOTP(
        apiKey: 'test-api-key',
        baseUrl: 'https://api.test.com',
      );

      expect(
        () => service.startTransactionSigningTOTP(
          identifier: '',
          identifierType: 'email',
          approvalData: {'amount': 100},
        ),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => service.startTransactionSigningTOTP(
          identifier: 'user@example.com',
          identifierType: '',
          approvalData: {'amount': 100},
        ),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => service.startTransactionSigningTOTP(
          identifier: 'user@example.com',
          identifierType: 'email',
          approvalData: {},
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
