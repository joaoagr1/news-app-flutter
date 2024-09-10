// lib/success_screen.dart
import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final String token;

  SuccessScreen({required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Bem-sucedido'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login realizado com sucesso!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Seu token é:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              token,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
