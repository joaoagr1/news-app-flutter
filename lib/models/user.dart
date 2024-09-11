// lib/models/user.dart
class User {
  final String id;
  final String login;
  final String email;
  final String role;

  User({
    required this.id,
    required this.login,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      login: json['login'],
      email: json['email'],
      role: json['role'],
    );
  }
}