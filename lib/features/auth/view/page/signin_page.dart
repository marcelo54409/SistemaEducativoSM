import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tmkt3_app/core/router/router.dart';
import 'package:tmkt3_app/features/auth/model/user_model.dart';
import 'package:tmkt3_app/features/auth/repositories/auth_remote_repository.dart';
import 'package:tmkt3_app/features/auth/view/page/signup_page.dart';
import 'package:tmkt3_app/features/auth/view/widgets/custom_text_form_field.dart';
import 'package:tmkt3_app/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:tmkt3_app/features/home/cliente/home_client_screen.dart';
import 'package:tmkt3_app/features/home/principal/home_admin_screen.dart';
import 'package:tmkt3_app/features/home/supervisor/home_supervisor_screen.dart';

class SigninPage extends ConsumerStatefulWidget {
  const SigninPage({super.key});

  @override
  ConsumerState<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends ConsumerState<SigninPage> {
  final usuarioController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool passwordVisible = true;

  @override
  void dispose() {
    usuarioController.dispose();
    passwordController.dispose();
    super.dispose();
    formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authViewmodelProvider)?.isLoading == true;

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 9,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        width: constraints.maxWidth,
                        margin: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth > 600
                              ? constraints.maxWidth * .33
                              : constraints.maxWidth * .03,
                          vertical: constraints.maxHeight * .12,
                        ),
                        padding: const EdgeInsets.all(21),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/logo_principal.png',
                                    width: 50,
                                    height: 50,
                                  ),
                                  Text('TMKT3', style: textTheme.titleLarge),
                                ],
                              ),
                              const SizedBox(height: 45),
                              Text(
                                'Inicio de sesión',
                                style: textTheme.headlineMedium,
                              ),
                              const SizedBox(height: 27),
                              Text(
                                'Usuario',
                                style: textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 6),
                              CustomTextFormField(
                                hint: 'Ingresa tu usuario',
                                controller: usuarioController,
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'El usuario es requerido';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 15),
                              Text(
                                'Contraseña',
                                style: textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 6),
                              CustomTextFormField(
                                hint: 'Ingresa tu contraseña segura',
                                obscureText: passwordVisible,
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return 'La contraseña es requerida';
                                  }
                                  return null;
                                },
                                controller: passwordController,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      passwordVisible = !passwordVisible;
                                    });
                                  },
                                  icon: Icon(passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text('Olvidé mi contraseña'),
                                ),
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                width: constraints.maxWidth,
                                child: FilledButton(
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      final email = usuarioController.text;
                                      final password = passwordController.text;
                                      await ref
                                          .read(authViewmodelProvider.notifier)
                                          .loginUser(email, password);

                                      //implementar mensaje sccafold
                                    }
                                  },
                                  child: Text("Iniciar sesión"),
                                ),
                              ),
                              const SizedBox(height: 9),
                              kIsWeb
                                  ? SizedBox(
                                      width: constraints.maxWidth,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          context.push('/signup');
                                        },
                                        child: Text("Registrarme"),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
