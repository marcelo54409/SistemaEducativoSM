import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tmkt3_app/core/widgets/custom_text_formulario.dart';
import 'package:tmkt3_app/features/home/deuda/deuda_get_controller.dart';
import 'package:tmkt3_app/features/home/deuda/model/deuda_model.dart';
import 'package:tmkt3_app/features/home/pagos/paypal_service.dart';
import 'package:tmkt3_app/features/home/recibos/model/recibo_model.dart';
import 'package:tmkt3_app/features/home/recibos/recibo_get_controller.dart';
import 'package:tmkt3_app/features/home/widgets/generic_list_screen.dart';

class ReciboGetScreen extends StatefulWidget {
  @override
  State<ReciboGetScreen> createState() => _ReciboGetScreenState();
}

class _ReciboGetScreenState extends State<ReciboGetScreen> {
  ReciboController con = ReciboController();
  final TextEditingController searchController = TextEditingController();
  List<ReciboModel> recibos = [];
  List<ReciboModel> filteredRecibos = [];
  List<DeudaModel> deudas = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await con.init(context);
      await _loadRecibos();
    });
    searchController.addListener(() {
      _filterRecibos(searchController.text);
    });
  }

  void _filterRecibos(String query) {
    setState(() {
      filteredRecibos = recibos.where((recibo) {
        final fullName =
            "${recibo.idAlumno.toString()} ${recibo.formaPago} ${recibo.fechaEmision}"
                .toLowerCase();
        return fullName.contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> _loadRecibos() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      final response = await con.getRecibos();
      final deuda = await DeudaController().getDeudasWithAlumnoNames();
      setState(() {
        recibos = response;
        filteredRecibos = response;
        deudas = deuda;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> processPayment(ReciboModel recibo) async {
    try {
      // Assuming orderId is stored in nOperacion
      await PayPalService.handlePayment(
        recibo.nOperacion,
        double.parse(recibo.importe),
      );

      // Add a payment status check
      final captured = await PayPalService.capturePayment(recibo.nOperacion);
      if (captured) {
        // Update local payment status

        await _loadRecibos();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error en el pago: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    void _showRegisterForm(BuildContext context, {ReciboModel? recibo}) {
      final _formKey = GlobalKey<FormState>();
      final TextEditingController idAlumnoController =
          TextEditingController(text: recibo?.idAlumno.toString() ?? '');
      final TextEditingController idDeudaController =
          TextEditingController(text: recibo?.idDeuda.toString() ?? '');
      final TextEditingController formaPagoController =
          TextEditingController(text: recibo?.formaPago ?? '');
      final TextEditingController nOperacionController =
          TextEditingController(text: recibo?.nOperacion ?? '');
      final TextEditingController fechaEmisionController =
          TextEditingController(text: recibo?.fechaEmision ?? '');
      final TextEditingController importeController =
          TextEditingController(text: recibo?.importe.toString() ?? '');

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
                      "Registrar Recibo",
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
                      hint: "Forma de Pago",
                      controller: formaPagoController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "La forma de pago es requerida";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextFormulario(
                      hint: "Número de Operación",
                      controller: nOperacionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El número de operación es requerido";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextFormulario(
                      hint: "Fecha de Emisión",
                      controller: fechaEmisionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "La fecha de emisión es requerida";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextFormulario(
                      hint: "Importe",
                      controller: importeController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El importe es requerido";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    FilledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final newRecibo = ReciboModel(
                            idRecibo: recibo?.idRecibo ?? 0,
                            idAlumno: int.parse(idAlumnoController.text),
                            idDeuda: int.parse(idDeudaController.text),
                            formaPago: formaPagoController.text,
                            nOperacion: nOperacionController.text,
                            fechaEmision: fechaEmisionController.text,
                            importe: importeController.text,
                          );
                          if (newRecibo.idRecibo != 0) {
                            await con.updateRecibo(newRecibo);
                          } else {
                            await con.createRecibo(newRecibo);
                          }
                          await _loadRecibos();
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
      DataColumn(label: Text("Alumno")),
      DataColumn(label: Text("Forma de Pago")),
      DataColumn(label: Text("Número de Operación")),
      DataColumn(label: Text("Fecha de Emisión")),
      DataColumn(label: Text("Importe")),
      DataColumn(label: Text("Acciones")),
    ];

    final rows = filteredRecibos.map((recibo) {
      final deuda = deudas.firstWhere(
          (deuda) => deuda.idDeuda == recibo.idDeuda,
          orElse: () => DeudaModel(
              idDeuda: 0,
              idAlumno: 0,
              idAsignarEscala: 0,
              idAsignarConcepto: 0,
              fecha: ""));
      log("Deuda: $deudas");
      return DataRow(
        cells: [
          DataCell(Text(deuda.nombreAlumno ?? "Desconocido")),
          DataCell(Text(recibo.formaPago)),
          DataCell(Text(recibo.nOperacion)),
          DataCell(Text(recibo.fechaEmision)),
          DataCell(Text(recibo.importe.toString())),
          DataCell(
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () {
                    _showRegisterForm(context, recibo: recibo);
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    await con.deleteRecibo(recibo.idRecibo);
                    await _loadRecibos();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.payment),
                  onPressed: () => processPayment(recibo),
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : errorMessage != null
            ? Center(child: Text("Error: $errorMessage"))
            : GenericListScreen(
                searchController: searchController,
                title: "Lista de Recibos",
                columns: columns,
                rows: rows,
                onAdd: () => _showRegisterForm(context),
                onExport: () {},
              );
  }
}
