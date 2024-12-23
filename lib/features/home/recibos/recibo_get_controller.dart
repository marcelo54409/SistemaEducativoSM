import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tmkt3_app/core/services/api_dio.dart';
import 'package:tmkt3_app/features/home/recibos/model/recibo_model.dart';

class ReciboController {
  ApiService api = ApiService();
  BuildContext? context;

  Future init(BuildContext context) async {
    this.context = context;
  }

  Future<List<ReciboModel>> getRecibos() async {
    try {
      var response = await api.getRequest('/recibo');
      if (response != null) {
        List<ReciboModel> recibos = [];
        for (var item in response) {
          recibos.add(ReciboModel.fromJson(item));
        }
        return recibos;
      } else {
        showMessage("Error al obtener la lista de recibos", isError: true);
      }
    } catch (e) {
      log("Error en getRecibos: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
    return [];
  }

  Future<void> createRecibo(ReciboModel recibo) async {
    try {
      var response = await api.postRequest('/recibo', recibo.toJson());
      if (response != null) {
        Navigator.of(context!).pop();
        showMessage("Recibo registrado con éxito");
      } else {
        Navigator.of(context!).pop();
        showMessage(
          response?['message'] ?? "Error al registrar el recibo",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en createRecibo: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
  }

  Future<void> updateRecibo(ReciboModel recibo) async {
    try {
      var response =
          await api.putRequest('/recibo/${recibo.idRecibo}', recibo.toJson());
      if (response != null) {
        Navigator.of(context!).pop();
        showMessage("Recibo actualizado con éxito");
      } else {
        Navigator.of(context!).pop();
        showMessage(
          response?['message'] ?? "Error al actualizar el recibo",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en updateRecibo: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
  }

  Future<void> deleteRecibo(int id) async {
    try {
      var response = await api.deleteRequest('/recibo/$id');
      if (response != null) {
        showMessage(
          response?['message'] ?? "Error al eliminar el recibo",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en deleteRecibo: $e");
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
