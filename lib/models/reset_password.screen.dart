// lib/reset_password_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  ResetPasswordScreen({required this.email});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _tokenController = TextEditingController();
  final _newPasswordController = TextEditingController();
  String _message = '';

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
        setState(() {
          _message = 'Senha alterada com sucesso.';
        });
      } else {
        setState(() {
          _message = 'Erro ao alterar a senha.';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Erro ao conectar ao servidor. Tente novamente mais tarde.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Redefinir Senha'),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Email: ${widget.email}'),
            CupertinoTextField(
              controller: _tokenController,
              placeholder: "Token",
              padding: EdgeInsets.all(16),
            ),
            SizedBox(height: 10),
            CupertinoTextField(
              controller: _newPasswordController,
              placeholder: "Nova Senha",
              obscureText: true,
              padding: EdgeInsets.all(16),
            ),
            SizedBox(height: 20),
            CupertinoButton.filled(
              child: Text("Redefinir Senha"),
              onPressed: resetPassword,
            ),
            SizedBox(height: 20),
            if (_message.isNotEmpty)
              Text(
                _message,
                style: TextStyle(color: CupertinoColors.systemRed),
              ),
          ],
        ),
      ),
    );
  }
}