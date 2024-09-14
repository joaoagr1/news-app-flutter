// lib/reset_password_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:newsapp/models/succes_dialog.dart';

import '../error_dialog.dart';


class ResetPasswordScreen extends StatefulWidget {
  final String email;

  ResetPasswordScreen({required this.email});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _tokenController = TextEditingController();
  final _newPasswordController = TextEditingController();

  Future<void> resetPassword() async {
    final url = Uri.parse('http://192.168.0.24:8585/auth/reset-password');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'token': _tokenController.text.trim(),
          'newPassword': _newPasswordController.text,
        }),
      );

      if (response.statusCode == 200) {
        showCupertinoDialog(
          context: context,
          builder: (context) => SuccessDialog(
            message: 'Password changed successfully',
            onOkPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).pop(); // Navigate back to login screen
            },
          ),
        );
      } else {
        final responseData = json.decode(response.body);
        showCupertinoDialog(
          context: context,
          builder: (context) => ErrorDialog(
            message: responseData['error'] ?? 'Error changing the password.',
          ),
        );
      }
    } catch (e) {
      showCupertinoDialog(
        context: context,
        builder: (context) => ErrorDialog(
          message: 'Error connecting to the server. Please try again later.',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Reset password'),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoTextField(
              controller: _tokenController,
              placeholder: "Token",
              padding: EdgeInsets.all(16),
            ),
            SizedBox(height: 10),
            CupertinoTextField(
              controller: _newPasswordController,
              placeholder: "New Password",
              obscureText: true,
              padding: EdgeInsets.all(16),
            ),
            SizedBox(height: 20),
            CupertinoButton.filled(
              child: Text("Redefinir Senha"),
              onPressed: resetPassword,
            ),
          ],
        ),
      ),
    );
  }
}