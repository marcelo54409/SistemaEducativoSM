import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tmkt3_app/core/widgets/custom_text_formulario.dart';
import 'package:tmkt3_app/features/home/usuarios/model/user_model.dart';
import 'package:tmkt3_app/features/home/usuarios/user_controller.dart';
import 'package:tmkt3_app/features/home/widgets/generic_list_screen.dart';

class UserScreen extends StatefulWidget {
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  UserController con = UserController();
  final TextEditingController searchController = TextEditingController();
  List<UserModel> users = [];
  List<UserModel> filteredUsers = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await con.init(context);
      await _loadUsers();
    });
    searchController.addListener(() {
      _filterUsers(searchController.text);
    });
  }

  void _filterUsers(String query) {
    setState(() {
      filteredUsers = users.where((user) {
        final fullInfo =
            "${user.name} ${user.email} ${user.username} ${user.businessName} ${user.jobTitle} ${user.phone}"
                .toLowerCase();
        return fullInfo.contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> _loadUsers() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      final response = await con.getUsers();
      setState(() {
        users = response;
        filteredUsers = response;
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
    void _showRegisterForm(BuildContext context, {UserModel? user}) {
      final _formKey = GlobalKey<FormState>();
      final TextEditingController name =
          TextEditingController(text: user?.name ?? '');
      final TextEditingController email =
          TextEditingController(text: user?.email ?? '');
      final TextEditingController businessName =
          TextEditingController(text: user?.businessName ?? '');
      final TextEditingController jobTitle =
          TextEditingController(text: user?.jobTitle ?? '');
      final TextEditingController phone =
          TextEditingController(text: user?.phone ?? '');
      final TextEditingController username =
          TextEditingController(text: user?.username ?? '');

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
                      "Registrar Usuario",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomTextFormulario(
                      hint: "Nombre",
                      controller: name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El nombre es requerido";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextFormulario(
                      hint: "Correo Electrónico",
                      controller: email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El correo electrónico es requerido";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextFormulario(
                      hint: "Nombre de la Empresa",
                      controller: businessName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El nombre de la empresa es requerido";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextFormulario(
                      hint: "Puesto",
                      controller: jobTitle,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El puesto es requerido";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextFormulario(
                      hint: "Teléfono",
                      controller: phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El teléfono es requerido";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextFormulario(
                      hint: "Nombre de Usuario",
                      controller: username,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "El nombre de usuario es requerido";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    FilledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final newUser = UserModel(
                            id: user?.id ?? 0,
                            name: name.text,
                            email: email.text,
                            businessName: businessName.text,
                            jobTitle: jobTitle.text,
                            phone: phone.text,
                            username: username.text,
                          );
                          if (newUser.id != 0) {
                            await con.updateUser(newUser);
                          } else {
                            await con.createUser(newUser);
                          }
                          await _loadUsers();
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
      DataColumn(label: Text("Nombre")),
      DataColumn(label: Text("Correo Electrónico")),
      DataColumn(label: Text("Empresa")),
      DataColumn(label: Text("Puesto")),
      DataColumn(label: Text("Teléfono")),
      DataColumn(label: Text("Usuario")),
      DataColumn(label: Text("Acciones")),
    ];

    final rows = filteredUsers
        .map(
          (user) => DataRow(
            cells: [
              DataCell(Text(user.name)),
              DataCell(Text(user.email)),
              DataCell(Text(user.businessName)),
              DataCell(Text(user.jobTitle)),
              DataCell(Text(user.phone)),
              DataCell(Text(user.username)),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () {
                        _showRegisterForm(context, user: user);
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        await con.deleteUser(user.id);
                        await _loadUsers();
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
                title: "Lista de Usuarios",
                columns: columns,
                rows: rows,
                onAdd: () => _showRegisterForm(context),
                onExport: () {},
              );
  }
}
