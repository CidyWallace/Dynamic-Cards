import 'package:flutter/material.dart';

class AppTheme {
  static const Color _mainColor = Color(0xFF0055FF);
  static const Color _mainDarkColor = Color(0xFF6699FF);

  static const Color _lightBackground = Color(0xFFF5F5F5);
  static const Color _darkBackground = Color(0xFF121212);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: _mainColor,
        onPrimary: Colors.white,

        surface: _lightBackground,
        onSurface: Colors.black,

        error: Colors.red,
        onError: Colors.white,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: _mainColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: _mainDarkColor,
        onPrimary: Colors.black,

        surface: _darkBackground,
        onSurface: Colors.white,

        error: Colors.redAccent,
        onError: Colors.black,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: _darkBackground,
        foregroundColor: _mainDarkColor,
        centerTitle: true,
        elevation: 0,
      ),
    );
  }
}
