import 'package:bot_toast/bot_toast.dart';
import 'package:transmit_dart_auth_sdk/transmit_dart_auth_sdk.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GCPSignInViewModel extends ChangeNotifier {
  bool loading = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/cloud-platform',
    ],
  );

  void setLoading(bool load) {
    loading = load;
    notifyListeners();
  }

  Future<void> signIn(VoidCallback onSuccess) async {
    try {
      setLoading(true);

      // Trigger Google Sign In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw transmitAuthException(
          code: 'sign-in-cancelled',
          message: 'Sign in was cancelled by the user',
        );
      }

      // Get auth details from request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Use tokens to sign in with transmit
      await transmitApp.transmitAuth?.signInWithGCP(
        clientId: googleAuth.accessToken!,
        clientSecret: googleAuth.idToken!,
      );

      onSuccess();
    } catch (e) {
      BotToast.showText(text: e.toString());
    }
    setLoading(false);
  }

  Future<void> signOut() async {
    try {
      setLoading(true);
      await Future.wait([
        _googleSignIn.signOut(),
        transmitApp.transmitAuth?.signOut() ?? Future.value(),
      ]);
    } catch (e) {
      BotToast.showText(text: e.toString());
    } finally {
      setLoading(false);
    }
  }
}
