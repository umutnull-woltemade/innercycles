import 'dart:js_interop';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

/// Web implementation - downloads image using HTML5 anchor element
void downloadImageOnWeb(Uint8List bytes, String fileName) {
  try {
    // Create blob from bytes
    final jsArray = bytes.toJS;
    final blob = web.Blob(
      [jsArray].toJS,
      web.BlobPropertyBag(type: 'image/png'),
    );
    final url = web.URL.createObjectURL(blob);

    // Create anchor element and trigger download
    final anchor = web.HTMLAnchorElement()
      ..href = url
      ..download = fileName
      ..style.display = 'none';

    web.document.body?.appendChild(anchor);
    anchor.click();

    // Cleanup
    anchor.remove();
    web.URL.revokeObjectURL(url);
  } catch (e) {
    if (kDebugMode) debugPrint('Web download failed: $e');
  }
}
