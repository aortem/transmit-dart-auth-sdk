import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_sdk_initializer.dart';
import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_session_manager.dart';
import 'package:transmit_dart_auth_sdk/src/core/aortem_transmit_token_manager.dart';
import 'package:transmit_dart_auth_sdk/src/methods/authentication/aortem_transmit_authenticate_mobile_biometrics.dart';
import 'package:transmit_dart_auth_sdk/src/methods/authentication/aortem_transmit_authenticate_password.dart';
import 'package:transmit_dart_auth_sdk/src/methods/authentication/aortem_transmit_authenticate_session.dart';
import 'package:transmit_dart_auth_sdk/src/methods/authentication/aortem_transmit_authenticate_totp.dart';
import 'package:transmit_dart_auth_sdk/src/methods/authentication/aortem_transmit_authenticate_transaction_totp.dart';
import 'package:transmit_dart_auth_sdk/src/methods/authentication/aortem_transmit_authenticate_webauthn.dart';
import 'package:transmit_dart_auth_sdk/src/methods/authentication/aortem_transmit_authentication_magic_link.dart';
import 'package:transmit_dart_auth_sdk/src/methods/authentication/aortem_transmit_authenticate_otp.dart';
import 'package:transmit_dart_auth_sdk/src/methods/biometrics/aortem_transmit_mobile_biometrics_registration.dart';
import 'package:transmit_dart_auth_sdk/src/methods/sessions/aortem_transmit_get_user_sessions.dart';
import 'package:transmit_dart_auth_sdk/src/methods/sessions/aortem_transmit_logout_backend_session.dart';
import 'package:transmit_dart_auth_sdk/src/methods/token/aortem_transmit_manage_totp.dart';
import 'package:transmit_dart_auth_sdk/src/methods/token/aortem_transmit_revoke_token.dart';
import 'package:transmit_dart_auth_sdk/src/methods/topo/aotem_transmit_register_totp.dart';
import 'package:transmit_dart_auth_sdk/src/methods/topo/aotem_transmit_start_transaction_totp.dart';
import 'package:transmit_dart_auth_sdk/src/methods/coumunication/aortem_transmit_send_magic_link.dart';
import 'package:transmit_dart_auth_sdk/src/methods/coumunication/aortem_transmit_send_otp.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmit_webauthn_cross_device_abort.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmit_webauthn_cross_device_attach_device.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmit_webauthn_cross_device_authenticate_start.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmit_webauthn_cross_device_authentication_init.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmit_webauthn_cross_device_status.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmit_webauthn_start.dart';
import 'package:transmit_dart_auth_sdk/src/models/tansmit_region.dart';

// ✅ Import for user session revocation
import 'package:transmit_dart_auth_sdk/src/methods/sessions/aortem_transmit_revoke_user_sessions.dart';

import 'methods/authorization/aortem_transmit_flexible_authorization.dart';
import 'methods/search/aortem_transmit_search_query_service.dart';
import 'methods/token/aortem_transmit_token_refresh.dart';
import 'methods/token/aortem_transmit_token_reset.dart';
import 'methods/token/aortem_transmit_journey_token.dart';

class TransmitSDK {
  late final TransmitAuthConfig _config;
  late final http.Client _client;

  late final AortemTransmitAuthorization authorization;
  late final AortemTransmitSearchQueryService searchQuery;
  late final AortemTransmitTokenManager tokenManager;
  late final AortemTransmitTokenRefresh tokenRefresh;
  late final AortemTransmitTokenReset tokenReset;
  late final AortemTransmitJourneyToken journeyToken;

  // ✅ Magic Link
  late final AortemTransmitSendMagicLink sendMagicLink;
  late final AortemTransmitAuthenticateMagicLink authenticateMagicLink;

  // ✅ OTP
  late final AortemTransmitSendOTP sendOTP;
  late final AortemTransmitAuthenticateOTP authenticateOTP;

  // ✅ TOTP
  late final AortemTransmitAuthenticateTOTP authenticateTOTP;
  late final AortemTransmitRegisterTOTP registerTOTP;
  late final AortemTransmitRevokeTOTP revokeTOTP;
  late final AortemTransmitRevokeTOTPManagement revokeTOTPManagement;

