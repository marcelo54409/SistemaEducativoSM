import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tmkt3_app/core/widgets/custom_text_formulario.dart';
import 'package:tmkt3_app/features/home/asignacion_escala/asig_escala_controlador.dart';
import 'package:tmkt3_app/features/home/asignacion_escala/model/asig_escala_model.dart';
import 'package:tmkt3_app/features/home/widgets/generic_list_screen.dart';

class AsigEscalaScreen extends StatefulWidget {
  @override
  State<AsigEscalaScreen> createState() => _AsigEscalaScreenState();
}

class _AsigEscalaScreenState extends State<AsigEscalaScreen> {
  AsigEscalaController con = AsigEscalaController();
  final TextEditingController searchController = TextEditingController();
  List<AsigEscalaModel> asignaciones = [];
  List<AsigEscalaModel> filteredAsignaciones = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await con.init(context);
      await _loadAsignaciones();
    });
    searchController.addListener(() {
      _filterAsignaciones(searchController.text);
    });
  }

  void _filterAsignaciones(String query) {
    setState(() {
      filteredAsignaciones = asignaciones.where((asignacion) {
        final fullInfo =
            "${asignacion.idAlumno} ${asignacion.idEscala} ${asignacion.fechaAsignacion}"
                .toLowerCase();
        return fullInfo.contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> _loadAsignaciones() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      final response = await con.getAsignacionesEscala();
      setState(() {
        asignaciones = response;
        filteredAsignaciones = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void _showRegisterForm(BuildContext context,
        {AsigEscalaModel? asignacion}) {
      final _formKey = GlobalKey<FormState>();
      final TextEditingController idAlumno =
          TextEditingController(text: asignacion?.idAlumno.toString() ?? '');
      final TextEditingController idEscala =
          TextEditingController(text: asignacion?.idEscala.toString() ?? '');
      final TextEditingController fechaAsignacion =
          TextEditingController(text: asignacion?.fechaAsignacion ?? '');

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
              padding: EdgeInsets.symmetric(vertical: 36.0, horizontal: 54),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Text(
                      "Registrar Asignación de Escala",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomTextFormulario(
                      hint: "ID Alumno",
                      controller: idAlumno,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El ID del alumno es requerido";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextFormulario(
                      hint: "ID Escala",
                      controller: idEscala,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El ID de la escala es requerido";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextFormulario(
                      hint: "Fecha de Asignación",
                      controller: fechaAsignacion,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "La fecha de asignación es requerida";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    FilledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final newAsignacion = AsigEscalaModel(
                            idAsignarEscala: asignacion?.idAsignarEscala ?? 0,
                            idAlumno: int.parse(idAlumno.text),
                            idEscala: int.parse(idEscala.text),
                            fechaAsignacion: fechaAsignacion.text,
                          );
                          if (newAsignacion.idAsignarEscala != 0) {
                            await con.updateAsignacionEscala(newAsignacion);
                          } else {
                            await con.createAsignacionEscala(newAsignacion);
                          }
                          await _loadAsignaciones();
                        }
                      },
                      child: Text("Registrar"),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    final columns = [
      DataColumn(label: Text("ID Alumno")),
      DataColumn(label: Text("ID Escala")),
      DataColumn(label: Text("Fecha de Asignación")),
      DataColumn(label: Text("Acciones")),
    ];

    final rows = filteredAsignaciones
        .map(
          (asignacion) => DataRow(
            cells: [
              DataCell(Text(asignacion.idAlumno.toString())),
              DataCell(Text(asignacion.idEscala.toString())),
              DataCell(Text(asignacion.fechaAsignacion)),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () {
                        _showRegisterForm(context, asignacion: asignacion);
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        await con
                            .deleteAsignacionEscala(asignacion.idAsignarEscala);
                        await _loadAsignaciones();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .toList();

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : errorMessage != null
            ? Center(child: Text("Error: $errorMessage"))
            : GenericListScreen(
                searchController: searchController,
                title: "Lista de Asignaciones de Escala",
                columns: columns,
                rows: rows,
                onAdd: () => _showRegisterForm(context),
                onExport: () {},
              );
  }
}
