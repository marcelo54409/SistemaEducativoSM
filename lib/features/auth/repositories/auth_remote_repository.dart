import 'dart:convert';
import 'dart:developer';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tmkt3_app/core/constants/server_constant.dart';
import 'package:tmkt3_app/core/failure/failure.dart';
import 'package:tmkt3_app/features/auth/model/role_model.dart';
import 'package:tmkt3_app/features/auth/model/user_model.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<Failure, UserModel>> login(
      String email, String password) async {
    try {
      // Hacer la solicitud POST
      final response = await http.post(
        Uri.parse('${ServerConstant.BASE_URL}auth/login'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      log("Response Status Code: ${response.statusCode}");

      // Verificar el código de estado
      if (response.statusCode == 200) {
        final user = jsonDecode(response.body);
        log("User: $user");
        // Retornar un objeto Right con el UserModel
        return Right(UserModel(
          user: User.fromJson(user["data"]["user"]),
          token: user['data']['token'],
        ));
      } else {
        final error = jsonDecode(response.body);
        log("Error Response: $error");
        return Left(Failure(error['message'] ?? 'Error desconocido'));
      }
    } catch (error) {
      // Manejar excepciones y errores de red
      log("Catch Error: $error");
      return Left(Failure(error.toString()));
    }
  }

  Future<Either<Failure, UserModel>> register({
    required String email,
    required String password,
    required String razonSocial,
    required String nombre,
    required String puesto,
    required String numeroContacto,
  }) async {
    try {
      // Construir el cuerpo de la solicitud
      final body = jsonEncode({
        'email': email,
        'username': email,
        'password': password,
        'businessName': razonSocial,
        'name': nombre,
        'jobTitle': puesto,
        'phone': numeroContacto,
      });

      // Realizar la solicitud POST
      final response = await http.post(
        Uri.parse('${ServerConstant.BASE_URL}auth/register'),
        body: body,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      log("Response Status Code: ${response.statusCode}");

      // Verificar el código de estado
      if (response.statusCode == 201) {
        final user = jsonDecode(response.body);
        log("Registered User: $user");
        // Retornar un objeto Right con el UserModel
        return Right(UserModel(
          user: User.fromJson(user["data"]["user"]),
          token: user['data']['token'],
        ));
      } else {
        final error = jsonDecode(response.body);
        log("Error Response: $error");
        return Left(Failure(error['message'] ?? 'Error desconocido'));
      }
    } catch (error) {
      // Manejar excepciones y errores de red
      log("Catch Error: $error");
      return Left(Failure(error.toString()));
    }
  }
}
