# cognito-dart-sample-app

## Description

A sample app to showcase the process of installing, setting up and using the cognito_dart_auth_sdk

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)

## Installation

- Add the absolute path of the cognito_dart_auth_sdk to the sample app's pubspec.yaml file
  ```yaml
  dependencies:
  cognito_dart_auth_sdk:
    path: /Users/user/Documents/GitLab/cognito_dart_auth_sdk/cognito_dart_auth_sdk
  ```

## Usage

    Depending on the platform cognito_dart_auth_sdk can be initialized via three methods

**Web:**
For Web we use Enviroment Variable

```
import 'package:flutter/material.dart';
import 'package:cognito_dart_auth_sdk/cognito_dart_auth_sdk.dart';

    void main() async
    {

        cognitoApp.initializeAppWithEnvironmentVariables(apiKey:'api_key',projectId: 'project_id',);

        cognitoApp.instance.getAuth();

        runApp(const MyApp());
    }

```

- Import the cognito_dart_auth_sdk and the material app
  ```
  import 'package:flutter/material.dart';
  import 'package:cognito_dart_auth_sdk/cognito_dart_auth_sdk.dart';
  ```
- In the main function call the 'cognitoApp.initializeAppWithEnvironmentVariables' and pass in your api key and project id

  ```
    cognitoApp.initializeAppWithEnvironmentVariables(apiKey:'api_key',projectId: 'project_id',);
  ```

- Aftwards call the 'cognitoApp.instance.getAuth()'
  ```
    cognitoApp.instance.getAuth();
  ```
- Then call the 'runApp(const MyApp())' method

  ```
      runApp(const MyApp())

  ```

**Mobile:**
For mobile we can use either [Service Account](#serviceaccount) or [Service account impersonation](#ServiceAccountImpersonation)

## ServiceAccount

    ```
    import 'package:flutter/material.dart';
    import 'package:cognito_dart_auth_sdk/cognito_dart_auth_sdk.dart';

    void main() async
    {
        cognitoApp.initializeAppWithServiceAccount(serviceAccountKeyFilePath: 'path_to_json_file');

        cognitoApp.instance.getAuth();
        runApp(const MyApp());
    }
    ```

- Import the cognito_dart_auth_sdk and the material app

  ```
  import 'package:flutter/material.dart';
  import 'package:cognito_dart_auth_sdk/cognito_dart_auth_sdk.dart';
  ```

- In the main function call the 'cognitoApp.initializeAppWithServiceAccount' function and pass the path to your the json file
  ```
   cognitoApp.initializeAppWithServiceAccount(serviceAccountKeyFilePath: 'path_to_json_file');
  ```
- Aftwards call the 'cognitoApp.instance.getAuth()'
  ```
    cognitoApp.instance.getAuth();
  ```
- Then call the 'runApp(const MyApp())' method

  ```
      runApp(const MyApp())

  ```

## ServiceAccountImpersonation

    ```
    import 'package:flutter/material.dart';
    import 'package:cognito_dart_auth_sdk/cognito_dart_auth_sdk.dart';

    void main() async
    {
        cognitoApp.initializeAppWithServiceAccountImpersonation(serviceAccountEmail: service_account_email, userEmail: user_email)

        cognitoApp.instance.getAuth();
        runApp(const MyApp());
    }
    ```

- Import the cognito_dart_auth_sdk and the material app

  ```
  import 'package:flutter/material.dart';
  import 'package:cognito_dart_auth_sdk/cognito_dart_auth_sdk.dart';
  ```

- In the main function call the 'cognitoApp.initializeAppWithServiceAccountImpersonation' function and pass the service_account_email and user_email
  ```
    cognitoApp.initializeAppWithServiceAccountImpersonation(serviceAccountEmail: serviceAccountEmail,userEmail:userEmail,)
  ```
- Aftwards call the 'cognitoApp.instance.getAuth()'
  ```
    cognitoApp.instance.getAuth();
  ```
- Then call the 'runApp(const MyApp())' method

  ```
      runApp(const MyApp())

  ```
