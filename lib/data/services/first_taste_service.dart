import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tracks "first taste free" usage — allows users to experience premium features
/// once before gating them. This creates endowment effect: they've experienced
/// the full version and now feel the loss.
class FirstTasteService {
  static const String _keyPrefix = 'ic_first_taste_';

  final SharedPreferences _prefs;

  FirstTasteService._(this._prefs);

  static Future<FirstTasteService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return FirstTasteService._(prefs);
  }

  /// Check if the user has already used their free taste for this feature.
  /// Returns true if the feature has been used (should be locked now).
  bool hasUsedFreeTaste(FirstTasteFeature feature) {
    return _prefs.getBool('$_keyPrefix${feature.name}') ?? false;
  }

  /// Check remaining free uses for counted features.
  int getRemainingUses(FirstTasteFeature feature) {
    final used = _prefs.getInt('$_keyPrefix${feature.name}_count') ?? 0;
    return (feature.freeUses - used).clamp(0, feature.freeUses);
  }

  /// Record a use. Returns true if this was the last free use (now locked).
  Future<bool> recordUse(FirstTasteFeature feature) async {
    if (feature.freeUses <= 1) {
      // Single use features
      await _prefs.setBool('$_keyPrefix${feature.name}', true);
      return true;
    }

    // Counted features
    final used = (_prefs.getInt('$_keyPrefix${feature.name}_count') ?? 0) + 1;
    await _prefs.setInt('$_keyPrefix${feature.name}_count', used);

    if (used >= feature.freeUses) {
      await _prefs.setBool('$_keyPrefix${feature.name}', true);
      return true;
    }
    return false;
  }

  /// Returns true if user should get this feature for free (hasn't exhausted free uses).
  bool shouldAllowFree(FirstTasteFeature feature) {
    return !hasUsedFreeTaste(feature);
  }

  /// Clear all first taste data (for testing)
  Future<void> clearAll() async {
    for (final feature in FirstTasteFeature.values) {
      await _prefs.remove('$_keyPrefix${feature.name}');
      await _prefs.remove('$_keyPrefix${feature.name}_count');
    }
  }
}

/// Features that offer a "first taste free" experience
enum FirstTasteFeature {
  /// First monthly report is free, subsequent months locked
  monthlyReport(freeUses: 1),

  /// First full dream interpretation (all perspectives) is free
  fullDreamInterpretation(freeUses: 1),

  /// First 3 share cards are free, then locked
  shareCards(freeUses: 3),

  /// First guided program is free
  guidedProgram(freeUses: 1);

  final int freeUses;
  const FirstTasteFeature({required this.freeUses});
}

/// Provider
final firstTasteServiceProvider = FutureProvider<FirstTasteService>((ref) {
  return FirstTasteService.init();
});
