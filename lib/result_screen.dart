// lib/result_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/create_news_screen.dart';
import 'models/news.dart';
import 'models/user.dart';
import 'news_detail.dart';

class ResultScreen extends StatefulWidget {
  final String token;
  final User user;

  ResultScreen({required this.token, required this.user});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List<News> _newsList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    final url = Uri.parse('http://192.168.0.24:8585/news/list');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> newsJson = json.decode(response.body);
      setState(() {
        _newsList = newsJson.map((json) => News.fromJson(json)).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultado do Login'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'user_data') {
                // Show user data
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('User Data'),
                    content: Text('Login: ${widget.user.login}\nEmail: ${widget.user.email}\nRole: ${widget.user.role}'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              } else if (value == 'add_news' && widget.user.role == 'ADMIN') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateNewsScreen(token: widget.token),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'user_data',
                child: Text('User Data'),
              ),
              if (widget.user.role == 'ADMIN')
                PopupMenuItem(
                  value: 'add_news',
                  child: Text('Add News'),
                ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _newsList.length,
              itemBuilder: (context, index) {
                final news = _newsList[index];
                return ListTile(
                  title: Text(news.titulo),
                  subtitle: Text(news.categoria.nome),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailScreen(news: news),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}