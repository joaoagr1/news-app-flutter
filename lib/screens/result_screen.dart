import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'category_screen.dart';
import '../models/create_news_screen.dart';
import '../models/news.dart';
import '../models/user.dart';
import '../components/dialog/news_card.dart';
import '../components/dialog/user_dialog.dart';
import 'news_detail_screen.dart';

class ResultScreen extends StatefulWidget {
  final String token;
  final User user;

  const ResultScreen({super.key, required this.token, required this.user});

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
        title: const Text('News'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _newsList.length,
        itemBuilder: (context, index) {
          final news = _newsList[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailScreen(news: news),
                ),
              );
            },
            child: NewsCard(news: news),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
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
              showDialog(
                context: context,
                builder: (context) => UserDataDialog(user: widget.user),
              );
              break;
            case 1:
            // Navigate to All News
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryScreen(),
                ),
              );
              break;
          }
        },
      ),
      floatingActionButton: widget.user.role == 'ADMIN'
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateNewsScreen(token: widget.token, user: widget.user),
            ),
          );
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }
}