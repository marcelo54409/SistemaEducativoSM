import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tmkt3_app/core/widgets/custom_text_formulario.dart';
import 'package:tmkt3_app/features/home/condonacion/condonacion_get_controller.dart';
import 'package:tmkt3_app/features/home/condonacion/model/concepto_model.dart';
import 'package:tmkt3_app/features/home/widgets/generic_list_screen.dart';

class CondonacionGetScreen extends StatefulWidget {
  @override
  State<CondonacionGetScreen> createState() => _CondonacionGetScreenState();
}

class _CondonacionGetScreenState extends State<CondonacionGetScreen> {
  CondonacionController con = CondonacionController();
  final TextEditingController searchController = TextEditingController();
  List<CondonacionModel> condonaciones = [];
  List<CondonacionModel> filteredCondonaciones = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await con.init(context);
      await _loadCondonaciones();
    });
    searchController.addListener(() {
      _filterCondonaciones(searchController.text);
    });
  }

  void _filterCondonaciones(String query) {
    setState(() {
      filteredCondonaciones = condonaciones.where((condonacion) {
        final fullName =
            "${condonacion.idDeuda.toString()} ${condonacion.fecha}"
                .toLowerCase();
        return fullName.contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> _loadCondonaciones() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      final response = await con.getCondonaciones();
      setState(() {
        condonaciones = response;
        filteredCondonaciones = response;
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
        {CondonacionModel? condonacion}) {
      final _formKey = GlobalKey<FormState>();
      final TextEditingController idDeudaController =
          TextEditingController(text: condonacion?.idDeuda.toString() ?? '');
      final TextEditingController fechaController =
          TextEditingController(text: condonacion?.fecha ?? '');

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
                      "Registrar Condonación",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomTextFormulario(
                      hint: "ID Deuda",
                      controller: idDeudaController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El ID de la deuda es requerido";
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
                          final newCondonacion = CondonacionModel(
                            idCondonacion: condonacion?.idCondonacion ?? 0,
                            idDeuda: int.parse(idDeudaController.text),
                            fecha: fechaController.text,
                          );
                          if (newCondonacion.idCondonacion != 0) {
                            await con.updateCondonacion(newCondonacion);
                          } else {
                            await con.createCondonacion(newCondonacion);
                          }
                          await _loadCondonaciones();
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
      DataColumn(label: Text("ID Deuda")),
      DataColumn(label: Text("Fecha")),
      DataColumn(label: Text("Acciones")),
    ];

    final rows = filteredCondonaciones
        .map(
          (condonacion) => DataRow(
            cells: [
              DataCell(Text(condonacion.idDeuda.toString())),
              DataCell(Text(condonacion.fecha)),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () {
                        _showRegisterForm(context, condonacion: condonacion);
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        await con.deleteCondonacion(condonacion.idCondonacion);
                        await _loadCondonaciones();
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
                title: "Lista de Condonaciones",
                columns: columns,
                rows: rows,
                onAdd: () => _showRegisterForm(context),
                onExport: () {},
              );
  }
}
