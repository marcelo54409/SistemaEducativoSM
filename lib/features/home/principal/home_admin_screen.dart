import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmkt3_app/features/home/principal/widgets/custom_drawer.dart';

class HomeAdminScreen extends StatelessWidget {
  final Object? extra;
  const HomeAdminScreen({super.key, this.extra});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: PartialDrawer(),
      appBar: AppBar(
        title: Text(
          'Clientes',
          style: textTheme.headlineMedium?.copyWith(color: Colors.orange),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              // Acción para agregar un nuevo cliente
            },
            icon: const Icon(Icons.add, color: Colors.orange),
            label: const Text(
              'Nuevo Cliente',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contador de registros y campo de búsqueda
            Row(
              children: [
                Text('Registros', style: textTheme.bodyMedium),
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('30'),
                ),
                const Spacer(),
                SizedBox(
                  width: 200,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            // Tabla de clientes
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Encabezados de la tabla
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      color: Colors.orange[100],
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Nombre',
                              style: textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Acciones',
                              style: textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Lista de clientes
                    ...List.generate(5, (index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text('Globex Corporation',
                                  style: textTheme.bodyMedium),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      SharedPreferences.getInstance()
                                          .then((prefs) {
                                        final result =
                                            prefs.get('x-auth-token');
                                        log(result.toString());
                                      });
                                    },
                                    icon: const Icon(Icons.shopping_cart,
                                        color: Colors.blue),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.edit,
                                        color: Colors.orange),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // Acción para eliminar
                                    },
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // Acción para más opciones
                                    },
                                    icon: const Icon(Icons.more_horiz,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
