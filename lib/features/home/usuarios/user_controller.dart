import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tmkt3_app/core/services/api_dio.dart';
import 'package:tmkt3_app/features/home/usuarios/model/user_model.dart';

class UserController {
  ApiService api = ApiService();
  BuildContext? context;

  Future init(BuildContext context) async {
    this.context = context;
  }

  // Método para obtener todos los usuarios
  Future<List<UserModel>> getUsers() async {
    try {
      var response = await api.getRequest('/auth/users');
      if (response != null) {
        response = response['data'];
        List<UserModel> users = [];
        for (var item in response) {
          users.add(UserModel.fromMap(item));
        }
        return users;
      } else {
        showMessage("Error al obtener la lista de usuarios", isError: true);
      }
    } catch (e) {
      log("Error en getUsers: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
    return [];
  }

  // Método para crear un nuevo usuario
  Future<void> createUser(UserModel user) async {
    try {
      var response = await api.postRequest('/users', user.toMap());
      if (response != null) {
        Navigator.of(context!).pop();
        showMessage("Usuario registrado con éxito");
      } else {
        Navigator.of(context!).pop();
        showMessage(
          response?['message'] ?? "Error al registrar el usuario",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en createUser: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
  }

  // Método para actualizar un usuario existente
  Future<void> updateUser(UserModel user) async {
    try {
      var response = await api.putRequest('/users/${user.id}', user.toMap());
      if (response != null) {
        Navigator.of(context!).pop();
        showMessage("Usuario actualizado con éxito");
      } else {
        Navigator.of(context!).pop();
        showMessage(
          response?['message'] ?? "Error al actualizar el usuario",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en updateUser: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
  }

  // Método para eliminar un usuario
  Future<void> deleteUser(int id) async {
    try {
      var response = await api.deleteRequest('/users/$id');
      if (response != null) {
        showMessage(
          response?['message'] ?? "Usuario eliminado con éxito",
        );
      } else {
        showMessage(
          response?['message'] ?? "Error al eliminar el usuario",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en deleteUser: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
  }

  // Método para mostrar mensajes al usuario
  void showMessage(String message, {bool isError = false}) {
    if (context != null) {
      showDialog(
        context: context!,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text("Información", style: TextStyle(color: Colors.black)),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cerrar"),
              ),
            ],
          );
        },
      );
    }
  }
}
