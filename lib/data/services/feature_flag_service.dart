import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Feature flag service for staged rollout and A/B testing
/// Fetches flags from Supabase and caches them locally
class FeatureFlagService {
  static final Map<String, FeatureFlag> _flags = {};
  static String _platform = 'unknown';
  static String _appVersion = '0.0.0';
  static DateTime? _lastFetch;
  static const Duration _cacheDuration = Duration(minutes: 15);

  /// Initialize the feature flag service
  static Future<void> initialize() async {
    // Determine platform
    if (kIsWeb) {
      _platform = 'web';
    } else {
      try {
        if (Platform.isIOS) {
          _platform = 'ios';
        } else if (Platform.isAndroid) {
          _platform = 'android';
        } else if (Platform.isMacOS) {
          _platform = 'macos';
        }
      } catch (_) {
        _platform = 'unknown';
      }
    }

    // Get app version
    try {
      final info = await PackageInfo.fromPlatform();
      _appVersion = info.version;
    } catch (_) {
      _appVersion = '0.0.0';
    }

    // Fetch flags
    await refresh();

    if (kDebugMode) {
      debugPrint(
        'FeatureFlagService: Initialized for $_platform v$_appVersion',
      );
      debugPrint('FeatureFlagService: ${_flags.length} flags loaded');
    }
  }

  /// Refresh flags from Supabase
  static Future<void> refresh({bool force = false}) async {
    // Check cache validity
    if (!force && _lastFetch != null) {
      final elapsed = DateTime.now().difference(_lastFetch!);
      if (elapsed < _cacheDuration) {
        return;
      }
    }

    try {
      final supabase = Supabase.instance.client;

      final response = await supabase
          .from('feature_flags')
          .select()
          .eq('is_enabled', true);

      _flags.clear();
      for (final row in response) {
        final flag = FeatureFlag.fromJson(row);
        _flags[flag.name] = flag;
      }

      _lastFetch = DateTime.now();

      if (kDebugMode) {
        debugPrint('FeatureFlagService: Refreshed ${_flags.length} flags');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('FeatureFlagService: Refresh failed: $e');
      }
      // Keep existing cached flags on failure
    }
  }

  /// Check if a feature flag is enabled
  static bool isEnabled(String flagName) {
    final flag = _flags[flagName];
    if (flag == null) return false;
    if (!flag.isEnabled) return false;

    // Check platform targeting
    if (flag.targetPlatforms.isNotEmpty) {
      if (!flag.targetPlatforms.contains(_platform)) {
        return false;
      }
    }

    // Check version targeting
    if (flag.targetVersions != null && flag.targetVersions!.isNotEmpty) {
      final minVersion = flag.targetVersions!.first;
      if (!_isVersionAtLeast(_appVersion, minVersion)) {
        return false;
      }
    }

    // Check rollout percentage (using stable user hash)
    if (flag.rolloutPercentage < 100) {
      final userHash = _getUserHash(flagName);
      if (userHash >= flag.rolloutPercentage) {
        return false;
      }
    }

    return true;
  }

  /// Get a feature flag value (for non-boolean flags)
  static T? getValue<T>(String flagName, {T? defaultValue}) {
    if (!isEnabled(flagName)) return defaultValue;
    return defaultValue;
  }

  /// Get all enabled flags
  static List<String> get enabledFlags {
    return _flags.entries
        .where((e) => isEnabled(e.key))
        .map((e) => e.key)
        .toList();
  }

  /// Get user hash for stable rollout
  static int _getUserHash(String flagName) {
    // Use a combination of flag name and timestamp for anonymous users
    // For logged-in users, this should use the user ID for consistency
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId != null) {
        return (userId.hashCode + flagName.hashCode).abs() % 100;
      }
    } catch (_) {}

    // For anonymous users, use a semi-stable hash based on flag name
    return flagName.hashCode.abs() % 100;
  }

  /// Compare versions (e.g., "1.2.3" >= "1.2.0")
  static bool _isVersionAtLeast(String current, String minimum) {
    try {
      final currentParts = current.split('.').map(int.parse).toList();
      final minimumParts = minimum.split('.').map(int.parse).toList();

      for (var i = 0; i < minimumParts.length; i++) {
        final currentPart = i < currentParts.length ? currentParts[i] : 0;
        final minimumPart = minimumParts[i];

        if (currentPart > minimumPart) return true;
        if (currentPart < minimumPart) return false;
      }
      return true; // Equal versions
    } catch (_) {
      return true; // Assume compatible on parse error
    }
  }

  /// Predefined flag names for type safety
  static const String flagDreamJournal = 'dream_journal';
  static const String flagPremiumFeatures = 'premium_features';
  static const String flagNewOnboarding = 'new_onboarding';
  static const String flagAdvancedAstrology = 'advanced_astrology';
  static const String flagSocialSharing = 'social_sharing';
}

/// Feature flag model
class FeatureFlag {
  final String id;
  final String name;
  final String? description;
  final bool isEnabled;
  final int rolloutPercentage;
  final List<String> targetPlatforms;
  final List<String>? targetVersions;
  final DateTime createdAt;
  final DateTime updatedAt;

  FeatureFlag({
    required this.id,
    required this.name,
    this.description,
    required this.isEnabled,
    this.rolloutPercentage = 100,
    this.targetPlatforms = const [],
    this.targetVersions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FeatureFlag.fromJson(Map<String, dynamic> json) => FeatureFlag(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    isEnabled: json['is_enabled'] ?? false,
    rolloutPercentage: json['rollout_percentage'] ?? 100,
    targetPlatforms: List<String>.from(json['target_platforms'] ?? []),
    targetVersions: json['target_versions'] != null
        ? List<String>.from(json['target_versions'])
        : null,
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'is_enabled': isEnabled,
    'rollout_percentage': rolloutPercentage,
    'target_platforms': targetPlatforms,
    'target_versions': targetVersions,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
