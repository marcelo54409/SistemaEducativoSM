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
            "${user.username} ${user.email} ${user.roleId} ${user.createdAt} ${user.updatedAt}"
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
      final TextEditingController username =
          TextEditingController(text: user?.username ?? '');
      final TextEditingController email =
          TextEditingController(text: user?.email ?? '');
      final TextEditingController roleId =
          TextEditingController(text: user?.roleId?.toString() ?? '');

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
                      hint: "ID de Rol (opcional)",
                      controller: roleId,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final parsedValue = int.tryParse(value);
                          if (parsedValue == null) {
                            return "El ID de rol debe ser un número válido";
                          }
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
                            username: username.text,
                            email: email.text,
                            roleId: roleId.text.isEmpty
                                ? null
                                : int.parse(roleId.text),
                            createdAt: user?.createdAt ?? DateTime.now(),
                            updatedAt: DateTime.now(),
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
      DataColumn(label: Text("Nombre de Usuario")),
      DataColumn(label: Text("Correo Electrónico")),
      DataColumn(label: Text("ID de Rol")),
      DataColumn(label: Text("Creado")),
      DataColumn(label: Text("Actualizado")),
      DataColumn(label: Text("Acciones")),
    ];

    final rows = filteredUsers
        .map(
          (user) => DataRow(
            cells: [
              DataCell(Text(user.username)),
              DataCell(Text(user.email)),
              DataCell(Text(user.roleId?.toString() ?? "N/A")),
              DataCell(Text(user.createdAt.toString())),
              DataCell(Text(user.updatedAt.toString())),
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
