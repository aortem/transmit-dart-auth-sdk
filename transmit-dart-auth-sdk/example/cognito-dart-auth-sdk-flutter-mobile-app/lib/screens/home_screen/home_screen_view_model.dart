import 'package:bot_toast/bot_toast.dart';
import 'package:cognito_dart_auth_sdk/cognito_dart_auth_sdk.dart';
import 'package:cognito/utils/platform_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreenViewModel extends ChangeNotifier {
  HomeScreenViewModel() {
    _googleSignIn.onCurrentUserChanged.listen(
      (event) async {
        signInAccount = event;
      },
    );

    refreshUser();
  }

  void refreshUser() {
    displayName = _cognitoSdk?.currentUser?.displayName ?? '';
    displayImage = _cognitoSdk?.currentUser?.photoURL;
    numberOfLinkedProviders =
        _cognitoSdk?.currentUser?.providerUserInfo?.length ?? 0;
    notifyListeners();
  }

  GoogleSignInAccount? signInAccount;
  List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: scopes,
    signInOption: SignInOption.standard,
  );
  final cognitoAuth? _cognitoSdk = cognitoApp.cognitoAuth;

  String displayName = '';
  String? displayImage;
  int numberOfLinkedProviders = 0;

  bool loading = false;
  void setLoading(bool load) {
    loading = load;
    notifyListeners();
  }

  Future<void> reloadUser() async {
    try {
      setLoading(true);
      await _cognitoSdk?.reloadUser();
      refreshUser();
      BotToast.showText(text: 'Reload Successful');
    } catch (e) {
      BotToast.showText(text: e.toString());
    } finally {
      setLoading(false);
    }
  }

  bool verificationLoading = false;

  void setVerificationLoading(bool load) {
    verificationLoading = load;
    notifyListeners();
  }

  Future<void> sendEmailVerificationCode(VoidCallback onSuccess) async {
    try {
      setVerificationLoading(true);

      await _cognitoSdk?.sendEmailVerificationCode();

      onSuccess();
      BotToast.showText(text: 'Code Sent');
    } catch (e) {
      BotToast.showText(text: e.toString());
    } finally {
      setVerificationLoading(false);
    }
  }

  bool getAdditionalInfoLoading = false;
  void setAdditionalInfoLoading(bool load) {
    getAdditionalInfoLoading = load;
    notifyListeners();
  }

  Future<void> getAdditionalUserInfo() async {
    try {
      setAdditionalInfoLoading(true);
      await _cognitoSdk?.getAdditionalUserInfo();

      BotToast.showText(text: 'Additional Info Gotten Successfully');
      refreshUser();
    } catch (e) {
      BotToast.showText(text: e.toString());
    } finally {
      setAdditionalInfoLoading(false);
    }
  }

  bool linkProviderLoading = false;
  void setLinkProviderLoading(bool load) {
    linkProviderLoading = load;
    notifyListeners();
  }

  Future<void> linkProvider() async {
    try {
      setLinkProviderLoading(true);

      if (kIsWeb) {
        signInAccount = await _googleSignIn.signInSilently();
      } else {
        signInAccount = await _googleSignIn.signIn();
      }

      var signInAuth = await signInAccount?.authentication;
      await _cognitoSdk?.linkProviderToUser(
        getPlatformId(),
        signInAuth!.idToken!,
      );

      BotToast.showText(text: 'Linking Successful');
      refreshUser();
    } catch (e) {
      BotToast.showText(text: e.toString());
    } finally {
      setLinkProviderLoading(false);
    }
  }
}
