import 'package:transmit_dart_auth_sdk/transmit_dart_auth_sdk.dart';

class AppleSignInViewModel {
  final transmitAuth auth;

  AppleSignInViewModel({required this.auth});

  Future<UserCredential> signInWithApple(String idToken,
      {String? nonce}) async {
    if (idToken.isEmpty) {
      throw transmitAuthException(
        code: 'invalid-id-token',
        message: 'Apple ID Token must not be empty',
      );
    }

    return await auth.signInWithApple(idToken, nonce: nonce);
  }
}
