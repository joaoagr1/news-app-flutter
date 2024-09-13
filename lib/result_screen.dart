// lib/result_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'category_screen.dart';
import 'models/create_news_screen.dart';
import 'models/news.dart';
import 'models/user.dart';
import 'news_card.dart';
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
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _newsList.length,
              itemBuilder: (context, index) {
                final news = _newsList[index];
                return NewsCard(news: news);
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'All News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
        ],

          onTap: (index) {
            switch (index) {
              case 0:
              // Navigate to User Data
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
                break;
              case 1:
              // Navigate to All News
                break;
              case 2:
              // Navigate to Categories
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryScreen(),
                  ),
                );
                break;
            }
          }

      ),
      floatingActionButton: widget.user.role == 'ADMIN'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateNewsScreen(token: widget.token),
                  ),
                );
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}