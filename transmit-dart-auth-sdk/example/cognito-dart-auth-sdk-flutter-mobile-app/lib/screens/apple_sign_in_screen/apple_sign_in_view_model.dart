import 'package:cognito_dart_auth_sdk/cognito_dart_auth_sdk.dart';

class AppleSignInViewModel {
  final cognitoAuth auth;

  AppleSignInViewModel({required this.auth});

  Future<UserCredential> signInWithApple(String idToken,
      {String? nonce}) async {
    if (idToken.isEmpty) {
      throw cognitoAuthException(
        code: 'invalid-id-token',
        message: 'Apple ID Token must not be empty',
      );
    }

    return await auth.signInWithApple(idToken, nonce: nonce);
  }
}
