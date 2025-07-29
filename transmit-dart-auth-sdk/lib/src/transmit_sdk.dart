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
import 'package:transmit_dart_auth_sdk/src/methods/communication/aortem_transmit_send_magic_link.dart';
import 'package:transmit_dart_auth_sdk/src/methods/communication/aortem_transmit_send_otp.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmit_webauthn_cross_device_abort.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmit_webauthn_cross_device_attach_device.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmit_webauthn_cross_device_authenticate_start.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmit_webauthn_cross_device_authentication_init.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmit_webauthn_cross_device_registration_init.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmit_webauthn_cross_device_status.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmit_webauthn_registration.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmit_webauthn_registration_external.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmit_webauthn_registration_hint.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmit_webauthn_registration_start.dart';
import 'package:transmit_dart_auth_sdk/src/methods/webauthn/aortem_transmit_webauthn_start.dart';
import 'package:transmit_dart_auth_sdk/src/models/tansmit_region.dart';

// Import for user session revocation
import 'package:transmit_dart_auth_sdk/src/methods/sessions/aortem_transmit_revoke_user_sessions.dart';

import 'methods/authorization/aortem_transmit_flexible_authorization.dart';
import 'methods/search/aortem_transmit_search_query_service.dart';
import 'methods/token/aortem_transmit_token_refresh.dart';
import 'methods/token/aortem_transmit_token_reset.dart';
import 'methods/token/aortem_transmit_journey_token.dart';

/// The main SDK class for Transmit authentication services.
///
/// This class provides access to all authentication methods including:
/// - Magic Link authentication
/// - OTP (One-Time Password) authentication
/// - TOTP (Time-Based One-Time Password) authentication
/// - WebAuthn authentication
/// - Password authentication
/// - Biometric authentication
/// - Session management
/// - Token management
///
/// Example usage:
/// ```dart
/// final sdk = TransmitSDK.withApiKey(
///   apiKey: 'your_api_key',
///   serviceId: 'your_service_id',
///   region: TransmitRegion.global,
/// );
/// ```
class TransmitSDK {
  late final TransmitAuthConfig _config;

  /// Authorization services for flexible access control
  late final AortemTransmitAuthorization authorization;

  /// Search query services
  late final AortemTransmitSearchQueryService searchQuery;

  /// Token management services
  late final AortemTransmitTokenManager tokenManager;

  /// Token refresh services
  late final AortemTransmitTokenRefresh tokenRefresh;

  /// Token reset services
  late final AortemTransmitTokenReset tokenReset;

  /// Journey token services
  late final AortemTransmitJourneyToken journeyToken;

  // Magic Link Services

  /// Service for sending magic links
  late final AortemTransmitSendMagicLink sendMagicLink;

  /// Service for authenticating with magic links
  late final AortemTransmitAuthenticateMagicLink authenticateMagicLink;

  // OTP Services

  /// Service for sending OTP codes
  late final AortemTransmitSendOTP sendOTP;

  /// Service for authenticating with OTP codes
  late final AortemTransmitAuthenticateOTP authenticateOTP;

  // TOTP Services

  /// Service for authenticating with TOTP
  late final AortemTransmitAuthenticateTOTP authenticateTOTP;

  /// Service for registering TOTP devices
  late final AortemTransmitRegisterTOTP registerTOTP;

  /// Service for revoking TOTP devices
  late final AortemTransmitRevokeTOTP revokeTOTP;

  /// Service for managing TOTP devices
  late final AortemTransmitRevokeTOTPManagement revokeTOTPManagement;

  // Transaction Signing TOTP Services

  /// Service for starting TOTP transactions
  late final AortemTransmitStartTransactionTOTP startTransactionTOTP;

  /// Service for authenticating TOTP transactions
  late final AortemTransmitAuthenticateTransactionTOTP
  authenticateTransactionTOTP;

  // WebAuthn Services

  /// Service for authenticating with WebAuthn credentials
  late final AortemTransmitAuthenticateWebAuthnCredential
  authenticateWebAuthnCredential;

  /// Service for starting WebAuthn authentication
  late final AortemTransmitAuthenticationStartWebAuthn
  authenticationStartWebAuthn;

  ///Service for Hosting WebAuthn Registration
  late final AortemTransmitHostedWebAuthnRegistrationHint
  hostedWebAuthnRegistrationHint;

