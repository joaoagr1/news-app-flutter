import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final String token;

  const SuccessScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Bem-sucedido'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login realizado com sucesso!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Seu token é:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              token,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
