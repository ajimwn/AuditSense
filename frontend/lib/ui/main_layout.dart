import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dashboard_screen.dart';
import 'home_screen.dart';
import 'audit_checklist_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const HomeScreen(),
    const AuditChecklistScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AuditSense',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFFE2E8F0),
                  child: Icon(Icons.person, color: Color(0xFF64748B), size: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  'Auditor Profile',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF334155),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.logout, color: Color(0xFF64748B)),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                ),
              ],
            ),
          )
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            backgroundColor: Colors.white,
            selectedLabelTextStyle: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
            ),
            unselectedLabelTextStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
            selectedIconTheme: const IconThemeData(color: Color(0xFF2563EB)),
            unselectedIconTheme: const IconThemeData(color: Color(0xFF64748B)),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.document_scanner_outlined),
                selectedIcon: Icon(Icons.document_scanner),
                label: Text('Analyze'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.checklist_outlined),
                selectedIcon: Icon(Icons.checklist),
                label: Text('Checklist'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1, color: Color(0xFFE2E8F0)),
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
