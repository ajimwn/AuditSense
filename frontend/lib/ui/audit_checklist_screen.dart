import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class AuditChecklistScreen extends StatefulWidget {
  final List<Map<String, dynamic>> auditItems;
  final ValueChanged<List<Map<String, dynamic>>> onItemsChanged;

  const AuditChecklistScreen({
    super.key,
    required this.auditItems,
    required this.onItemsChanged,
  });

  @override
  State<AuditChecklistScreen> createState() => _AuditChecklistScreenState();
}

class _AuditChecklistScreenState extends State<AuditChecklistScreen> {
  late List<Map<String, dynamic>> _auditItems;

  @override
  void initState() {
    super.initState();
    _auditItems = List.from(widget.auditItems);
  }

  @override
  void didUpdateWidget(AuditChecklistScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.auditItems != oldWidget.auditItems) {
      _auditItems = List.from(widget.auditItems);
    }
  }

  void _notifyParent() {
    widget.onItemsChanged(_auditItems);
  }

  void _updateStatus(int index, String status) {
    setState(() {
      _auditItems[index]['status'] = status;
    });
    _notifyParent();
  }

  void _submitAudit() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Submitting Final Audit to Database...',
          style: GoogleFonts.inter(),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Basic sanitization to block script tags and other potentially malicious inputs
  final List<TextInputFormatter> _sanitizationFormatters = [
    FilteringTextInputFormatter.deny(RegExp(r'<script.*?>.*?</script>', caseSensitive: false)),
    FilteringTextInputFormatter.deny(RegExp(r'<.*?>')), // Block basic HTML tags
  ];

  void _manualOverride(int index) {
    TextEditingController controller = TextEditingController(text: _auditItems[index]['iso_clause']);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
          title: Text(
            'Manual Override Mapping',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
          ),
          content: TextField(
            controller: controller,
            inputFormatters: _sanitizationFormatters,
            decoration: InputDecoration(
              labelText: 'ISO 27001 Clause',
              labelStyle: GoogleFonts.inter(color: const Color(0xFF64748B)),
              hintText: 'Enter correct ISO clause...',
              hintStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
            style: GoogleFonts.inter(color: const Color(0xFF334155)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.inter(color: const Color(0xFF64748B))),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _auditItems[index]['iso_clause'] = controller.text;
                });
                _notifyParent();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Save Override', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            )
          ],
        );
      },
    );
  }

  void _addManualClause() {
    TextEditingController policyController = TextEditingController();
    TextEditingController clauseController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
          title: Text(
            'Add Manual Clause',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: policyController,
                  inputFormatters: _sanitizationFormatters,
                  decoration: InputDecoration(
                    labelText: 'Policy Text',
                    labelStyle: GoogleFonts.inter(color: const Color(0xFF64748B)),
                    hintText: 'Enter policy text...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: clauseController,
                  inputFormatters: _sanitizationFormatters,
                  decoration: InputDecoration(
                    labelText: 'ISO 27001 Clause',
                    labelStyle: GoogleFonts.inter(color: const Color(0xFF64748B)),
                    hintText: 'Enter ISO clause...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.inter(color: const Color(0xFF64748B))),
            ),
            ElevatedButton(
              onPressed: () {
                if (policyController.text.trim().isEmpty || clauseController.text.trim().isEmpty) return;
                setState(() {
                  _auditItems.add({
                    "id": DateTime.now().millisecondsSinceEpoch.toString(),
                    "policy_text": policyController.text,
                    "iso_clause": clauseController.text,
                    "confidence": 100, // Manual entry has high confidence
                    "status": null,
                    "notes": "",
                  });
                });
                _notifyParent();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Add Clause', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Review Extracted Policies',
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Verify the automated mapping of ISO 27001 controls against the extracted policy text. Adjust compliance status and provide evidence as needed before final submission.',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: const Color(0xFF475569),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _auditItems.isEmpty
                    ? Center(
                        child: Text(
                          'No audit clauses mapped yet. Analyze a document or add one manually.',
                          style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                        itemCount: _auditItems.length,
                        itemBuilder: (context, index) {
                          final item = _auditItems[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            color: Colors.white,
                            child: Theme(
                              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                tilePadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                                title: Text(
                                  item['policy_text'],
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.psychology_outlined, size: 18, color: Color(0xFF2563EB)),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          item['iso_clause'],
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFF2563EB),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: item['confidence'] > 90 ? const Color(0xFFF0FDF4) : const Color(0xFFFFFBEB),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: item['confidence'] > 90 ? const Color(0xFFBBF7D0) : const Color(0xFFFDE68A),
                                          ),
                                        ),
                                        child: Text(
                                          'Match Confidence: ${item['confidence']}%',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: item['confidence'] > 90 ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                childrenPadding: const EdgeInsets.all(24.0),
                                children: [
                                  const Divider(color: Color(0xFFE2E8F0)),
                                  const SizedBox(height: 16),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Auditor Status',
                                              style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, color: const Color(0xFF334155)),
                                            ),
                                            const SizedBox(height: 12),
                                            Wrap(
                                              spacing: 8.0,
                                              runSpacing: 8.0,
                                              children: [
                                                ChoiceChip(
                                                  label: Text('Compliant', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                                                  selected: item['status'] == 'Compliant',
                                                  selectedColor: const Color(0xFFDCFCE7),
                                                  backgroundColor: Colors.white,
                                                  labelStyle: TextStyle(
                                                    color: item['status'] == 'Compliant' ? const Color(0xFF16A34A) : const Color(0xFF64748B),
                                                  ),
                                                  side: BorderSide(
                                                    color: item['status'] == 'Compliant' ? const Color(0xFF22C55E) : const Color(0xFFE2E8F0),
                                                  ),
                                                  onSelected: (_) => _updateStatus(index, 'Compliant'),
                                                ),
                                                ChoiceChip(
                                                  label: Text('Non-Compliant', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                                                  selected: item['status'] == 'Non-Compliant',
                                                  selectedColor: const Color(0xFFFEE2E2),
                                                  backgroundColor: Colors.white,
                                                  labelStyle: TextStyle(
                                                    color: item['status'] == 'Non-Compliant' ? const Color(0xFFDC2626) : const Color(0xFF64748B),
                                                  ),
                                                  side: BorderSide(
                                                    color: item['status'] == 'Non-Compliant' ? const Color(0xFFEF4444) : const Color(0xFFE2E8F0),
                                                  ),
                                                  onSelected: (_) => _updateStatus(index, 'Non-Compliant'),
                                                ),
                                                ChoiceChip(
                                                  label: Text('N/A', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                                                  selected: item['status'] == 'N/A',
                                                  selectedColor: const Color(0xFFF1F5F9),
                                                  backgroundColor: Colors.white,
                                                  labelStyle: TextStyle(
                                                    color: item['status'] == 'N/A' ? const Color(0xFF475569) : const Color(0xFF64748B),
                                                  ),
                                                  side: BorderSide(
                                                    color: item['status'] == 'N/A' ? const Color(0xFF94A3B8) : const Color(0xFFE2E8F0),
                                                  ),
                                                  onSelected: (_) => _updateStatus(index, 'N/A'),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 24),
                                            OutlinedButton.icon(
                                              onPressed: () => _manualOverride(index),
                                              icon: const Icon(Icons.edit_outlined, size: 16),
                                              label: Text('Manual Override', style: GoogleFonts.inter()),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: const Color(0xFF2563EB),
                                                side: const BorderSide(color: Color(0xFFCBD5E1)),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 32),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Evidence & Notes',
                                              style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, color: const Color(0xFF334155)),
                                            ),
                                            const SizedBox(height: 12),
                                            TextField(
                                              onChanged: (val) {
                                                _auditItems[index]['notes'] = val;
                                                _notifyParent();
                                              },
                                              inputFormatters: _sanitizationFormatters,
                                              maxLines: 4,
                                              style: GoogleFonts.inter(color: const Color(0xFF334155)),
                                              decoration: InputDecoration(
                                                hintText: 'Enter auditor notes, observations, or links to evidence artifacts...',
                                                hintStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: _addManualClause,
                      icon: const Icon(Icons.add, size: 20),
                      label: Text(
                        'Add Manual Clause',
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF2563EB),
                      ),
                    ),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _submitAudit,
                        icon: const Icon(Icons.send_outlined, size: 20),
                        label: Text(
                          'Submit Final Audit',
                          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
