import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tmkt3_app/core/widgets/custom_text_formulario.dart';
import 'package:tmkt3_app/features/home/alumnos/alumnos_get_controller.dart';
import 'package:tmkt3_app/features/home/alumnos/model/alumno_model.dart';
import 'package:tmkt3_app/features/home/asignacion_escala/asig_escala_controlador.dart';
import 'package:tmkt3_app/features/home/asignacion_escala/model/asig_escala_model.dart';
import 'package:tmkt3_app/features/home/escalas/escalas_get_controller.dart';
import 'package:tmkt3_app/features/home/escalas/model/escalas_model.dart';
import 'package:tmkt3_app/features/home/widgets/elegant_dropdown.dart';
import 'package:tmkt3_app/features/home/widgets/generic_list_screen.dart';

class AsigEscalaScreen extends StatefulWidget {
  @override
  State<AsigEscalaScreen> createState() => _AsigEscalaScreenState();
}

class _AsigEscalaScreenState extends State<AsigEscalaScreen> {
  AsigEscalaController con = AsigEscalaController();
  final TextEditingController searchController = TextEditingController();
  List<AsigEscalaModel> asignaciones = [];
  List escalas = [];
  List alumnos = [];
  List<DropDownValueModel> dropdownEscala = [];
  List<DropDownValueModel> dropdownAlumno = [];
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
      final escala =
          await EscalasController().getEscalas(includeDropdown: true);
      final alumno =
          await AlumnosGetController().getAlumnos(includeDropdown: true);
      setState(() {
        asignaciones = response;
        alumnos = alumno['alumnos'];
        dropdownAlumno = alumno['dropdown'];
        escalas = escala['escalas'];
        dropdownEscala = escala['dropdown'];
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
        {AsigEscalaModel? asignacion,
        EscalasModel? escala,
        AlumnoModelo? alumno}) {
      final _formKey = GlobalKey<FormState>();
      final TextEditingController idAlumno =
          TextEditingController(text: asignacion?.idAlumno.toString() ?? '');
      final TextEditingController idEscala =
          TextEditingController(text: asignacion?.idEscala.toString() ?? '');
      final TextEditingController fechaAsignacion =
          TextEditingController(text: asignacion?.fechaAsignacion ?? '');

      final SingleValueDropDownController controllerDropdownEscala =
          SingleValueDropDownController(
        data: DropDownValueModel(
            name: escala?.descripcion ?? "", value: escala?.idEscala),
      );

      final SingleValueDropDownController controllerDropdownAlumno =
          SingleValueDropDownController(
        data: DropDownValueModel(
            name: alumno != null
                ? "${alumno.primerNombre} ${alumno.apellidoPaterno}"
                : "",
            value: alumno?.id),
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
                      "Registrar Asignación de Escala",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElegantDropdown(
                      controller: controllerDropdownAlumno,
                      dropdownList: dropdownAlumno,
                      labelText: "Seleccionar Alumno",
                    ),
                    SizedBox(height: 20),
                    ElegantDropdown(
                      controller: controllerDropdownEscala,
                      dropdownList: dropdownEscala,
                      labelText: "Seleccionar Escala",
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
                            idAlumno:
                                controllerDropdownAlumno.dropDownValue?.value ??
                                    0,
                            idEscala:
                                controllerDropdownEscala.dropDownValue?.value ??
                                    0,
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
      DataColumn(label: Text("Alumno")),
      DataColumn(label: Text("Escala")),
      DataColumn(label: Text("Fecha de Asignación")),
      DataColumn(label: Text("Acciones")),
    ];

    final rows = filteredAsignaciones.map((asignacion) {
      final descEscala = escalas
          .firstWhere((element) => element.idEscala == asignacion.idEscala)
          .descripcion;
      final alumno =
          alumnos.firstWhere((element) => element.id == asignacion.idAlumno);
      return DataRow(
        cells: [
          DataCell(Text("${alumno.primerNombre} ${alumno.apellidoPaterno}")),
          DataCell(Text(descEscala)),
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
                    _showRegisterForm(context,
                        asignacion: asignacion,
                        escala: escalas.firstWhere((element) =>
                            element.idEscala == asignacion.idEscala),
                        alumno: alumnos.firstWhere(
                            (element) => element.id == asignacion.idAlumno));
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
      );
    }).toList();

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
