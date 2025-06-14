library;

import 'dart:typed_data';

/// Stub implementation for web-specific thumbnail generation.
///
/// This class is used on non-web platforms to prevent compilation errors
/// by avoiding direct imports of web-only libraries like 'dart:html' or 'package:web'.
/// The actual web implementation is in `flutter_video_thumbnail_web.dart`.
class FlutterVideoThumbnailWeb {
  /// This is a stub method and should not be called on non-web platforms.
  /// It will throw an [UnsupportedError] if invoked.
  static Future<Uint8List?> getThumbnail(String videoPath, int quality) async {
    throw UnsupportedError(
      'FlutterVideoThumbnailWeb.getThumbnail should not be called on non-web platforms. This is a stub implementation.',
    );
  }
}
