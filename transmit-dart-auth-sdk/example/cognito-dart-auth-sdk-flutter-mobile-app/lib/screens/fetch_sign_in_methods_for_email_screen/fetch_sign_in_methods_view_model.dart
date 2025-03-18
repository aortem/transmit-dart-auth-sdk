import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:transmit_dart_auth_sdk/transmit_dart_auth_sdk.dart';

class FetchSignInMethodsViewModel extends ChangeNotifier {
  bool loading = false;
  List<String>? result;

  void setLoading(bool load) {
    loading = load;
    notifyListeners();
  }

  Future<void> fetchSignInMethods(String email) async {
    if (email.isEmpty) {
      BotToast.showText(text: 'Please enter an email');
      return;
    }

    try {
      setLoading(true);
      var fetchedResult =
          await transmitApp.transmitAuth?.fetchSignInMethodsForEmail(email);
      result = fetchedResult?.cast<String>(); // Explicitly cast to List<String>
      notifyListeners();
    } catch (e) {
      BotToast.showText(text: e.toString());
    } finally {
      setLoading(false);
    }
  }
}
