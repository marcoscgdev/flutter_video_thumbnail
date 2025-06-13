import AVFoundation
import Dispatch
import Flutter
import UIKit

public class FlutterVideoThumbnailPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "flutter_video_thumbnail", binaryMessenger: registrar.messenger())
    let instance = FlutterVideoThumbnailPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getVideoThumbnail":
      guard let args = call.arguments as? [String: Any],
        let videoPath = args["videoPath"] as? String,
        let imageQuality = args["quality"] as? Int
      else {
        result(
          FlutterError(
            code: "INVALID_ARGS",
            message: "Invalid arguments",
            details: nil))
        return
      }

      let url = URL(fileURLWithPath: videoPath)
      let asset = AVAsset(url: url)

      DispatchQueue.global().async {
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        let time = CMTime(seconds: 0.0, preferredTimescale: 600)
        let times = [NSValue(time: time)]
        imageGenerator.generateCGImagesAsynchronously(
          forTimes: times,
          completionHandler: { _, image, _, _, _ in
            if let cgImage = image,
              let data = UIImage(cgImage: cgImage).jpegData(
                compressionQuality: ((imageQuality ?? 80) / 100))
            {
              result(FlutterStandardTypedData(bytes: data))
            } else {
              result(
                FlutterError(
                  code: "NO_IMAGE",
                  message: "Could not generate image",
                  details: nil))
            }
          })
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
