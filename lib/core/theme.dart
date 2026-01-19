import 'package:flutter/material.dart';

ThemeData buildLightTheme() {
  final base = ThemeData(
    colorSchemeSeed: const Color(0xFF1E88E5),
    useMaterial3: true,
    brightness: Brightness.light,
  );
  return base.copyWith(
    cardTheme: const CardTheme(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
  );
}

ThemeData buildDarkTheme() {
  final base = ThemeData(
    colorSchemeSeed: const Color(0xFF90CAF9),
    useMaterial3: true,
    brightness: Brightness.dark,
  );
  return base.copyWith(
    cardTheme: const CardTheme(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
  );
}
