import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class ElegantDropdown extends StatelessWidget {
  final SingleValueDropDownController controller;
  final List<DropDownValueModel> dropdownList;
  final String labelText;
  final String? Function(String?)? validator;

  const ElegantDropdown({
    Key? key,
    required this.controller,
    required this.dropdownList,
    this.labelText = "Seleccionar",
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropDownTextField(
      dropDownItemCount: 3,
      dropDownList: dropdownList,
      enableSearch: true,
      controller: controller,
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return "Este campo es requerido";
            }
            return null;
          },
      textFieldDecoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.blue[300]!,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.red[200]!,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.red[300]!,
            width: 1.5,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        isDense: true,
      ),
      dropDownIconProperty:
          IconProperty(icon: Icons.keyboard_arrow_down_rounded),
      clearIconProperty: IconProperty(icon: Icons.close_rounded),

      // Estilo para el campo de búsqueda
      searchDecoration: InputDecoration(
        hintText: "Buscar...",
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.blue[300]!,
            width: 1.5,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        isDense: true,
        prefixIcon: Icon(
          Icons.search_rounded,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}
