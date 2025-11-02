// lib/constants/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryLight = Color(0xFF6200EE);
  static const Color primaryDark = Color(0xFFBB86FC);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1E1E1E);

  static final TextTheme _textTheme = GoogleFonts.poppinsTextTheme();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryLight,
    scaffoldBackgroundColor: backgroundLight,
    cardColor: cardLight,
    textTheme: _textTheme.apply(bodyColor: Colors.black),
    colorScheme: const ColorScheme.light(
      primary: primaryLight,
      secondary: primaryLight,
      background: backgroundLight,
      surface: cardLight, // REVISI (Warning): Ganti backgroundColor
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Colors.black,
      onSurface: Colors.black, // REVISI (Warning): Ganti onBackground
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryLight,
      titleTextStyle: _textTheme.titleLarge?.copyWith(color: Colors.white),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
        textStyle: _textTheme.labelLarge,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryDark,
    scaffoldBackgroundColor: backgroundDark,
    cardColor: cardDark,
    textTheme: _textTheme.apply(bodyColor: Colors.white),
    colorScheme: const ColorScheme.dark(
      primary: primaryDark,
      secondary: primaryDark,
      background: backgroundDark,
      surface: cardDark, // REVISI (Warning): Ganti backgroundColor
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onBackground: Colors.white,
      onSurface: Colors.white, // REVISI (Warning): Ganti onBackground
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundDark,
      titleTextStyle: _textTheme.titleLarge?.copyWith(color: Colors.white),
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryDark,
        foregroundColor: Colors.black,
        textStyle: _textTheme.labelLarge,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}