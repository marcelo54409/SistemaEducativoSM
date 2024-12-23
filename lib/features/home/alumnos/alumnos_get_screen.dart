import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tmkt3_app/core/widgets/custom_text_formulario.dart';
import 'package:tmkt3_app/features/home/alumnos/alumnos_get_controller.dart';
import 'package:tmkt3_app/features/home/alumnos/model/alumno_model.dart';
import 'package:tmkt3_app/features/home/widgets/generic_list_screen.dart';

class AlumnosGetScreen extends StatefulWidget {
  @override
  State<AlumnosGetScreen> createState() => _AlumnosGetScreenState();
}

class _AlumnosGetScreenState extends State<AlumnosGetScreen> {
  final AlumnosGetController con = AlumnosGetController();
  List<AlumnoModelo> alumnos = [];
  List<AlumnoModelo> filteredAlumnos = [];
  bool isLoading = true;
  String? errorMessage;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await con.init(context);
      await _loadAlumnos();
    });
    searchController.addListener(() {
      _filterAlumnos(searchController.text);
    });
  }

  void _filterAlumnos(String query) {
    setState(() {
      filteredAlumnos = alumnos.where((alumno) {
        final fullName =
            "${alumno.primerNombre ?? ''} ${alumno.otrosNombres ?? ''}"
                .toLowerCase();
        return fullName.contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> _loadAlumnos() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      final response = await con.getAlumnos();
      setState(() {
        alumnos = response;
        filteredAlumnos = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _showRegisterForm(BuildContext context, {AlumnoModelo? alumno}) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nameController =
        TextEditingController(text: alumno?.primerNombre ?? '');
    final TextEditingController lastNameController =
        TextEditingController(text: alumno?.apellidoPaterno ?? '');
    final TextEditingController yearController =
        TextEditingController(text: alumno?.anio.toString() ?? '');
    final TextEditingController seccionController =
        TextEditingController(text: alumno?.seccion ?? '');
    final TextEditingController periodoController =
        TextEditingController(text: alumno?.periodo ?? '');
    final TextEditingController nameSecController =
        TextEditingController(text: alumno?.otrosNombres ?? '');
    final TextEditingController lastNameSecController =
        TextEditingController(text: alumno?.apellidoMaterno ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.36,
            padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 54),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  const Text(
                    "Registrar Alumno",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormulario(
                    hint: "Nombre",
                    controller: nameController,
                    validator: (value) =>
                        value!.isEmpty ? "Por favor, ingresa un nombre" : null,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormulario(
                    hint: "Segundo nombre",
                    controller: nameSecController,
                    validator: (value) =>
                        value!.isEmpty ? "Por favor, ingresa un nombre" : null,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormulario(
                    hint: "Apellido Paterno",
                    controller: lastNameController,
                    validator: (value) => value!.isEmpty
                        ? "Por favor, ingresa el apellido paterno"
                        : null,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormulario(
                    hint: "Apellido Materno",
                    controller: lastNameSecController,
                    validator: (value) => value!.isEmpty
                        ? "Por favor, ingresa el apellido materno"
                        : null,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormulario(
                    hint: "Año",
                    keyboardType: TextInputType.number,
                    controller: yearController,
                    validator: (value) =>
                        value!.isEmpty ? "Por favor, ingresa un año" : null,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormulario(
                    hint: "Sección",
                    controller: seccionController,
                    validator: (value) => value!.isEmpty
                        ? "Por favor, ingresa una sección"
                        : null,
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormulario(
                    hint: "Periodo",
                    controller: periodoController,
                    validator: (value) =>
                        value!.isEmpty ? "Por favor, ingresa un periodo" : null,
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final alumnos = AlumnoModelo(
                          id: alumno?.id ?? 0,
                          primerNombre: nameController.text,
                          otrosNombres: nameSecController.text,
                          apellidoPaterno: lastNameController.text,
                          apellidoMaterno: lastNameSecController.text,
                          anio: int.parse(yearController.text),
                          seccion: seccionController.text,
                          periodo: periodoController.text,
                          estado: "Activo",
                          imagenPerfil: "",
                        );

                        if (alumnos.id == 0) {
                          // Nuevo registro
                          await con.createAlumno(alumnos);
                        } else {
                          // Actualizar registro
                          await con.updateAlumno(alumnos);
                        }

                        await _loadAlumnos();
                      }
                    },
                    child: Text(alumno != null ? "Actualizar" : "Registrar"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final columns = [
      const DataColumn(label: Text("Nombre")),
      const DataColumn(label: Text("Apellido Paterno")),
      const DataColumn(label: Text("Año")),
      const DataColumn(label: Text("Sección")),
      const DataColumn(label: Text("Periodo")),
      const DataColumn(label: Text("Acciones")),
    ];

    final rows = filteredAlumnos
        .map(
          (alumno) => DataRow(cells: [
            DataCell(Text("${alumno.primerNombre} ${alumno.otrosNombres}")),
            DataCell(
                Text("${alumno.apellidoPaterno} ${alumno.apellidoMaterno}")),
            DataCell(Text(alumno.anio.toString())),
            DataCell(Text(alumno.seccion)),
            DataCell(Text(alumno.periodo)),
            DataCell(
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () {
                      _showRegisterForm(context, alumno: alumno);
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      log("Eliminar Alumno: ${alumno.id}");
                      await con.deleteAlumno(alumno.id.toString());
                      await _loadAlumnos();
                    },
                  ),
                ],
              ),
            ),
          ]),
        )
        .toList();

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : errorMessage != null
            ? Center(child: Text("Error: $errorMessage"))
            : GenericListScreen(
                searchController: searchController,
                title: "Lista de Alumnos",
                columns: columns,
                rows: rows,
                onAdd: () => _showRegisterForm(context),
                onExport: () {
                  log("Exportar PDF");
                },
              );
  }
}
