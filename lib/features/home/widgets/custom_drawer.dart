import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmkt3_app/core/router/router.dart';
import 'package:tmkt3_app/features/auth/repositories/auth_local_repository.dart';
import 'package:tmkt3_app/features/auth/viewmodel/auth_viewmodel.dart';

class CustomDrawer extends StatefulWidget {
  final String? userName;
  final String? userEmail;
  final String? userAvatarUrl;

  const CustomDrawer({
    Key? key,
    this.userName,
    this.userEmail,
    this.userAvatarUrl,
  }) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header del Drawer con información de usuario
          UserAccountsDrawerHeader(
            accountName: Text(
              "Marcelo",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),
            ),
            accountEmail: Text(
              "Administrador",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepOrange.shade900,
                  Colors.orange.shade600,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Sección de Navegación
          _buildDrawerItem(
            icon: Icons.home,
            text: 'Inicio',
            onTap: () {
              GoRouter.of(context).go('/admin');
            },
          ),

          _buildDrawerItem(
            icon: Icons.person,
            text: 'Usuarios',
            onTap: () {
              GoRouter.of(context).go('/usuarios');
            },
          ),

          // _buildDrawerItem(
          //   icon: Icons.settings,
          //   text: 'Configuración',
          //   onTap: () {
          //     Navigator.pushReplacementNamed(context, '/settings');
          //   },
          // ),

          // Sección de Maestros Desplegable
          ExpansionTile(
            leading: Icon(Icons.group, color: Colors.orange),
            title: Text(
              'Maestros',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            children: [
              _buildTeacherItem(
                name: 'Alumnos',
                subject: 'Matemáticas',
                onTap: () {
                  GoRouter.of(context).go('/alumnos');
                },
              ),
              _buildTeacherItem(
                name: 'Escalas',
                subject: 'Ciencias',
                onTap: () {
                  GoRouter.of(context).go('/escalas');
                },
              ),
              _buildTeacherItem(
                name: 'Concepto',
                subject: 'Literatura',
                onTap: () {
                  GoRouter.of(context).go('/conceptos');
                },
              ),
            ],
          ),

          ExpansionTile(
            leading: Icon(Icons.group, color: Colors.orange),
            title: Text(
              'Asignaciones',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            children: [
              _buildTeacherItem(
                name: 'Asignar Escala',
                subject: 'Matemáticas',
                onTap: () {
                  Navigator.pushNamed(context, '/teacher/maria');
                },
              ),
              _buildTeacherItem(
                name: 'Asignar Concepto',
                subject: 'Ciencias',
                onTap: () {
                  Navigator.pushNamed(context, '/teacher/carlos');
                },
              ),
            ],
          ),
          _buildDrawerItem(
            icon: Icons.monetization_on,
            text: 'Deuda',
            onTap: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
          ),
          _buildDrawerItem(
            icon: Icons.money_off,
            text: 'Condonacion',
            onTap: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
          ),
          _buildDrawerItem(
            icon: Icons.payment,
            text: 'Pagos',
            onTap: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
          ),
          _buildDrawerItem(
            icon: Icons.receipt,
            text: 'Recibos',
            onTap: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
          ),

          Divider(color: Colors.grey.shade300),

          _buildDrawerItem(
            icon: Icons.logout,
            text: 'Cerrar Sesión',
            onTap: () {
              // Implementar lógica de cierre de sesión
              _showLogoutConfirmation(context);
            },
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  // Método para construcción de elementos del drawer
  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? Colors.orange,
      ),
      title: Text(
        text,
        style: TextStyle(
          color: color ?? Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      horizontalTitleGap: 8,
    );
  }

  // Método para construir elementos de maestros
  Widget _buildTeacherItem({
    required String name,
    required String subject,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 32),
      title: Text(
        name,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 14,
        ),
      ),
      onTap: onTap,
    );
  }

  // Diálogo de confirmación de cierre de sesión
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cerrar Sesión'),
        content: Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implementar lógica de cierre de sesión
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}
