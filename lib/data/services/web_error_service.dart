import 'package:flutter/foundation.dart';
import 'analytics_service.dart';

/// Service for monitoring and logging errors on web platform
/// Tracks error boundary activations and repeated failures
class WebErrorService {
  static final WebErrorService _instance = WebErrorService._internal();
  factory WebErrorService() => _instance;
  WebErrorService._internal();

  final AnalyticsService _analytics = AnalyticsService();

  // Error tracking
  int _errorBoundaryActivations = 0;
  final List<_ErrorEntry> _recentErrors = [];
  static const int _maxRecentErrors = 10;
  static const int _spikeThreshold = 3; // 3 errors in 60 seconds = spike

  /// Log an error that triggered the error boundary
  void logError(String errorMessage) {
    _errorBoundaryActivations++;

    // Track recent errors for spike detection
    final entry = _ErrorEntry(message: errorMessage, timestamp: DateTime.now());
    _recentErrors.add(entry);

    // Keep only recent errors
    if (_recentErrors.length > _maxRecentErrors) {
      _recentErrors.removeAt(0);
    }

    // Log to analytics
    _analytics.logEvent('web_error_boundary', {
      'message': _truncate(errorMessage, 100),
      'count': _errorBoundaryActivations.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    });

    if (kDebugMode) {
      debugPrint(
        'WebErrorService: Error logged (#$_errorBoundaryActivations): $errorMessage',
      );
    }

    // Check for error spike
    _checkForSpike();
  }

  /// Check if there's a spike in errors (potential white screen loop)
  void _checkForSpike() {
    final now = DateTime.now();
    final recentCount = _recentErrors.where((e) {
      return now.difference(e.timestamp).inSeconds < 60;
    }).length;

    if (recentCount >= _spikeThreshold) {
      _analytics.logEvent('web_error_spike', {
        'count_last_minute': recentCount.toString(),
        'total_count': _errorBoundaryActivations.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      if (kDebugMode) {
        debugPrint(
          'WebErrorService: ERROR SPIKE DETECTED! $recentCount errors in last 60 seconds',
        );
      }
    }
  }

  /// Truncate string to max length
  String _truncate(String s, int maxLength) {
    if (s.length <= maxLength) return s;
    return '${s.substring(0, maxLength)}...';
  }
}

/// Internal class to track error entries with timestamps
class _ErrorEntry {
  final String message;
  final DateTime timestamp;

  _ErrorEntry({required this.message, required this.timestamp});
}
