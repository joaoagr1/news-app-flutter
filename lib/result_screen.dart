import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String token;

  ResultScreen({required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resultado do Login')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login bem-sucedido!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Token JWT:',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                token,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
