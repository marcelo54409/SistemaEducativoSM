import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmkt3_app/features/auth/viewmodel/auth_viewmodel.dart';

class PartialDrawer extends ConsumerStatefulWidget {
  @override
  _PartialDrawerState createState() => _PartialDrawerState();
}

class _PartialDrawerState extends ConsumerState<PartialDrawer> {
  bool isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCollapsed ? 70 : 250, // Ancho del Drawer
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado del Drawer
          GestureDetector(
            onTap: () {
              setState(() {
                isCollapsed = !isCollapsed;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/logo_principal.png',
                    width: isCollapsed ? 24 : 48,
                  ),
                  if (!isCollapsed) ...[
                    const SizedBox(width: 16),
                    Text(
                      'Administrador',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const Divider(color: Colors.grey),

          // Lista de opciones
          Expanded(
            child: ListView(
              children: [
                _buildDrawerItem(
                  icon: Icons.group,
                  label: 'Usuarios',
                  isCollapsed: isCollapsed,
                ),
                _buildDrawerItem(
                  icon: Icons.sell,
                  label: 'Cadenas',
                  isCollapsed: isCollapsed,
                ),
                _buildDrawerItem(
                  icon: Icons.person,
                  label: 'Colaboradores',
                  isCollapsed: isCollapsed,
                ),
                const Divider(color: Colors.grey),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Clientes',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: isCollapsed ? 12 : 14,
                    ),
                  ),
                ),
                _buildDrawerItem(
                  icon: Icons.person_outline,
                  label: 'Clientes',
                  isCollapsed: isCollapsed,
                ),
                _buildDrawerItem(
                  icon: Icons.shopping_cart,
                  label: 'Productos',
                  isCollapsed: isCollapsed,
                ),
                _buildDrawerItem(
                  icon: Icons.business_center,
                  label: 'Contratos',
                  isCollapsed: isCollapsed,
                ),
                const Divider(color: Colors.grey),
                _buildDrawerItem(
                  icon: Icons.logout,
                  label: 'Log Out',
                  onTap: () {
                    ref.read(authViewmodelProvider.notifier).logout();
                  },
                  isCollapsed: isCollapsed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required bool isCollapsed,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: isCollapsed
          ? null
          : Text(
              label,
              style: const TextStyle(color: Colors.black),
            ),
      onTap: onTap,
    );
  }
}
