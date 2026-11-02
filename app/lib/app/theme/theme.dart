import 'package:flutter/material.dart';

class RekindleTheme {
  // Light Palette
  static const Color lightPageBackground = Color(0xFFFAF7F2);
  static const Color lightSurfaceCard = Color(0xFFFFFDF9);
  static const Color lightTextPrimary = Color(0xFF2B2622);
  static const Color lightTextSecondary = Color(0xFF6F665D);
  static const Color lightBorder = Color(0xFFE8E1D6);
  static const Color lightAccentTintBackground = Color(0xFFF7E6D3);
  static const Color lightAccentTintText = Color(0xFF8A4B14);
  static const Color accentEmber = Color(0xFFC6742F);

  // Dark Palette
  static const Color darkPageBackground = Color(0xFF1E1B18);
  static const Color darkSurfaceCard = Color(0xFF2A2521);
  static const Color darkTextPrimary = Color(0xFFF0EAE0);
  static const Color darkTextSecondary = Color(0xFFB8AEA0);
  static const Color darkBorder = Color(0xFF3A342D);
  static const Color darkAccentTintBackground = Color(0xFF3A2A1A);
  static const Color darkAccentTintText = Color(0xFFF0B267);

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightPageBackground,
      colorScheme: const ColorScheme.light(
        surface: lightSurfaceCard,
        onSurface: lightTextPrimary,
        onSurfaceVariant: lightTextSecondary,
        outlineVariant: lightBorder,
        primary: accentEmber,
        primaryContainer: lightAccentTintBackground,
        onPrimaryContainer: lightAccentTintText,
      ),
      cardTheme: const CardThemeData(
        color: lightSurfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          side: BorderSide(color: lightBorder),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: lightAccentTintBackground,
          foregroundColor: lightAccentTintText,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: lightTextPrimary,
          side: const BorderSide(color: lightBorder),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontFamily: 'Lora',
          fontSize: 19,
          height: 1.6,
          color: lightTextPrimary,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: lightTextPrimary,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: lightTextSecondary,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: lightTextPrimary,
        ),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkPageBackground,
      colorScheme: const ColorScheme.dark(
        surface: darkSurfaceCard,
        onSurface: darkTextPrimary,
        onSurfaceVariant: darkTextSecondary,
        outlineVariant: darkBorder,
        primary: accentEmber,
        primaryContainer: darkAccentTintBackground,
        onPrimaryContainer: darkAccentTintText,
      ),
      cardTheme: const CardThemeData(
        color: darkSurfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          side: BorderSide(color: darkBorder),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: darkAccentTintBackground,
          foregroundColor: darkAccentTintText,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: darkTextPrimary,
          side: const BorderSide(color: darkBorder),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontFamily: 'Lora',
          fontSize: 19,
          height: 1.6,
          color: darkTextPrimary,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: darkTextPrimary,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: darkTextSecondary,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: darkTextPrimary,
        ),
      ),
    );
  }
}
