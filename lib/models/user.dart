import 'dart:convert';

class User {
  final String id;
  final String email;
  final List<String> permissions;

  User({required this.id, required this.email, required this.permissions});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        email: json['email'],
        permissions: (json['permissions'] as List).map((e) => e.toString()).toList());
  }
}
