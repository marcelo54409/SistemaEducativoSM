import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tmkt3_app/core/services/api_dio.dart';
import 'package:tmkt3_app/features/home/alumnos/model/alumno_model.dart';
import 'package:tmkt3_app/features/home/deuda/model/deuda_model.dart';

class DeudaController {
  ApiService api = ApiService();
  BuildContext? context;

  Future init(BuildContext context) async {
    this.context = context;
  }

  Future<List<DeudaModel>> getDeudasWithAlumnoNames() async {
    try {
      var responseDeudas = await api.getRequest('/deuda');
      var responseAlumnos = await api.getRequest('/alumnos');

      if (responseDeudas != null && responseAlumnos != null) {
        Map<int, String> alumnosMap = {
          for (var alumno in responseAlumnos)
            alumno['idAlumno']:
                "${alumno['primerNombre']} ${alumno["ApellidoPaterno"]}" ??
                    'Desconocido'
        };

        // Vincular nombres de alumnos a las deudas
        List<DeudaModel> deudas = [];
        for (var item in responseDeudas) {
          final deuda = DeudaModel.fromJson(item);
          deuda.nombreAlumno = alumnosMap[deuda.idAlumno] ?? 'Desconocido';
          deudas.add(deuda);
        }
        return deudas;
      } else {
        showMessage("Error al obtener la lista de deudas o alumnos",
            isError: true);
      }
    } catch (e) {
      print("Error en getDeudasWithAlumnoNames: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
    return [];
  }

  Future<void> createDeuda(DeudaModel deuda) async {
    try {
      var response = await api.postRequest('/deuda', deuda.toJson());
      if (response != null) {
        Navigator.of(context!).pop();
        showMessage("Deuda registrada con éxito");
      } else {
        Navigator.of(context!).pop();
        showMessage(
          response?['message'] ?? "Error al registrar la deuda",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en createDeuda: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
  }

  Future<void> updateDeuda(DeudaModel deuda) async {
    try {
      var response =
          await api.putRequest('/deuda/${deuda.idDeuda}', deuda.toJson());
      if (response != null) {
        Navigator.of(context!).pop();
        showMessage("Deuda actualizada con éxito");
      } else {
        Navigator.of(context!).pop();
        showMessage(
          response?['message'] ?? "Error al actualizar la deuda",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en updateDeuda: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
  }

  Future<void> deleteDeuda(int id) async {
    try {
      var response = await api.deleteRequest('/deuda/$id');
      if (response != null) {
        showMessage(
          response?['message'] ?? "Error al eliminar la deuda",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en deleteDeuda: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
  }

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
