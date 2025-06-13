# flutter_video_thumbnail

A Flutter plugin to generate thumbnails from video files. Supports both local and network videos on Android and iOS.

## Features

*   Generate thumbnails from local video files.
*   Generate thumbnails from network video URLs.
*   Specify thumbnail quality.
*   Supports Android and iOS.

## Getting Started

### Installation

Add `flutter_video_thumbnail` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_video_thumbnail: ^latest_version # Replace with the latest version
```

Then, run `flutter pub get`.

### Import

Import the package in your Dart code:

```dart
import 'package:flutter_video_thumbnail/flutter_video_thumbnail.dart';
import 'dart:typed_data'; // For Uint8List
```

## Usage

Use the `FlutterVideoThumbnail.getThumbnail` method to generate a thumbnail.

```dart
Future<Uint8List?> getVideoThumbnail(String videoUrlOrPath) async {
  final Uint8List? thumbnailBytes = await FlutterVideoThumbnail.getThumbnail(
    videoUrlOrPath,
    quality: 80, // Optional: Quality of the thumbnail (0-100, default 80)
  );
  return thumbnailBytes;
}

// To display the thumbnail (e.g., in an Image widget):
if (networkThumbnail != null) {
  Image.memory(networkThumbnail);
}
```

For a more complete example, please see the `example` directory in this plugin.

## API

### `static Future<Uint8List?> getThumbnail(String videoPath, {int quality = 80})`

*   `videoPath` (String, required): The path to the local video file or the URL of a network video.
*   `quality` (int, optional): The quality of the generated thumbnail, an integer between 0 and 100. Defaults to `80`.

Returns a `Future<Uint8List?>` which is the byte data of the thumbnail image, or `null` if thumbnail generation fails.

## License

This project is licensed under the Apache License 2.0 - see the LICENSE.md file for details.
