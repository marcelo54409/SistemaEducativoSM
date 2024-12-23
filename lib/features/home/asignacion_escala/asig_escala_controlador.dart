import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tmkt3_app/core/services/api_dio.dart';
import 'package:tmkt3_app/features/home/asignacion_escala/model/asig_escala_model.dart';

class AsigEscalaController {
  ApiService api = ApiService();
  BuildContext? context;

  Future init(BuildContext context) async {
    this.context = context;
  }

  // Método para obtener todas las asignaciones de escala
  Future<List<AsigEscalaModel>> getAsignacionesEscala() async {
    try {
      var response = await api.getRequest('/asignar_escala');
      if (response != null) {
        List<AsigEscalaModel> asignaciones = [];
        for (var item in response) {
          asignaciones.add(AsigEscalaModel.fromJson(item));
        }
        return asignaciones;
      } else {
        showMessage("Error al obtener la lista de asignaciones de escala",
            isError: true);
      }
    } catch (e) {
      log("Error en getAsignacionesEscala: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
    return [];
  }

  // Método para crear una nueva asignación de escala
  Future<void> createAsignacionEscala(AsigEscalaModel asignacion) async {
    try {
      var response =
          await api.postRequest('/asignar_escala', asignacion.toJson());
      if (response != null) {
        Navigator.of(context!).pop();
        showMessage("Asignación de escala registrada con éxito");
      } else {
        Navigator.of(context!).pop();
        showMessage(
          response?['message'] ?? "Error al registrar la asignación de escala",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en createAsignacionEscala: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
  }

  // Método para actualizar una asignación de escala existente
  Future<void> updateAsignacionEscala(AsigEscalaModel asignacion) async {
    try {
      var response = await api.putRequest(
          '/asignar_escala/${asignacion.idAsignarEscala}', asignacion.toJson());
      if (response != null) {
        Navigator.of(context!).pop();
        showMessage("Asignación de escala actualizada con éxito");
      } else {
        Navigator.of(context!).pop();
        showMessage(
          response?['message'] ?? "Error al actualizar la asignación de escala",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en updateAsignacionEscala: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
  }

  // Método para eliminar una asignación de escala
  Future<void> deleteAsignacionEscala(int id) async {
    try {
      var response = await api.deleteRequest('/asignar_escala/$id');
      if (response != null) {
        showMessage(
          response?['message'] ?? "Asignación de escala eliminada con éxito",
        );
      } else {
        showMessage(
          response?['message'] ?? "Error al eliminar la asignación de escala",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en deleteAsignacionEscala: $e");
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
