// lib/login_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'forgot_password_screen.dart';
import 'models/user.dart';
import 'register_screen.dart';
import 'result_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> login() async {
    final url = Uri.parse('http://192.168.0.24:8585/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'login': _loginController.text.trim(),
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        _navigateToResultScreen(response);
      } else {
        _handleError(response);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao conectar ao servidor. Tente novamente mais tarde.';
      });
    }
  }

  void _navigateToResultScreen(http.Response response) {
    final responseData = json.decode(response.body);
    final token = responseData['token'];
    final user = User.fromJson(responseData['users']);

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => ResultScreen(token: token, user: user),
      ),
    );
  }

  void _handleError(http.Response response) {
    final responseData = json.decode(response.body);
    setState(() {
      _errorMessage = responseData['error'] ?? 'Falha no login. Verifique suas credenciais.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Login'),
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
                  keyboardType: TextInputType.emailAddress,
                  placeholder: "E-mail",
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
                Container(
                  height: 40,
                  alignment: Alignment.centerRight,
                  child: CupertinoButton(
                    child: Text("Recuperar Senha"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => ForgotPasswordScreen(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  child: CupertinoButton.filled(
                    child: Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    onPressed: login,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  child: CupertinoButton(
                    color: CupertinoColors.systemGrey,
                    child: Center(
                      child: Text(
                        "Cadastre-se",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    onPressed: _navigateToRegisterScreen,
                  ),
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

  void _navigateToRegisterScreen() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => RegisterScreen()),
    );
  }
}