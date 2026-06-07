import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<List<Map<String, dynamic>>>? onAnalysisComplete;

  const HomeScreen({super.key, this.onAnalysisComplete});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  PlatformFile? _selectedFile;

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'txt'],
        withData: false,
        withReadStream: false,
      );

      if (result != null) {
        final file = result.files.single;

        // Mock UI file-size limit check (10MB)
        if (file.size > 10 * 1024 * 1024) {
          _showErrorSnackBar(
            "Invalid file size. Please upload a file smaller than 10MB.",
          );
          return;
        }

        // Strict client-side extension validation just to be sure
        final ext = file.extension?.toLowerCase();
        if (ext != 'pdf' && ext != 'docx' && ext != 'txt') {
          _showErrorSnackBar(
            "Invalid file type selected. Only PDF, DOCX, and TXT are allowed.",
          );
          return;
        }

        setState(() {
          _selectedFile = file;
        });
      }
    } catch (e) {
      _showErrorSnackBar("An error occurred while picking the file.");
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.inter()),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _runAnalysis() async {
    if (_selectedFile == null) return;

    setState(() {
      _isLoading = true;
    });

    // Mock processing delay since we don't have a live backend
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    // Mock parsed results to carry over to Checklist Screen
    final mockResults = [
      {
        "id": "${DateTime.now().millisecondsSinceEpoch}_1",
        "policy_text":
            "Extracted from ${_selectedFile?.name}: All employees must use a minimum 8-character password.",
        "iso_clause": "A.9.4.3 Password management system",
        "confidence": 96,
        "status": null,
        "notes": "",
      },
      {
        "id": "${DateTime.now().millisecondsSinceEpoch}_2",
        "policy_text":
            "Extracted from ${_selectedFile?.name}: Sensitive data must be encrypted at rest and in transit.",
        "iso_clause": "A.10.1.1 Policy on the use of cryptographic controls",
        "confidence": 91,
        "status": null,
        "notes": "",
      },
    ];

    if (widget.onAnalysisComplete != null) {
      widget.onAnalysisComplete!(mockResults);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Document Analyzer',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Upload a security policy document to see how the analysis engine maps it to ISO 27001 clauses.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: const Color(0xFF475569),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // Drag-and-drop / File Picker UI
              GestureDetector(
                onTap: _isLoading ? null : _pickFile,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFCBD5E1),
                      width: 2,
                      style: BorderStyle
                          .solid, // In a real app, you might use a dashed border package here
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 48,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        if (_selectedFile != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              'Selected: ${_selectedFile!.name}',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0F172A),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        else
                          Text(
                            'Click to Select File or Drag and Drop',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          'Supported formats: .pdf, .docx, .txt (Max 10MB)',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: (_isLoading || _selectedFile == null)
                      ? null
                      : _runAnalysis,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
                      : const Icon(Icons.document_scanner),
                  label: Text(
                    _isLoading ? 'Processing Document...' : 'Process Document',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
