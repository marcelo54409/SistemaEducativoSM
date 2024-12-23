import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tmkt3_app/core/services/api_dio.dart';
import 'package:tmkt3_app/features/home/condonacion/model/concepto_model.dart';

class CondonacionController {
  ApiService api = ApiService();
  BuildContext? context;

  Future init(BuildContext context) async {
    this.context = context;
  }

  Future<List<CondonacionModel>> getCondonaciones() async {
    try {
      var response = await api.getRequest('/condonaciones');
      if (response != null) {
        List<CondonacionModel> condonaciones = [];
        for (var item in response) {
          condonaciones.add(CondonacionModel.fromJson(item));
        }
        return condonaciones;
      } else {
        showMessage("Error al obtener la lista de condonaciones",
            isError: true);
      }
    } catch (e) {
      log("Error en getCondonaciones: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
    return [];
  }

  Future<void> createCondonacion(CondonacionModel condonacion) async {
    try {
      var response =
          await api.postRequest('/condonaciones', condonacion.toJson());
      if (response != null) {
        Navigator.of(context!).pop();
        showMessage("Condonación registrada con éxito");
      } else {
        Navigator.of(context!).pop();
        showMessage(
          response?['message'] ?? "Error al registrar la condonación",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en createCondonacion: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
  }

  Future<void> updateCondonacion(CondonacionModel condonacion) async {
    try {
      var response = await api.putRequest(
          '/condonaciones/${condonacion.idCondonacion}', condonacion.toJson());
      if (response != null) {
        Navigator.of(context!).pop();
        showMessage("Condonación actualizada con éxito");
      } else {
        Navigator.of(context!).pop();
        showMessage(
          response?['message'] ?? "Error al actualizar la condonación",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en updateCondonacion: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
  }

  Future<void> deleteCondonacion(int id) async {
    try {
      var response = await api.deleteRequest('/condonaciones/$id');
      if (response != null) {
        showMessage(
          response?['message'] ?? "Error al eliminar la condonación",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en deleteCondonacion: $e");
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
