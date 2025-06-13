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
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () => _getLocalVideoThumbnail(),
                    child: Text("Get local video thumbnail"),
                  ),
                  FilledButton(
                    onPressed: () => _getNetworkVideoThumbnail(),
                    child: Text("Get network video thumbnail"),
                  ),
                  if (_isLoading) CircularProgressIndicator(),
                  if (_thumbImage != null)
                    Image.memory(_thumbImage!, width: 220),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _getLocalVideoThumbnail() async {
    final XFile? galleryVideo = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );

    _showLoading();

    Uint8List? thumb = await FlutterVideoThumbnail.getThumbnail(
      galleryVideo?.path ?? '',
      quality: 80, // Optional
    );

    setState(() {
      _thumbImage = thumb;
    });

    _hideLoading();
  }

  _getNetworkVideoThumbnail() async {
    _showLoading();

    Uint8List? thumb = await FlutterVideoThumbnail.getThumbnail(
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      quality: 80, // Optional
    );

    setState(() {
      _thumbImage = thumb;
    });

    _hideLoading();
  }

  _showLoading() {
    setState(() {
      _thumbImage = null;
      _isLoading = true;
    });
  }

  _hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }
}
