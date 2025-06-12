import 'package:flutter/material.dart';

class AppTheme {
  // 🎨 Palette Purple personnalisée
  static const Color purple50 = Color(0xFFFAF5FF);
  static const Color purple500 = Color(0xFFAD46FF);
  static const Color purple600 = Color(0xFF9810FA); // Couleur principale
  static const Color purple700 = Color(0xFF8200DB);
  static const Color purple800 = Color(0xFF6E11B0);
  static const Color purple900 = Color(0xFF59168B);

  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'Arial',
      scaffoldBackgroundColor: Colors.white,
      primaryColor: purple600,
      appBarTheme: const AppBarTheme(
        backgroundColor: purple600,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: purple600,
        foregroundColor: Colors.white,
      ),
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: purple600,
        onPrimary: Colors.white,
        secondary: purple800,
        onSecondary: Colors.white,
        background: Colors.white,
        onBackground: Colors.black,
        surface: purple50,
        onSurface: Colors.black,
        error: Colors.red,
        onError: Colors.white,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: purple900,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      fontFamily: 'Arial',
      scaffoldBackgroundColor: const Color(0xFF2E2E2E),
      // Gris foncé
      primaryColor: purple600,
      appBarTheme: const AppBarTheme(
        backgroundColor: purple700,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: purple700,
        foregroundColor: Colors.white,
      ),
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: purple600,
        onPrimary: Colors.white,
        secondary: purple800,
        onSecondary: Colors.white,
        background: Color(0xFF2E2E2E),
        // Gris foncé
        onBackground: Colors.white,
        surface: purple900,
        onSurface: Colors.white,
        error: Colors.red,
        onError: Colors.black,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: purple50,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.white70,
        ),
      ),
    );
  }
}