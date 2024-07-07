import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Light Theme Colors
  static const Color _lightPrimaryColor = Color(0xFF6200EE);
  static const Color _lightPrimaryVariantColor = Color(0xFF3700B3);
  static const Color _lightSecondaryColor = Color(0xFF03DAC6);
  static const Color _lightSecondaryVariantColor = Color(0xFF018786);
  static const Color _lightBackgroundColor = Color(0xFFF5F5F5);
  static const Color _lightErrorColor = Color(0xFFB00020);

// Earth Theme Colors
  static const Color _earthPrimaryColor = Color.fromRGBO(181, 193, 142, 1);
  static const Color _earthPrimaryVariantColor =
      Color.fromRGBO(247, 220, 185, 1);
  static const Color _earthSecondaryColor = Color.fromRGBO(222, 172, 128, 1);
  static const Color _earthSecondaryVariantColor =
      Color.fromRGBO(181, 193, 142, 1);
  static const Color _earthBackgroundColor = Color.fromRGBO(185, 148, 112, 1);
  static const Color _earthErrorColor = Color(0xFFCF6679);

  // Dark Theme Colors
  static const Color _darkPrimaryColor = Color(0xFFBB86FC);
  static const Color _darkPrimaryVariantColor = Color(0xFF3700B3);
  static const Color _darkSecondaryColor = Color(0xFF03DAC6);
  static const Color _darkBackgroundColor = Color(0xFF121212);
  static const Color _darkErrorColor = Color(0xFFCF6679);

  static final ThemeData lightTheme = ThemeData(
    primaryColor: _lightPrimaryColor,
    scaffoldBackgroundColor: _lightBackgroundColor,
    appBarTheme: AppBarTheme(
      color: _lightPrimaryColor,
      iconTheme: IconThemeData(color: Colors.white),
      elevation: 0,
    ),
    colorScheme: ColorScheme.light(
      primary: _lightPrimaryColor,
      primaryContainer: _lightPrimaryVariantColor,
      secondary: _lightSecondaryColor,
      secondaryContainer: _lightSecondaryVariantColor,
      background: _lightBackgroundColor,
      error: _lightErrorColor,
    ),
    textTheme: GoogleFonts.robotoTextTheme().apply(
      bodyColor: Colors.black87,
      displayColor: Colors.black,
    ),
    iconTheme: IconThemeData(
      color: _lightPrimaryColor,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _lightSecondaryColor,
      foregroundColor: Colors.black,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: _lightPrimaryColor,
        onPrimary: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 4,
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: _lightPrimaryColor),
      ),
    ),
  );

  static final ThemeData earthTheme = ThemeData(
    primaryColor: _earthPrimaryColor,
    scaffoldBackgroundColor: _earthBackgroundColor,
    appBarTheme: AppBarTheme(
      color: _earthPrimaryColor,
      iconTheme: IconThemeData(color: Colors.white),
      elevation: 0,
    ),
    colorScheme: ColorScheme.light(
      primary: _earthPrimaryColor,
      primaryContainer: _earthPrimaryVariantColor,
      secondary: _earthSecondaryColor,
      secondaryContainer: _earthSecondaryVariantColor,
      background: _earthBackgroundColor,
      error: _earthErrorColor,
    ),
    textTheme: GoogleFonts.robotoTextTheme().apply(
      bodyColor: Colors.black87,
      displayColor: Colors.black,
    ),
    iconTheme: IconThemeData(
      color: _earthPrimaryColor,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _earthSecondaryColor,
      foregroundColor: Colors.black,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: _earthPrimaryColor,
        onPrimary: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 4,
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: _earthPrimaryColor),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: _darkPrimaryColor,
    scaffoldBackgroundColor: _darkBackgroundColor,
    appBarTheme: AppBarTheme(
      color: _darkBackgroundColor,
      iconTheme: IconThemeData(color: _darkPrimaryColor),
      elevation: 0,
    ),
    colorScheme: ColorScheme.dark(
      primary: _darkPrimaryColor,
      primaryContainer: _darkPrimaryVariantColor,
      secondary: _darkSecondaryColor,
      background: _darkBackgroundColor,
      error: _darkErrorColor,
    ),
    textTheme: GoogleFonts.robotoTextTheme().apply(
      bodyColor: Colors.white70,
      displayColor: Colors.white,
    ),
    iconTheme: IconThemeData(
      color: _darkPrimaryColor,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _darkSecondaryColor,
      foregroundColor: Colors.black,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: _darkPrimaryColor,
        onPrimary: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 4,
      ),
    ),
    cardTheme: CardTheme(
      color: Color(0xFF1E1E1E),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: _darkPrimaryColor),
      ),
    ),
  );
}
