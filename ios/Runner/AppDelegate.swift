import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "sample_time_zone_flutter_channel", binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        if (call.method == "get_native_time_zone") {
            let timezone = TimeZone.current
            let timezoneName = timezone.identifier
            let offsetFromUtc = timezone.secondsFromGMT()
            let resultMap: [String: Any] = ["timezone": timezoneName, "gmt_offset": offsetFromUtc]
            result(resultMap)
        }
    })
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
