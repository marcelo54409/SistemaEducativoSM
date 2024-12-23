import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tmkt3_app/core/widgets/custom_text_formulario.dart';
import 'package:tmkt3_app/features/home/escalas/escalas_get_controller.dart';
import 'package:tmkt3_app/features/home/escalas/model/escalas_model.dart';
import 'package:tmkt3_app/features/home/widgets/generic_list_screen.dart';

class EscalasGetScreen extends StatefulWidget {
  @override
  State<EscalasGetScreen> createState() => _EscalasGetScreenState();
}

class _EscalasGetScreenState extends State<EscalasGetScreen> {
  EscalasController con = EscalasController();
  final TextEditingController searchController = TextEditingController();
  List<EscalasModel> escalas = [];
  List<EscalasModel> filteredEscalas = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await con.init(context);
      await _loadEscalas();
    });
    searchController.addListener(() {
      _filterEscalas(searchController.text);
    });
  }

  void _filterEscalas(String query) {
    setState(() {
      filteredEscalas = escalas.where((escala) {
        final fullName =
            "${escala.escala ?? ''} ${escala.descripcion ?? ''}".toLowerCase();
        return fullName.contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> _loadEscalas() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      final response = await con.getEscalas();
      setState(() {
        escalas = response;
        filteredEscalas = response;
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
    void _showRegisterForm(BuildContext context, {EscalasModel? escala}) {
      final _formKey = GlobalKey<FormState>();
      final TextEditingController escalaController =
          TextEditingController(text: escala?.escala ?? '');
      final TextEditingController descripcionController =
          TextEditingController(text: escala?.descripcion ?? '');
      final TextEditingController montoController =
          TextEditingController(text: escala?.monto.toString() ?? '');

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
                      "Registrar Escala",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomTextFormulario(
                      hint: "Escala",
                      controller: escalaController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "La escala es requerida";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextFormulario(
                      hint: "Descripción",
                      controller: descripcionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "La descripción es requerida";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextFormulario(
                      hint: "Monto",
                      controller: montoController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El monto es requerido";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    FilledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final newEscala = EscalasModel(
                            idEscala: escala?.idEscala ?? 0,
                            escala: escalaController.text,
                            descripcion: descripcionController.text,
                            monto: double.parse(montoController.text),
                          );
                          if (newEscala.idEscala != 0) {
                            await con.updateEscala(newEscala);
                          } else {
                            await con.createEscala(newEscala);
                          }
                          await _loadEscalas();
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
      DataColumn(label: Text("Escala")),
      DataColumn(label: Text("Descripción")),
      DataColumn(label: Text("Monto")),
      DataColumn(label: Text("Acciones")),
    ];

    final rows = filteredEscalas
        .map(
          (escala) => DataRow(
            cells: [
              DataCell(Text(escala.escala)),
              DataCell(Text(escala.descripcion)),
              DataCell(Text(escala.monto.toString())),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () {
                        _showRegisterForm(context, escala: escala);
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        await con.deleteEscala(escala.idEscala);
                        await _loadEscalas();
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
                title: "Lista de Escalas",
                columns: columns,
                rows: rows,
                onAdd: () => _showRegisterForm(context),
                onExport: () {},
              );
  }
}
