import 'dart:convert';

import 'package:tmkt3_app/features/auth/model/role_model.dart';

class UserModel {
  final String token;
  final User user;
  final Role role;

  UserModel({
    required this.token,
    required this.user,
    required this.role,
  });

  // Factory constructor para crear el objeto desde un JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['data']['token'],
      user: User.fromJson(json['data']['user']),
      role: Role.fromJson(json['data']['role']),
    );
  }

  // Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
      'role': role.toJson(),
    };
  }
}

class User {
  final int userId;
  final String businessName;
  final String name;
  final String jobTitle;
  final int phone;
  final String email;
  final String username;
  final int roleId;
  final String createdAt;
  final String updatedAt;

  User({
    required this.userId,
    required this.businessName,
    required this.name,
    required this.jobTitle,
    required this.phone,
    required this.email,
    required this.username,
    required this.roleId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      businessName: json['businessName'],
      name: json['name'],
      jobTitle: json['jobTitle'],
      phone: json['phone'],
      email: json['email'],
      username: json['username'],
      roleId: json['roleId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'businessName': businessName,
      'name': name,
      'jobTitle': jobTitle,
      'phone': phone,
      'email': email,
      'username': username,
      'roleId': roleId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
