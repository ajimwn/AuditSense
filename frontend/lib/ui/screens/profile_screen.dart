import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage your professional auditor profile and system preferences.',
              style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.secondary),
            ),
            const SizedBox(height: 48),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: _ProfileSidebar(theme: theme),
                ),
                const SizedBox(width: 32),
                Expanded(
                  flex: 2,
                  child: _ProfileDetailsForm(theme: theme),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSidebar extends StatelessWidget {
  final ThemeData theme;
  const _ProfileSidebar({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                child: Icon(Icons.person_rounded, size: 60, color: theme.colorScheme.primary),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('John Auditor', style: theme.textTheme.titleLarge),
          Text('Lead Compliance Specialist', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.secondary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 40),
          const Divider(),
          const SizedBox(height: 24),
          _buildMenuAction(Icons.shield_outlined, 'Security & MFA'),
          _buildMenuAction(Icons.notifications_none_rounded, 'Notification Rules'),
          _buildMenuAction(Icons.history_edu_rounded, 'Audit Activity Log'),
        ],
      ),
    );
  }

  Widget _buildMenuAction(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.secondary),
          const SizedBox(width: 16),
          Text(title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
          const Spacer(),
          const Icon(Icons.chevron_right_rounded, size: 18, color: Colors.grey),
        ],
      ),
    );
  }
}

class _ProfileDetailsForm extends StatelessWidget {
  final ThemeData theme;
  const _ProfileDetailsForm({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Personal Information', style: theme.textTheme.titleMedium?.copyWith(fontSize: 18)),
          const SizedBox(height: 32),
          _buildField('FULL NAME', 'John Auditor'),
          const SizedBox(height: 24),
          _buildField('EMAIL ADDRESS', 'john.auditor@auditsense.com'),
          const SizedBox(height: 24),
          _buildField('ORGANIZATION', 'Global Governance Partners'),
          const SizedBox(height: 48),
          Text('System Preferences', style: theme.textTheme.titleMedium?.copyWith(fontSize: 18)),
          const SizedBox(height: 24),
          _buildSwitch('Enable System Matching Logic', true),
          _buildSwitch('Automatic History Archiving', true),
          const SizedBox(height: 48),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {}, 
                child: const Text('SAVE PROFILE CHANGES'),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: () {}, 
                child: const Text('DISCARD', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.grey)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF6B7280), letterSpacing: 1)),
        const SizedBox(height: 10),
        TextFormField(
          initialValue: value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
        ),
      ],
    );
  }

  Widget _buildSwitch(String title, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF334155))),
          Switch(
            value: value, 
            onChanged: (v) {}, 
            activeThumbColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
