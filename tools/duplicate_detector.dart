// ignore_for_file: avoid_print
// Duplicate Detector — Content Deduplication Tool
//
// Detects duplicate or near-duplicate content using Jaccard similarity.
// Threshold: 70% similarity = flagged as duplicate.
//
// Usage: dart run tools/duplicate_detector.dart [path]

import 'dart:io';

const double duplicateThreshold = 0.70;

class DuplicatePair {
  final String fileA;
  final int lineA;
  final String fileB;
  final int lineB;
  final String contentA;
  final String contentB;
  final double similarity;

  DuplicatePair({
    required this.fileA,
    required this.lineA,
    required this.fileB,
    required this.lineB,
    required this.contentA,
    required this.contentB,
    required this.similarity,
  });
}

/// Compute Jaccard similarity between two strings (word-level)
double jaccardSimilarity(String a, String b) {
  final wordsA = _tokenize(a);
  final wordsB = _tokenize(b);

  if (wordsA.isEmpty && wordsB.isEmpty) return 1.0;
  if (wordsA.isEmpty || wordsB.isEmpty) return 0.0;

  final intersection = wordsA.intersection(wordsB).length;
  final union = wordsA.union(wordsB).length;

  return union == 0 ? 0.0 : intersection / union;
}

Set<String> _tokenize(String text) {
  return text
      .toLowerCase()
      .replaceAll(RegExp(r'[^\w\s]'), '')
      .split(RegExp(r'\s+'))
      .where((w) => w.length > 2)
      .toSet();
}

/// Extract string literals from Dart files
List<(String file, int line, String content)> extractStrings(String path) {
  final strings = <(String, int, String)>[];
  final dir = Directory(path);

  for (final entity in dir.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;

    final lines = entity.readAsLinesSync();
    final buffer = StringBuffer();
    var startLine = -1;
    var inMultiline = false;

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];

      // Detect multiline string starts
      if (line.contains("'''") || line.contains('"""')) {
        if (!inMultiline) {
          inMultiline = true;
          startLine = i + 1;
          buffer.write(line);
        } else {
          buffer.write(line);
          final content = buffer.toString();
          if (content.length > 50) {
            strings.add((entity.path, startLine, content));
          }
          buffer.clear();
          inMultiline = false;
        }
        continue;
      }

      if (inMultiline) {
        buffer.write(' $line');
        continue;
      }

      // Single-line strings > 50 chars
      final matches = RegExp(r"'([^']{50,})'").allMatches(line);
      for (final match in matches) {
        strings.add((entity.path, i + 1, match.group(1)!));
      }
    }
  }

  return strings;
}

void main(List<String> args) {
  final targetPath = args.isNotEmpty ? args[0] : 'lib/data/content/';

  print('╔══════════════════════════════════════════════════════╗');
  print('║        DUPLICATE DETECTOR — Content Quality         ║');
  print('╚══════════════════════════════════════════════════════╝');
  print('');
  print('Scanning: $targetPath');
  print('Threshold: ${(duplicateThreshold * 100).toStringAsFixed(0)}% Jaccard similarity');
  print('');

  final strings = extractStrings(targetPath);
  print('Found ${strings.length} content strings to compare.');
  print('');

  final duplicates = <DuplicatePair>[];

  for (var i = 0; i < strings.length; i++) {
    for (var j = i + 1; j < strings.length; j++) {
      // Skip same file comparisons for adjacent lines (likely related)
      if (strings[i].$1 == strings[j].$1 &&
          (strings[i].$2 - strings[j].$2).abs() < 5) {
        continue;
      }

      final sim = jaccardSimilarity(strings[i].$3, strings[j].$3);
      if (sim >= duplicateThreshold) {
        duplicates.add(DuplicatePair(
          fileA: strings[i].$1,
          lineA: strings[i].$2,
          fileB: strings[j].$1,
          lineB: strings[j].$2,
          contentA: strings[i].$3.substring(0, strings[i].$3.length.clamp(0, 80)),
          contentB: strings[j].$3.substring(0, strings[j].$3.length.clamp(0, 80)),
          similarity: sim,
        ));
      }
    }
  }

  if (duplicates.isEmpty) {
    print('✅ PASS — No duplicate content detected.');
    exit(0);
  }

  print('⚠️  Found ${duplicates.length} potential duplicate pair(s):\n');

  for (final d in duplicates) {
    final pct = (d.similarity * 100).toStringAsFixed(1);
    print('  SIMILARITY: $pct%');
    print('  A: ${d.fileA}:${d.lineA}');
    print('     "${d.contentA}..."');
    print('  B: ${d.fileB}:${d.lineB}');
    print('     "${d.contentB}..."');
    print('');
  }

  print('─────────────────────────────────────────────────');
  print('Total duplicate pairs: ${duplicates.length}');

  // Only fail on very high similarity
  final exact = duplicates.where((d) => d.similarity > 0.9).length;
  if (exact > 0) {
    print('❌ FAIL — $exact near-exact duplicate(s) found.');
    exit(1);
  } else {
    print('⚠️  WARNING — Review flagged pairs for content variety.');
    exit(0);
  }
}
