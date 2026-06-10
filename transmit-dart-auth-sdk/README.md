# Transmit Dart Auth SDK

Backend and trusted-client authentication SDK for Transmit Security in Dart.

This package exposes a central `TransmitSDK` plus the clearer public aliases `TransmitAuth` and `TransmitClient`. Services are available as properties such as `sendMagicLink`, `authenticatePassword`, `tokenRefresh`, `getUserSessions`, and the WebAuthn helpers.

## Installation

```yaml
dependencies:
  transmit_dart_auth_sdk: ^0.0.6
```

## Recommended Initialization Model

Use one of these paths:

1. `TransmitAuth.withApiKey(...)`
   Preferred for direct API-key-backed integrations.
2. `TransmitClient.withApiKey(...)`
   Same behavior with a client-oriented entrypoint name.
3. `TransmitSDK.fromConfig(...)`
   Use when you already manage a `TransmitAuthConfig`.

## Preferred Backend Initialization

```dart
import 'package:transmit_dart_auth_sdk/transmit_dart_auth_sdk.dart';

Future<void> main() async {
  final transmit = TransmitAuth.withApiKey(
    apiKey: 'your-api-key',
    serviceId: 'your-service-id',
  );

  final magicLink = await transmit.sendMagicLink.sendMagicLinkEmail(
    'alice@example.com',
  );

  final tokens = await transmit.authenticatePassword.authenticatePassword(
    username: 'alice@example.com',
    password: 'SuperSecret123!',
    usernameType: 'email',
  );

  print(magicLink['message']);
  print(tokens['access_token']);
}
```

## Common Operations

### Magic-link authentication

```dart
final result = await transmit.sendMagicLink.sendMagicLinkEmail(
  'alice@example.com',
);

print(result['message']);
```

### Password authentication

```dart
final tokens = await transmit.authenticatePassword.authenticatePassword(
  username: 'alice@example.com',
  password: 'SuperSecret123!',
  usernameType: 'email',
);

print(tokens['session_id']);
```

## Service Layout

The main SDK instance exposes grouped services for:

- magic link and OTP flows
- password, TOTP, biometric, and WebAuthn authentication
- session inspection and revocation
- token refresh, reset, revoke, and journey-token flows

You can also import the exported service classes directly if you only need one flow.

## Security Guidance

- Keep Transmit API keys in backend or other trusted environments.
- Rotate service keys and scope them to the flows you actually use.
- Do not embed privileged service credentials in public browser or mobile apps.
- Treat returned tokens and session identifiers as sensitive credentials.

## Examples

See the `example/` directory for current frontend sample apps and integration references.
