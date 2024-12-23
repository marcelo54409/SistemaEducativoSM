import 'dart:convert';

import 'package:tmkt3_app/features/auth/model/role_model.dart';

class UserModel {
  final String token;
  final User user;

  UserModel({
    required this.token,
    required this.user,
  });

  // Factory constructor para crear el objeto desde un JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['data']['token'],
      user: User.fromJson(json['data']['user']),
    );
  }

  // Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
    };
  }
}

class User {
  final int userId;
  final String email;
  final String username;
  final int roleId;
  final String createdAt;
  final String updatedAt;

  User({
    required this.userId,
    required this.email,
    required this.username,
    required this.roleId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['id'],
      email: json['email'],
      username: json['username'],
      roleId: json['roleId'] ?? 1,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'email': email,
      'username': username,
      'roleId': roleId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
