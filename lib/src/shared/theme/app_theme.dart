import 'package:flutter/material.dart';

class AppTheme {
  static const Color darkGreen = Color(0xFF3B533E);     // Fundo Principal
  static const Color gold = Color(0xFFF7E6B8);          // Acento/Destaque
  static const Color wineRed = Color(0xFF8B0000);       // Alerta/Revogação
  static const Color shelves = Color(0xFF5A4A3A);       // Icone de Estante (simulado)

  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: gold, 
      brightness: Brightness.dark, 
      primary: darkGreen, 
      secondary: gold,    
      background: darkGreen, 
      error: wineRed,     
      surface: const Color(0xFF2e4033),
    ),
    scaffoldBackgroundColor: darkGreen,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Colors.white),
      headlineMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: darkGreen, 
        backgroundColor: gold, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}
