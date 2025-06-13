import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_video_thumbnail/flutter_video_thumbnail.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Uint8List? _thumbImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter Video Thumbnail')),
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: () => _getVideoThumbnail(),
                  child: Text("Get video thumbnail"),
                ),
                if (_isLoading) CircularProgressIndicator(),
                if (_thumbImage != null) Image.memory(_thumbImage!, width: 220),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getVideoThumbnail() async {
    final ImagePicker picker = ImagePicker();
    final XFile? galleryVideo = await picker.pickVideo(
      source: ImageSource.gallery,
    );

    setState(() {
      _isLoading = true;
    });

    Uint8List? thumb = await FlutterVideoThumbnail.getThumbnail(
      galleryVideo?.path ?? '',
      quality: 80, // Optional
    );

    setState(() {
      _isLoading = false;
      _thumbImage = thumb;
    });
  }
}
