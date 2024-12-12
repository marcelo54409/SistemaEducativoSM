import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmkt3_app/features/auth/viewmodel/auth_viewmodel.dart';

class HomeClientScreen extends ConsumerStatefulWidget {
  const HomeClientScreen({super.key});

  @override
  ConsumerState<HomeClientScreen> createState() => _HomeClientScreenState();
}

class _HomeClientScreenState extends ConsumerState<HomeClientScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
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
            Text(
              'Principal',
              style: textTheme.headlineMedium,
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                ref.read(authViewmodelProvider.notifier).logout();
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 9),
              child: Wrap(
                runSpacing: 9,
                children: [
                  ElevatedButton(
                      onPressed: () {},
                      child: Text('Visitas'),
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Color(0xFFFFEDE0))),
                  SizedBox(width: 9),
                  ElevatedButton(
                      onPressed: () {},
                      child: Text('Estadisiticas'),
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Color(0xFFFFEDE0))),
                  SizedBox(width: 9),
                  ElevatedButton(
                      onPressed: () {},
                      child: Text('Nuevas Misiones'),
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Color(0xFFFFEDE0))),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  width: size.width,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFF7C1C),
                        Color(0xFFCC1650),
                        Color(0xFFB80C81),
                      ],
                      stops: [
                        0, // El primer color termina al 20% del gradiente
                        0.8, // El segundo color termina al 50% del gradiente
                        1, // El tercer color comienza al 80% del gradiente
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "¿Tienes un proyecto diferente?",
                        style: textTheme.headlineMedium
                            ?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "¡Nosotros te ayudamos! Cuéntanos sobre tu proyecto y te contactaremos pronto.",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      const SizedBox(height: 9),
                      ElevatedButton.icon(
                          icon: Icon(
                            Icons.arrow_right_alt_outlined,
                          ),
                          iconAlignment: IconAlignment.end,
                          onPressed: () {},
                          label: Text("Contáctanos ahora!"))
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Grafica de Visitas',
              style: textTheme.headlineMedium,
            ),
            const SizedBox(height: 18),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barGroups: _getBarGroups(),
                  titlesData: FlTitlesData(
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 10,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const regions = [
                            'Baja California',
                            'Coahuila',
                            'Jalisco',
                            'Hidalgo',
                            'Puebla',
                            'Oaxaca'
                          ];
                          return Text(
                            regions[value.toInt()],
                            style: TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Enviar comentarios",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Escribe tus comentarios aquí",
                      filled:
                          true, // Indica que el campo de texto debe rellenarse con un color de fondo
                      fillColor: Color(0xFFFFE4CF), // Define el color de fondo
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // Bordes redondeados
                        borderSide: BorderSide.none, // Elimina el borde
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // Bordes redondeados
                        borderSide: BorderSide(
                            color: Colors.transparent, width: 0.0), // Sin borde
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Bordes redondeados al enfocar
                        borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1.0), // Color del borde al enfocar
                      ),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  FilledButton(onPressed: () {}, child: Text("Enviar"))
                ],
              ),
            ),
            SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    final data = [
      [60, 80, 100], // Baja California
      [40, 70, 90], // Coahuila
      [30, 60, 90], // Jalisco
      [50, 80, 100], // Hidalgo
      [20, 40, 70], // Puebla
      [10, 50, 80], // Oaxaca
    ];

    return List.generate(data.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: List.generate(data[i].length, (j) {
          return BarChartRodData(
            toY: data[i][j].toDouble(),
            width: 12,
            color: j == 0
                ? Colors.blue
                : j == 1
                    ? Colors.red
                    : Colors.cyan,
            borderRadius: BorderRadius.circular(4),
          );
        }),
      );
    });
  }
}
