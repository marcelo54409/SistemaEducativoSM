import 'package:flutter/material.dart';
import 'package:tmkt3_app/core/theme/app_pallete.dart';

class AppTheme {
  static const fontFamily = 'Poppins';
  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(10),
      );

  static final darkThemeMode = ThemeData.dark().copyWith();
  static final lightThemeMode = ThemeData.light().copyWith(
    primaryColor: Pallete.buttonColor,
    colorScheme: const ColorScheme.light(
      primary: Pallete.buttonColor,
    ),
    scaffoldBackgroundColor: Pallete.backgroundColor,
    cardColor: Pallete.cardColor,
    textTheme: textTheme,
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: _border(Pallete.greenColor),
      enabledBorder: _border(Pallete.borderColor),
      errorBorder: _border(Pallete.errorColor),
      focusedErrorBorder: _border(Pallete.errorColor),
      hintStyle: const TextStyle(
        color: Pallete.subtitleText,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Pallete.cardColor,
      selectedItemColor: Pallete.greenColor,
      unselectedItemColor: Pallete.inactiveBottomBarItemColor,
    ),
  );

  static const TextTheme textTheme = TextTheme(
    titleLarge: TextStyle(
      // Título principal
      fontSize: 36,
      fontWeight: FontWeight.w600,
      color: Pallete.titleText,
      fontFamily: fontFamily,
    ),
    headlineLarge: TextStyle(
      // Título principal
      fontSize: 30,
      fontWeight: FontWeight.w700,
      color: Pallete.primaryTextColor,
      fontFamily: fontFamily,
    ),
    headlineMedium: TextStyle(
      // Subtítulo principal
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Pallete.primaryTextColor,
      fontFamily: fontFamily,
    ),
    bodyLarge: TextStyle(
      // Texto normal
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Pallete.secondaryTextColor,
      fontFamily: fontFamily,
    ),
    bodyMedium: TextStyle(
      // Texto secundario
      fontSize: 17.5,
      fontWeight: FontWeight.normal,
      color: Pallete.primaryTextColor,
      fontFamily: fontFamily,
    ),
    bodySmall: TextStyle(
      // Texto secundario
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Pallete.subtitleText,
      fontFamily: fontFamily,
    ),
  );
}
