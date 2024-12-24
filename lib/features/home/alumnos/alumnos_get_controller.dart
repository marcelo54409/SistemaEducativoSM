import 'dart:developer';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:tmkt3_app/core/services/api_dio.dart';
import 'package:tmkt3_app/features/home/alumnos/model/alumno_model.dart';

class AlumnosGetController {
  ApiService api = ApiService();
  BuildContext? context;

  Future init(BuildContext context) async {
    this.context = context;
  }

  Future getAlumnos({bool includeDropdown = false}) async {
    try {
      var response = await api.getRequest('/alumnos');
      if (response != null) {
        List<AlumnoModelo> alumnos = [];
        List<DropDownValueModel> dropdownAlumnos = [];
        for (var item in response) {
          final alumno = AlumnoModelo.fromJson(item);
          alumnos.add(alumno);
          dropdownAlumnos.add(DropDownValueModel(
            value:
                alumno.id, // Asumiendo que `idAlumno` existe en `AlumnoModelo`
            name:
                "${alumno.primerNombre} ${alumno.apellidoPaterno}", // Asumiendo que `nombreCompleto` existe en `AlumnoModelo`
          ));
        }
        // Retorna según el parámetro includeDropdown
        if (includeDropdown) {
          return {'alumnos': alumnos, 'dropdown': dropdownAlumnos};
        } else {
          return alumnos;
        }
      } else {
        showMessage("Error al obtener la lista de alumnos", isError: true);
      }
    } catch (e) {
      log("Error en getAlumnos: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
    return includeDropdown ? {'alumnos': [], 'dropdown': []} : [];
  }

  Future<void> createAlumno(AlumnoModelo alumno) async {
    try {
      var response = await api.postRequest('/alumnos', alumno.toJson());
      log(response.toString());
      if (response != null) {
        log(response.toString());
        Navigator.of(context!).pop();

        showMessage("Alumno registrado con éxito");
      } else {
        Navigator.of(context!).pop();
        showMessage(
          response?['message'] ?? "Error al registrar al alumno",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en createAlumno: $e");
      showMessage("Error de conexión al servidor", isError: true);
    }
  }

  Future<void> updateAlumno(AlumnoModelo alumno) async {
    try {
      var response =
          await api.putRequest('/alumnos/${alumno.id}', alumno.toJson());
      if (response != null) {
        Navigator.of(context!).pop();
        showMessage("Alumno actualizado con éxito");
      } else {
        Navigator.of(context!).pop();
        showMessage(
          response?['message'] ?? "Error al actualizar al alumno",
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
      var response = await api.deleteRequest('/alumnos/$id');
      if (response != null) {
        showMessage(
          response?['message'] ?? "Error al eliminar al alumno",
          isError: true,
        );
      }
    } catch (e) {
      log("Error en deleteAlumno: $e");
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
