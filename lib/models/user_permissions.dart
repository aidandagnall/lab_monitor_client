import 'dart:convert';

class UserPermissions {
  final bool admin;
  final List<String> permissions;

  UserPermissions(this.admin, this.permissions);

  factory UserPermissions.fromJson(Map<String, dynamic> json) {
    final perms = UserPermissions(
      json['admin'] ?? false,
      (json['permissions'] as List).map((e) => e.toString()).toList(),
    );
    return perms;
  }
}
