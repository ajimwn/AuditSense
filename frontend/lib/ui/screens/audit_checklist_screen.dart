import 'package:flutter/material.dart';
import 'package:frontend/data/models/audit_item.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

enum MatchFilter { all, automated, manual }

class AuditChecklistScreen extends StatefulWidget {
  final List<AuditItem> auditItems;
  final ValueChanged<List<AuditItem>> onItemsChanged;
  final String? initialFilter;

  const AuditChecklistScreen({
    super.key,
    required this.auditItems,
    required this.onItemsChanged,
    this.initialFilter,
  });

  @override
  State<AuditChecklistScreen> createState() => _AuditChecklistScreenState();
}

class _AuditChecklistScreenState extends State<AuditChecklistScreen> {
  late List<AuditItem> _auditItems;
  String _searchQuery = '';
  String? _statusFilter;
  String? _applicabilityFilter;
  MatchFilter _matchFilter = MatchFilter.all;
  
  // High-density selection logic
  String? _selectedClause;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _auditItems = List.from(widget.auditItems);
    _statusFilter = widget.initialFilter;
    if (_auditItems.isNotEmpty) {
      _selectedClause = _auditItems.first.isoClause;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AuditChecklistScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.auditItems != oldWidget.auditItems) {
      _auditItems = List.from(widget.auditItems);
      if (_selectedClause == null && _auditItems.isNotEmpty) {
        _selectedClause = _auditItems.first.isoClause;
      }
    }
    if (widget.initialFilter != oldWidget.initialFilter) {
      setState(() {
        _statusFilter = widget.initialFilter;
      });
    }
  }

  List<AuditItem> get _filteredItems {
    return _auditItems.where((item) {
      final matchesSearch = item.isoClause.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.isoTitle.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _statusFilter == null || item.status == _statusFilter;
      final matchesApplicability = _applicabilityFilter == null || item.applicability == _applicabilityFilter;
      
      bool matchesSource = true;
      if (_matchFilter == MatchFilter.automated) matchesSource = item.isAutomatedMatch;
      if (_matchFilter == MatchFilter.manual) matchesSource = !item.isAutomatedMatch;
      
      return matchesSearch && matchesStatus && matchesApplicability && matchesSource;
    }).toList();
  }

  void _updateItem(String id, {String? status, String? applicability, String? justification}) {
    setState(() {
      final index = _auditItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        if (status != null) _auditItems[index].status = status;
        if (applicability != null) _auditItems[index].applicability = applicability;
        if (justification != null) _auditItems[index].justification = justification;
      }
    });
    widget.onItemsChanged(_auditItems);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _filteredItems;
    final grouped = _groupedItemsByTheme(filtered);
    
    // Ensure we have a valid selection even after filtering
    AuditItem? selectedItem;
    if (filtered.isNotEmpty) {
      selectedItem = filtered.any((i) => i.isoClause == _selectedClause)
          ? filtered.firstWhere((i) => i.isoClause == _selectedClause)
          : filtered.first;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          _buildUnifiedToolbar(theme),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. LEFT NAVIGATION: Grouped list with Domain Titles
                Container(
                  width: 320,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(right: BorderSide(color: Color(0xFFE5E7EB))),
                  ),
                  child: filtered.isEmpty 
                    ? const Center(child: Text('No matching controls'))
                    : _buildGroupedList(grouped),
                ),
                
                // 2. RIGHT WORKSPACE: Focused editing
                Expanded(
                  child: Container(
                    color: const Color(0xFFF9FAFB),
                    padding: const EdgeInsets.all(40),
                    child: selectedItem == null 
                      ? const Center(child: Text('Please select a control from the list'))
                      : SingleChildScrollView(
                          child: _buildAuditWorkspace(selectedItem, theme),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnifiedToolbar(ThemeData theme) {
    final implemented = _auditItems.where((i) => i.status == 'Implemented').length;
    final inProgress = _auditItems.where((i) => i.status == 'In Progress').length;
    final notImplemented = _auditItems.where((i) => i.status == 'Not Implemented').length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          // Stats Group - Professional wording
          _buildCompactHeaderStat('Implemented', implemented, const Color(0xFF00A36C)),
          _buildCompactHeaderStat('In Progress', inProgress, const Color(0xFFE9A115)),
          _buildCompactHeaderStat('Not Implemented', notImplemented, const Color(0xFFBC204B)),
          
          const VerticalDivider(width: 40),
          
          // SEARCH BAR - Expanded to fit organized space
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: const InputDecoration(
                  hintText: 'Search controls...',
                  prefixIcon: Icon(Icons.search_rounded, size: 18),
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 24),
          
          // Dropdowns Group
          _buildSmallDropdown<String?>(
            value: _statusFilter,
            items: [
              const DropdownMenuItem(value: null, child: Text('All Statuses')),
              const DropdownMenuItem(value: 'Implemented', child: Text('Implemented')),
              const DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
              const DropdownMenuItem(value: 'Not Implemented', child: Text('Not Implemented')),
            ],
            onChanged: (v) => setState(() => _statusFilter = v),
          ),
          const SizedBox(width: 8),
          _buildSmallDropdown<String?>(
            value: _applicabilityFilter,
            items: [
              const DropdownMenuItem(value: null, child: Text('All Applicability')),
              const DropdownMenuItem(value: 'Applicable', child: Text('Applicable')),
              const DropdownMenuItem(value: 'Not Applicable', child: Text('Not Applicable')),
            ],
            onChanged: (v) => setState(() => _applicabilityFilter = v),
          ),
          const SizedBox(width: 8),
          _buildSmallDropdown<MatchFilter>(
            value: _matchFilter,
            items: [
              const DropdownMenuItem(value: MatchFilter.all, child: Text('All Types')),
              const DropdownMenuItem(value: MatchFilter.automated, child: Text('Automated')),
              const DropdownMenuItem(value: MatchFilter.manual, child: Text('Manual')),
            ],
            onChanged: (v) => setState(() => _matchFilter = v!),
          ),
          
          const SizedBox(width: 24),
          
          // PIE CHART - Maintained in toolbar
          SizedBox(
            width: 44, height: 44,
            child: PieChart(
              PieChartData(
                sectionsSpace: 1, centerSpaceRadius: 10,
                sections: [
                  PieChartSectionData(value: implemented.toDouble(), color: const Color(0xFF00A36C), radius: 10, title: ''),
                  PieChartSectionData(value: inProgress.toDouble(), color: const Color(0xFFE9A115), radius: 10, title: ''),
                  PieChartSectionData(value: notImplemented.toDouble(), color: const Color(0xFFBC204B), radius: 10, title: ''),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactHeaderStat(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Text('$value', style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A))),
          const SizedBox(width: 8),
          Text(label.toUpperCase(), style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.grey.shade600, letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _buildSmallDropdown<T>({required T value, required List<DropdownMenuItem<T>> items, required ValueChanged<T?> onChanged}) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value, items: items, onChanged: onChanged,
          style: GoogleFonts.publicSans(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF334155)),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 16),
        ),
      ),
    );
  }

  Map<String, List<AuditItem>> _groupedItemsByTheme(List<AuditItem> items) {
    final grouped = <String, List<AuditItem>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.theme, () => []).add(item);
    }
    return grouped;
  }

  Widget _buildGroupedList(Map<String, List<AuditItem>> grouped) {
    final themes = grouped.keys.toList();
    return ListView.builder(
      itemCount: themes.length,
      itemBuilder: (context, index) {
        final theme = themes[index];
        final items = grouped[theme]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Domain Theme Header (Organizational, etc.)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFFF9FAFB),
              child: Text(
                theme.toUpperCase(),
                style: GoogleFonts.publicSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF64748B),
                  letterSpacing: 1.2,
                ),
              ),
            ),
            // Items in Domain
            ...items.map((item) => _buildDenseNavItem(item, _selectedClause == item.isoClause)),
          ],
        );
      },
    );
  }

  Widget _buildDenseNavItem(AuditItem item, bool isSelected) {
    Color statusColor = Colors.grey.shade300;
    if (item.status == 'Implemented') statusColor = const Color(0xFF00A36C);
    if (item.status == 'In Progress') statusColor = const Color(0xFFE9A115);
    if (item.status == 'Not Implemented') statusColor = const Color(0xFFBC204B);

    return InkWell(
      onTap: () => setState(() => _selectedClause = item.isoClause),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00338D).withValues(alpha: 0.05) : Colors.transparent,
          border: Border(
            bottom: const BorderSide(color: Color(0xFFF3F4F6)), 
            left: BorderSide(color: isSelected ? const Color(0xFF00338D) : Colors.transparent, width: 4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(item.isoClause, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10, color: isSelected ? const Color(0xFF00338D) : Colors.grey.shade600)),
                const Spacer(),
                Container(width: 8, height: 8, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              item.isoTitle, 
              maxLines: 2, 
              overflow: TextOverflow.ellipsis, 
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600, 
                fontSize: 12, 
                color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF4B5563),
                height: 1.3,
              ),
            ),
            if (item.isAutomatedMatch) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.auto_awesome, size: 10, color: Color(0xFF005F9E)),
                  const SizedBox(width: 4),
                  Text('AUTOMATED MATCH', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: const Color(0xFF005F9E))),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAuditWorkspace(AuditItem item, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.isoClause, style: GoogleFonts.manrope(fontWeight: FontWeight.w900, fontSize: 14, color: theme.colorScheme.primary, letterSpacing: 2)),
                  const SizedBox(height: 8),
                  Text(item.isoTitle, style: theme.textTheme.displaySmall?.copyWith(color: const Color(0xFF0F172A), fontSize: 28, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
            if (item.isAutomatedMatch) _buildMatchBadge(item.confidence, item.policyText),
          ],
        ),
        const SizedBox(height: 32),
        _sectionTitle('DESCRIPTION'),
        Text(item.fullDescription, style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16, height: 1.7)),
        const SizedBox(height: 48),
        
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('COMPLIANCE STATUS'),
                  const SizedBox(height: 12),
                  _buildStatusToggles(item),
                ],
              ),
            ),
            const SizedBox(width: 48),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('APPLICABILITY'),
                  const SizedBox(height: 12),
                  _buildApplicabilityToggle(item),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 48),
        _sectionTitle('JUSTIFICATION & EVIDENCE'),
        const SizedBox(height: 16),
        TextFormField(
          key: ValueKey('justification-${item.id}'),
          initialValue: item.justification,
          maxLines: 8,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Provide internal control reasoning or link to evidence documents...',
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFD1D5DB))),
          ),
          onChanged: (v) => _updateItem(item.id, justification: v),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF94A3B8), letterSpacing: 1.5)),
    );
  }

  Widget _buildStatusToggles(AuditItem item) {
    return Row(
      children: [
        _toggleBtn('Implemented', const Color(0xFF00A36C), item.status == 'Implemented', () => _updateItem(item.id, status: 'Implemented')),
        const SizedBox(width: 8),
        _toggleBtn('In Progress', const Color(0xFFE9A115), item.status == 'In Progress', () => _updateItem(item.id, status: 'In Progress')),
        const SizedBox(width: 8),
        _toggleBtn('Not Implemented', const Color(0xFFBC204B), item.status == 'Not Implemented', () => _updateItem(item.id, status: 'Not Implemented')),
      ],
    );
  }

  Widget _buildApplicabilityToggle(AuditItem item) {
    return Row(
      children: [
        _toggleBtn('Applicable', const Color(0xFF00338D), item.applicability == 'Applicable', () => _updateItem(item.id, applicability: 'Applicable')),
        const SizedBox(width: 8),
        _toggleBtn('Exclude', const Color(0xFF64748B), item.applicability == 'Not Applicable', () => _updateItem(item.id, applicability: 'Not Applicable')),
      ],
    );
  }

  Widget _toggleBtn(String label, Color color, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.white,
            border: Border.all(color: isSelected ? color : const Color(0xFFD1D5DB)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(label.toUpperCase(), textAlign: TextAlign.center, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: isSelected ? Colors.white : const Color(0xFF4B5563))),
        ),
      ),
    );
  }

  Widget _buildMatchBadge(int confidence, String evidence) {
    return Tooltip(
      message: 'Source Reasoning: $evidence',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(color: const Color(0xFF00A36C).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF00A36C).withValues(alpha: 0.2))),
        child: Column(
          children: [
            const Text('SYSTEM MATCH', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF00A36C))),
            Text('$confidence%', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF00A36C))),
          ],
        ),
      ),
    );
  }
}
