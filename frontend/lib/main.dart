import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ui/login_screen.dart';
import 'ui/register_screen.dart';
import 'ui/main_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AuditSense FYP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF00338D), // KPMG-like Deep Blue
          secondary: Color(0xFF0091DA), // Light Blue Accent
          surface: Colors.white,
          onPrimary: Colors.white,
          onSurface: Color(0xFF333333),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF00338D),
          elevation: 1,
          shadowColor: Colors.black12,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00338D),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Color(0xFF00338D), width: 2),
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/layout': (context) => const MainLayout(),
      },
    );
  }
}
