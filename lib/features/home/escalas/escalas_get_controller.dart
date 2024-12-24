import 'dart:developer';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:tmkt3_app/core/services/api_dio.dart';
import 'package:tmkt3_app/features/home/escalas/model/escalas_model.dart';

class EscalasController {
  ApiService api = ApiService();
  BuildContext? context;

  Future init(BuildContext context) async {
    this.context = context;
  }

  Future getEscalas({bool includeDropdown = false}) async {
    try {
      var response = await api.getRequest('/escala');
      if (response != null) {
        List<EscalasModel> escalas = [];
        List<DropDownValueModel> dropdownEscalas = [];
        for (var item in response) {
          final escala = EscalasModel.fromJson(item);
          escalas.add(escala);
          dropdownEscalas.add(DropDownValueModel(
            value: escala
                .idEscala, // Asumiendo que `idEscala` existe en `EscalasModel`
            name: escala
                .descripcion, // Asumiendo que `nombreEscala` existe en `EscalasModel`
          ));
        }
        // Retorna según el parámetro includeDropdown
        if (includeDropdown) {
          return {'escalas': escalas, 'dropdown': dropdownEscalas};
        } else {
          return escalas;
        }
      } else {
        showMessage("Error al obtener la lista de escalas", isError: true);
      }
    } catch (e) {
      log("Error en getEscalas: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
    return includeDropdown ? {'escalas': [], 'dropdown': []} : [];
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
