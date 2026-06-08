import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width <= 900;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Left Panel: Executive Branding Zone (Hidden on mobile)
          if (!isMobile)
            Expanded(
              flex: 5,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&q=80&w=2070'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF00338D).withValues(alpha: 0.95),
                        const Color(0xFF005F9E).withValues(alpha: 0.85),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(80.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AuditSense',
                          style: GoogleFonts.inter(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -2,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'POLICY ANALYSIS TOOL',
                                    style: GoogleFonts.publicSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white.withValues(alpha: 0.7),
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Easily map your policies to ISO 27001 controls and track your compliance progress.',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: Colors.white,
                                      fontSize: 18,
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 64),
                        _buildBadge(Icons.verified_user_outlined, 'Secure Login'),
                        _buildBadge(Icons.shield_outlined, 'Safe & Encrypted'),
                        _buildBadge(Icons.history_toggle_off_rounded, 'Saved Audit History'),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Right Panel: Form Action Zone
          Expanded(
            flex: 4,
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 32.0 : 64.0, vertical: 32.0),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isMobile) ...[
                          Text(
                            'AuditSense',
                            style: GoogleFonts.inter(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: theme.colorScheme.primary,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 48),
                        ],
                        Text(
                          'Sign In',
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: const Color(0xFF0F172A),
                            fontWeight: FontWeight.w800,
                            fontSize: isMobile ? 28 : 36,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Access your audit dashboard.',
                          style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 48),
                        
                        _buildFieldLabel('EMAIL ADDRESS'),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'name@company.com',
                            prefixIcon: Icon(Icons.mail_outline_rounded, size: 20),
                          ),
                          validator: (v) => (v == null || !v.contains('@')) ? 'Valid email required' : null,
                        ),
                        const SizedBox(height: 24),
                        
                        _buildFieldLabel('PASSWORD'),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          validator: (v) => (v == null || v.isEmpty) ? 'Password is required' : null,
                        ),
                        const SizedBox(height: 48),
                        
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            child: _isLoading
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Text('SIGN IN'),
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Text("New to AuditSense?", style: TextStyle(color: Color(0xFF64748B))),
                              TextButton(
                                onPressed: () => Navigator.pushReplacementNamed(context, '/register'),
                                child: const Text('CREATE ACCOUNT', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        text,
        style: GoogleFonts.publicSans(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF64748B),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 16),
          Text(
            text,
            style: GoogleFonts.publicSans(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
