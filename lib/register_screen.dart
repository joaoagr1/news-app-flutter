// lib/register_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'error_dialog.dart';
import 'models/succes_dialog.dart';


class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _documentController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> register() async {
    final url = Uri.parse('http://192.168.0.24:8585/auth/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'login': _loginController.text,
          'password': _passwordController.text,
          'document': _documentController.text,
          'email': _emailController.text,
          'role': 'USER',
        }),
      );

      if (response.statusCode == 200) {
        _showSuccessDialog('Cadastro realizado com sucesso. Um email de confirmação foi enviado.');
      } else {
        final responseData = json.decode(response.body);
        _showErrorDialog(responseData['error'] ?? 'Falha no cadastro. Verifique as informações.');
      }
    } catch (e) {
      _showErrorDialog('Erro ao conectar ao servidor. Tente novamente mais tarde.');
    }
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => ErrorDialog(message: message),
    );
  }

  void _showSuccessDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => SuccessDialog(
        message: message,
        onOkPressed: () {
          Navigator.of(context).pop(); // Close the dialog
          Navigator.of(context).pop(); // Navigate back to login screen
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Register'),
      ),
      child: Stack(
        children: [
          Container(color: CupertinoColors.systemBackground),
          Container(
            padding: EdgeInsets.only(top: 60, left: 40, right: 40),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 20),
                CupertinoTextField(
                  controller: _loginController,
                  keyboardType: TextInputType.text,
                  placeholder: "Login",
                  padding: EdgeInsets.all(16),
                ),
                SizedBox(height: 10),
                CupertinoTextField(
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  placeholder: "Senha",
                  padding: EdgeInsets.all(16),
                ),
                SizedBox(height: 10),
                CupertinoTextField(
                  controller: _documentController,
                  keyboardType: TextInputType.text,
                  placeholder: "Documento",
                  padding: EdgeInsets.all(16),
                ),
                SizedBox(height: 10),
                CupertinoTextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  placeholder: "Email",
                  padding: EdgeInsets.all(16),
                ),
                SizedBox(height: 40),
                CupertinoButton.filled(
                  child: Center(
                    child: Text(
                      "Cadastrar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  onPressed: register,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}