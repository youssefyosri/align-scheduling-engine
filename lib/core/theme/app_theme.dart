import 'package:flutter/material.dart';

class AppTheme {
  // Base Colors for Align
  static const Color _primaryBrandColor = Color(0xFF1A1A1A); // Deep Obsidian

  // Light Mode Colors
  static const Color _lightBg = Color(0xFFFAF9F6); // Warm Ivory
  static const Color _lightCard = Color(0xFFFFFFFF); // Pure White
  static const Color _lightBorder = Color(0xFFE5E5E5); // Soft contrast border

  // Dark Mode Colors
  static const Color _darkBg = Color(0xFF121212); // True Dark
  static const Color _darkCard = Color(0xFF1A1A1A); // Obsidian Cards
  static const Color _darkBorder = Color(0xFF2A2A2A); // Subtle dark border

  // --- LIGHT THEME ---
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryBrandColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // Automatic Background
      scaffoldBackgroundColor: _lightBg,

      // Automatic AppBar Styling
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightBg,
        foregroundColor: _primaryBrandColor, // Dark text on Ivory
        elevation: 0,
        centerTitle: false,
      ),

      // Automatic Card Styling
      cardTheme: const CardThemeData(
        color: _lightCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: _lightBorder, width: 1),
        ),
      ),

      // Text Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryBrandColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
      ),

      // Primary Buttons
      elevatedButtonTheme: _buttonTheme(colorScheme, _primaryBrandColor, Colors.white),
    );
  }

  // --- DARK THEME ---
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryBrandColor,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // Automatic Background
      scaffoldBackgroundColor: _darkBg,

      // Automatic AppBar Styling
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkBg,
        foregroundColor: Colors.white, // White text on True Dark
        elevation: 0,
        centerTitle: false,
      ),

      // Automatic Card Styling
      cardTheme: const CardThemeData(
        color: _darkCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: _darkBorder, width: 1),
        ),
      ),

      // Text Fields
      inputDecorationTheme: lightTheme.inputDecorationTheme.copyWith(
        fillColor: _darkCard,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
      ),

      // Primary Buttons
      elevatedButtonTheme: _buttonTheme(colorScheme, Colors.white, _darkBg),
    );
  }

  // Helper for buttons to keep code DRY
  static ElevatedButtonThemeData _buttonTheme(ColorScheme colorScheme, Color bg, Color fg) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: bg,
        foregroundColor: fg,
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}