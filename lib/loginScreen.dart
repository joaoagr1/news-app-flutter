import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'result_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> login(String identifier, String password) async {
    final url = Uri.parse('http://10.220.222.110:8585/auth/login'); // Substitua pela URL da sua API
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'login': identifier, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final token = responseData['token'];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(token: token),
        ),
      );
    } else {
      setState(() {
        _errorMessage = 'Falha no login. Verifique suas credenciais.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _identifierController,
              decoration: InputDecoration(labelText: 'Login ou Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                login(_identifierController.text, _passwordController.text);
              },
              child: Text('Entrar'),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
