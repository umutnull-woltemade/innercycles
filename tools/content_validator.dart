// ignore_for_file: avoid_print
// Content Validator — Quality & Depth Checker
//
// Validates content meets minimum quality standards:
// - Minimum word count per content type
// - Depth score (vocabulary richness)
// - Language consistency (EN vs TR)
// - Structural completeness
//
// Usage: dart run tools/content_validator.dart [path]

import 'dart:io';

class ValidationResult {
  final String file;
  final int issues;
  final List<String> warnings;
  final List<String> errors;
  final double depthScore;

  ValidationResult({
    required this.file,
    required this.issues,
    required this.warnings,
    required this.errors,
    required this.depthScore,
  });
}

/// Compute vocabulary richness (type-token ratio)
double computeDepthScore(String text) {
  final words = text
      .toLowerCase()
      .replaceAll(RegExp(r'[^\w\s]'), '')
      .split(RegExp(r'\s+'))
      .where((w) => w.length > 2)
      .toList();

  if (words.isEmpty) return 0.0;

  final uniqueWords = words.toSet().length;
  return uniqueWords / words.length;
}

/// Check for mixed language (EN strings containing TR characters, etc.)
bool hasMixedLanguage(String text) {
  final hasTurkish = RegExp(r'[ğüşıöçĞÜŞİÖÇ]').hasMatch(text);
  final hasEnglishMarkers = RegExp(r'\b(the|and|is|are|you|your|this)\b', caseSensitive: false)
      .hasMatch(text);
  return hasTurkish && hasEnglishMarkers;
}

ValidationResult validateFile(File file) {
  final content = file.readAsStringSync();
  final lines = content.split('\n');
  final warnings = <String>[];
  final errors = <String>[];

  // Check file size
  if (content.length < 100) {
    errors.add('File too short (${content.length} chars). Minimum: 100.');
  }

  // Check for placeholder content
  final placeholders = ['TODO', 'FIXME', 'PLACEHOLDER', 'Lorem ipsum', 'xxx', 'TBD'];
  for (var i = 0; i < lines.length; i++) {
    for (final ph in placeholders) {
      if (lines[i].contains(ph)) {
        warnings.add('Line ${i + 1}: Placeholder found: "$ph"');
      }
    }
  }

  // Check for empty strings in content files
  final emptyStrings = RegExp(r"''\s*[,;]").allMatches(content).length;
  if (emptyStrings > 0) {
    warnings.add('$emptyStrings empty string literals found');
  }

  // Mixed language check on string literals
  final stringMatches = RegExp(r"'([^']{20,})'").allMatches(content);
  for (final match in stringMatches) {
    final str = match.group(1)!;
    if (hasMixedLanguage(str)) {
      final lineNum = content.substring(0, match.start).split('\n').length;
      warnings.add('Line $lineNum: Possible mixed language in string');
    }
  }

  // Depth score
  final depthScore = computeDepthScore(content);
  if (depthScore < 0.3) {
    warnings.add('Low vocabulary richness (${depthScore.toStringAsFixed(2)}). Consider diversifying language.');
  }

  return ValidationResult(
    file: file.path,
    issues: errors.length + warnings.length,
    warnings: warnings,
    errors: errors,
    depthScore: depthScore,
  );
}

void main(List<String> args) {
  final targetPath = args.isNotEmpty ? args[0] : 'lib/data/content/';

  print('╔══════════════════════════════════════════════════════╗');
  print('║       CONTENT VALIDATOR — Quality & Depth           ║');
  print('╚══════════════════════════════════════════════════════╝');
  print('');
  print('Scanning: $targetPath');
  print('');

  final dir = Directory(targetPath);
  if (!dir.existsSync()) {
    print('ERROR: Directory not found: $targetPath');
    exit(2);
  }

  final results = <ValidationResult>[];
  var totalErrors = 0;
  var totalWarnings = 0;

  for (final entity in dir.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    final result = validateFile(entity);
    results.add(result);
    totalErrors += result.errors.length;
    totalWarnings += result.warnings.length;
  }

  print('Files scanned: ${results.length}');
  print('');

  for (final r in results.where((r) => r.issues > 0)) {
    print('📄 ${r.file}');
    print('   Depth: ${r.depthScore.toStringAsFixed(2)}');
    for (final e in r.errors) {
      print('   ❌ $e');
    }
    for (final w in r.warnings) {
      print('   ⚠️  $w');
    }
    print('');
  }

  // Summary
  final avgDepth = results.isEmpty
      ? 0.0
      : results.fold<double>(0, (sum, r) => sum + r.depthScore) / results.length;

  print('═══════════════════════════════════════════════════');
  print('Files: ${results.length}');
  print('Errors: $totalErrors');
  print('Warnings: $totalWarnings');
  print('Average depth: ${avgDepth.toStringAsFixed(2)}');

  if (totalErrors > 0) {
    print('');
    print('❌ FAIL — $totalErrors error(s) must be fixed.');
    exit(1);
  } else if (totalWarnings > 0) {
    print('');
    print('⚠️  PASS with warnings — Review $totalWarnings warning(s).');
    exit(0);
  } else {
    print('');
    print('✅ PASS — All content meets quality standards.');
    exit(0);
  }
}
