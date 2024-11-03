import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/models/succes_dialog.dart';
import 'package:newsapp/models/user.dart';
import 'dart:convert';
import '../screens/result_screen.dart';
import 'category.dart';

class CreateNewsScreen extends StatefulWidget {
  final String token;
  final User user;

  CreateNewsScreen({required this.token, required this.user});

  @override
  _CreateNewsScreenState createState() => _CreateNewsScreenState();
}

class _CreateNewsScreenState extends State<CreateNewsScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  List<Category> _categories = [];
  Category? _selectedCategory;
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

  Future<void> _createNews() async {
    final url = Uri.parse('http://192.168.0.24:8585/news/create');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: json.encode({
        'title': _titleController.text,
        'content': _contentController.text,
        'categoryId': _selectedCategory?.id,
      }),
    );

    if (response.statusCode == 200) {
      showCupertinoDialog(
        context: context,
        builder: (context) => SuccessDialog(
          message: 'News created successfully',
          onOkPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ResultScreen(token: widget.token, user: widget.user),
              ),
            );
          },
        ),
      );
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create News')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
            ),
            DropdownButton<Category>(
              hint: Text('Select Category'),
              value: _selectedCategory,
              onChanged: (Category? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              items: _categories.map((Category category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Text(category.nome),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createNews,
              child: Text('Create News'),
            ),
          ],
        ),
      ),
    );
  }
}