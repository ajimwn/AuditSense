class AuditItem {
  final String id;
  final String isoClause;
  final String isoTitle;
  final String theme;
  final String fullDescription;
  
  // Dynamic fields from Analysis Engine
  String policyText;
  int confidence;
  String? status;
  String applicability;
  String justification;
  String notes;
  bool isAutomatedMatch;

  AuditItem({
    required this.id,
    required this.isoClause,
    required this.isoTitle,
    required this.theme,
    required this.fullDescription,
    this.policyText = '',
    this.confidence = 0,
    this.status,
    this.applicability = 'Applicable',
    this.justification = '',
    this.notes = '',
    this.isAutomatedMatch = false,
  });

  // Create a deep copy
  AuditItem copy() {
    return AuditItem(
      id: id,
      isoClause: isoClause,
      isoTitle: isoTitle,
      theme: theme,
      fullDescription: fullDescription,
      policyText: policyText,
      confidence: confidence,
      status: status,
      applicability: applicability,
      justification: justification,
      notes: notes,
      isAutomatedMatch: isAutomatedMatch,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'iso_clause': isoClause,
      'iso_title': isoTitle,
      'theme': theme,
      'policy_text': policyText,
      'applicability': applicability,
      'justification': justification,
      'confidence': confidence,
      'status': status,
      'notes': notes,
      'is_automated': isAutomatedMatch,
    };
  }
}
