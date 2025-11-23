# Transmit Dart Auth SDK

## Overview

The **Transmit Dart Auth SDK** provides seamless authentication and token management for Transmit’s API services in both server-side Dart applications and Flutter clients. With this SDK, you can:

- Authenticate via API key, OAuth 2.0 (authorization code & client credentials), and JWT bearer flows  
- Cache, refresh, and revoke access tokens automatically  
- Store tokens securely with a pluggable storage interface  
- Attach auth headers to `http` requests with minimal boilerplate  
- Perform admin operations (service account creation, key rotation) via Transmit’s Management API  

Whether you’re building a backend service in Dart or a cross-platform Flutter app, this SDK handles the heavy lifting of Transmit authentication.

## Features

- **Multiple Auth Flows**  
  - API Key header injection  
  - OAuth 2.0: Authorization Code (PKCE) & Client Credentials  
  - JWT Bearer for server-to-server interactions  

- **Token Lifecycle Management**  
  - Automatic caching & expiry checks  
  - Silent refresh before token expiration  
  - Manual revoke and logout helpers  

- **Secure Token Storage**  
  - Built-in `FileTokenStorage` and `MemoryTokenStorage`  
  - Pluggable `TokenStorage` interface for custom backends (e.g., keychain, database)  

- **Request Interceptor**  
  - `AuthHttpClient` wraps `http.Client` and adds `Authorization` headers automatically  

- **Admin API Helpers**  
  - Create, list, and rotate service account API keys  
  - Fetch user and service account details  

- **Platform Support**  
  - Dart VM (server)  
  - Flutter Mobile (iOS/Android)  
  - Flutter Web  

## Getting Started

### 1. Prerequisites

- Dart SDK ≥ 2.14.0 or Flutter SDK ≥ 3.0  
- A Transmit API project with client credentials (Client ID & Client Secret) or an API key  

### 2. Configure Your Transmit App

- In the Transmit Developer Portal, register your application  
- Note your **Client ID**, **Client Secret**, and **OAuth Redirect URI**  
- Generate an **API Key** if you plan to use the API Key flow  

## Installation

Add the SDK to your project:

```bash
# Dart:
dart pub add transmit_dart_auth_sdk

# Flutter:
flutter pub add transmit_dart_auth_sdk
