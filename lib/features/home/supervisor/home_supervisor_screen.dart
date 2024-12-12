import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmkt3_app/features/auth/viewmodel/auth_viewmodel.dart';

class HomeSupervisorScreen extends ConsumerStatefulWidget {
  const HomeSupervisorScreen({super.key});

  @override
  ConsumerState<HomeSupervisorScreen> createState() =>
      _HomeSupervisorScreenState();
}

class _HomeSupervisorScreenState extends ConsumerState<HomeSupervisorScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            icon: const Icon(Icons.download),
            label: const Text('Reporte'),
          ),
          SizedBox(width: 9),
          IconButton(
            onPressed: () {
              ref.watch(authViewmodelProvider.notifier).logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        title: Row(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 33, // Ajusta este tamaño para el diámetro del contenedor
                height: 33,

                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xFFFF7C1C)),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo_principal.png',
                    width: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 9),
            Text('Supervisión de visitas', style: textTheme.headlineMedium),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filtros
            Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Zonas'),
                  items: ['Zona 1', 'Zona 2', 'Zona 3']
                      .map((zona) => DropdownMenuItem(
                            value: zona,
                            child: Text(zona),
                          ))
                      .toList(),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Fecha',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Promotor'),
                  items: ['Juan Lopez', 'Maria Perez', 'Carlos Gomez']
                      .map((promotor) => DropdownMenuItem(
                            value: promotor,
                            child: Text(promotor),
                          ))
                      .toList(),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Asignación'),
                  items: ['Pendiente', 'Completado', 'Cancelado']
                      .map((estado) => DropdownMenuItem(
                            value: estado,
                            child: Text(estado),
                          ))
                      .toList(),
                  onChanged: (value) {},
                ),
              ],
            ),
            const SizedBox(height: 18),
            // Tarjetas de visitas
            Expanded(
              child: ListView(
                children: [
                  _buildVisitaCard(
                    context,
                    titulo: 'Walmart Morelos',
                    promotor: 'Juan Lopez',
                    fecha: '10/02/2021',
                    tiempo: '45 minutos',
                    estado: 'Pendiente',
                  ),
                  _buildVisitaCard(
                    context,
                    titulo: 'Soriana Centro',
                    promotor: 'Juan Lopez',
                    fecha: '10/02/2021',
                    tiempo: '45 minutos',
                    estado: 'Pendiente',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisitaCard(
    BuildContext context, {
    required String titulo,
    required String promotor,
    required String fecha,
    required String tiempo,
    required String estado,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 15,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text('Promotor: $promotor'),
            Text('Fecha: $fecha'),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 6),
                Text(tiempo),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: estado == 'Pendiente'
                    ? Colors.orange[100]
                    : Colors.green[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                estado,
                style: TextStyle(
                  color: estado == 'Pendiente' ? Colors.orange : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
