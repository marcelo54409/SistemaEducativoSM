import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tmkt3_app/core/services/api_dio.dart';
import 'package:tmkt3_app/features/home/asignacion_concepto/model/asig_concepto_model.dart';

class AsignarConceptoController {
  ApiService api = ApiService();
  BuildContext? context;

  Future init(BuildContext context) async {
    this.context = context;
  }

  // Método para obtener todas las asignaciones de conceptos
  Future<List<AsignarConceptoModel>> getAsignacionesConcepto() async {
    try {
      var response = await api.getRequest('/asignar_concepto');
      if (response != null) {
        List<AsignarConceptoModel> asignaciones = [];
        for (var item in response) {
          asignaciones.add(AsignarConceptoModel.fromJson(item));
        }
        return asignaciones;
      } else {
        showMessage("Error al obtener la lista de asignaciones de conceptos",
            isError: true);
      }
    } catch (e) {
      log("Error en getAsignacionesConcepto: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
    return [];
  }

  // Método para crear una nueva asignación de concepto
  Future<void> createAsignacionConcepto(AsignarConceptoModel asignacion) async {
    try {
      var response =
          await api.postRequest('/asignar_concepto', asignacion.toJson());
      if (response != null) {
        Navigator.of(context!).pop();
        showMessage("Asignación de concepto registrada con éxito");
      } else {
        Navigator.of(context!).pop();
        showMessage(
          response?['message'] ??
              "Error al registrar la asignación de concepto",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en createAsignacionConcepto: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
  }

  // Método para actualizar una asignación de concepto existente
  Future<void> updateAsignacionConcepto(AsignarConceptoModel asignacion) async {
    try {
      var response = await api.putRequest(
          '/asignar_concepto/${asignacion.idAsignarConcepto}',
          asignacion.toJson());
      if (response != null) {
        Navigator.of(context!).pop();
        showMessage("Asignación de concepto actualizada con éxito");
      } else {
        Navigator.of(context!).pop();
        showMessage(
          response?['message'] ??
              "Error al actualizar la asignación de concepto",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en updateAsignacionConcepto: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
  }

  // Método para eliminar una asignación de concepto
  Future<void> deleteAsignacionConcepto(int id) async {
    try {
      var response = await api.deleteRequest('/asignar_concepto/$id');
      if (response != null) {
        showMessage(
          response?['message'] ?? "Asignación de concepto eliminada con éxito",
        );
      } else {
        showMessage(
          response?['message'] ?? "Error al eliminar la asignación de concepto",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en deleteAsignacionConcepto: $e");
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
