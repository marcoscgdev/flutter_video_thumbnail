package com.example.flutter_video_thumbnail

import android.graphics.Bitmap
import android.media.MediaMetadataRetriever
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.ByteArrayOutputStream
import kotlin.concurrent.thread

class FlutterVideoThumbnailPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_video_thumbnail")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getVideoThumbnail") {
      val videoPath = call.argument<String>("videoPath")
      val imageQuality = call.argument<Int?>("quality")
      if (videoPath != null) {
        thread {
          getVideoThumbnail(videoPath, imageQuality, result)
        }
      } else {
        result.error("INVALID_ARGUMENTS", "Video path not provided", null)
      }
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun getVideoThumbnail(videoPath: String, imageQuality: Int?, result: MethodChannel.Result) {
    try {
      val retriever = MediaMetadataRetriever()
      if (videoPath.startsWith("http")) {
        retriever.setDataSource(videoPath, mapOf())
      } else {
        retriever.setDataSource(videoPath)
      }
      val bitmap = retriever.frameAtTime
      if (bitmap != null) {
        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.JPEG, imageQuality ?: 80, stream)
        val byteArray = stream.toByteArray()
        result.success(byteArray)
      } else {
        result.error("NO_FRAME", "Could not extract frame from video", null)
      }
      retriever.release()
    } catch (e: Exception) {
      result.error("ERROR", "Failed to get thumbnail: ${e.message}", null)
    }
  }
}