  // ✅ Transaction Signing TOTP
  late final AortemTransmitStartTransactionTOTP startTransactionTOTP;
  late final AortemTransmitAuthenticateTransactionTOTP
  authenticateTransactionTOTP;

  // ✅ WebAuthn
  late final AortemTransmitAuthenticateWebAuthnCredential
  authenticateWebAuthnCredential;
  late final AortemTransmitAuthenticationStartWebAuthn
  authenticationStartWebAuthn;

  // ✅ User Sessions
  late final UserSessionManager revokeUserSessions;
  late final AortemTransmitGetUserSessions getUserSessions;
  late final AortemTransmitLogoutBackendSession logoutBackendSession;
  late final AortemTransmitRefreshBackendAuthToken refreshBackendAuthToken;
  late final AortemTransmitAuthenticateSession authenticateSession;

  late final AortemTransmitAuthenticatePassword authenticatePassword;

  ///Bio metric
  late final AortemTransmitAuthenticateNativeMobileBiometrics
  authenticateNativeMobileBiometrics;
  late final AortemTransmitMobileBiometricsRegistration
  mobileBiometricsRegistration;
  late final AortemTransmitWebAuthnCrossDeviceAuthenticateStart
  webAuthnCrossDeviceAuthenticateStart;
  late final AortemTransmitWebAuthnCrossDeviceAuthenticationInit
  webAuthnCrossDeviceAuthenticationInit;
  late final AortemTransmitWebAuthnCrossDeviceStatus webAuthnCrossDeviceStatus;
  // ✅ WebAuthn Cross-Device
  late final AortemTransmitWebAuthnCrossDeviceAttachDevice
  webAuthnCrossDeviceAttachDevice;
  late final AortemTransmitWebAuthnCrossDeviceAbort webAuthnCrossDeviceAbort;

  TransmitSDK.withApiKey({
    required String apiKey,
    required String serviceId,
    TransmitRegion region = TransmitRegion.global,
    http.Client? client,
  }) {
    _config = TransmitAuthConfig(
      apiKey: apiKey,
      serviceId: serviceId,
      region: region,
    );

    _client = client ?? http.Client();

    authorization = AortemTransmitAuthorization(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    );
    searchQuery = AortemTransmitSearchQueryService(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    );
    tokenManager = AortemTransmitTokenManager(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    );
    tokenRefresh = AortemTransmitTokenRefresh(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    );
    tokenReset = AortemTransmitTokenReset(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    );
    journeyToken = AortemTransmitJourneyToken(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    );

    // ✅ Magic Link
    sendMagicLink = AortemTransmitSendMagicLink(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    );
    authenticateMagicLink = AortemTransmitAuthenticateMagicLink(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    );

    // ✅ OTP
    sendOTP = AortemTransmitSendOTP(apiKey: apiKey, baseUrl: _config.baseUrl);
    authenticateOTP = AortemTransmitAuthenticateOTP(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    );

    // ✅ TOTP
    authenticateTOTP = AortemTransmitAuthenticateTOTP(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    );
    registerTOTP = AortemTransmitRegisterTOTP(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    );
    revokeTOTP = AortemTransmitRevokeTOTP(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    );
    revokeTOTPManagement = AortemTransmitRevokeTOTPManagement(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    );

    // ✅ Transaction Signing TOTP
    startTransactionTOTP = AortemTransmitStartTransactionTOTP(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    );
    authenticateTransactionTOTP = AortemTransmitAuthenticateTransactionTOTP(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    );

    // ✅ WebAuthn
    authenticateWebAuthnCredential =
        AortemTransmitAuthenticateWebAuthnCredential(
          apiKey: apiKey,
          baseUrl: _config.baseUrl,
        );
    authenticationStartWebAuthn = AortemTransmitAuthenticationStartWebAuthn(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    );

    // ✅ User Sessions
    revokeUserSessions = UserSessionManager(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    );
    getUserSessions = AortemTransmitGetUserSessions(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    );
    logoutBackendSession = AortemTransmitLogoutBackendSession(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    );

    refreshBackendAuthToken = AortemTransmitRefreshBackendAuthToken(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    );
    authenticateSession = AortemTransmitAuthenticateSession(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    );
    authenticatePassword = AortemTransmitAuthenticatePassword(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    );
    authenticateNativeMobileBiometrics =
        AortemTransmitAuthenticateNativeMobileBiometrics(
          apiKey: apiKey,
          baseUrl: _config.baseUrl,
        );
    mobileBiometricsRegistration = AortemTransmitMobileBiometricsRegistration(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    );
    webAuthnCrossDeviceAuthenticateStart =
        AortemTransmitWebAuthnCrossDeviceAuthenticateStart(
          apiKey: apiKey,
          baseUrl: _config.baseUrl,
        );
    webAuthnCrossDeviceAuthenticationInit =
        AortemTransmitWebAuthnCrossDeviceAuthenticationInit(
          apiKey: apiKey,
          baseUrl: _config.baseUrl,
        );
    webAuthnCrossDeviceStatus = AortemTransmitWebAuthnCrossDeviceStatus(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    );
    // ✅ WebAuthn Cross-Device
    webAuthnCrossDeviceAttachDevice =
        AortemTransmitWebAuthnCrossDeviceAttachDevice(
          apiKey: apiKey,
          baseUrl: _config.baseUrl,
        );

    webAuthnCrossDeviceAbort = AortemTransmitWebAuthnCrossDeviceAbort(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    );
  }

