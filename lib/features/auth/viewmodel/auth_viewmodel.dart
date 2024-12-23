import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tmkt3_app/features/auth/model/user_model.dart';
import 'package:tmkt3_app/features/auth/repositories/auth_local_repository.dart';
import 'package:tmkt3_app/features/auth/repositories/auth_remote_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewmodel extends _$AuthViewmodel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  @override
  @override
  AsyncValue<UserModel?> build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    return const AsyncValue.data(null);
  }

  Future initPreferences() async {
    await _authLocalRepository.init();
  }

  Future loginUser(String email, String password) async {
    state = const AsyncValue.loading();
    final reponse = await _authRemoteRepository.login(email, password);
    final val = reponse.fold(
        (l) => state = AsyncValue.error(l.message, StackTrace.current),
        (r) async => await _loginSuccess(r));
  }

  Future<AsyncValue<UserModel?>?> _loginSuccess(UserModel user) async {
    await _authLocalRepository.init();
    await _authLocalRepository.setUser(user);
    _authLocalRepository.setToken(user.token);

    return state = AsyncValue.data(user);
  }

  Future<void> registerUser({
    required String email,
    required String password,
    required String razonSocial,
    required String nombre,
    required String puesto,
    required String numeroContacto,
  }) async {
    state = const AsyncValue.loading();
    final response = await _authRemoteRepository.register(
      email: email,
      password: password,
      razonSocial: razonSocial,
      nombre: nombre,
      puesto: puesto,
      numeroContacto: numeroContacto,
    );

    response.fold(
      (l) {
        state = AsyncValue.error(l.message, StackTrace.current);
        log('Error during registration: ${l.message}');
      },
      (r) async {
        await _loginSuccess(r);
        log('User registered successfully');
      },
    );
  }

  Future<UserModel?> getData() async {
    state = const AsyncValue.loading();
    final token = _authLocalRepository.getToken();
    final user = await _authLocalRepository.getUser();
    if (token != null && user != null) {
      state = AsyncValue.data(user);
      return user;
    } else {
      state = const AsyncValue.data(null);
      return null;
    }
  }

  Future<void> logout() async {
    try {
      state = const AsyncValue.loading();
      _authLocalRepository.clearToken();
      await _authLocalRepository.clear();

      state = const AsyncValue.data(null);
      log('Usuario ha cerrado sesión exitosamente.');
    } catch (error) {
      log('Error al cerrar sesión: $error');
      state = AsyncValue.error('Error al cerrar sesión', StackTrace.current);
    }
  }
}
