// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:transmit_dart_auth_sdk/transmit_dart_auth_sdk.dart';
import 'package:provider/provider.dart';

class ConfirmPasswordResetScreen extends StatefulWidget {
  const ConfirmPasswordResetScreen({super.key});

  @override
  _ConfirmPasswordResetScreenState createState() =>
      _ConfirmPasswordResetScreenState();
}

class _ConfirmPasswordResetScreenState
    extends State<ConfirmPasswordResetScreen> {
  final TextEditingController _resetLinkController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  Future<void> _confirmPasswordReset() async {
    final auth = Provider.of<transmitAuth>(context, listen: false);
    try {
      String oobCode = _extractOobCode(_resetLinkController.text);
      await auth.confirmPasswordReset(oobCode, _newPasswordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset confirmed successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to confirm password reset: $e')),
      );
    }
  }

  String _extractOobCode(String resetLink) {
    Uri uri = Uri.parse(resetLink);
    return uri.queryParameters['oobCode'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Password Reset')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _resetLinkController,
              decoration: const InputDecoration(labelText: 'Reset Link'),
            ),
            TextField(
              controller: _newPasswordController,
              decoration: const InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _confirmPasswordReset,
              child: const Text('Confirm Password Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
