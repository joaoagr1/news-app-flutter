import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class MockClient extends Mock implements http.Client {}

Future<List<User>> fetchActiveUsers(http.Client client) async {
  final response = await client.get(Uri.parse('http://example.com/api/users'));

  if (response.statusCode == 200) {
    final List<dynamic> usersJson = json.decode(response.body);
    return usersJson
        .map((json) => User.fromJson(json))
        .where((user) => user.isActive)
        .toList();
  } else {
    throw Exception('Failed to load users');
  }
}

class User {
  final String name;
  final bool isActive;

  User({required this.name, required this.isActive});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      isActive: json['isActive'],
    );
  }
}

void main() {
  test('fetchActiveUsers retorna apenas usuários ativos', () async {

    final client = MockClient();


    final response = [
      {'name': 'User 1', 'isActive': true},
      {'name': 'User 2', 'isActive': false},
      {'name': 'User 3', 'isActive': true},
    ];


    when(client.get(Uri.parse('http://example.com/api/users')))
        .thenAnswer((_) async => http.Response(json.encode(response), 200));


    final activeUsers = await fetchActiveUsers(client);


    expect(activeUsers.length, 2);
    expect(activeUsers[0].name, 'User 1');
    expect(activeUsers[1].name, 'User 3');
    expect(activeUsers.every((user) => user.isActive), isTrue);
  });
}