  /// Handles starting a new WebAuthn registration flow.
  ///
  /// This field provides access to methods for initiating a WebAuthn credential
  /// registration process for a user. It interacts with the Transmit Security API
  /// to start the registration ceremony and retrieve challenge data required for
  /// creating a WebAuthn credential.
  late final AortemTransmitWebAuthnRegistrationStart webAuthnRegistrationStart;

  /// Handles completing external WebAuthn registration.
  ///
  /// This field provides access to methods that finalize a WebAuthn credential
  /// registration for users not yet logged in. It submits the credential
  /// attestation data to the Transmit Security API.
  late final AortemTransmitWebAuthnRegistrationExternal
  webAuthnRegistrationExternal;

  /// Handles completion of WebAuthn credential registration
  /// for users who are already logged in.
  ///
  /// This field provides access to the `webauthn-registration` endpoint
  /// to finalize WebAuthn credential enrollment for authenticated users.
  late final AortemTransmitWebAuthnRegistration webAuthnRegistration;

  // User Session Services

  /// Service for managing user sessions
  late final UserSessionManager revokeUserSessions;

  /// Service for retrieving user sessions
  late final AortemTransmitGetUserSessions getUserSessions;

  /// Service for logging out backend sessions
  late final AortemTransmitLogoutBackendSession logoutBackendSession;

  /// Service for refreshing backend auth tokens
  late final AortemTransmitRefreshUserSession refreshBackendAuthToken;

  /// Service for authenticating sessions
  late final AortemTransmitAuthenticateSession authenticateSession;

  /// Service for password authentication
  late final AortemTransmitAuthenticatePassword authenticatePassword;

  // Biometric Services

  /// Service for native mobile biometric authentication
  late final AortemTransmitAuthenticateNativeMobileBiometrics
  authenticateNativeMobileBiometrics;

  /// Service for mobile biometric registration
  late final AortemTransmitMobileBiometricsRegistration
  mobileBiometricsRegistration;

  /// Service for WebAuthn cross-device authentication start
  late final AortemTransmitWebAuthnCrossDeviceAuthenticateStart
  webAuthnCrossDeviceAuthenticateStart;

  /// Handles initiating cross-device WebAuthn registration.
  late final AortemTransmitWebAuthnCrossDeviceRegistrationInit
  webAuthnCrossDeviceRegistrationInit;

  /// Service for WebAuthn cross-device authentication initialization
  late final AortemTransmitWebAuthnCrossDeviceAuthenticationInit
  webAuthnCrossDeviceAuthenticationInit;

  /// Service for checking WebAuthn cross-device status
  late final AortemTransmitWebAuthnCrossDeviceStatus webAuthnCrossDeviceStatus;

  // WebAuthn Cross-Device Services

  /// Service for attaching WebAuthn cross-device
  late final AortemTransmitWebAuthnCrossDeviceAttachDevice
  webAuthnCrossDeviceAttachDevice;

  /// Service for aborting WebAuthn cross-device operations
  late final AortemTransmitWebAuthnCrossDeviceAbort webAuthnCrossDeviceAbort;

  /// Creates a new instance of TransmitSDK with API key authentication.
  ///
  /// [apiKey]: The API key for authentication
  /// [serviceId]: The service ID for the application
  /// [region]: The region for the service (defaults to TransmitRegion.global)
  /// [client]: Optional HTTP client (uses default if not provided)
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

