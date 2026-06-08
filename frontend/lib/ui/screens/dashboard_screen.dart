import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/models/audit_item.dart';
import 'audit_history_screen.dart';

class DashboardScreen extends StatelessWidget {
  final List<AuditItem> auditItems;
  final List<AuditHistoryItem> history;
  final Function(int tabIndex, String? filter)? onNavigate;

  const DashboardScreen({
    super.key,
    this.auditItems = const [],
    this.history = const [],
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width <= 900;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Aggregate Stat Grid
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = constraints.maxWidth > 1200 ? 4 : (constraints.maxWidth > 800 ? 2 : 1);
                double aspectRatio = constraints.maxWidth > 1200 ? 1.8 : (constraints.maxWidth > 800 ? 2.0 : 3.0);
                
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: isMobile ? 16 : 24,
                  mainAxisSpacing: isMobile ? 16 : 24,
                  childAspectRatio: aspectRatio,
                  children: [
                    _buildStatCard(
                      context,
                      'Overall Compliance',
                      '${_calculateAverageCompliance()}%',
                      Icons.insights_rounded,
                      theme.colorScheme.primary,
                      'Average across ${history.length} audits',
                    ),
                    _buildStatCard(
                      context,
                      'Total Audits',
                      '${history.length}',
                      Icons.history_rounded,
                      const Color(0xFF00338D),
                      'Saved audit reports',
                      onTap: () => onNavigate?.call(3, null),
                    ),
                    _buildStatCard(
                      context,
                      'Implemented Controls',
                      '${_countStatus('Implemented')}',
                      Icons.fact_check_rounded,
                      const Color(0xFF00A36C),
                      'Current active workspace',
                      onTap: () => onNavigate?.call(2, 'Implemented'),
                    ),
                    _buildStatCard(
                      context,
                      'To-Do Items',
                      '${_countStatus('Not Implemented')}',
                      Icons.assignment_late_outlined,
                      const Color(0xFFBC204B),
                      'Requires review',
                      onTap: () => onNavigate?.call(2, 'Not Implemented'),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
            
            if (isMobile) ...[
              _buildAggregatePieChart(context),
              const SizedBox(height: 16),
              _buildAuditTrailTable(context),
            ] else 
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildAuditTrailTable(context),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    flex: 2,
                    child: _buildAggregatePieChart(context),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                if (onTap != null) const Icon(Icons.arrow_forward_rounded, color: Color(0xFF94A3B8), size: 18),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      value,
                      style: GoogleFonts.manrope(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.publicSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.publicSans(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAggregatePieChart(BuildContext context) {
    final implemented = _countStatus('Implemented');
    final inProgress = _countStatus('In Progress');
    final notImplemented = _countStatus('Not Implemented');
    final total = auditItems.length;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Compliance Status', style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          const Text('Inventory breakdown of current active workspace', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          const SizedBox(height: 32),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 50,
                sections: [
                  PieChartSectionData(value: implemented.toDouble(), color: const Color(0xFF00A36C), title: '', radius: 30),
                  PieChartSectionData(value: inProgress.toDouble(), color: const Color(0xFFE9A115), title: '', radius: 30),
                  PieChartSectionData(value: notImplemented.toDouble(), color: const Color(0xFFBC204B), title: '', radius: 30),
                  if (total == 0) PieChartSectionData(value: 1, color: Colors.grey.shade200, title: '', radius: 30),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildPieLegend('Implemented', const Color(0xFF00A36C), implemented),
          _buildPieLegend('In Progress', const Color(0xFFE9A115), inProgress),
          _buildPieLegend('Not Implemented', const Color(0xFFBC204B), notImplemented),
        ],
      ),
    );
  }

  Widget _buildPieLegend(String label, Color color, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Text(label, style: GoogleFonts.publicSans(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF475569))),
          const Spacer(),
          Text('$value', style: GoogleFonts.publicSans(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF1E293B))),
        ],
      ),
    );
  }

  Widget _buildAuditTrailTable(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Audits', style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w800)),
              TextButton(onPressed: () => onNavigate?.call(3, null), child: const Text('View All')),
            ],
          ),
          const SizedBox(height: 16),
          if (history.isEmpty)
             _buildEmptyLogs()
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 600),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1.5),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1.5),
                  },
                  children: [
                    TableRow(
                      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 2))),
                      children: [
                        _buildTableHeader('Session Reference'),
                        _buildTableHeader('Execution Date'),
                        _buildTableHeader('Score'),
                        _buildTableHeader('Review Status'),
                      ],
                    ),
                    ...history.take(6).map((item) => _buildHistoryRow(item)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  TableRow _buildHistoryRow(AuditHistoryItem item) {
    final bool isPerfect = item.complianceScore == 100;
    return _buildTableRow(
      item.id,
      '${item.date.day}/${item.date.month}/${item.date.year}',
      '${item.complianceScore}%',
      isPerfect ? 'Certified' : 'Draft Review',
      isPerfect,
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.publicSans(fontSize: 10, fontWeight: FontWeight.w900, color: const Color(0xFF64748B), letterSpacing: 1),
      ),
    );
  }

  TableRow _buildTableRow(String id, String date, String score, String status, bool isPerfect) {
    return TableRow(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9)))),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(id, style: GoogleFonts.publicSans(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A))),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(date, style: GoogleFonts.publicSans(fontSize: 13, color: const Color(0xFF64748B))),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(score, style: GoogleFonts.publicSans(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF00338D))),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isPerfect ? const Color(0xFFD1FAE5) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status.toUpperCase(),
              style: GoogleFonts.publicSans(fontSize: 9, fontWeight: FontWeight.w900, color: isPerfect ? const Color(0xFF059669) : const Color(0xFF475569)),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyLogs() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(child: Text('No historical sessions found. Initiate analysis to generate a trail.', style: TextStyle(color: Colors.grey.shade400, fontSize: 13))),
    );
  }

  int _calculateAverageCompliance() {
    if (history.isEmpty) return 0;
    double sum = history.fold(0, (prev, element) => prev + element.complianceScore);
    return (sum / history.length).round();
  }

  int _countStatus(String status) => auditItems.where((item) => item.status == status).length;
}
