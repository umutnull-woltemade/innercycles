import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// PART 5 & 6: Instagram Share Service
///
/// WHY INSTAGRAM SHARE FAILS:
/// 1. Instagram has NO public API for direct posting
/// 2. iOS restricts direct app-to-app sharing without user consent
/// 3. Android intents require specific MIME types and content URIs
/// 4. Web cannot trigger native Instagram app
/// 5. Stories API requires Meta developer approval (not practical for most apps)
///
/// SOLUTION:
/// Use the native OS share sheet which includes Instagram when installed.
/// This is the ONLY reliable cross-platform method.
class InstagramShareService {
  /// Main share method - handles all platforms
  static Future<ShareResult> shareCosmicContent({
    required RenderRepaintBoundary boundary,
    required String shareText,
    String? hashtags,
  }) async {
    try {
      // 1. Capture the image
      final imageBytes = await _captureImage(boundary);
      if (imageBytes == null) {
        return ShareResult(
          success: false,
          error: ShareError.captureFailed,
          message: 'Görsel oluşturulamadı',
        );
      }

      // 2. Save to temp file
      final file = await _saveToTempFile(imageBytes);
      if (file == null) {
        return ShareResult(
          success: false,
          error: ShareError.saveFailed,
          message: 'Dosya kaydedilemedi',
        );
      }

      // 3. Platform-specific share
      if (kIsWeb) {
        return await _shareOnWeb(file, shareText, hashtags);
      } else if (Platform.isIOS) {
        return await _shareOnIOS(file, shareText, hashtags);
      } else if (Platform.isAndroid) {
        return await _shareOnAndroid(file, shareText, hashtags);
      } else {
        return await _shareGeneric(file, shareText, hashtags);
      }
    } catch (e) {
      return ShareResult(
        success: false,
        error: ShareError.unknown,
        message: 'Paylaşım hatası: $e',
      );
    }
  }

  /// Capture widget as image
  static Future<Uint8List?> _captureImage(RenderRepaintBoundary boundary) async {
    try {
      // Wait for any pending renders
      await Future.delayed(const Duration(milliseconds: 50));

      // Capture at 3x resolution for quality
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Image capture error: $e');
      return null;
    }
  }

