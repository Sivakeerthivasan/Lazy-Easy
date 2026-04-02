import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ── Color Palette ──────────────────────────────────────────────────────
  static const Color primaryColor = Color(0xFF7C4DFF);
  static const Color primaryDark = Color(0xFF651FFF);
  static const Color secondary = Color(0xFFB388FF);
  static const Color surface = Color(0xFFF3E5F5);
  static const Color backgroundDark = Color(0xFF1A0033);
  static const Color backgroundMid = Color(0xFF4A148C);
  static const Color onPrimary = Colors.white;
  static const Color error = Color(0xFFFF5252);
  static const Color textLight = Color(0xFFEDE7F6);
  static const Color textMuted = Color(0xFFCE93D8);
  static const Color cardDark = Color(0xFF2D004F);

  // ── Gradients ──────────────────────────────────────────────────────────
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [backgroundDark, backgroundMid],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [primaryColor, primaryDark],
  );

  // ── Theme Data ─────────────────────────────────────────────────────────
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondary,
        surface: cardDark,
        error: error,
        onPrimary: onPrimary,
        onSecondary: Colors.white,
        onSurface: textLight,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
            color: onPrimary,
            letterSpacing: -0.5,
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: onPrimary,
          ),
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: onPrimary,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textLight,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: textLight,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: textMuted,
          ),
          labelLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: onPrimary,
            letterSpacing: 0.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardDark.withValues(alpha: 0.6),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: secondary.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: secondary.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: error, width: 2),
        ),
        hintStyle: TextStyle(color: textMuted.withValues(alpha: 0.6)),
        prefixIconColor: secondary,
        labelStyle: const TextStyle(color: textMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onPrimary,
        ),
        iconTheme: const IconThemeData(color: onPrimary),
      ),
    );
  }
}
