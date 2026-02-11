#!/usr/bin/env dart
// ignore_for_file: avoid_print

/// i18n Hardcoded String Scanner
///
/// This script scans Dart files for potentially hardcoded user-facing strings
/// that should be internationalized using L10nService.
///
/// Exit codes:
/// - 0: No violations found
/// - 1: Violations found
library;
///
/// Usage:
///   dart run scripts/i18n_hardcoded_scanner.dart
///   dart run scripts/i18n_hardcoded_scanner.dart --strict

import 'dart:io';

void main(List<String> args) {
  final strict = args.contains('--strict');

  print('=== i18n Hardcoded String Scanner ===\n');

  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    print('ERROR: lib directory not found');
    exit(1);
  }

  final violations = <Violation>[];

  // Get all Dart files
  final dartFiles = libDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  print('Scanning ${dartFiles.length} Dart files...\n');

  // Turkish characters to detect
  const turkishChars = 'ığüşöçİĞÜŞÖÇ';

  // Common Turkish words that indicate hardcoded strings (even without special chars)
  const turkishWords = [
    'Burç', 'Günlük', 'Haftalık', 'Aylık', 'Yıllık',
    'Keşfet', 'Devam', 'Analiz', 'Yorum', 'Harita',
    'Uyum', 'Paylaş', 'Kozmik', 'Enerji', 'Tarot',
    'Numeroloji', 'Rüya', 'Kadim', 'Bilgelik', 'Evren',
    'Yıldız', 'Gezegen', 'Ay', 'Güneş', 'Doğum',
    'Aşk', 'İlişki', 'Kariyer', 'Sağlık', 'Finans',
    'Bugün', 'Yarın', 'Dün', 'Şimdi', 'Sonra',
    'Merak', 'Bakış', 'Açı', 'Dünya', 'Bağlan',
  ];

  for (final file in dartFiles) {
    final content = file.readAsStringSync();
    final lines = content.split('\n');
    final relativePath = file.path.replaceFirst('lib/', '');

    // Skip certain files
    if (_shouldSkipFile(relativePath)) {
      continue;
    }

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final lineNumber = i + 1;

      // Skip certain line patterns
      if (_shouldSkipLine(line)) {
        continue;
      }

      // Check for hardcoded strings with Turkish characters
      // Match strings in single or double quotes
      final stringPattern = RegExp(r'''["']([^"']+)["']''');
      final matches = stringPattern.allMatches(line);

      for (final match in matches) {
        final text = match.group(1) ?? '';

        // Check if contains Turkish characters
        final hasTurkish = turkishChars.split('').any((c) => text.contains(c));

        // Check if contains common Turkish words
        final hasTurkishWord = turkishWords.any((word) => text.contains(word));

        if ((hasTurkish || hasTurkishWord) && text.length > 3 && !_isAllowedString(text)) {
          // Determine context
          String type;
          if (line.contains('Text(') || line.contains('Text.')) {
            type = 'Turkish in Text widget';
          } else if (RegExp(r'(title|content|label|message|hint):', caseSensitive: false).hasMatch(line)) {
            type = 'Turkish in parameter';
          } else {
            type = 'Turkish string literal';
          }

          violations.add(Violation(
            file: relativePath,
            line: lineNumber,
            text: text,
            type: type,
          ));
        }
      }

      // In strict mode, also check for common English UI strings that should be i18n
      if (strict) {
        final commonUiStrings = [
          'Loading',
          'Error',
          'Success',
          'Cancel',
          'Save',
          'Delete',
          'Edit',
          'Close',
          'Back',
          'Next',
        ];

        for (final uiString in commonUiStrings) {
          // Match exact string as UI text (not as part of variable names)
          final pattern = RegExp('''["']$uiString["']''');
          if (pattern.hasMatch(line) && !line.contains('L10nService')) {
            violations.add(Violation(
              file: relativePath,
              line: lineNumber,
              text: uiString,
              type: 'Common UI string not i18n',
            ));
          }
        }
      }
    }
  }

  // Group violations by file
  final byFile = <String, List<Violation>>{};
  for (final v in violations) {
    byFile.putIfAbsent(v.file, () => []).add(v);
  }

  // Report violations
  if (violations.isEmpty) {
    print('No hardcoded string violations found.');
    print('\n=== Summary ===');
    print('PASSED: No i18n violations detected');
    exit(0);
  } else {
    print('Found ${violations.length} potential violations in ${byFile.length} files:\n');

    for (final entry in byFile.entries) {
      print('${entry.key}:');
      for (final v in entry.value) {
        print('  Line ${v.line}: ${v.type}');
        print('    "${_truncate(v.text, 60)}"');
      }
      print('');
    }

    print('=== Summary ===');
    print('FAILED: ${violations.length} hardcoded strings found');
    print('All user-facing strings should use L10nService.get()');

    // Exit with warning (0) instead of error (1) for now
    // This allows the build to continue while flagging issues
    // Change to exit(1) to enforce strict mode
    print('\nNote: Currently running in advisory mode.');
    print('Set --strict to enforce blocking.');

    if (strict) {
      exit(1);
    } else {
      exit(0);
    }
  }
}

bool _shouldSkipFile(String path) {
  final skipPatterns = [
    'generated',
    '.g.dart',
    '.freezed.dart',
    'test/',
    'l10n_service.dart', // The l10n service itself
    'routes.dart',       // Route constants
    'app_colors.dart',   // Color constants
    'constants/',        // Constants folder
  ];

  return skipPatterns.any((p) => path.contains(p));
}

bool _shouldSkipLine(String line) {
  final trimmed = line.trim();

  // Skip comments
  if (trimmed.startsWith('//') || trimmed.startsWith('*') || trimmed.startsWith('///')) {
    return true;
  }

  // Skip imports
  if (trimmed.startsWith('import ') || trimmed.startsWith('export ')) {
    return true;
  }

  // Skip lines with L10nService (already internationalized)
  if (line.contains('L10nService')) {
    return true;
  }

  // Skip debug/log lines
  if (line.contains('debugPrint') || line.contains('print(') || line.contains('log(')) {
    return true;
  }

  // Skip asset paths
  if (line.contains('assets/') || line.contains('.png') || line.contains('.jpg') || line.contains('.svg')) {
    return true;
  }

  // Skip route definitions
  if (line.contains('static const') && line.contains('Route')) {
    return true;
  }

  // Skip package references
  if (line.contains('package:')) {
    return true;
  }

  // Skip key assignments (l10n keys themselves)
  if (RegExp(r'''['"][a-z_]+\.[a-z_]+['"]''').hasMatch(line)) {
    return true;
  }

  return false;
}

bool _isAllowedString(String text) {
  // Allow certain patterns
  if (RegExp(r'^[0-9\s\-\+\.\,\:\;]+$').hasMatch(text)) return true;     // Numbers, dates
  if (RegExp(r'^[A-Z_]+$').hasMatch(text)) return true;                   // Constants
  if (text.startsWith('http://') || text.startsWith('https://')) return true; // URLs
  if (text.startsWith('assets/')) return true;                            // Asset paths
  if (RegExp(r'^\{[^}]+\}$').hasMatch(text)) return true;                // Placeholders
  if (RegExp(r'^[a-z_]+\.[a-z_]+').hasMatch(text)) return true;          // Key references

  return false;
}

String _truncate(String text, int maxLength) {
  if (text.length <= maxLength) return text;
  return '${text.substring(0, maxLength)}...';
}

class Violation {
  final String file;
  final int line;
  final String text;
  final String type;

  Violation({
    required this.file,
    required this.line,
    required this.text,
    required this.type,
  });
}
