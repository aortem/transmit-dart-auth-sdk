import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:transmit_dart_auth_sdk/src/methods/authentication/aortem_transmit_authenticate_mobile_biometrics.dart';

void main() {
  group('MobileBiometricsAuth', () {
    test('throws ArgumentError if userId is empty', () async {
      expect(
        () => MobileBiometricsAuth.authenticate(
          userId: "",
          biometricData: {"fingerprint": "data"},
          apiKey: "dummy_api_key",
        ),
        throwsArgumentError,
      );
    });

    test('throws ArgumentError if biometricData is empty', () async {
      expect(
        () => MobileBiometricsAuth.authenticate(
          userId: "user@example.com",
          biometricData: {},
          apiKey: "dummy_api_key",
        ),
        throwsArgumentError,
      );
    });

    test('mockAuthenticate should return mock authentication data', () async {
      final response = await MobileBiometricsAuth.mockAuthenticate();
      expect(response.containsKey("accessToken"), true);
      expect(response.containsKey("idToken"), true);
    });
  });
}
