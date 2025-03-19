<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/aortem/logos/main/Aortem-logo-small.png" />
    <img align="center" alt="Aortem Logo" src="https://raw.githubusercontent.com/aortem/logos/main/Aortem-logo-small.png" />
  </picture>
</p>

<h2 align="center">Transmit Dart Auth SDK</h2>

<!-- x-hide-in-docs-end -->
<p align="center" class="github-badges">
  <!-- Release Badge -->
  <a href="https://github.com/aortem/Transmit-dart--auth-sdk/tags">
    <img alt="Release" src="https://img.shields.io/static/v1?label=release&message=v0.0.1-pre+13&color=blue&style=for-the-badge" />
  </a>
  <br/>
  <!-- Dart-Specific Badges -->
  <a href="https://pub.dev/packages/Transmit_dart__auth_sdk">
    <img alt="Pub Version" src="https://img.shields.io/pub/v/Transmit_dart__auth_sdk.svg?style=for-the-badge" />
  </a>
  <a href="https://dart.dev/">
    <img alt="Built with Dart" src="https://img.shields.io/badge/Built%20with-Dart-blue.svg?style=for-the-badge" />
  </a>
 <!-- Transmit Badge -->
   <a href="https://Transmit.google.com/docs/reference//node/Transmit-.auth?_gl=1*1ewipg9*_up*MQ..*_ga*NTUxNzc0Mzk3LjE3MzMxMzk3Mjk.*_ga_CW55HF8NVT*MTczMzEzOTcyOS4xLjAuMTczMzEzOTcyOS4wLjAuMA..">
    <img alt="API Reference" src="https://img.shields.io/badge/API-reference-blue.svg?style=for-the-badge" />
  <br/>
<!-- Pipeline Badge -->
<a href="https://github.com/aortem/Transmit-dart--auth-sdk/actions">
  <img alt="Pipeline Status" src="https://img.shields.io/github/actions/workflow/status/aortem/Transmit-dart--auth-sdk/dart-analysis.yml?branch=main&label=pipeline&style=for-the-badge" />
</a>
<!-- Code Coverage Badges -->
  </a>
  <a href="https://codecov.io/gh/open-feature/dart-server-sdk">
    <img alt="Code Coverage" src="https://codecov.io/gh/open-feature/dart-server-sdk/branch/main/graph/badge.svg?token=FZ17BHNSU5" />
<!-- Open Source Badge -->
  </a>
  <a href="https://bestpractices.coreinfrastructure.org/projects/6601">
    <img alt="CII Best Practices" src="https://bestpractices.coreinfrastructure.org/projects/6601/badge?style=for-the-badge" />
  </a>
</p>
<!-- x-hide-in-docs-start -->

# Transmit Dart Auth SDK

Transmit Dart Auth SDK is designed to provide select out of the box features of Transmit in Dart.  Both low level and high level abstractions are provided.

## Features
This implementation does not yet support all functionalities of the Transmit authentication service. Here is a list of functionalities with the current support status:

