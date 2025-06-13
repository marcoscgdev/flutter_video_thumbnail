import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class FlutterVideoThumbnail {
  static const MethodChannel _channel = MethodChannel(
    'flutter_video_thumbnail',
  );

  static Future<Uint8List?> getThumbnail(
    String videoPath, {
    int quality = 80,
    bool useCache = true,
  }) async {
    if (useCache && videoPath.startsWith('http')) {
      return _getCachedThumbnail(videoPath, quality);
    }

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

  static Future<Uint8List?> _getCachedThumbnail(
    String videoPath,
    int quality,
  ) async {
    final key = '${videoPath}_$quality';
    final file = await DefaultCacheManager().getFileFromCache(key);

    if (file != null) return file.file.readAsBytes();

    final thumb = await getThumbnail(
      videoPath,
      quality: quality,
      useCache: false,
    );

    if (thumb != null) {
      await DefaultCacheManager().putFile(videoPath, thumb, key: key);
    }

    return thumb;
  }
}
