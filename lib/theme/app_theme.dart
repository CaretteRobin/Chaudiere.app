import 'package:flutter/material.dart';

class AppTheme {
  // 🎨 Couleurs converties depuis OKLCH
  static const Color primaryPurple = Color(0xFF9857A9); // oklch(55.8% ...)
  static const Color darkPurple = Color(0xFF884E99);    // oklch(49.6% ...)

  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'Arial',
      scaffoldBackgroundColor: Colors.white,
      primaryColor: primaryPurple,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryPurple,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPurple,
        primary: primaryPurple,
        secondary: darkPurple,
        brightness: Brightness.light,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        bodyLarge: TextStyle(fontSize: 16),
        bodyMedium: TextStyle(fontSize: 14),
      ),
    );
  }
}
