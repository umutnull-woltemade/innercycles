// ============================================================================
// INTRODUCTORY OFFER SERVICE - 72-hour limited-time discount
// ============================================================================
// Shows a 50% off yearly plan offer within the first 72 hours of install.
// Countdown timer creates urgency. Offer disappears after expiry.
// ============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================================
// SERVICE
// ============================================================================

class IntroductoryOfferService {
  static const String _installTimeKey = 'ic_intro_offer_install_time';
  static const String _dismissedKey = 'ic_intro_offer_dismissed';
  static const String _convertedKey = 'ic_intro_offer_converted';
  static const Duration _offerDuration = Duration(hours: 72);

  final SharedPreferences _prefs;

  IntroductoryOfferService._(this._prefs) {
    // Record install time on first access
    if (_prefs.getInt(_installTimeKey) == null) {
      _prefs.setInt(
        _installTimeKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    }
  }

  static Future<IntroductoryOfferService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return IntroductoryOfferService._(prefs);
  }

  // =========================================================================
  // STATE
  // =========================================================================

  /// When the app was first installed
  DateTime get installTime => DateTime.fromMillisecondsSinceEpoch(
    _prefs.getInt(_installTimeKey) ?? DateTime.now().millisecondsSinceEpoch,
  );

  /// When the offer expires
  DateTime get expiresAt => installTime.add(_offerDuration);

  /// Time remaining on the offer
  Duration get timeRemaining {
    final remaining = expiresAt.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Whether the offer is still active (within 72h, not dismissed/converted)
  bool get isOfferActive {
    if (_prefs.getBool(_dismissedKey) == true) return false;
    if (_prefs.getBool(_convertedKey) == true) return false;
    return timeRemaining > Duration.zero;
  }

  /// Whether user has dismissed the offer
  bool get isDismissed => _prefs.getBool(_dismissedKey) == true;

  /// Whether user converted via this offer
  bool get hasConverted => _prefs.getBool(_convertedKey) == true;

  // =========================================================================
  // FORMATTED TIME
  // =========================================================================

  /// Formatted countdown string: "47:23:15"
  String get countdownFormatted {
    final d = timeRemaining;
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  /// Formatted countdown parts for styled display
  ({String hours, String minutes, String seconds}) get countdownParts {
    final d = timeRemaining;
    return (
      hours: d.inHours.toString().padLeft(2, '0'),
      minutes: (d.inMinutes % 60).toString().padLeft(2, '0'),
      seconds: (d.inSeconds % 60).toString().padLeft(2, '0'),
    );
  }

  // =========================================================================
  // ACTIONS
  // =========================================================================

  /// Mark offer as dismissed (user closed it)
  void dismiss() {
    _prefs.setBool(_dismissedKey, true);
  }

  /// Mark offer as converted (user subscribed through it)
  void markConverted() {
    _prefs.setBool(_convertedKey, true);
  }

  /// Reset offer (for testing)
  void reset() {
    _prefs.remove(_installTimeKey);
    _prefs.remove(_dismissedKey);
    _prefs.remove(_convertedKey);
  }
}

// ============================================================================
// PROVIDER
// ============================================================================

final introductoryOfferProvider =
    FutureProvider<IntroductoryOfferService>((ref) {
  return IntroductoryOfferService.init();
});
