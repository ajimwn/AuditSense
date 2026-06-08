import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/audit_item.dart';
import '../models/iso_standards.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  static Future<List<AuditItem>?> fetchAnalysis(String policyText) async {
    try {
      debugPrint('Sending text to analysis engine...');

      final response = await http.post(
        Uri.parse('$baseUrl/analyze'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"text": policyText}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> resultsList = data.containsKey('results') ? data['results'] : [data];
        
        // Start with the full standard list
        final List<AuditItem> fullList = ISOStandards.getAnnexA2022();
        
        // Map detected items back to the full list
        for (var rawItem in resultsList) {
          final String matchedClause = rawItem['match'] ?? '';
          final int confidence = (rawItem['confidence'] as num?)?.toInt() ?? 0;
          
          final int index = fullList.indexWhere((item) => item.isoClause == matchedClause);
          if (index != -1) {
            fullList[index].policyText = policyText;
            fullList[index].confidence = confidence;
            fullList[index].isAutomatedMatch = true;
            
            // Set initial status based on reasoning
            if (confidence > 80) {
              fullList[index].status = 'Implemented';
            } else if (confidence > 40) {
              fullList[index].status = 'In Progress';
            } else {
              fullList[index].status = 'Not Implemented';
            }
          }
        }

        return fullList;
      } else {
        debugPrint('Server Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Analysis Error: $e');
      return null;
    }
  }
}
