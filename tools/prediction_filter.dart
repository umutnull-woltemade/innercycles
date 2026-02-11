// ignore_for_file: avoid_print
// Prediction Filter — Apple App Store 4.3(b) Compliance Tool
//
// Scans Dart source files for blacklisted predictive phrases.
// Returns exit code 1 if violations found, 0 if clean.
//
// Usage: dart run tools/prediction_filter.dart [path]
// Default path: lib/

import 'dart:io';

/// Phrases that violate Apple's 4.3(b) guidelines (fortune-telling / prediction)
const List<String> blacklistedPhrases = [
  'you will',
  'you shall',
  'your future',
  'will happen',
  'is destined',
  'fate says',
  'stars say',
  'stars predict',
  'stars reveal',
  'the universe says',
  'the cosmos says',
  'the planets say',
  'guaranteed to',
  'certainly will',
  'definitely will',
  'without a doubt',
  'is certain',
  'will bring you',
  'will come to you',
  'awaits you',
  'is coming your way',
  'fortune tells',
  'destiny reveals',
  'fate reveals',
  'the cards say',
  'your horoscope says',
  'the stars align for',
  'cosmic forces will',
  'planetary alignment will',
  'mercury retrograde will cause',
  'this transit will',
  'this aspect will make',
  'your birth chart shows you will',
  'prediction:',
  'forecast:',
  'prophesy',
  'divination result',
  'your reading says',
  'guaranteed outcome',
  'inevitable',
];

/// Safe replacement suggestions
const Map<String, String> safeReplacements = {
  'you will': 'you may notice',
  'your future': 'your journey ahead',
  'will happen': 'may unfold',
  'is destined': 'may be drawn toward',
  'stars say': 'symbolic themes suggest',
  'stars predict': 'patterns may reflect',
  'guaranteed to': 'may support',
  'awaits you': 'may be worth exploring',
  'fortune tells': 'reflection suggests',
  'the cards say': 'the symbolic themes suggest',
  'your horoscope says': 'your reflective profile suggests',
  'this transit will': 'during this period, you may notice',
  'prediction:': 'reflection:',
  'forecast:': 'outlook:',
};

class Violation {
  final String file;
  final int line;
  final String phrase;
  final String content;
  final String? suggestion;

  Violation({
    required this.file,
    required this.line,
    required this.phrase,
    required this.content,
    this.suggestion,
  });
}

List<Violation> scanFile(File file) {
  final violations = <Violation>[];
  final lines = file.readAsLinesSync();

  for (var i = 0; i < lines.length; i++) {
    final lower = lines[i].toLowerCase();

    // Skip comments and import lines
    if (lower.trimLeft().startsWith('//') || lower.trimLeft().startsWith('import ')) {
      continue;
    }

    for (final phrase in blacklistedPhrases) {
      if (lower.contains(phrase.toLowerCase())) {
        violations.add(Violation(
          file: file.path,
          line: i + 1,
          phrase: phrase,
          content: lines[i].trim(),
          suggestion: safeReplacements[phrase],
        ));
      }
    }
  }

  return violations;
}

List<Violation> scanDirectory(String path) {
  final dir = Directory(path);
  if (!dir.existsSync()) {
    print('ERROR: Directory not found: $path');
    exit(2);
  }

  final violations = <Violation>[];

  for (final entity in dir.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      violations.addAll(scanFile(entity));
    }
  }

  return violations;
}

void main(List<String> args) {
  final targetPath = args.isNotEmpty ? args[0] : 'lib/';

  print('╔══════════════════════════════════════════════════════╗');
  print('║          PREDICTION FILTER — Apple 4.3(b)           ║');
  print('╚══════════════════════════════════════════════════════╝');
  print('');
  print('Scanning: $targetPath');
  print('Blacklisted phrases: ${blacklistedPhrases.length}');
  print('');

  final violations = scanDirectory(targetPath);

  if (violations.isEmpty) {
    print('✅ PASS — No predictive language found.');
    print('   Scanned for ${blacklistedPhrases.length} blacklisted phrases.');
    exit(0);
  }

  print('❌ FAIL — ${violations.length} violation(s) found:\n');

  for (final v in violations) {
    print('  FILE: ${v.file}:${v.line}');
    print('  PHRASE: "${v.phrase}"');
    print('  CONTENT: ${v.content}');
    if (v.suggestion != null) {
      print('  SUGGESTION: Replace with "${v.suggestion}"');
    }
    print('');
  }

  print('─────────────────────────────────────────────────');
  print('Total violations: ${violations.length}');
  print('Fix all violations before submitting to App Store.');

  exit(1);
}
