// router.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:tmkt3_app/core/router/auth_notifier_provider.dart';
import 'package:tmkt3_app/features/auth/view/page/signin_page.dart';
import 'package:tmkt3_app/features/auth/view/page/signup_page.dart';
import 'package:tmkt3_app/features/auth/view/page/splash_screen.dart';
import 'package:tmkt3_app/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:tmkt3_app/features/home/alumnos/alumnos_get_screen.dart';
import 'package:tmkt3_app/features/home/concepto/concepto_get_screen.dart';
import 'package:tmkt3_app/features/home/escalas/escalas_get_screen.dart';

import 'package:tmkt3_app/features/home/principal/home_admin_screen.dart';
import 'package:tmkt3_app/features/home/supervisor/home_supervisor_screen.dart';
import 'package:tmkt3_app/features/auth/model/user_model.dart';
import 'package:tmkt3_app/features/home/usuarios/usuarios_get_screen.dart';

part 'router.g.dart';

@riverpod
GoRouter goRouter(ref) {
  final authState = ref.watch(authViewmodelProvider);

  /// Lógica de redirección basada en el estado de autenticación
  String? redirectLogic(BuildContext context, GoRouterState state) {
    final isLoggingIn = state.uri.path.startsWith('/signin') ||
        state.uri.path.startsWith('/signup');

    // Manejar null de manera explícita
    if (authState == null) {
      return '/signin';
    }

    // Manejar AsyncValue de manera segura
    if (authState is AsyncData<UserModel?>) {
      final user = authState.value;

      final isLoggedIn = user != null && user.token.isNotEmpty == true;

      if (!isLoggedIn) {
        // Usuario no logueado, redirigir a SignIn si no está ya allí
        return isLoggingIn ? null : '/signin';
      }

      // Usuario está logueado
      log("path ${state.uri.path}");
      if (isLoggedIn) {
        // Si el usuario está logueado y trata de acceder a /signin o /signup, lo llevas a /admin
        if (isLoggingIn) {
          return "/admin";
        }

        // Si el usuario está logueado y se encuentra en la splash (ruta '/'), redirigir a /admin
        if (state.uri.path == '/') {
          return "/admin";
        }

        // Si el usuario está logueado y no está en rutas de autenticación ni en '/', no redirigir.
        return null;
      }
    }

    if (authState is AsyncLoading) {
      log('Loading...');
      // Mientras se carga el estado, mostrar SplashPage
      return null;
    }

    if (authState is AsyncError) {
      log('Error in auth state: ${(authState as AsyncError).error}');
      // En caso de error, redirigir a /signin
      return '/signin';
    }

    // Caso por defecto
    return '/signin';
  }

  return GoRouter(
    initialLocation: '/', // Ruta de SplashPage
    refreshListenable: ref.watch(authChangeNotifierProvider),
    redirect: redirectLogic,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/signin',
        builder: (context, state) => const SigninPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const HomeAdminScreen(),
      ),
      GoRoute(
        path: '/alumnos',
        builder: (context, state) => AlumnosGetScreen(),
      ),
      GoRoute(
        path: '/escalas',
        builder: (context, state) => EscalasGetScreen(),
      ),
      GoRoute(
        path: '/conceptos',
        builder: (context, state) => ConceptoGetScreen(),
      ),
    ],
  );
}
