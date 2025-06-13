import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FlutterVideoThumbnail {
  static const MethodChannel _channel = MethodChannel(
    'flutter_video_thumbnail',
  );

  static Future<Uint8List?> getThumbnail(
    String videoPath, {
    int quality = 80,
  }) async {
    try {
      final bytes = await _channel.invokeMethod('getVideoThumbnail', {
        'videoPath': videoPath,
        'quality': quality,
      });
      return bytes;
    } on PlatformException catch (e) {
      debugPrint("Failed to get thumbnail: '${e.message}'.");
      return null;
    }
  }
}
