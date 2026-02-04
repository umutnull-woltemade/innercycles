import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Privacy-safe error reporting service
/// Logs errors to Supabase and sends Slack alerts for fatal errors
class ErrorReportingService {
  static String _platform = 'unknown';
  static String _appVersion = '0.0.0';
  static bool _initialized = false;

  /// Initialize the error reporting service
  static Future<void> initialize() async {
    if (_initialized) return;

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

    _initialized = true;

    if (kDebugMode) {
      debugPrint('ErrorReportingService: Initialized for $_platform v$_appVersion');
    }
  }

  /// Report a fatal error
  static Future<void> reportFatal({
    required String message,
    String? stackTrace,
    Map<String, dynamic>? context,
  }) async {
    await _report(
      errorType: 'fatal',
      message: message,
      stackTrace: stackTrace,
      context: context,
    );
  }

  /// Report a non-fatal error
  static Future<void> reportError({
    required String message,
    String? stackTrace,
    Map<String, dynamic>? context,
  }) async {
    await _report(
      errorType: 'error',
      message: message,
      stackTrace: stackTrace,
      context: context,
    );
  }

  /// Report a warning
  static Future<void> reportWarning({
    required String message,
    Map<String, dynamic>? context,
  }) async {
    await _report(
      errorType: 'warning',
      message: message,
      context: context,
    );
  }

  /// Report an info-level event
  static Future<void> reportInfo({
    required String message,
    Map<String, dynamic>? context,
  }) async {
    if (kDebugMode) {
      debugPrint('ErrorReportingService [INFO]: $message');
    }
    // Info level not stored in database, only logged in debug mode
  }

  /// Internal report method
  static Future<void> _report({
    required String errorType,
    required String message,
    String? stackTrace,
    Map<String, dynamic>? context,
  }) async {
    // Always log locally in debug mode
    if (kDebugMode) {
      debugPrint('ErrorReportingService [$errorType]: $message');
      if (stackTrace != null) {
        debugPrint('Stack trace: $stackTrace');
      }
    }

    try {
      final supabase = Supabase.instance.client;

      // Sanitize the message (remove potential PII)
      final sanitizedMessage = _sanitizeMessage(message);
      final sanitizedStackTrace = stackTrace != null
          ? _sanitizeStackTrace(stackTrace)
          : null;

      // Log to Supabase
      await supabase.from('error_logs').insert({
        'error_type': errorType,
        'message': sanitizedMessage,
        'stack_trace': sanitizedStackTrace,
        'platform': _platform,
        'app_version': _appVersion,
        'device_info': _getDeviceInfo(),
        'user_id': supabase.auth.currentUser?.id,
      });

      // Send Slack alert for fatal errors
      if (errorType == 'fatal') {
        await _sendSlackAlert(
          message: sanitizedMessage,
          stackTrace: sanitizedStackTrace,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ErrorReportingService: Failed to report error: $e');
      }
    }
  }

  /// Send a Slack alert via Edge Function
  static Future<void> _sendSlackAlert({
    required String message,
    String? stackTrace,
  }) async {
    try {
      await Supabase.instance.client.functions.invoke(
        'slack-alert',
        body: {
          'error_type': 'fatal',
          'message': message,
          'platform': _platform,
          'app_version': _appVersion,
          'stack_trace': stackTrace,
        },
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ErrorReportingService: Failed to send Slack alert: $e');
      }
    }
  }

  /// Sanitize message to remove potential PII
  static String _sanitizeMessage(String message) {
    // Remove email addresses
    var sanitized = message.replaceAll(
      RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'),
      '[EMAIL]',
    );

    // Remove phone numbers (basic pattern)
    sanitized = sanitized.replaceAll(
      RegExp(r'\+?[\d\s-]{10,}'),
      '[PHONE]',
    );

    // Remove UUIDs
    sanitized = sanitized.replaceAll(
      RegExp(r'[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}', caseSensitive: false),
      '[UUID]',
    );

    // Remove file paths (but keep relative paths for debugging)
    sanitized = sanitized.replaceAll(
      RegExp(r'/Users/[^/\s]+'),
      '/Users/[USER]',
    );

    return sanitized;
  }

  /// Sanitize stack trace
  static String _sanitizeStackTrace(String stackTrace) {
    // Limit length
    var sanitized = stackTrace.length > 2000
        ? '${stackTrace.substring(0, 2000)}...[truncated]'
        : stackTrace;

    // Remove file paths
    sanitized = sanitized.replaceAll(
      RegExp(r'/Users/[^/\s]+'),
      '/Users/[USER]',
    );

    return sanitized;
  }

  /// Get device info (privacy-safe)
  static Map<String, dynamic> _getDeviceInfo() {
    return {
      'platform': _platform,
      'is_web': kIsWeb,
      'is_debug': kDebugMode,
    };
  }

  /// Convenience method for Flutter error handler
  static void handleFlutterError(FlutterErrorDetails details) {
    reportFatal(
      message: details.exception.toString(),
      stackTrace: details.stack?.toString(),
      context: {
        'library': details.library,
        'context': details.context?.toString(),
      },
    );
  }

  /// Convenience method for async error handler
  static bool handleAsyncError(Object error, StackTrace stack) {
    reportFatal(
      message: error.toString(),
      stackTrace: stack.toString(),
    );
    return true; // Error handled
  }
}
