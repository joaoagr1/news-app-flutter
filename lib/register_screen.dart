// lib/register_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _documentController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _errorMessage = '';

  Future<void> register() async {
    final url = Uri.parse('http://192.168.0.24:8585/auth/register');
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
      Navigator.pop(context);
    } else {
      final responseData = json.decode(response.body);
      setState(() {
        _errorMessage = responseData['error'] ?? 'Falha no cadastro. Verifique as informações.';
      });
    }
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
                SizedBox(height: 10),
                if (_errorMessage.isNotEmpty) _buildErrorText(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        _errorMessage,
        style: const TextStyle(color: CupertinoColors.systemRed),
      ),
    );
  }
}