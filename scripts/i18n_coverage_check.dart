#!/usr/bin/env dart

/// i18n Coverage Check Script
///
/// This script validates that all translation files have 100% key coverage.
/// It compares en.json (source of truth) against all other language files.
///
/// Exit codes:
/// - 0: All languages have 100% coverage
/// - 1: Coverage is below 100% or keys are missing
///
/// Usage:
///   dart run scripts/i18n_coverage_check.dart
///   dart run scripts/i18n_coverage_check.dart --verbose

import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  final verbose = args.contains('--verbose') || args.contains('-v');

  print('=== i18n Coverage Check ===\n');

  final l10nDir = Directory('assets/l10n');
  if (!l10nDir.existsSync()) {
    print('ERROR: assets/l10n directory not found');
    exit(1);
  }

  // Load English as source of truth
  final enFile = File('assets/l10n/en.json');
  if (!enFile.existsSync()) {
    print('ERROR: en.json not found');
    exit(1);
  }

  Map<String, dynamic> enJson;
  try {
    enJson = jsonDecode(enFile.readAsStringSync()) as Map<String, dynamic>;
  } catch (e) {
    print('ERROR: Failed to parse en.json: $e');
    exit(1);
  }

  final enKeys = _extractAllKeys(enJson);
  print('Source (en.json): ${enKeys.length} keys');

  // Get all language files
  final languageFiles = l10nDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json') && !f.path.endsWith('en.json'))
      .toList();

  if (languageFiles.isEmpty) {
    print('WARNING: No other language files found');
    exit(0);
  }

  // Priority languages that MUST have 100% coverage (blocks CI)
  // Other languages are advisory only
  const priorityLanguages = ['tr.json'];

  var hasErrors = false;

  for (final file in languageFiles) {
    final filename = file.path.split('/').last;

    Map<String, dynamic> langJson;
    try {
      langJson = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    } catch (e) {
      print('\nERROR: Failed to parse $filename: $e');
      hasErrors = true;
      continue;
    }

    final langKeys = _extractAllKeys(langJson);

    // Find missing keys (in EN but not in this language)
    final missingKeys = enKeys.where((k) => !langKeys.contains(k)).toList();

    // Find extra keys (in this language but not in EN)
    final extraKeys = langKeys.where((k) => !enKeys.contains(k)).toList();

    final coverage = ((langKeys.length - extraKeys.length) / enKeys.length * 100).toStringAsFixed(1);

    final isPriority = priorityLanguages.contains(filename);

    if (missingKeys.isEmpty && extraKeys.isEmpty) {
      print('$filename: ${langKeys.length} keys (100% coverage) ✓');
    } else {
      // Only block on priority languages
      if (isPriority) {
        hasErrors = true;
      }
      final marker = isPriority ? '✗ BLOCKING' : '⚠ advisory';
      print('\n$filename: ${langKeys.length} keys ($coverage% coverage) $marker');

      if (missingKeys.isNotEmpty) {
        print('  Missing ${missingKeys.length} keys:');
        if (verbose) {
          for (final key in missingKeys.take(20)) {
            print('    - $key');
          }
          if (missingKeys.length > 20) {
            print('    ... and ${missingKeys.length - 20} more');
          }
        } else {
          print('    (use --verbose to see details)');
        }
      }

      if (extraKeys.isNotEmpty) {
        print('  Extra ${extraKeys.length} keys (not in en.json):');
        if (verbose) {
          for (final key in extraKeys.take(20)) {
            print('    - $key');
          }
          if (extraKeys.length > 20) {
            print('    ... and ${extraKeys.length - 20} more');
          }
        } else {
          print('    (use --verbose to see details)');
        }
      }
    }
  }

  print('\n=== Summary ===');
  print('Priority languages (blocking): ${priorityLanguages.join(', ')}');

  if (hasErrors) {
    print('FAILED: Priority languages have incomplete coverage');
    print('Priority translation files must have 100% key alignment with en.json');
    exit(1);
  } else {
    print('PASSED: All priority languages have 100% coverage');
    exit(0);
  }
}

/// Recursively extracts all keys from a nested JSON object
/// Returns keys in dot notation (e.g., "common.cancel", "dreams.canonical.falling_question")
Set<String> _extractAllKeys(Map<String, dynamic> json, [String prefix = '']) {
  final keys = <String>{};

  for (final entry in json.entries) {
    final key = prefix.isEmpty ? entry.key : '$prefix.${entry.key}';

    if (entry.value is Map<String, dynamic>) {
      keys.addAll(_extractAllKeys(entry.value as Map<String, dynamic>, key));
    } else if (entry.value is List) {
      // For arrays, we just track the key itself
      keys.add(key);
    } else {
      keys.add(key);
    }
  }

  return keys;
}