  TransmitSDK.fromConfig({
    required TransmitAuthConfig config,
    http.Client? client,
  }) {
    _config = config;
    _client = client ?? http.Client();

    authorization = AortemTransmitAuthorization(
      apiKey: config.apiKey,
      baseUrl: config.baseUrl,
    );
    searchQuery = AortemTransmitSearchQueryService(
      apiKey: config.apiKey,
      baseUrl: config.baseUrl,
    );
    tokenManager = AortemTransmitTokenManager(
      apiKey: config.apiKey,
      baseUrl: config.baseUrl,
    );
    tokenRefresh = AortemTransmitTokenRefresh(
      apiKey: config.apiKey,
      baseUrl: config.baseUrl,
    );
    tokenReset = AortemTransmitTokenReset(
      apiKey: config.apiKey,
      baseUrl: config.baseUrl,
    );
    journeyToken = AortemTransmitJourneyToken(
      apiKey: config.apiKey,
      baseUrl: config.baseUrl,
    );

    // ✅ Magic Link
    sendMagicLink = AortemTransmitSendMagicLink(
      apiKey: config.apiKey,
      baseUrl: config.baseUrl,
    );
    authenticateMagicLink = AortemTransmitAuthenticateMagicLink(
      apiKey: config.apiKey,
      baseUrl: config.baseUrl,
    );

    // ✅ OTP
    sendOTP = AortemTransmitSendOTP(
      apiKey: config.apiKey,
      baseUrl: config.baseUrl,
    );
    authenticateOTP = AortemTransmitAuthenticateOTP(
      apiKey: config.apiKey,
      baseUrl: config.baseUrl,
    );

    // ✅ TOTP
    authenticateTOTP = AortemTransmitAuthenticateTOTP(
      apiKey: config.apiKey,
      baseUrl: config.baseUrl,
    );
    registerTOTP = AortemTransmitRegisterTOTP(
      apiKey: config.apiKey,
      baseUrl: config.baseUrl,
    );
    revokeTOTP = AortemTransmitRevokeTOTP(
      apiKey: config.apiKey,
      baseUrl: config.baseUrl,
    );
    revokeTOTPManagement = AortemTransmitRevokeTOTPManagement(
      apiKey: config.apiKey,
      baseUrl: config.baseUrl,
    );

    // ✅ Transaction Signing TOTP
    startTransactionTOTP = AortemTransmitStartTransactionTOTP(
      apiKey: config.apiKey,
      baseUrl: config.baseUrl,
    );
    authenticateTransactionTOTP = AortemTransmitAuthenticateTransactionTOTP(
      apiKey: config.apiKey,
      baseUrl: config.baseUrl,
    );

    // ✅ WebAuthn
    authenticateWebAuthnCredential =
        AortemTransmitAuthenticateWebAuthnCredential(
          apiKey: config.apiKey,
          baseUrl: config.baseUrl,
        );
    authenticationStartWebAuthn = AortemTransmitAuthenticationStartWebAuthn(
      apiKey: config.apiKey,
      baseUrl: config.baseUrl,
    );

    // ✅ User Sessions
    revokeUserSessions = UserSessionManager(
      apiKey: config.apiKey,
      baseUrl: config.baseUrl,
    );
    getUserSessions = AortemTransmitGetUserSessions(
      apiKey: config.apiKey,
      baseUrl: config.baseUrl,
    );
    logoutBackendSession = AortemTransmitLogoutBackendSession(
      apiKey: config.apiKey,
      baseUrl: config.baseUrl,
    );
    refreshBackendAuthToken = AortemTransmitRefreshBackendAuthToken(
      apiKey: config.apiKey,
      baseUrl: config.baseUrl,
    );
    authenticateSession = AortemTransmitAuthenticateSession(
      apiKey: config.apiKey,
      baseUrl: _config.baseUrl,
    );
    authenticatePassword = AortemTransmitAuthenticatePassword(
      apiKey: config.apiKey,
      baseUrl: config.baseUrl,
    );
    authenticateNativeMobileBiometrics =
        AortemTransmitAuthenticateNativeMobileBiometrics(
          apiKey: config.apiKey,
          baseUrl: config.baseUrl,
        );
    mobileBiometricsRegistration = AortemTransmitMobileBiometricsRegistration(
      apiKey: config.apiKey,
      baseUrl: config.baseUrl,
    );
    webAuthnCrossDeviceAuthenticateStart =
        AortemTransmitWebAuthnCrossDeviceAuthenticateStart(
          apiKey: config.apiKey,
          baseUrl: config.baseUrl,
        );
    webAuthnCrossDeviceAuthenticationInit =
        AortemTransmitWebAuthnCrossDeviceAuthenticationInit(
          apiKey: config.apiKey,
          baseUrl: config.baseUrl,
        );
    webAuthnCrossDeviceAuthenticationInit =
        AortemTransmitWebAuthnCrossDeviceAuthenticationInit(
          apiKey: config.apiKey,
          baseUrl: _config.baseUrl,
        );
    // ✅ WebAuthn Cross-Device
    webAuthnCrossDeviceAttachDevice =
        AortemTransmitWebAuthnCrossDeviceAttachDevice(
          apiKey: config.apiKey,
          baseUrl: config.baseUrl,
        );
    webAuthnCrossDeviceStatus = AortemTransmitWebAuthnCrossDeviceStatus(
      apiKey: config.apiKey,
      baseUrl: config.baseUrl,
    );

    webAuthnCrossDeviceAbort = AortemTransmitWebAuthnCrossDeviceAbort(
      apiKey: config.apiKey,
      baseUrl: config.baseUrl,
    );
  }

