import 'package:flutter/material.dart';
import 'ui/home_screen.dart'; // 1. Import your new screen here!

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          background: Colors.grey[50],
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(), // 2. Tell the app to load your new screen!
    );
  }
}
