import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormulario extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorMessage;
  final bool enabled;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters; // Agregar inputFormatters
  final FocusNode? focusNode;
  const CustomTextFormulario({
    super.key,
    this.label,
    this.suffixIcon,
    this.hint,
    this.errorMessage,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.controller,
    this.initialValue,
    this.inputFormatters,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.grey, width: 0.5),
      borderRadius: BorderRadius.circular(6),
    );

    const borderRadius = Radius.circular(6);

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: borderRadius,
            bottomLeft: borderRadius,
            bottomRight: borderRadius,
            topRight: borderRadius,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 3,
              offset: const Offset(0, 9),
            ),
          ]),
      child: Column(
        children: [
          TextFormField(
            controller: controller,
            focusNode: focusNode,
            enabled: enabled,
            onChanged: onChanged,
            validator: validator,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontSize: 13.8,
              color: Colors.black,
              fontWeight: FontWeight.w300,
            ),
            initialValue: initialValue,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              hintStyle: const TextStyle(color: Colors.grey),
              floatingLabelStyle: const TextStyle(fontSize: 18),
              enabledBorder: border,
              focusedBorder: border,
              errorStyle: const TextStyle(fontSize: 9),
              errorBorder: border.copyWith(
                borderSide: const BorderSide(color: Colors.redAccent),
              ),
              focusedErrorBorder: border.copyWith(
                borderSide: const BorderSide(color: Colors.redAccent),
              ),
              isDense: true,
              label: label != null ? Text(label!) : null,
              hintText: hint,
              focusColor: colors.primary,
              fillColor: colors.primary,
              errorText: errorMessage,
            ),
          ),
        ],
      ),
    );
  }
}
