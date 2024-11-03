import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'category_news_screen.dart';
import '../models/category.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final url = Uri.parse('http://192.168.0.24:8585/news/categories/list');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> categoriesJson = json.decode(response.body);
      setState(() {
        _categories = categoriesJson.map((json) => Category.fromJson(json)).toList();
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
        title: const Text('Categories'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              title: Text(category.nome, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              subtitle: Text(category.description, style: const TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryNewsScreen(categoryId: category.id),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}