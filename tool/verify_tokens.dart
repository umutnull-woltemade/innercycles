// ignore_for_file: avoid_print
// Design Token Sync Verification Script
//
// Reads assets/design_tokens.json and verifies key values match
// cosmic_palette.dart and glass_tokens.dart.
//
// Usage: dart run tool/verify_tokens.dart
//
// Exit codes:
//   0 = All tokens in sync
//   1 = Drift detected

import 'dart:convert';
import 'dart:io';

void main() async {
  print('Design Token Sync Verification');
  print('=' * 50);

  final tokenFile = File('assets/design_tokens.json');
  if (!tokenFile.existsSync()) {
    print('ERROR: assets/design_tokens.json not found');
    exit(1);
  }

  final tokens =
      jsonDecode(tokenFile.readAsStringSync()) as Map<String, dynamic>;
  final errors = <String>[];
  final warnings = <String>[];

  // ── Verify cosmic_palette.dart ──────────────────────────────────────────
  final paletteFile = File('lib/core/theme/cosmic_palette.dart');
  if (!paletteFile.existsSync()) {
    print('ERROR: cosmic_palette.dart not found');
    exit(1);
  }
  final paletteSource = paletteFile.readAsStringSync();

  // Check dark background colors
  final darkColors =
      (tokens['colors'] as Map)['dark'] as Map<String, dynamic>;
  final darkBg = darkColors['background'] as Map<String, dynamic>;

  _verifyColor(paletteSource, 'bgDeepSpace', darkBg['deep'] as String, errors);
  _verifyColor(paletteSource, 'bgCosmic', darkBg['cosmic'] as String, errors);
  _verifyColor(
      paletteSource, 'bgElevated', darkBg['elevated'] as String, errors);

  // Check primary
  _verifyColor(
      paletteSource, 'amethyst', darkColors['primary'] as String, errors);

  // Check gold
  _verifyColor(
      paletteSource, 'starGold', darkColors['secondary'] as String, errors);

  // Check text colors
  final textColors = darkColors['text'] as Map<String, dynamic>;
  _verifyColor(
      paletteSource, 'textPrimary', textColors['primary'] as String, errors);
  _verifyColor(
      paletteSource, 'textSecondary', textColors['secondary'] as String, errors);
  _verifyColor(
      paletteSource, 'textMuted', textColors['muted'] as String, errors);
  _verifyColor(
      paletteSource, 'textGold', textColors['gold'] as String, errors);

  // ── Verify glass_tokens.dart ───────────────────────────────────────────
  final glassFile = File('lib/core/theme/liquid_glass/glass_tokens.dart');
  if (!glassFile.existsSync()) {
    print('ERROR: glass_tokens.dart not found');
    exit(1);
  }
  final glassSource = glassFile.readAsStringSync();

  // Check elevation system
  final elevation = tokens['elevation'] as Map<String, dynamic>;
  _verifyDouble(
      glassSource, 'g1Blur', (elevation['G1'] as Map)['blur'], errors);
  _verifyDouble(
      glassSource, 'g1Opacity', (elevation['G1'] as Map)['opacity'], errors);
  _verifyDouble(
      glassSource, 'g2Blur', (elevation['G2'] as Map)['blur'], errors);
  _verifyDouble(
      glassSource, 'g3Blur', (elevation['G3'] as Map)['blur'], errors);
  _verifyDouble(
      glassSource, 'g4Blur', (elevation['G4'] as Map)['blur'], errors);
  _verifyDouble(
      glassSource, 'g5Blur', (elevation['G5'] as Map)['blur'], errors);

  // Check blur scale
  final blur = tokens['blur'] as Map<String, dynamic>;
  _verifyDouble(glassSource, 'blurSubtle', blur['subtle'], errors);
  _verifyDouble(glassSource, 'blurLight', blur['light'], errors);
  _verifyDouble(glassSource, 'blurMedium', blur['medium'], errors);
  _verifyDouble(glassSource, 'blurHeavy', blur['heavy'], errors);
  _verifyDouble(glassSource, 'blurMax', blur['max'], errors);

  // Check spacing from app_constants.dart
  final constantsFile = File('lib/core/constants/app_constants.dart');
  if (constantsFile.existsSync()) {
    final constSource = constantsFile.readAsStringSync();
    final spacing = tokens['spacing'] as Map<String, dynamic>;
    _verifyDouble(constSource, 'spacingSm', spacing['sm'], warnings);
    _verifyDouble(constSource, 'spacingMd', spacing['md'], warnings);
    _verifyDouble(constSource, 'spacingLg', spacing['lg'], warnings);
    _verifyDouble(constSource, 'spacingXl', spacing['xl'], warnings);
  }

  // ── Report ─────────────────────────────────────────────────────────────
  print('');
  if (warnings.isNotEmpty) {
    print('WARNINGS (${warnings.length}):');
    for (final w in warnings) {
      print('  ⚠️  $w');
    }
    print('');
  }

  if (errors.isEmpty) {
    print('✅ All $_checksRun token checks passed — no drift detected');
    exit(0);
  } else {
    print('❌ DRIFT DETECTED (${errors.length} mismatches):');
    for (final e in errors) {
      print('  ✗ $e');
    }
    exit(1);
  }
}

int _checksRun = 0;

void _verifyColor(
    String source, String varName, String hexColor, List<String> issues) {
  _checksRun++;
  // Normalize: #RRGGBB → 0xFFRRGGBB
  final normalized =
      hexColor.replaceFirst('#', '').toUpperCase();
  final expected = '0xFF$normalized';

  if (!source.contains(expected)) {
    issues.add('$varName: expected $expected from tokens, not found in source');
  }
}

void _verifyDouble(
    String source, String varName, dynamic value, List<String> issues) {
  _checksRun++;
  final numVal = (value is int) ? value.toDouble() : (value as double);
  // Match patterns like: static const double varName = 8;
  // or: static const double varName = 0.05;
  final intPattern = RegExp(
      '${RegExp.escape(varName)}\\s*=\\s*${numVal.toInt()}[^.]');
  final doublePattern =
      RegExp('${RegExp.escape(varName)}\\s*=\\s*$numVal');

  if (!intPattern.hasMatch(source) && !doublePattern.hasMatch(source)) {
    issues.add('$varName: expected $numVal from tokens, not found in source');
  }
}