    _initializeServices(apiKey, _config.baseUrl);
  }

  /// Creates a new instance of TransmitSDK from a configuration object.
  ///
  /// [config]: The TransmitAuthConfig configuration object
  /// [client]: Optional HTTP client (uses default if not provided)
  TransmitSDK.fromConfig({
    required TransmitAuthConfig config,
    http.Client? client,
  }) {
    _config = config;
    _initializeServices(config.apiKey, config.baseUrl);
  }

  /// Initializes all service instances with the given API key and base URL.
  void _initializeServices(String apiKey, String baseUrl) {
    authorization = AortemTransmitAuthorization(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );
    searchQuery = AortemTransmitSearchQueryService(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );
    tokenManager = AortemTransmitTokenManager(apiKey: apiKey, baseUrl: baseUrl);
    tokenRefresh = AortemTransmitTokenRefresh(apiKey: apiKey, baseUrl: baseUrl);
    tokenReset = AortemTransmitTokenReset(apiKey: apiKey, baseUrl: baseUrl);
    journeyToken = AortemTransmitJourneyToken(apiKey: apiKey, baseUrl: baseUrl);

    // Magic Link Services
    sendMagicLink = AortemTransmitSendMagicLink(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );
    authenticateMagicLink = AortemTransmitAuthenticateMagicLink(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );

    // OTP Services
    sendOTP = AortemTransmitSendOTP(apiKey: apiKey, baseUrl: baseUrl);
    authenticateOTP = AortemTransmitAuthenticateOTP(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );

    // TOTP Services
    authenticateTOTP = AortemTransmitAuthenticateTOTP(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );
    registerTOTP = AortemTransmitRegisterTOTP(apiKey: apiKey, baseUrl: baseUrl);
    revokeTOTP = AortemTransmitRevokeTOTP(apiKey: apiKey, baseUrl: baseUrl);
    revokeTOTPManagement = AortemTransmitRevokeTOTPManagement(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );

    // Transaction Signing TOTP Services
    startTransactionTOTP = AortemTransmitStartTransactionTOTP(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );
    authenticateTransactionTOTP = AortemTransmitAuthenticateTransactionTOTP(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );

    // WebAuthn Services
    authenticateWebAuthnCredential =
        AortemTransmitAuthenticateWebAuthnCredential(
          apiKey: apiKey,
          baseUrl: baseUrl,
        );
    authenticationStartWebAuthn = AortemTransmitAuthenticationStartWebAuthn(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );
    // ✅ WebAuthn Registration stat
    webAuthnRegistrationStart = AortemTransmitWebAuthnRegistrationStart(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    ); // ✅ WebAuthn Registration
    webAuthnRegistration = AortemTransmitWebAuthnRegistration(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    );

    // User Session Services
    revokeUserSessions = UserSessionManager(apiKey: apiKey, baseUrl: baseUrl);
    getUserSessions = AortemTransmitGetUserSessions(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );
    logoutBackendSession = AortemTransmitLogoutBackendSession(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );
    refreshBackendAuthToken = AortemTransmitRefreshUserSession(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );
    authenticateSession = AortemTransmitAuthenticateSession(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );
    authenticatePassword = AortemTransmitAuthenticatePassword(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );
    authenticateNativeMobileBiometrics =
        AortemTransmitAuthenticateNativeMobileBiometrics(
          apiKey: apiKey,
          baseUrl: baseUrl,
        );
    mobileBiometricsRegistration = AortemTransmitMobileBiometricsRegistration(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );
    webAuthnRegistrationExternal = AortemTransmitWebAuthnRegistrationExternal(
      apiKey: apiKey,
      baseUrl: _config.baseUrl,
    );

    webAuthnCrossDeviceAuthenticateStart =
        AortemTransmitWebAuthnCrossDeviceAuthenticateStart(
          apiKey: apiKey,
          baseUrl: baseUrl,
        );
    webAuthnCrossDeviceAuthenticationInit =
        AortemTransmitWebAuthnCrossDeviceAuthenticationInit(
          apiKey: apiKey,
          baseUrl: baseUrl,
        );
    webAuthnCrossDeviceRegistrationInit =
        AortemTransmitWebAuthnCrossDeviceRegistrationInit(
          apiKey: apiKey,
          baseUrl: _config.baseUrl,
        );

    webAuthnCrossDeviceStatus = AortemTransmitWebAuthnCrossDeviceStatus(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );
    hostedWebAuthnRegistrationHint =
        AortemTransmitHostedWebAuthnRegistrationHint(
          apiKey: apiKey,
          baseUrl: baseUrl,
        );

    // WebAuthn Cross-Device Services
    webAuthnCrossDeviceAttachDevice =
        AortemTransmitWebAuthnCrossDeviceAttachDevice(
          apiKey: apiKey,
          baseUrl: baseUrl,
        );
    webAuthnCrossDeviceAbort = AortemTransmitWebAuthnCrossDeviceAbort(
      apiKey: apiKey,
      baseUrl: baseUrl,
    );
    // WebAuthn hosted registration Services
    hostedWebAuthnRegistrationHint =
        AortemTransmitHostedWebAuthnRegistrationHint(
          apiKey: apiKey,
          baseUrl: _config.baseUrl,
        );
  }

  /// Updates the SDK configuration with new settings.
  ///
  /// This will reinitialize all services with the new configuration.
  ///
  /// [newConfig]: The new TransmitAuthConfig configuration
  void updateConfig(TransmitAuthConfig newConfig) {
    _config = newConfig;
    _initializeServices(newConfig.apiKey, newConfig.baseUrl);
  }
}
