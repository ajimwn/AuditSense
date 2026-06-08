import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color kpmgBlue = Color(0xFF00338D);
  static const Color kpmgRoyalBlue = Color(0xFF005F9E);
  static const Color kpmgBackground = Color(0xFFF5F5F7);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textBody = Color(0xFF334155);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color borderGray = Color(0xFFE2E8F0);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: kpmgBlue,
        primary: kpmgBlue,
        secondary: kpmgRoyalBlue,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSurface: textDark,
        outline: borderGray,
      ),
      scaffoldBackgroundColor: kpmgBackground,
      
      // UX Strategy: Manrope for Authority, Public Sans for High-Density Data
      textTheme: GoogleFonts.publicSansTextTheme().copyWith(
        displayLarge: GoogleFonts.manrope(
          fontWeight: FontWeight.w800,
          color: kpmgBlue,
          letterSpacing: -1.5,
        ),
        displayMedium: GoogleFonts.manrope(
          fontWeight: FontWeight.w700,
          color: kpmgBlue,
          letterSpacing: -1,
        ),
        displaySmall: GoogleFonts.manrope(
          fontWeight: FontWeight.w700,
          color: kpmgBlue,
        ),
        titleLarge: GoogleFonts.manrope(
          fontWeight: FontWeight.w800,
          color: textDark,
        ),
        titleMedium: GoogleFonts.publicSans(
          fontWeight: FontWeight.w700,
          color: textDark,
        ),
        bodyLarge: GoogleFonts.publicSans(
          color: textBody,
          fontSize: 16,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.publicSans(
          color: textBody,
          fontSize: 14,
          height: 1.5,
        ),
        labelLarge: GoogleFonts.publicSans(
          fontWeight: FontWeight.w700,
          fontSize: 12,
          color: textSecondary,
          letterSpacing: 1.1,
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: kpmgBlue,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.manrope(
          color: kpmgBlue,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borderGray),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kpmgBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          textStyle: GoogleFonts.publicSans(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
          elevation: 0,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kpmgBlue, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        labelStyle: GoogleFonts.publicSans(fontWeight: FontWeight.w600, color: textSecondary),
        hintStyle: GoogleFonts.publicSans(color: Colors.grey.shade400, fontSize: 14),
      ),
    );
  }
}
