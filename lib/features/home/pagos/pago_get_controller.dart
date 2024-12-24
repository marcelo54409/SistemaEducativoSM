import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tmkt3_app/core/services/api_dio.dart';
import 'package:tmkt3_app/features/home/padres/model/padre_model.dart';
import 'package:tmkt3_app/features/home/pagos/model/pago_model.dart';

class PagoController {
  ApiService api = ApiService();
  BuildContext? context;

  Future init(BuildContext context) async {
    this.context = context;
  }

  Future<List<PagoModel>> getPagos() async {
    try {
      var response = await api.getRequest('/pago');
      if (response != null) {
        List<PagoModel> pagos = [];
        for (var item in response) {
          pagos.add(PagoModel.fromJson(item));
        }
        return pagos;
      } else {
        showMessage("Error al obtener la lista de pagos", isError: true);
      }
    } catch (e) {
      log("Error en getPagos: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
    return [];
  }

  Future<List<PadreModel>> getPadres() async {
    try {
      var response = await api.getRequest('/padres');
      if (response != null) {
        List<PadreModel> padres = [];
        for (var item in response) {
          padres.add(PadreModel.fromMap(item));
        }
        return padres;
      } else {
        showMessage("Error al obtener la lista de pagos", isError: true);
      }
    } catch (e) {
      log("Error en getPagos: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
    return [];
  }

  Future<void> createPago(PagoModel pago) async {
    try {
      var response = await api.postRequest('/pago', pago.toJson());
      if (response != null) {
        Navigator.of(context!).pop();
        showMessage("Pago registrado con éxito");
      } else {
        Navigator.of(context!).pop();
        showMessage(
          response?['message'] ?? "Error al registrar el pago",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en createPago: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
  }

  Future<void> updatePago(PagoModel pago) async {
    try {
      var response =
          await api.putRequest('/pago/${pago.idPago}', pago.toJson());
      if (response != null) {
        Navigator.of(context!).pop();
        showMessage("Pago actualizado con éxito");
      } else {
        Navigator.of(context!).pop();
        showMessage(
          response?['message'] ?? "Error al actualizar el pago",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en updatePago: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
  }

  Future<void> deletePago(int id) async {
    try {
      var response = await api.deleteRequest('/pago/$id');
      if (response != null) {
        showMessage(
          response?['message'] ?? "Error al eliminar el pago",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en deletePago: $e");
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
