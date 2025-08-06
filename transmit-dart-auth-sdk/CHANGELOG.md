## 0.0.2

### Added
- **Example App Enhancements**
  - Added `transmit-dart-auth-sdk/example/transmit-dart-auth-sdk-flutter-mobile-app/pubspec.lock`.
  - Added `transmit-dart-auth-sdk/example/transmit-dart-auth-sdk-flutter-mobile-app/pubspec.yaml`.
  - Added entrypoint: `transmit-dart-auth-sdk/example/transmit-dart-auth-sdk-flutter-mobile-app/lib/main.dart`.

### ⚠️ Breaking Changes
- **Namespace Update**
  - Removed `aortem` prefix from package name and paths for a cleaner public release.  
    ⚠️ Consumers using prior versions must update import paths and dependencies accordingly.

## 0.0.1

### Added
- **Local Dev Tools**  
  - New scripts in `local_dev_tools/` (`validate_branch.dart`, `validate_commit_msg.dart`) to enforce branch and commit-message conventions.  
- **Core SDK CLI**  
  - Added `bin/main.dart` as the CLI entry point for the Cognito Dart Auth SDK.  
- **Tests**  
  - Unit tests under `test/unit/` covering core logic.  
  - Integration tests under `test/integration/` validating end-to-end authentication and storage flows.  
- **Authentication Modules**  
  - Initial AWS Cognito flows implemented in `lib/src/auth/` (sign-up, sign-in, token management, MFA).

### Changed
- **Example App Restructure**  
  - Renamed and reorganized 214 files from  
    `example/cognito-dart-auth-sdk-sample-app/…` →  
    `example/cognito-dart-auth-sdk-flutter-mobile-app/…`.  
- **CI/CD Pipeline**  
  - Moved child-CI configs from `tools/pipelines/` →  
    `tools/pipelines/backend/` and `tools/pipelines/frontend/`.  
- **Project Metadata**  
  - Updated `.gitignore`, `.gitlab-ci.yml`, `cloudbuild.yaml`, `.firebaserc`, and `README.md`.  
- **Pubspec & Lockfile**  
  - Bumped SDK version and refreshed dependencies in `pubspec.yaml`/`pubspec.lock`.  
- **GitHub Issue Templates**  
  - Revised `.github/ISSUE_TEMPLATE/config.yml` and removed deprecated `workflows/dart-analysis.yml`.

### Removed
- **Deprecated Example Files**  
  - Deleted 84 legacy files under the old `example/...-sample-app/` path.  
- **Obsolete Workflow**  
  - Removed `.github/ISSUE_TEMPLATE/workflows/dart-analysis.yml`.

### Renamed
- **Example Directory**  
  - Renamed 214 files from  
    `example/cognito-dart-auth-sdk-sample-app/…` →  
    `example/cognito-dart-auth-sdk-flutter-mobile-app/…`.

- Update to Dart 3.8.3

## 0.0.1-pre+4

- Update Readme

## 0.0.1-pre+3

- Merge development into main, integrated feature branches, and resolved merge conflicts.
- Update README
- Refine folder naming conventions
- Ensure required files are in place.
- Update the pubspec and Dart version (now 3.7.3)
- Add .gitignore entries - including removal of extraneous git checkin files.
- Implement SDK setup
- Token management (including sending magic links)
- Authorization/token operations.

## 0.0.1-pre+2

- Update Readme
- Update Pubspec
- Cleanup Repo Code.

## 0.0.1-pre+1

- Add SDK Setup & Initialization
- Add Authorization Methods with Flexible Options
- Add Search Query Functionality with Flexible Options
- Add Token Reference Operations with Flexible Options
- Add Token Issuance/Generation Method
- Add Refresh Token Flow
- Add Reset Token Flow
- Add Journey Token Flow
- Add Send Magic Link Email Method
- Add Authenticate Magic Link Method
- Add Send OTP MethodInitial pre-release version of the transmit Dart Auth SDK.
