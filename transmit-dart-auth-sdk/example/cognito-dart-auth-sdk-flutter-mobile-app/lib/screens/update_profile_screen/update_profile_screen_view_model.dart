import 'package:bot_toast/bot_toast.dart';
import 'package:transmit_dart_auth_sdk/transmit_dart_auth_sdk.dart';
import 'package:flutter/material.dart';

class UpdateProfileScreenViewModel extends ChangeNotifier {
  bool loading = false;

  void setLoading(bool load) {
    loading = load;
    notifyListeners();
  }

  Future<void> updateProfile(
    String displayName,
    String displayImage,
    VoidCallback onSuccess,
  ) async {
    try {
      setLoading(true);
      await transmitApp.transmitAuth?.updateProfile(displayName, displayImage);

      BotToast.showText(text: 'Update Successfull');
      onSuccess();
    } catch (e) {
      BotToast.showText(text: e.toString());
    } finally {
      setLoading(false);
    }
  }
}
