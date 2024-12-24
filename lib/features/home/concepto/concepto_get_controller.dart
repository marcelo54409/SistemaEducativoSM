import 'dart:developer';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:tmkt3_app/core/services/api_dio.dart';
import 'package:tmkt3_app/features/home/alumnos/model/alumno_model.dart';
import 'package:tmkt3_app/features/home/concepto/model/concepto_model.dart';

class ConceptoGetController {
  ApiService api = ApiService();
  BuildContext? context;

  Future init(BuildContext context) async {
    this.context = context;
  }

  Future getConceptos({bool includeDropdown = false}) async {
    try {
      var response = await api.getRequest('/concepto');
      if (response != null) {
        List<ConceptoModel> alumnos = [];
        List<DropDownValueModel> dropdownAlumnos = [];
        for (var item in response) {
          final concepto = ConceptoModel.fromJson(item);
          alumnos.add(concepto);
          dropdownAlumnos.add(DropDownValueModel(
            value: concepto.idConcepto,
            name: concepto.descripcion,
          ));
        }
        // Retorna según el parámetro includeDropdown
        if (includeDropdown) {
          return {'alumnos': alumnos, 'dropdown': dropdownAlumnos};
        } else {
          return alumnos;
        }
      } else {
        showMessage("Error al obtener la lista de conceptos", isError: true);
      }
    } catch (e) {
      log("Error en getConcepto: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
    return includeDropdown ? {'alumnos': [], 'dropdown': []} : [];
  }

  Future<void> createAlumno(ConceptoModel alumno) async {
    try {
      var response = await api.postRequest('/concepto', alumno.toJson());
      log(response.toString());
      if (response != null) {
        log(response.toString());
        Navigator.of(context!).pop();

        showMessage("Concepto registrado con éxito");
      } else {
        Navigator.of(context!).pop();
        showMessage(
          response?['message'] ?? "Error al registrar al concepto",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en createAlumno: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
  }

  Future<void> updateAlumno(ConceptoModel alumno) async {
    try {
      var response = await api.putRequest(
          '/concepto/${alumno.idConcepto}', alumno.toJson());
      if (response != null) {
        Navigator.of(context!).pop();
        showMessage("Alumno actualizado con éxito");
      } else {
        Navigator.of(context!).pop();
        showMessage(
          response?['message'] ?? "Error al actualizar al concepto",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en updateAlumno: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
  }

  Future<void> deleteAlumno(String id) async {
    try {
      var response = await api.deleteRequest('/concepto/$id');
      if (response != null) {
        showMessage(
          response?['message'] ?? "Error al eliminar al concepto",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en delete concepto: $e");
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
