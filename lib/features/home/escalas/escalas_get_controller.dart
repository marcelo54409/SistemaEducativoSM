import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tmkt3_app/core/services/api_dio.dart';
import 'package:tmkt3_app/features/home/escalas/model/escalas_model.dart';

class EscalasController {
  ApiService api = ApiService();
  BuildContext? context;

  Future init(BuildContext context) async {
    this.context = context;
  }

  Future<List<EscalasModel>> getEscalas() async {
    try {
      var response = await api.getRequest('/escala');
      if (response != null) {
        print(response.toString());
        List<EscalasModel> escalas = [];
        for (var item in response) {
          print(item.toString());
          escalas.add(EscalasModel.fromJson(item));
          print("seguimo");
        }
        return escalas;
      } else {
        showMessage("Error al obtener la lista de escalas", isError: true);
      }
    } catch (e) {
      log("Error en getEscalas: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
    return [];
  }

  Future<void> createEscala(EscalasModel escala) async {
    try {
      var response = await api.postRequest('/escala', escala.toJson());
      if (response != null) {
        Navigator.of(context!).pop();
        showMessage("Escala registrada con éxito");
      } else {
        Navigator.of(context!).pop();
        showMessage(
          response?['message'] ?? "Error al registrar la escala",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en createEscala: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
  }

  Future<void> updateEscala(EscalasModel escala) async {
    try {
      var response =
          await api.putRequest('/escala/${escala.idEscala}', escala.toJson());
      if (response != null) {
        Navigator.of(context!).pop();
        showMessage("Escala actualizada con éxito");
      } else {
        Navigator.of(context!).pop();
        showMessage(
          response?['message'] ?? "Error al actualizar la escala",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en updateEscala: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
  }

  Future<void> deleteEscala(int id) async {
    try {
      var response = await api.deleteRequest('/escala/$id');
      if (response != null) {
        showMessage(
          response?['message'] ?? "Error al eliminar la escala",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en deleteEscala: $e");
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
