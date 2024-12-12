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
import 'package:tmkt3_app/features/home/cliente/home_client_screen.dart';
import 'package:tmkt3_app/features/home/principal/home_admin_screen.dart';
import 'package:tmkt3_app/features/home/supervisor/home_supervisor_screen.dart';
import 'package:tmkt3_app/features/auth/model/user_model.dart';

part 'router.g.dart';

@riverpod
GoRouter goRouter(ref) {
  final authState = ref.watch(authViewmodelProvider);

  /// Lógica de redirección basada en el estado de autenticación
  String? redirectLogic(BuildContext context, GoRouterState state) {
    log('Redirecting to ${state.uri.path}');
    final isLoggingIn =
        state.uri.path == '/signin' || state.uri.path == '/signup';

    // Manejar null de manera explícita
    if (authState == null) {
      return '/signin';
    }

    // Manejar AsyncValue de manera segura
    if (authState is AsyncData<UserModel?>) {
      final user = authState.value;
      log('Usererasd: ${user != null} token: ${user?.token.isNotEmpty}');

      final isLoggedIn = user != null && user.token?.isNotEmpty == true;
      log('Is logged in: $isLoggedIn');
      if (!isLoggedIn) {
        // Usuario no logueado, redirigir a SignIn si no está ya allí
        return isLoggingIn ? null : '/signin';
      }

      // Usuario está logueado
      log("path ${state.uri.path}");
      if (isLoggedIn) {
        log('Already logged in, redirecting to home');
        // Si está en /signin o /signup, redirigir a la página principal según el rol
        final role = user.role?.name?.toLowerCase() ?? '';
        if (role == 'admin') {
          return '/admin';
        }
        if (role == 'client') {
          return '/client';
        }
        if (role == 'supervisor') {
          return '/supervisor';
        }
        // Ruta por defecto si no se encuentra el rol
        return '/client';
      }

      // Si ya está logueado y no está en la página de login, no redirigir
      return null;
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
        path: '/client',
        builder: (context, state) => const HomeClientScreen(),
      ),
      GoRoute(
        path: '/supervisor',
        builder: (context, state) => const HomeSupervisorScreen(),
      ),
    ],
  );
}
