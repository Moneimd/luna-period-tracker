// lib/utils/theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFFE91E8C);
  static const Color primaryLight = Color(0xFFF48FB1);
  static const Color primaryDark = Color(0xFFC2185B);
  static const Color accent = Color(0xFFFF80AB);
  static const Color fertile = Color(0xFF66BB6A);
  static const Color fertileLight = Color(0xFFA5D6A7);
  static const Color background = Color(0xFFFFF0F5);
  static const Color surface = Colors.white;
  static const Color textDark = Color(0xFF37474F);
  static const Color textMedium = Color(0xFF78909C);

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: primary,
          secondary: accent,
          background: background,
          surface: surface,
        ),
    scaffoldBackgroundColor: background,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: textDark,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: primary),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    fontFamily: 'Roboto',
  );
}

const List<String> kSymptoms = [
  'Crampes 😣',
  'Maux de tête 🤕',
  'Fatigue 😴',
  'Ballonnements 🤢',
  'Sautes d\'humeur 😤',
  'Douleurs dos 😖',
  'Acné 😕',
  'Envies alimentaires 🍫',
  'Nausées 🤮',
  'Seins sensibles 💔',
];
