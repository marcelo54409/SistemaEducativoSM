import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmkt3_app/core/theme/theme.dart';
import 'package:tmkt3_app/features/auth/view/widgets/custom_text_form_field.dart';
import 'package:tmkt3_app/features/auth/viewmodel/auth_viewmodel.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final correoController = TextEditingController();
  final razonSocialController = TextEditingController();
  final nombreController = TextEditingController();
  final puestoController = TextEditingController();
  final numeroContactoController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey1 = GlobalKey<FormState>();
  bool passwordVisible = true;
  bool passwordConfVisible = true;

  @override
  void dispose() {
    correoController.dispose();
    razonSocialController.dispose();
    nombreController.dispose();
    puestoController.dispose();
    numeroContactoController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
    formKey1.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authViewmodelProvider)?.isLoading == true;

    ref.listen(authViewmodelProvider, (_, next) {
      next?.when(
        data: (data) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              backgroundColor: Color(0xFFFF7C1C),
              content: Text('Usuario registrado: ${data?.user.username}'),
            ));
          Navigator.of(context).pop(); // Regresar a la pantalla anterior
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              backgroundColor: Color(0xFFFF7C1C),
              content: Text('${error.toString()}'),
            ));
        },
        loading: () {},
      );
    });
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Evita el cambio de tamaño del contenido
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 9,
                        offset: const Offset(0, 3))
                  ]),
              width: size.width,
              height: size.height,
              margin: EdgeInsets.symmetric(
                  horizontal:
                      size.width > 600 ? size.width * .33 : size.width * .03,
                  vertical: size.height * .12),
              padding: const EdgeInsets.all(21),
              child: Form(
                key: formKey1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child:
                            Text('Bienvenido', style: textTheme.headlineLarge)),
                    const SizedBox(height: 9),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width:
                            50, // Ajusta este tamaño para el diámetro del contenedor
                        height: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xFFFF7C1C)),
                        child: Center(
                          child: Image.asset(
                            'assets/images/logo_principal.png',
                            width: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      'Regístrate',
                      style: textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Correo electrónico',
                              style: textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 9),
                            CustomTextFormField(
                              hint: 'Ingresa tu correo',
                              keyboardType: TextInputType.emailAddress,
                              controller: correoController,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'El correo es requerido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'Razón social',
                              style: textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 9),
                            CustomTextFormField(
                              hint: 'Ingresa tu razón social',
                              controller: razonSocialController,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'La razón social es requerida';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'Nombre',
                              style: textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 9),
                            CustomTextFormField(
                              hint: 'Ingresa tu nombre',
                              controller: nombreController,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'El nombre es requerido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'Puesto',
                              style: textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 9),
                            CustomTextFormField(
                              hint: 'Ingresa tu puesto',
                              controller: puestoController,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'El puesto es requerido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'Numero de contacto',
                              style: textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 9),
                            CustomTextFormField(
                              hint: 'Ingresa número de contacto',
                              controller: numeroContactoController,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'El número de contacto es requerido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'Contraseña',
                              style: textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 9),
                            CustomTextFormField(
                              hint: 'Ingresa una contraseña',
                              controller: passwordController,
                              obscureText: passwordVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'La contraseña es requerida';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'Confirmar contraseña',
                              style: textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 9),
                            CustomTextFormField(
                              hint: 'Repite tu contraseña',
                              keyboardType: TextInputType.emailAddress,
                              obscureText: passwordConfVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  passwordConfVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passwordConfVisible = !passwordConfVisible;
                                  });
                                },
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'La contraseña es requerida';
                                }
                                return null;
                              },
                              controller: confirmPasswordController,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                        width: size.width,
                        child: FilledButton(
                            onPressed: () async {
                              if (formKey1.currentState!.validate()) {
                                if (passwordController.text !=
                                    confirmPasswordController.text) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor: Color(0xFFFF7C1C),
                                        content: Text(
                                            'Las contraseñas no coinciden')),
                                  );
                                  return;
                                }
                                final authViewmodel =
                                    ref.read(authViewmodelProvider.notifier);

                                // Llamar al método de registro
                                await authViewmodel.registerUser(
                                  email: correoController.text,
                                  password: passwordController.text,
                                  razonSocial: razonSocialController.text,
                                  nombre: nombreController.text,
                                  puesto: puestoController.text,
                                  numeroContacto: numeroContactoController.text,
                                );
                              }
                            },
                            child: Text("Registrarme")))
                  ],
                ),
              ),
            ),
    );
  }
}
