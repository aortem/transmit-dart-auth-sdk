# transmit-dart-sample-app

## Description

A sample app to showcase the process of installing, setting up and using the transmit_dart_auth_sdk

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)

## Installation

- Add the absolute path of the transmit_dart_auth_sdk to the sample app's pubspec.yaml file
  ```yaml
  dependencies:
  transmit_dart_auth_sdk:
    path: /Users/user/Documents/GitLab/transmit_dart_auth_sdk/transmit_dart_auth_sdk
  ```

## Usage

    Depending on the platform transmit_dart_auth_sdk can be initialized via three methods

**Web:**
For Web we use Enviroment Variable

```
import 'package:flutter/material.dart';
import 'package:transmit_dart_auth_sdk/transmit_dart_auth_sdk.dart';

    void main() async
    {

        transmitApp.initializeAppWithEnvironmentVariables(apiKey:'api_key',projectId: 'project_id',);

        transmitApp.instance.getAuth();

        runApp(const MyApp());
    }

```

- Import the transmit_dart_auth_sdk and the material app
  ```
  import 'package:flutter/material.dart';
  import 'package:transmit_dart_auth_sdk/transmit_dart_auth_sdk.dart';
  ```
- In the main function call the 'transmitApp.initializeAppWithEnvironmentVariables' and pass in your api key and project id

  ```
    transmitApp.initializeAppWithEnvironmentVariables(apiKey:'api_key',projectId: 'project_id',);
  ```

- Aftwards call the 'transmitApp.instance.getAuth()'
  ```
    transmitApp.instance.getAuth();
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
    import 'package:transmit_dart_auth_sdk/transmit_dart_auth_sdk.dart';

    void main() async
    {
        transmitApp.initializeAppWithServiceAccount(serviceAccountKeyFilePath: 'path_to_json_file');

        transmitApp.instance.getAuth();
        runApp(const MyApp());
    }
    ```

- Import the transmit_dart_auth_sdk and the material app

  ```
  import 'package:flutter/material.dart';
  import 'package:transmit_dart_auth_sdk/transmit_dart_auth_sdk.dart';
  ```

- In the main function call the 'transmitApp.initializeAppWithServiceAccount' function and pass the path to your the json file
  ```
   transmitApp.initializeAppWithServiceAccount(serviceAccountKeyFilePath: 'path_to_json_file');
  ```
- Aftwards call the 'transmitApp.instance.getAuth()'
  ```
    transmitApp.instance.getAuth();
  ```
- Then call the 'runApp(const MyApp())' method

  ```
      runApp(const MyApp())

  ```

## ServiceAccountImpersonation

    ```
    import 'package:flutter/material.dart';
    import 'package:transmit_dart_auth_sdk/transmit_dart_auth_sdk.dart';

    void main() async
    {
        transmitApp.initializeAppWithServiceAccountImpersonation(serviceAccountEmail: service_account_email, userEmail: user_email)

        transmitApp.instance.getAuth();
        runApp(const MyApp());
    }
    ```

- Import the transmit_dart_auth_sdk and the material app

  ```
  import 'package:flutter/material.dart';
  import 'package:transmit_dart_auth_sdk/transmit_dart_auth_sdk.dart';
  ```

- In the main function call the 'transmitApp.initializeAppWithServiceAccountImpersonation' function and pass the service_account_email and user_email
  ```
    transmitApp.initializeAppWithServiceAccountImpersonation(serviceAccountEmail: serviceAccountEmail,userEmail:userEmail,)
  ```
- Aftwards call the 'transmitApp.instance.getAuth()'
  ```
    transmitApp.instance.getAuth();
  ```
- Then call the 'runApp(const MyApp())' method

  ```
      runApp(const MyApp())

  ```
