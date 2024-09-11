// lib/register_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const Color primaryColor = Colors.lightGreen;
const Color secondaryColor = Colors.white;

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
    return Scaffold(
      body: Stack(
        children: [
          Container(color: secondaryColor),
          CustomPaint(
            painter: CurvePainter(),
            child: Container(),
          ),
          Container(
            padding: EdgeInsets.only(top: 60, left: 40, right: 40),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  width: 230,
                  height: 230,
                  child: Image.asset("lib/assets/logo.png"),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _loginController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Login",
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
                SizedBox(height: 10),
                TextFormField(
                  controller: _documentController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Documento",
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
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  style: TextStyle(fontSize: 20),
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
                          "Cadastrar",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: secondaryColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      onPressed: register,
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