  void updateConfig(TransmitAuthConfig newConfig) {
    _config = newConfig;

    authorization = AortemTransmitAuthorization(
      apiKey: newConfig.apiKey,
      baseUrl: newConfig.baseUrl,
    );
    searchQuery = AortemTransmitSearchQueryService(
      apiKey: newConfig.apiKey,
      baseUrl: newConfig.baseUrl,
    );
    tokenManager = AortemTransmitTokenManager(
      apiKey: newConfig.apiKey,
      baseUrl: newConfig.baseUrl,
    );
    tokenRefresh = AortemTransmitTokenRefresh(
      apiKey: newConfig.apiKey,
      baseUrl: newConfig.baseUrl,
    );
    tokenReset = AortemTransmitTokenReset(
      apiKey: newConfig.apiKey,
      baseUrl: newConfig.baseUrl,
    );
    journeyToken = AortemTransmitJourneyToken(
      apiKey: newConfig.apiKey,
      baseUrl: newConfig.baseUrl,
    );

    // ✅ Magic Link
    sendMagicLink = AortemTransmitSendMagicLink(
      apiKey: newConfig.apiKey,
      baseUrl: newConfig.baseUrl,
    );
    authenticateMagicLink = AortemTransmitAuthenticateMagicLink(
      apiKey: newConfig.apiKey,
      baseUrl: newConfig.baseUrl,
    );

    // ✅ OTP
    sendOTP = AortemTransmitSendOTP(
      apiKey: newConfig.apiKey,
      baseUrl: newConfig.baseUrl,
    );
    authenticateOTP = AortemTransmitAuthenticateOTP(
      apiKey: newConfig.apiKey,
      baseUrl: newConfig.baseUrl,
    );

    // ✅ TOTP
    authenticateTOTP = AortemTransmitAuthenticateTOTP(
      apiKey: newConfig.apiKey,
      baseUrl: newConfig.baseUrl,
    );
    registerTOTP = AortemTransmitRegisterTOTP(
      apiKey: newConfig.apiKey,
      baseUrl: newConfig.baseUrl,
    );
    revokeTOTP = AortemTransmitRevokeTOTP(
      apiKey: newConfig.apiKey,
      baseUrl: newConfig.baseUrl,
    );
    revokeTOTPManagement = AortemTransmitRevokeTOTPManagement(
      apiKey: newConfig.apiKey,
      baseUrl: newConfig.baseUrl,
    );

    // ✅ Transaction Signing TOTP
    startTransactionTOTP = AortemTransmitStartTransactionTOTP(
      apiKey: newConfig.apiKey,
      baseUrl: newConfig.baseUrl,
    );
    authenticateTransactionTOTP = AortemTransmitAuthenticateTransactionTOTP(
      apiKey: newConfig.apiKey,
      baseUrl: newConfig.baseUrl,
    );

    // ✅ WebAuthn
    authenticateWebAuthnCredential =
        AortemTransmitAuthenticateWebAuthnCredential(
          apiKey: newConfig.apiKey,
          baseUrl: newConfig.baseUrl,
        );
    authenticationStartWebAuthn = AortemTransmitAuthenticationStartWebAuthn(
      apiKey: newConfig.apiKey,
      baseUrl: newConfig.baseUrl,
    );

    // ✅ User Sessions
    revokeUserSessions = UserSessionManager(
      apiKey: newConfig.apiKey,
      baseUrl: newConfig.baseUrl,
    );
    getUserSessions = AortemTransmitGetUserSessions(
      apiKey: newConfig.apiKey,
      baseUrl: newConfig.baseUrl,
    );
    logoutBackendSession = AortemTransmitLogoutBackendSession(
      apiKey: newConfig.apiKey,
      baseUrl: newConfig.baseUrl,
    );
    refreshBackendAuthToken = AortemTransmitRefreshBackendAuthToken(
      apiKey: newConfig.apiKey,
      baseUrl: newConfig.baseUrl,
    );
    authenticateSession = AortemTransmitAuthenticateSession(
      apiKey: newConfig.apiKey,
      baseUrl: newConfig.baseUrl,
    );
    authenticatePassword = AortemTransmitAuthenticatePassword(
      apiKey: newConfig.apiKey,
      baseUrl: newConfig.baseUrl,
    );
    authenticateNativeMobileBiometrics =
        AortemTransmitAuthenticateNativeMobileBiometrics(
          apiKey: newConfig.apiKey,
          baseUrl: newConfig.baseUrl,
        );
    mobileBiometricsRegistration = AortemTransmitMobileBiometricsRegistration(
      apiKey: newConfig.apiKey,
      baseUrl: newConfig.baseUrl,
    );
    webAuthnCrossDeviceAuthenticateStart =
        AortemTransmitWebAuthnCrossDeviceAuthenticateStart(
          apiKey: newConfig.apiKey,
          baseUrl: newConfig.baseUrl,
        );
    webAuthnCrossDeviceAuthenticationInit =
        AortemTransmitWebAuthnCrossDeviceAuthenticationInit(
          apiKey: newConfig.apiKey,
          baseUrl: newConfig.baseUrl,
        );
    webAuthnCrossDeviceStatus = AortemTransmitWebAuthnCrossDeviceStatus(
      apiKey: newConfig.apiKey,
      baseUrl: newConfig.baseUrl,
    );

    // ✅ WebAuthn Cross-Device
    webAuthnCrossDeviceAttachDevice =
        AortemTransmitWebAuthnCrossDeviceAttachDevice(
          apiKey: newConfig.apiKey,
          baseUrl: newConfig.baseUrl,
        );

    webAuthnCrossDeviceAbort = AortemTransmitWebAuthnCrossDeviceAbort(
      apiKey: newConfig.apiKey,
      baseUrl: newConfig.baseUrl,
    );
  }
}
