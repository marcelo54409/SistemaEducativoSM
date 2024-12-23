import 'package:flutter/material.dart';

import 'package:tmkt3_app/core/router/router.dart';
import 'package:tmkt3_app/core/theme/theme.dart';
//TODO: Sign in
import 'package:tmkt3_app/features/auth/view/page/signin_page.dart';
import 'package:tmkt3_app/features/auth/view/page/signup_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmkt3_app/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:tmkt3_app/features/home/alumnos/alumnos_get_screen.dart';
import 'package:tmkt3_app/features/home/asignacion_escala/asig_escala_screen.dart';
import 'package:tmkt3_app/features/home/concepto/concepto_get_screen.dart';
import 'package:tmkt3_app/features/home/condonacion/condonacion_get_screen.dart';
import 'package:tmkt3_app/features/home/deuda/deuda_get_screen.dart';
import 'package:tmkt3_app/features/home/escalas/escalas_get_screen.dart';
import 'package:tmkt3_app/features/home/principal/home_admin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(authViewmodelProvider.notifier).initPreferences();
  runApp(
      UncontrolledProviderScope(container: container, child: const MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightThemeMode,
      home: AsigEscalaScreen(),
    );
  }
}
