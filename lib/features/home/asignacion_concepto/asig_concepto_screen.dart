import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tmkt3_app/core/widgets/custom_text_formulario.dart';
import 'package:tmkt3_app/features/home/asignacion_concepto/asig_concepto_controller.dart';
import 'package:tmkt3_app/features/home/asignacion_concepto/model/asig_concepto_model.dart';
import 'package:tmkt3_app/features/home/widgets/generic_list_screen.dart';

class AsignarConceptoScreen extends StatefulWidget {
  @override
  State<AsignarConceptoScreen> createState() => _AsignarConceptoScreenState();
}

class _AsignarConceptoScreenState extends State<AsignarConceptoScreen> {
  AsignarConceptoController con = AsignarConceptoController();
  final TextEditingController searchController = TextEditingController();
  List<AsignarConceptoModel> asignaciones = [];
  List<AsignarConceptoModel> filteredAsignaciones = [];
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
            "${asignacion.idEscala} ${asignacion.idConcepto}".toLowerCase();
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
      final response = await con.getAsignacionesConcepto();
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
        {AsignarConceptoModel? asignacion}) {
      final _formKey = GlobalKey<FormState>();
      final TextEditingController idEscala =
          TextEditingController(text: asignacion?.idEscala.toString() ?? '');
      final TextEditingController idConcepto =
          TextEditingController(text: asignacion?.idConcepto.toString() ?? '');

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
                      "Registrar Asignación de Concepto",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
                      hint: "ID Concepto",
                      controller: idConcepto,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El ID del concepto es requerido";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    FilledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final newAsignacion = AsignarConceptoModel(
                            idAsignarConcepto:
                                asignacion?.idAsignarConcepto ?? 0,
                            idEscala: int.parse(idEscala.text),
                            idConcepto: int.parse(idConcepto.text),
                          );
                          if (newAsignacion.idAsignarConcepto != 0) {
                            await con.updateAsignacionConcepto(newAsignacion);
                          } else {
                            await con.createAsignacionConcepto(newAsignacion);
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
      DataColumn(label: Text("ID Escala")),
      DataColumn(label: Text("ID Concepto")),
      DataColumn(label: Text("Acciones")),
    ];

    final rows = filteredAsignaciones
        .map(
          (asignacion) => DataRow(
            cells: [
              DataCell(Text(asignacion.idEscala.toString())),
              DataCell(Text(asignacion.idConcepto.toString())),
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
                        await con.deleteAsignacionConcepto(
                            asignacion.idAsignarConcepto);
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
                title: "Lista de Asignaciones de Conceptos",
                columns: columns,
                rows: rows,
                onAdd: () => _showRegisterForm(context),
                onExport: () {},
              );
  }
}
