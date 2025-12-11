import 'package:flutter/material.dart';

class AppTheme {
  // Paleta da Livraria do Duque (Cores essenciais)
  static const Color darkGreen = Color(0xFF3B533E);     // Fundo Principal
  static const Color gold = Color(0xFFF7E6B8);          // Acento/Destaque
  static const Color wineRed = Color(0xFF8B0000);       // Alerta/Revogação
  static const Color shelves = Color(0xFF5A4A3A);       // Icone de Estante (simulado)

  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    // Tema Escuro, baseando-se no DarkGreen como fundo
    colorScheme: ColorScheme.fromSeed(
      seedColor: gold, 
      brightness: Brightness.dark, 
      primary: darkGreen, // Cor principal para barras
      secondary: gold,    // Cor de destaque
      background: darkGreen, 
      error: wineRed,     // Cor de alerta
      surface: const Color(0xFF2e4033), // Superfícies (Cards, Diálogos)
    ),
    scaffoldBackgroundColor: darkGreen,
    // Tipografia
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Colors.white),
      headlineMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
    ),
    // Estilo dos botões
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