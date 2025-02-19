import 'dart:convert';
import 'package:ds_tools_testing/ds_tools_testing.dart';

import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:transmit_dart_auth_sdk/services/aortem_transmit_otp.dart';

// Register a fake Uri
class FakeUri extends Fake implements Uri {}

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late AortemTransmitOTP transmitOTP;
  late MockHttpClient mockHttpClient;

  setUpAll(() {
    registerFallbackValue(FakeUri()); // Registering fallback for Uri
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    transmitOTP = AortemTransmitOTP(apiKey: 'valid-api-key', httpClient: mockHttpClient); // Inject mock client
  });

  test('sends OTP with valid identifier (mocked response)', () async {
    final identifier = 'user@example.com';
    final fakeResponse = json.encode({
      'identifier': identifier,
      'tempToken': 'mock-temp-token',
      'message': 'Mocked OTP sent successfully.',
    });

    when(() => mockHttpClient.post(
          any(), 
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        )).thenAnswer((_) async => http.Response(fakeResponse, 200));

    final result = await transmitOTP.sendOTP(identifier);
    expect(result['tempToken'], equals('mock-temp-token'));
    expect(result['message'], equals('Mocked OTP sent successfully.'));
  });

  test('throws error for empty identifier (mock)', () {
    expect(() => transmitOTP.sendOTP(''), throwsA(isA<ArgumentError>()));
  });
}
