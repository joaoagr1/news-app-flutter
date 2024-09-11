// lib/login_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'models/user.dart';
import 'register_screen.dart';
import 'result_screen.dart';
// import 'reset_password.page.dart';

const Color primaryColor = Colors.lightGreen;
const Color secondaryColor = Colors.white;

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
      MaterialPageRoute(
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
    return Scaffold(
      body: Stack(
        children: [
          Container(color: secondaryColor),
          CustomPaint(
            painter: CurvePainter(),
            child: Container(),
          ),
          Container(
            padding: EdgeInsets.only(top: 100, left: 40, right: 40),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  width: 230,
                  height: 230,
                  //child: Image.asset("lib/assets/logo.png"),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _loginController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "E-mail",
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Senha",
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  height: 40,
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: Text("Recuperar Senha",
                      style: TextStyle(color: Colors.white),
                    ),

                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ResetPasswordPage(),
                      //   ),
                      // );
                    },
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: SizedBox.expand(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shadowColor: Colors.transparent,
                      ),
                      child: Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: secondaryColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      onPressed: login,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: SizedBox.expand(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor,
                      ),
                      child: Center(
                        child: Text(
                          "Cadastre-se",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      onPressed: _navigateToRegisterScreen,
                    ),
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
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  void _navigateToRegisterScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = primaryColor;
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(size.width / 2, size.height * 0.2, size.width, size.height * 0.2);
    path.lineTo(size.width, size.height);
    path.lineTo(2, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}