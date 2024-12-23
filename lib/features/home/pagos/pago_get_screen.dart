import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tmkt3_app/core/widgets/custom_text_formulario.dart';
import 'package:tmkt3_app/features/home/pagos/model/pago_model.dart';
import 'package:tmkt3_app/features/home/pagos/pago_get_controller.dart';
import 'package:tmkt3_app/features/home/widgets/generic_list_screen.dart';

class PagoGetScreen extends StatefulWidget {
  @override
  State<PagoGetScreen> createState() => _PagoGetScreenState();
}

class _PagoGetScreenState extends State<PagoGetScreen> {
  PagoController con = PagoController();
  final TextEditingController searchController = TextEditingController();
  List<PagoModel> pagos = [];
  List<PagoModel> filteredPagos = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await con.init(context);
      await _loadPagos();
    });
    searchController.addListener(() {
      _filterPagos(searchController.text);
    });
  }

  void _filterPagos(String query) {
    setState(() {
      filteredPagos = pagos.where((pago) {
        final fullName =
            "${pago.idAlumno.toString()} ${pago.fechaPago} ${pago.estadoPago}"
                .toLowerCase();
        return fullName.contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> _loadPagos() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      final response = await con.getPagos();
      setState(() {
        pagos = response;
        filteredPagos = response;
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
    void _showRegisterForm(BuildContext context, {PagoModel? pago}) {
      final _formKey = GlobalKey<FormState>();
      final TextEditingController idPadreController =
          TextEditingController(text: pago?.idPadre.toString() ?? '');
      final TextEditingController idAlumnoController =
          TextEditingController(text: pago?.idAlumno.toString() ?? '');
      final TextEditingController idDeudaController =
          TextEditingController(text: pago?.idDeuda.toString() ?? '');
      final TextEditingController fechaPagoController =
          TextEditingController(text: pago?.fechaPago ?? '');
      final TextEditingController estadoPagoController =
          TextEditingController(text: pago?.estadoPago ?? '');

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
                      "Registrar Pago",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomTextFormulario(
                      hint: "ID Padre",
                      controller: idPadreController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El ID del padre es requerido";
                        }
                        return null;
                      },
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
                      hint: "Fecha de Pago",
                      controller: fechaPagoController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "La fecha de pago es requerida";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextFormulario(
                      hint: "Estado de Pago",
                      controller: estadoPagoController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El estado de pago es requerido";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    FilledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final newPago = PagoModel(
                            idPago: pago?.idPago ?? 0,
                            idPadre: int.parse(idPadreController.text),
                            idAlumno: int.parse(idAlumnoController.text),
                            idDeuda: int.parse(idDeudaController.text),
                            fechaPago: fechaPagoController.text,
                            estadoPago: estadoPagoController.text,
                          );
                          if (newPago.idPago != 0) {
                            await con.updatePago(newPago);
                          } else {
                            await con.createPago(newPago);
                          }
                          await _loadPagos();
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
      DataColumn(label: Text("ID Padre")),
      DataColumn(label: Text("ID Alumno")),
      DataColumn(label: Text("ID Deuda")),
      DataColumn(label: Text("Fecha de Pago")),
      DataColumn(label: Text("Estado de Pago")),
      DataColumn(label: Text("Acciones")),
    ];

    final rows = filteredPagos
        .map(
          (pago) => DataRow(
            cells: [
              DataCell(Text(pago.idPadre.toString())),
              DataCell(Text(pago.idAlumno.toString())),
              DataCell(Text(pago.idDeuda.toString())),
              DataCell(Text(pago.fechaPago)),
              DataCell(Text(pago.estadoPago)),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () {
                        _showRegisterForm(context, pago: pago);
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        await con.deletePago(pago.idPago);
                        await _loadPagos();
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
                title: "Lista de Pagos",
                columns: columns,
                rows: rows,
                onAdd: () => _showRegisterForm(context),
                onExport: () {},
              );
  }
}