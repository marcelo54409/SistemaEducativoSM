import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tmkt3_app/core/widgets/custom_text_formulario.dart';
import 'package:tmkt3_app/features/home/concepto/concepto_get_controller.dart';
import 'package:tmkt3_app/features/home/concepto/model/concepto_model.dart';
import 'package:tmkt3_app/features/home/widgets/generic_list_screen.dart';

class ConceptoGetScreen extends StatefulWidget {
  @override
  State<ConceptoGetScreen> createState() => _ConceptoGetScreenState();
}

class _ConceptoGetScreenState extends State<ConceptoGetScreen> {
  ConceptoGetController con = ConceptoGetController();
  final TextEditingController searchController = TextEditingController();
  List<ConceptoModel> conceptos = [];
  List<ConceptoModel> filteredConceptos = [];
  bool isLoading = true;
  String? errorMessage;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await con.init(context);
      await _loadConceptos();
    });
    searchController.addListener(() {
      _filterConceptos(searchController.text);
    });
  }

  void _filterConceptos(String query) {
    setState(() {
      filteredConceptos = conceptos.where((concepto) {
        final fullName =
            "${concepto.concepto ?? ''} ${concepto.descripcion ?? ''}"
                .toLowerCase();
        return fullName.contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> _loadConceptos() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      final response = await con.getConceptos();
      setState(() {
        conceptos = response;
        filteredConceptos = response;
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
    void _showRegisterForm(BuildContext context, {ConceptoModel? conceptor}) {
      final _formKey = GlobalKey<FormState>();
      final TextEditingController concepto =
          TextEditingController(text: conceptor?.concepto ?? '');
      final TextEditingController descripcion =
          TextEditingController(text: conceptor?.descripcion ?? '');
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
                      "Registrar Concepto",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomTextFormulario(
                      hint: "Concepto",
                      controller: concepto,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El concepto es requerido";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextFormulario(
                      hint: "Descripción",
                      controller: descripcion,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "La descripción es requerida";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    FilledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final newConcepto = ConceptoModel(
                            idConcepto: conceptor?.idConcepto ?? 0,
                            concepto: concepto.text,
                            descripcion: descripcion.text,
                          );
                          if (newConcepto.idConcepto != 0) {
                            await con.updateAlumno(newConcepto);
                          } else {
                            await con.createAlumno(newConcepto);
                          }
                          await _loadConceptos();
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
      DataColumn(label: Text("Concepto")),
      DataColumn(label: Text("Descripción")),
      DataColumn(label: Text("Acciones")),
    ];

    final rows = filteredConceptos
        .map(
          (concepto) => DataRow(
            cells: [
              DataCell(Text(concepto.concepto)),
              DataCell(Text(concepto.descripcion)),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () {
                        _showRegisterForm(context, conceptor: concepto);
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        await con.deleteAlumno(concepto.idConcepto.toString());
                        await _loadConceptos();
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
                title: "Lista de Conceptos",
                columns: columns,
                rows: rows,
                onAdd: () => _showRegisterForm(context),
                onExport: () {},
              );
  }
}
