// lib/forgot_password_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'models/reset_password.screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  String _message = '';

  Future<void> sendResetEmail() async {
    final url = Uri.parse('http://192.168.0.24:8585/auth/forgot-password?email=${_emailController.text.trim()}');
    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => ResetPasswordScreen(email: _emailController.text.trim()),
          ),
        );
      } else {
        setState(() {
          _message = 'Erro ao enviar email de recuperação.';
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
        middle: Text('Recuperar Senha'),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoTextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              placeholder: "E-mail",
              padding: EdgeInsets.all(16),
            ),
            SizedBox(height: 20),
            CupertinoButton.filled(
              child: Text("Enviar Email de Recuperação"),
              onPressed: sendResetEmail,
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