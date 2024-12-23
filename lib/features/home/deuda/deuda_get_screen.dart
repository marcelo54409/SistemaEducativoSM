import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tmkt3_app/core/widgets/custom_text_formulario.dart';
import 'package:tmkt3_app/features/home/deuda/deuda_get_controller.dart';
import 'package:tmkt3_app/features/home/deuda/model/deuda_model.dart';
import 'package:tmkt3_app/features/home/widgets/generic_list_screen.dart';

class DeudaGetScreen extends StatefulWidget {
  @override
  State<DeudaGetScreen> createState() => _DeudaGetScreenState();
}

class _DeudaGetScreenState extends State<DeudaGetScreen> {
  DeudaController con = DeudaController();
  final TextEditingController searchController = TextEditingController();
  List<DeudaModel> deudas = [];
  List<DeudaModel> filteredDeudas = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await con.init(context);
      await _loadDeudas();
    });
    searchController.addListener(() {
      _filterDeudas(searchController.text);
    });
  }

  void _filterDeudas(String query) {
    setState(() {
      filteredDeudas = deudas.where((deuda) {
        final fullName =
            "${deuda.idAlumno.toString()} ${deuda.fecha}".toLowerCase();
        return fullName.contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> _loadDeudas() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      final response = await con.getDeudasWithAlumnoNames();
      setState(() {
        deudas = response;
        filteredDeudas = response;
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
    void _showRegisterForm(BuildContext context, {DeudaModel? deuda}) {
      final _formKey = GlobalKey<FormState>();
      final TextEditingController idAlumnoController =
          TextEditingController(text: deuda?.idAlumno.toString() ?? '');
      final TextEditingController idAsignarEscalaController =
          TextEditingController(text: deuda?.idAsignarEscala.toString() ?? '');
      final TextEditingController idAsignarConceptoController =
          TextEditingController(
              text: deuda?.idAsignarConcepto.toString() ?? '');
      final TextEditingController fechaController =
          TextEditingController(text: deuda?.fecha ?? '');

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
                      "Registrar Deuda",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomTextFormulario(
                      hint: "ID Alumno",
                      controller: idAlumnoController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El ID del alumno es requerido";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextFormulario(
                      hint: "ID Asignar Escala",
                      controller: idAsignarEscalaController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El ID de la escala es requerido";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextFormulario(
                      hint: "ID Asignar Concepto",
                      controller: idAsignarConceptoController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El ID del concepto es requerido";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextFormulario(
                      hint: "Fecha",
                      controller: fechaController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "La fecha es requerida";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    FilledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final newDeuda = DeudaModel(
                            idDeuda: deuda?.idDeuda ?? 0,
                            idAlumno: int.parse(idAlumnoController.text),
                            idAsignarEscala:
                                int.parse(idAsignarEscalaController.text),
                            idAsignarConcepto:
                                int.parse(idAsignarConceptoController.text),
                            fecha: fechaController.text,
                          );
                          if (newDeuda.idDeuda != 0) {
                            await con.updateDeuda(newDeuda);
                          } else {
                            await con.createDeuda(newDeuda);
                          }
                          await _loadDeudas();
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
      DataColumn(label: Text("ID Concepto")),
      DataColumn(label: Text("Fecha")),
      DataColumn(label: Text("Acciones")),
    ];

    final rows = filteredDeudas
        .map(
          (deuda) => DataRow(
            cells: [
              DataCell(Text(deuda.nombreAlumno ?? "Desconocido")),
              DataCell(Text(deuda.idAsignarEscala.toString())),
              DataCell(Text(deuda.idAsignarConcepto.toString())),
              DataCell(Text(deuda.fecha)),
              DataCell(
                Row(
                  children: [
                    OutlinedButton(onPressed: () {}, child: Text("Condonar")),
                    SizedBox(width: 12),
                    OutlinedButton(onPressed: () {}, child: Text("Pagar"))
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
                title: "Lista de Deudas",
                columns: columns,
                rows: rows,
                onAdd: null,
                onExport: () {},
              );
  }
}