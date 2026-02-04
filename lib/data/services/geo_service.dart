import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Geo-IP service for detecting user's country and suggesting language
class GeoService {
  static const String _geoSuggestionShownKey = 'geo_suggestion_shown';
  static const String _detectedCountryKey = 'detected_country';

  /// Detect user's country code via free Geo-IP API
  /// Returns ISO 3166-1 alpha-2 country code (e.g., 'TR', 'US', 'DE')
  static Future<String?> detectCountry() async {
    try {
      // Use free ipapi.co service (no API key required for basic use)
      final response = await http.get(
        Uri.parse('https://ipapi.co/json/'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final country = data['country_code'] as String?;

        // Cache the result
        if (country != null) {
          try {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(_detectedCountryKey, country);
          } catch (_) {}
        }

        return country;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('GeoService.detectCountry error: $e');
      }
    }
    return null;
  }

  /// Get cached country (if previously detected)
  static Future<String?> getCachedCountry() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_detectedCountryKey);
    } catch (_) {
      return null;
    }
  }

  /// Check if user is from Turkey (for Turkish language suggestion)
  static Future<bool> isFromTurkey() async {
    // First check cache
    final cached = await getCachedCountry();
    if (cached != null) return cached == 'TR';

    // Then detect
    final countryCode = await detectCountry();
    return countryCode == 'TR';
  }

  /// Check if geo-based language suggestion has already been shown
  static Future<bool> hasShownGeoSuggestion() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_geoSuggestionShownKey) ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Mark geo-based language suggestion as shown
  static Future<void> markGeoSuggestionShown() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_geoSuggestionShownKey, true);
    } catch (e) {
      if (kDebugMode) debugPrint('GeoService storage error: $e');
    }
  }

  /// Determine if we should show Turkish language suggestion
  /// Only shows once, only for users from Turkey who haven't seen it
  static Future<bool> shouldSuggestTurkish() async {
    // Only if not already shown
    if (await hasShownGeoSuggestion()) return false;

    // Only if user is from Turkey
    return await isFromTurkey();
  }
}
