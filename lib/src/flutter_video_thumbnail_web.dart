library;

import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

class FlutterVideoThumbnailWeb {
  static Future<Uint8List?> getThumbnail(String videoPath, int quality) async {
    final video =
        web.HTMLVideoElement()
          ..src = videoPath
          ..crossOrigin = 'anonymous'
          ..muted = true
          ..style.display = 'none';

    web.document.body?.append(video);

    try {
      await video.play().toDart;
      video.pause();

      final canvas = web.HTMLCanvasElement();
      canvas.width = video.videoWidth;
      canvas.height = video.videoHeight;

      canvas.context2D.drawImage(video, 0, 0, canvas.width, canvas.height);

      final completer = Completer<Uint8List>();
      canvas.toBlob(
        (web.Blob? blob) {
          final reader = web.FileReader();
          reader.onloadend =
              () {
                completer.complete(
                  (reader.result as JSArrayBuffer).toDart.asUint8List(),
                );
              }.toJS;
          reader.readAsArrayBuffer(blob!);
        }.toJS,
        'image/jpeg',
        (quality / 100).toJS,
      );

      return completer.future;
    } catch (e) {
      return null;
    } finally {
      video.remove();
    }
  }
}
