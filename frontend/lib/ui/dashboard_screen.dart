import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ISO 27001 Overview',
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Aggregate metrics and domain-level compliance status based on recent automated audits.',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: const Color(0xFF475569),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),

                // 1. Top Summary Section
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 800) {
                      return Row(
                        children: [
                          Expanded(child: _buildMetricCard(context, 'Overall Compliance Score (%)', '84%', Icons.analytics_outlined, const Color(0xFF2563EB))),
                          const SizedBox(width: 24),
                          Expanded(child: _buildMetricCard(context, 'Total Mapped Clauses', '142', Icons.rule_outlined, const Color(0xFF0D9488))),
                          const SizedBox(width: 24),
                          Expanded(child: _buildMetricCard(context, 'Critical Security Gaps', '3', Icons.warning_amber_rounded, const Color(0xFFDC2626))),
                        ],
                      );
                    } else {
                      return Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(width: double.infinity, child: _buildMetricCard(context, 'Overall Compliance Score (%)', '84%', Icons.analytics_outlined, const Color(0xFF2563EB))),
                          SizedBox(width: double.infinity, child: _buildMetricCard(context, 'Total Mapped Clauses', '142', Icons.rule_outlined, const Color(0xFF0D9488))),
                          SizedBox(width: double.infinity, child: _buildMetricCard(context, 'Critical Security Gaps', '3', Icons.warning_amber_rounded, const Color(0xFFDC2626))),
                        ],
                      );
                    }
                  },
                ),

                const SizedBox(height: 48),

                // 2. Domain Compliance Chart and Recent Audits
                LayoutBuilder(
                  builder: (context, constraints) {
                    final chartWidget = _buildDomainComplianceChart(context);
                    final auditsWidget = _buildRecentAuditsTable(context);

                    if (constraints.maxWidth > 900) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: chartWidget),
                          const SizedBox(width: 32),
                          Expanded(flex: 3, child: auditsWidget),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          chartWidget,
                          const SizedBox(height: 32),
                          auditsWidget,
                        ],
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, String value, IconData icon, Color iconColor) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
                letterSpacing: -1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDomainComplianceChart(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Compliance by Domain',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const titles = ['A.9', 'A.10', 'A.11', 'A.12', 'A.13'];
                          if (value.toInt() >= 0 && value.toInt() < titles.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                titles[value.toInt()],
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF64748B),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}%',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF64748B),
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 25,
                    getDrawingHorizontalLine: (value) {
                      return const FlLine(
                        color: Color(0xFFF1F5F9),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    _buildBarGroup(0, 92, const Color(0xFF10B981)),
                    _buildBarGroup(1, 78, const Color(0xFFF59E0B)),
                    _buildBarGroup(2, 100, const Color(0xFF10B981)),
                    _buildBarGroup(3, 65, const Color(0xFFEF4444)),
                    _buildBarGroup(4, 88, const Color(0xFF3B82F6)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Compliant', const Color(0xFF10B981)),
                const SizedBox(width: 16),
                _buildLegendItem('Warning', const Color(0xFFF59E0B)),
                const SizedBox(width: 16),
                _buildLegendItem('Critical', const Color(0xFFEF4444)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(title, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
      ],
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 20,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentAuditsTable(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Audits Log',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                    letterSpacing: -0.5,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'CSV Exported Successfully.',
                          style: GoogleFonts.inter(),
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.download_outlined, size: 16, color: Color(0xFF2563EB)),
                  label: Text('Export CSV', style: GoogleFonts.inter(color: const Color(0xFF2563EB))),
                )
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingTextStyle: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                    fontSize: 13,
                  ),
                  dataTextStyle: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF334155),
                  ),
                  dividerThickness: 1,
                  horizontalMargin: 12,
                  columns: const [
                    DataColumn(label: Text('File Name')),
                    DataColumn(label: Text('Date Processed')),
                    DataColumn(label: Text('Final Score'), numeric: true),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: [
                    _buildDataRow('Q3_Network_Policy_v2.pdf', 'Oct 12, 2023', '85%', 'Verified'),
                    _buildDataRow('HR_Onboarding_Security.docx', 'Oct 10, 2023', '92%', 'Verified'),
                    _buildDataRow('Vendor_Risk_Assessment.pdf', 'Oct 05, 2023', '78%', 'Flagged'),
                    _buildDataRow('Cloud_Migration_Plan.pdf', 'Sep 28, 2023', '95%', 'Verified'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(String filename, String date, String score, String status) {
    final isFlagged = status == 'Flagged';
    return DataRow(
      cells: [
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.description_outlined, size: 18, color: Color(0xFF64748B)),
            const SizedBox(width: 8),
            Text(filename, style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: const Color(0xFF0F172A))),
          ],
        )),
        DataCell(Text(date, style: GoogleFonts.inter(color: const Color(0xFF64748B)))),
        DataCell(Text(score, style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isFlagged ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isFlagged ? const Color(0xFFFECACA) : const Color(0xFFBBF7D0),
              ),
            ),
            child: Text(
              status,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isFlagged ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
