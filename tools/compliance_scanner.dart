// ignore_for_file: avoid_print
// Compliance Scanner — Apple App Store Guideline Checker
//
// Scans content for compliance risks across multiple categories:
// - Prediction language (4.3b)
// - Health claims (medical disclaimer)
// - Emotional manipulation (dark patterns)
// - Missing disclaimers
//
// Usage: dart run tools/compliance_scanner.dart [path]

import 'dart:io';

enum RiskLevel { critical, high, medium, low, minor }

class ComplianceIssue {
  final String file;
  final int line;
  final RiskLevel risk;
  final String category;
  final String description;
  final String recommendation;

  ComplianceIssue({
    required this.file,
    required this.line,
    required this.risk,
    required this.category,
    required this.description,
    required this.recommendation,
  });

  int get score => switch (risk) {
        RiskLevel.critical => 100,
        RiskLevel.high => 50,
        RiskLevel.medium => 20,
        RiskLevel.low => 5,
        RiskLevel.minor => 1,
      };
}

// Category: Prediction Language (4.3b)
const _predictionPatterns = [
  (r'you will\b', RiskLevel.critical, 'Deterministic prediction: "you will"'),
  (r'is destined', RiskLevel.critical, 'Fatalistic language: "is destined"'),
  (r'stars? (say|predict|reveal)', RiskLevel.high, 'Personified celestial prediction'),
  (r'guaranteed', RiskLevel.high, 'Outcome guarantee'),
  (r'your future (holds|contains|shows)', RiskLevel.high, 'Future prediction'),
  (r'will (definitely|certainly|surely)', RiskLevel.high, 'Certainty language'),
  (r'fortune.?tell', RiskLevel.critical, 'Fortune-telling reference'),
  (r'horoscope says', RiskLevel.high, 'Horoscope as authority'),
  (r'reading (says|reveals|shows)', RiskLevel.medium, 'Reading as authority'),
];

// Category: Health Claims
const _healthPatterns = [
  (r'cures?\b', RiskLevel.critical, 'Medical cure claim'),
  (r'treats?\b.*disease', RiskLevel.critical, 'Medical treatment claim'),
  (r'heals?\b.*(?:illness|disease|condition)', RiskLevel.high, 'Healing claim'),
  (r'replace.*(?:doctor|therapist|medication)', RiskLevel.critical, 'Medical replacement claim'),
  (r'diagnos', RiskLevel.critical, 'Diagnostic claim'),
];

// Category: Emotional Manipulation
const _manipulationPatterns = [
  (r'don.?t miss out', RiskLevel.high, 'FOMO language'),
  (r'limited.?time', RiskLevel.high, 'Urgency pressure'),
  (r'act now', RiskLevel.medium, 'Urgency pressure'),
  (r'only \d+ left', RiskLevel.high, 'Scarcity pressure'),
  (r'everyone is', RiskLevel.medium, 'Social pressure'),
  (r'\d+ users? (just|already)', RiskLevel.medium, 'Social proof pressure'),
];

List<ComplianceIssue> scanFile(File file) {
  final issues = <ComplianceIssue>[];
  final lines = file.readAsLinesSync();

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    final lower = line.toLowerCase();

    // Skip pure comments
    if (lower.trimLeft().startsWith('//') || lower.trimLeft().startsWith('import ')) continue;

    for (final (pattern, risk, desc) in _predictionPatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(lower)) {
        issues.add(ComplianceIssue(
          file: file.path,
          line: i + 1,
          risk: risk,
          category: 'PREDICTION',
          description: desc,
          recommendation: 'Replace with reflective/educational language',
        ));
      }
    }

    for (final (pattern, risk, desc) in _healthPatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(lower)) {
        issues.add(ComplianceIssue(
          file: file.path,
          line: i + 1,
          risk: risk,
          category: 'HEALTH',
          description: desc,
          recommendation: 'Add disclaimer or rephrase as educational',
        ));
      }
    }

    for (final (pattern, risk, desc) in _manipulationPatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(lower)) {
        issues.add(ComplianceIssue(
          file: file.path,
          line: i + 1,
          risk: risk,
          category: 'MANIPULATION',
          description: desc,
          recommendation: 'Remove dark pattern language',
        ));
      }
    }
  }

  return issues;
}

void main(List<String> args) {
  final targetPath = args.isNotEmpty ? args[0] : 'lib/';

  print('╔══════════════════════════════════════════════════════╗');
  print('║          COMPLIANCE SCANNER — App Store Safe        ║');
  print('╚══════════════════════════════════════════════════════╝');
  print('');
  print('Scanning: $targetPath');
  print('');

  final dir = Directory(targetPath);
  if (!dir.existsSync()) {
    print('ERROR: Directory not found: $targetPath');
    exit(2);
  }

  final allIssues = <ComplianceIssue>[];

  for (final entity in dir.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      allIssues.addAll(scanFile(entity));
    }
  }

  if (allIssues.isEmpty) {
    print('✅ PASS — No compliance issues found.');
    exit(0);
  }

  // Group by risk level
  final critical = allIssues.where((i) => i.risk == RiskLevel.critical).toList();
  final high = allIssues.where((i) => i.risk == RiskLevel.high).toList();
  final medium = allIssues.where((i) => i.risk == RiskLevel.medium).toList();
  final low = allIssues.where((i) => i.risk == RiskLevel.low).toList();
  final minor = allIssues.where((i) => i.risk == RiskLevel.minor).toList();

  final totalScore = allIssues.fold<int>(0, (sum, i) => sum + i.score);

  void printIssues(String label, List<ComplianceIssue> issues) {
    if (issues.isEmpty) return;
    print('── $label (${issues.length}) ──');
    for (final i in issues) {
      print('  ${i.file}:${i.line}');
      print('    [${i.category}] ${i.description}');
      print('    → ${i.recommendation}');
      print('');
    }
  }

  printIssues('🔴 CRITICAL', critical);
  printIssues('🟠 HIGH', high);
  printIssues('🟡 MEDIUM', medium);
  printIssues('🔵 LOW', low);
  printIssues('⚪ MINOR', minor);

  print('═══════════════════════════════════════════════════');
  print('Risk Score: $totalScore');
  print('  Critical: ${critical.length}');
  print('  High: ${high.length}');
  print('  Medium: ${medium.length}');
  print('  Low: ${low.length}');
  print('  Minor: ${minor.length}');
  print('');

  if (critical.isNotEmpty) {
    print('❌ BLOCKED — Critical issues must be resolved before submission.');
    exit(1);
  } else if (high.isNotEmpty) {
    print('⚠️  WARNING — High-risk issues should be resolved.');
    exit(1);
  } else {
    print('✅ PASS — No blocking issues (review medium/low at your discretion).');
    exit(0);
  }
}
