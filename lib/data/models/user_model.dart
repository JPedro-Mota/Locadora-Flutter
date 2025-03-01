
import 'package:flutter_teste/enum/enum_role.dart';
class UsersModel {
  final int id;
  final String name;
  final String email;
  final String password;
  final EnumRole role;

  UsersModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.password,
  });

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '******',
      role: EnumRole.fromString(json['role'] as String),// Se não vier, define '******'
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.name, // Convertendo Enum para String
    };
  }
}