import 'package:flutter/material.dart';
import '../api/api_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 1. We changed this from a List to a Map to hold the new AI Dictionary
  Map<String, dynamic>? _analysisResult;
  bool _isLoading = false;
  final TextEditingController _textController = TextEditingController();

  void _runAnalysis() async {
    if (_textController.text.trim().isEmpty) return;
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _analysisResult = null;
    });

    // 2. Here is the fix! It now correctly calls fetchAnalysis instead of fetchKeywords
    final result = await ApiService.fetchAnalysis(_textController.text);

    setState(() {
      _analysisResult = result;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'AuditSense',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Policy Analyzer',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter a security requirement to see how the AI maps it to ISO 27001.',
                style: TextStyle(fontSize: 15, color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),

              TextField(
                controller: _textController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'e.g., "Staff must use an 8-character password..."',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _runAnalysis,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.auto_awesome),
                  label: Text(_isLoading ? 'Analyzing...' : 'Analyze Policy'),
                ),
              ),
              const SizedBox(height: 40),

              // --- The Explainable AI Results Card ---
              if (_analysisResult != null) ...[
                const Text(
                  'Analysis Breakdown',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _analysisResult!['match'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        "Official ISO Definition:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _analysisResult!['description'],
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
                      ),

                      const Divider(height: 30),

                      Row(
                        children: [
                          const Icon(
                            Icons.psychology_alt,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "AI Reasoning",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _analysisResult!['reasoning'],
                        style: TextStyle(color: Colors.grey[800], height: 1.4),
                      ),
                    ],
                  ),
                ),
              ] else if (!_isLoading) ...[
                Center(
                  child: Text(
                    'Awaiting input...',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
