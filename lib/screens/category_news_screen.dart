import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/news.dart';
import '../components/dialog/news_card.dart';

class CategoryNewsScreen extends StatefulWidget {
  final int categoryId;

  CategoryNewsScreen({required this.categoryId});

  @override
  _CategoryNewsScreenState createState() => _CategoryNewsScreenState();
}

class _CategoryNewsScreenState extends State<CategoryNewsScreen> {
  List<News> _newsList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNewsByCategory();
  }

  Future<void> _fetchNewsByCategory() async {
    final url = Uri.parse('http://192.168.0.24:8585/news/listByCategory/${widget.categoryId}');
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
        title: Text('News by Category'),
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
    );
  }
}