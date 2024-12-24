import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tmkt3_app/core/widgets/custom_text_formulario.dart';
import 'package:tmkt3_app/features/home/asignacion_concepto/asig_concepto_controller.dart';
import 'package:tmkt3_app/features/home/asignacion_concepto/model/asig_concepto_model.dart';
import 'package:tmkt3_app/features/home/concepto/concepto_get_controller.dart';
import 'package:tmkt3_app/features/home/concepto/model/concepto_model.dart';
import 'package:tmkt3_app/features/home/escalas/escalas_get_controller.dart';
import 'package:tmkt3_app/features/home/escalas/model/escalas_model.dart';
import 'package:tmkt3_app/features/home/widgets/elegant_dropdown.dart';
import 'package:tmkt3_app/features/home/widgets/generic_list_screen.dart';

class AsignarConceptoScreen extends StatefulWidget {
  @override
  State<AsignarConceptoScreen> createState() => _AsignarConceptoScreenState();
}

class _AsignarConceptoScreenState extends State<AsignarConceptoScreen> {
  AsignarConceptoController con = AsignarConceptoController();
  final TextEditingController searchController = TextEditingController();
  List<AsignarConceptoModel> asignaciones = [];
  List<EscalasModel> escalas = [];
  List conceptos = [];
  List<DropDownValueModel> dropdownConcepto = [];
  List<DropDownValueModel> dropdownEscala = [];
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
      final escala =
          await EscalasController().getEscalas(includeDropdown: true);
      final concepto =
          await ConceptoGetController().getConceptos(includeDropdown: true);
      setState(() {
        asignaciones = response;
        escalas = escala['escalas'];
        dropdownEscala = escala['dropdown'];
        conceptos = concepto['alumnos'];
        dropdownConcepto = concepto['dropdown'];
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
        {AsignarConceptoModel? asignacion,
        EscalasModel? escala,
        ConceptoModel? concepto}) {
      final _formKey = GlobalKey<FormState>();
      final TextEditingController idEscala =
          TextEditingController(text: asignacion?.idEscala.toString() ?? '');
      final TextEditingController idConcepto =
          TextEditingController(text: asignacion?.idConcepto.toString() ?? '');

      final SingleValueDropDownController controllerDropdownConcepto =
          SingleValueDropDownController(
        data: DropDownValueModel(
            name: escala?.descripcion ?? "", value: escala?.idEscala),
      );
      final SingleValueDropDownController controllerDropdownEscala =
          SingleValueDropDownController(
        data: DropDownValueModel(
            name: concepto?.descripcion ?? "", value: concepto?.idConcepto),
      );

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
                    ElegantDropdown(
                        controller: controllerDropdownEscala,
                        dropdownList: dropdownEscala,
                        labelText: "Seleccionar Escala"),
                    SizedBox(height: 20),
                    ElegantDropdown(
                        controller: controllerDropdownConcepto,
                        dropdownList: dropdownConcepto,
                        labelText: "Seleccionar Concepto"),
                    SizedBox(height: 20),
                    FilledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final newAsignacion = AsignarConceptoModel(
                            idAsignarConcepto:
                                asignacion?.idAsignarConcepto ?? 0,
                            idEscala:
                                controllerDropdownEscala.dropDownValue?.value ??
                                    0,
                            idConcepto: controllerDropdownConcepto
                                    .dropDownValue?.value ??
                                0,
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
      DataColumn(label: Text("Escala")),
      DataColumn(label: Text("Concepto")),
      DataColumn(label: Text("Acciones")),
    ];

    final rows = filteredAsignaciones.map((asignacion) {
      final EscalasModel descEscala = escalas
          .firstWhere((element) => element.idEscala == asignacion.idEscala);
      final ConceptoModel descConcepto = conceptos
          .firstWhere((element) => element.idConcepto == asignacion.idConcepto);
      return DataRow(
        cells: [
          DataCell(Text(descEscala.descripcion)),
          DataCell(Text(descConcepto.descripcion)),
          DataCell(
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () {
                    _showRegisterForm(context,
                        asignacion: asignacion,
                        escala: descEscala,
                        concepto: descConcepto);
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    await con
                        .deleteAsignacionConcepto(asignacion.idAsignarConcepto);
                    await _loadAsignaciones();
                  },
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
                title: "Lista de Asignaciones de Conceptos",
                columns: columns,
                rows: rows,
                onAdd: () => _showRegisterForm(context),
                onExport: () {},
              );
  }
}