| Method                                       | Supported |
|--------------------------------------------- |-----------|
| TransmitApp.getAuth                          | ✅        |
| TransmitApp.initializeAuth                   | ✅        |
| TransmitStorage.getStorage                   | ✅        |
| TransmitAuth.applyActionCode                 | ✅        |
| TransmitAuth.beforeAuthStateChanged          | ✅        |
| TransmitAuth.checkActionCode                 | ✅        |
| TransmitAuth.confirmPasswordReset            | ✅        |
| TransmitAuth.connectAuthEmulator             | ✅        |
| TransmitAuth.createUserWithEmailAndPassword  | ✅        |
| TransmitAuth.fetchSignInMethodsForEmail      | ✅        |
| TransmitAuth.getMultiFactorResolver          | ✅        |
| TransmitAuth.getRedirectResult               | ✅        |
| TransmitAuth.initializeRecaptchaConfig       | ✅        |
| TransmitAuth.isSignInWithEmailLink           | ✅        |
| TransmitAuth.onAuthStateChanged              | ✅        |
| TransmitAuth.onIdTokenChanged                | ✅        |
| TransmitAuth.revokeAccessToken               | ✅        |
| TransmitAuth.sendPasswordResetEmail          | ✅        |
| TransmitAuth.sendSignInLinkToEmail           | ✅        |
| TransmitAuth.setLanguageCode                 | ✅        |
| TransmitAuth.setPersistence                  | ✅        |
| TransmitAuth.signInAnonymously               | ✅        |
| TransmitAuth.signInWithCredential            | ✅        |
| TransmitAuth.signInWithCustomToken           | ✅        |
| TransmitAuth.signInWithEmailAndPassword      | ✅        |
| TransmitAuth.signInWithEmailLink             | ✅        |
| TransmitAuth.signInWithPhoneNumber           | ✅        |
| TransmitAuth.signInWithPopup                 | ✅        |
| TransmitAuth.signInWithRedirect              | ✅        |
| TransmitAuth.signOut                         | ✅        |
| TransmitAuth.updateCurrentUser               | ✅        |
| TransmitAuth.useDeviceLanguage               | ✅        |
| TransmitAuth.verifyPasswordResetCode         | ✅        |
| TransmitLink.parseActionCodeURL              | ✅        |
| TransmitUser.deleteUser                      | ✅        |
| TransmitUser.getIdToken                      | ✅        |
| TransmitUser.getIdTokenResult                | ✅        |
| TransmitUser.linkWithCredential              | ✅        |
| TransmitUser.linkWithPhoneNumber             | ✅        |
| TransmitUser.linkWithPopup                   | ✅        |
| TransmitUser.linkWithRedirect                | ✅        |
| TransmitUser.multiFactor                     | ✅        |
| TransmitUser.reauthenticateWithCredential    | ✅        |
| TransmitUser.reauthenticateWithPhoneNumber   | ✅        |
| TransmitUser.reauthenticateWithPopUp         | ✅        |
| TransmitUser.reauthenticateWithRedirect      | ✅        |
| TransmitUser.reload                          | ✅        |
| TransmitUser.sendEmailVerification           | ✅        |
| TransmitUser.unlink                          | ✅        |
| TransmitUser.updateEmail                     | ✅        |
| TransmitUser.updatePassword                  | ✅        |
| TransmitUser.updatePhoneNumber               | ✅        |
| TransmitUser.updateProfile                   | ✅        |
| TransmitUser.verifyBeforeUpdateEmail         | ✅        |
| TransmitUserCredential.getAdditionalUserInfo | ✅        |


## Available Versions

Transmit Dart Auth SDK is available in two versions to cater to different needs:

1. **Main - Stable Version**: Usually one release a month.  This version attempts to keep stability without introducing breaking changes.
2. **Pre-Release - Edge Version**: Provided as an early indication of a release when breaking changes are expect.  This release is inconsistent. Use only if you are looking to test new features.

## Documentation

For detailed guides, API references, and example projects, visit our [Transmit Dart Auth SDK Documentation](https://aortem.gitbook.io/Transmit-dart-auth--sdk). Start building with  Transmit Dart Auth SDK today and take advantage of its robust features and elegant syntax.

## Examples

Explore the `/example` directory in this repository to find sample applications demonstrating  Transmit Dart Auth SDK's capabilities in real-world scenarios.

## Contributing

We welcome contributions of all forms from the community! If you're interested in helping improve  Transmit Dart Auth SDK, please fork the repository and submit your pull requests. For more details, check out our [CONTRIBUTING.md](CONTRIBUTING.md) guide.  Our team will review your pull request. Once approved, we will integrate your changes into our primary repository and push the mirrored changes on the main github branch.

## Support

For support across all Aortem open-source products, including this SDK, visit our Support Page.

## Licensing

The **EntraID Dart Auth SDK** is licensed under a dual-license approach:

1. **BSD-3 License**:
   - Applies to all packages and libraries in the SDK.
   - Allows use, modification, and redistribution, provided that credit is given and compliance with the BSD-3 terms is maintained.
   - Permits usage in open-source projects, applications, and private deployments.

2. **Enhanced License Version 2 (ELv2)**:
   - Applies to all use cases where the SDK or its derivatives are offered as part of a **cloud service**.
   - This ensures that the SDK cannot be directly used by cloud providers to offer competing services without explicit permission.
   - Example restricted use cases:
     - Including the SDK in a hosted SaaS authentication platform.
     - Offering the SDK as a component of a managed cloud service.

### **Summary**
- You are free to use the SDK in your applications, including open-source and commercial projects, as long as the SDK is not directly offered as part of a third-party cloud service.
- For details, refer to the [LICENSE](LICENSE.md) file.

## Enhance with Transmit Dart Auth SDK

We hope the Transmit Dart Auth SDK helps you to efficiently build and scale your server-side applications. Join our growing community and start contributing to the ecosystem today!  test