  /// Save bytes to temp file
  static Future<File?> _saveToTempFile(Uint8List bytes) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${tempDir.path}/astrobobo_cosmic_$timestamp.png');
      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      debugPrint('File save error: $e');
      return null;
    }
  }

  /// iOS Share Implementation
  ///
  /// Uses UIActivityViewController via share_plus
  /// Instagram Stories option appears if Instagram is installed
  static Future<ShareResult> _shareOnIOS(
    File file,
    String shareText,
    String? hashtags,
  ) async {
    try {
      final fullText = _buildShareText(shareText, hashtags);

      // Use SharePlus which wraps UIActivityViewController
      final result = await Share.shareXFiles(
        [XFile(file.path)],
        text: fullText,
        subject: 'Kozmik Enerji',
      );

      // Check result status
      if (result.status == ShareResultStatus.success) {
        return ShareResult(
          success: true,
          platform: SharePlatform.ios,
          message: 'Paylaşıldı!',
        );
      } else if (result.status == ShareResultStatus.dismissed) {
        return ShareResult(
          success: false,
          error: ShareError.dismissed,
          platform: SharePlatform.ios,
          message: 'Paylaşım iptal edildi',
        );
      } else {
        return ShareResult(
          success: false,
          error: ShareError.unknown,
          platform: SharePlatform.ios,
          message: 'Paylaşım tamamlanamadı',
        );
      }
    } catch (e) {
      return ShareResult(
        success: false,
        error: ShareError.platformError,
        platform: SharePlatform.ios,
        message: 'iOS paylaşım hatası: $e',
      );
    }
  }

  /// Android Share Implementation
  ///
  /// Uses Intent.ACTION_SEND with proper MIME type
  /// System share sheet shows Instagram if installed
  static Future<ShareResult> _shareOnAndroid(
    File file,
    String shareText,
    String? hashtags,
  ) async {
    try {
      final fullText = _buildShareText(shareText, hashtags);

      // share_plus handles Intent.ACTION_SEND correctly
      final result = await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png')],
        text: fullText,
        subject: 'Kozmik Enerji',
      );

      if (result.status == ShareResultStatus.success) {
        return ShareResult(
          success: true,
          platform: SharePlatform.android,
          message: 'Paylaşıldı!',
        );
      } else if (result.status == ShareResultStatus.dismissed) {
        return ShareResult(
          success: false,
          error: ShareError.dismissed,
          platform: SharePlatform.android,
          message: 'Paylaşım iptal edildi',
        );
      } else {
        return ShareResult(
          success: false,
          error: ShareError.unknown,
          platform: SharePlatform.android,
          message: 'Paylaşım tamamlanamadı',
        );
      }
    } catch (e) {
      return ShareResult(
        success: false,
        error: ShareError.platformError,
        platform: SharePlatform.android,
        message: 'Android paylaşım hatası: $e',
      );
    }
  }

  /// Web Share Implementation
  ///
  /// Web cannot directly share to Instagram
  /// Fallback: Download image + copy text + show instructions
  static Future<ShareResult> _shareOnWeb(
    File file,
    String shareText,
    String? hashtags,
  ) async {
    try {
      // Try Web Share API first (Chrome, Safari, Edge support)
      if (await _canUseWebShareApi()) {
        final result = await Share.shareXFiles(
          [XFile(file.path)],
          text: _buildShareText(shareText, hashtags),
        );

        if (result.status == ShareResultStatus.success) {
          return ShareResult(
            success: true,
            platform: SharePlatform.web,
            message: 'Paylaşıldı!',
          );
        }
      }

      // Fallback: Provide download and instructions
      return ShareResult(
        success: false,
        error: ShareError.webFallback,
        platform: SharePlatform.web,
        message: 'Görseli indirip Instagram\'da paylaşabilirsin',
        fallbackData: ShareFallbackData(
          downloadUrl: file.path,
          copyText: _buildShareText(shareText, hashtags),
          instructions: [
            '1. Görseli indir',
            '2. Instagram\'ı aç',
            '3. Hikaye veya gönderi olarak paylaş',
            '4. Metni yapıştır',
          ],
        ),
      );
    } catch (e) {
      return ShareResult(
        success: false,
        error: ShareError.platformError,
        platform: SharePlatform.web,
        message: 'Web paylaşım hatası: $e',
      );
    }
  }

  /// Generic share fallback
  static Future<ShareResult> _shareGeneric(
    File file,
    String shareText,
    String? hashtags,
  ) async {
    try {
      final result = await Share.shareXFiles(
        [XFile(file.path)],
        text: _buildShareText(shareText, hashtags),
      );

      return ShareResult(
        success: result.status == ShareResultStatus.success,
        platform: SharePlatform.other,
        message: result.status == ShareResultStatus.success
            ? 'Paylaşıldı!'
            : 'Paylaşım tamamlanamadı',
      );
    } catch (e) {
      return ShareResult(
        success: false,
        error: ShareError.unknown,
        message: 'Paylaşım hatası: $e',
      );
    }
  }

  /// Build share text with hashtags
  static String _buildShareText(String text, String? hashtags) {
    final buffer = StringBuffer(text);
    if (hashtags != null && hashtags.isNotEmpty) {
      buffer.writeln();
      buffer.writeln();
      buffer.write(hashtags);
    }
    return buffer.toString();
  }

  /// Check if Web Share API is available
  static Future<bool> _canUseWebShareApi() async {
    // This is a simplified check - in production, use a proper JS interop
    return kIsWeb;
  }

  /// Open Instagram app directly (for "Open in Instagram" button)
  static Future<bool> openInstagram() async {
    const instagramUrl = 'instagram://app';
    const webUrl = 'https://instagram.com';

    try {
      final uri = Uri.parse(instagramUrl);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      } else {
        // Fallback to web
        return await launchUrl(Uri.parse(webUrl));
      }
    } catch (e) {
      debugPrint('Could not open Instagram: $e');
      return false;
    }
  }

  /// Check if Instagram is installed
  static Future<bool> isInstagramInstalled() async {
    if (kIsWeb) return false;

    try {
      final uri = Uri.parse('instagram://app');
      return await canLaunchUrl(uri);
    } catch (e) {
      return false;
    }
  }

  /// Copy text to clipboard (helper for web fallback)
  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
}

// ═══════════════════════════════════════════════════════════════
// RESULT MODELS
// ═══════════════════════════════════════════════════════════════

class ShareResult {
  final bool success;
  final ShareError? error;
  final SharePlatform? platform;
  final String message;
  final ShareFallbackData? fallbackData;

  const ShareResult({
    required this.success,
    this.error,
    this.platform,
    required this.message,
    this.fallbackData,
  });
}

enum ShareError {
  captureFailed,
  saveFailed,
  dismissed,
  platformError,
  webFallback,
  unknown,
}

enum SharePlatform {
  ios,
  android,
  web,
  other,
}

class ShareFallbackData {
  final String downloadUrl;
  final String copyText;
  final List<String> instructions;

  const ShareFallbackData({
    required this.downloadUrl,
    required this.copyText,
    required this.instructions,
  });
}
