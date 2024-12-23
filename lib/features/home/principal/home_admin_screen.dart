import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmkt3_app/features/home/widgets/custom_drawer.dart';

class HomeAdminScreen extends StatelessWidget {
  final Object? extra;
  const HomeAdminScreen({super.key, this.extra});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CustomDrawer(
          userName: "Marcelo Raul",
          userEmail: "marceloperu09",
          userAvatarUrl: "url"),
      appBar: AppBar(
        title: Text(
          'Inicio',
          style: textTheme.headlineMedium,
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
      body: Padding(padding: const EdgeInsets.all(18.0), child: Container()),
    );
  }
}
