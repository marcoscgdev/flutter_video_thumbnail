import 'package:flutter/foundation.dart';
import 'package:flutter_video_thumbnail/src/flutter_video_thumbnail_base.dart';
import 'package:flutter_video_thumbnail/src/flutter_video_thumbnail_web.dart';

class FlutterVideoThumbnail {
  static Future<Uint8List?> getThumbnail(
    String videoPath, {
    int quality = 80,
    bool useCache = true,
  }) async {
    if (!kIsWeb) {
      return FlutterVideoThumbnailBase.getThumbnail(
        videoPath,
        quality,
        useCache,
      );
    } else {
      return FlutterVideoThumbnailWeb.getThumbnail(videoPath, quality);
    }
  }
}
