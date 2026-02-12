import Flutter
import UIKit
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Register Flutter plugins
    GeneratedPluginRegistrant.register(with: self)

    // Setup widget method channel
    setupWidgetChannel()

    // This must be called AFTER GeneratedPluginRegistrant for Firebase
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // MARK: - Widget Channel Setup

  private func setupWidgetChannel() {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      return
    }

    let widgetChannel = FlutterMethodChannel(
      name: "com.venusone.innercycles/widgets",
      binaryMessenger: controller.binaryMessenger
    )

    widgetChannel.setMethodCallHandler { [weak self] (call, result) in
      switch call.method {
      case "updateWidgetData":
        self?.handleUpdateWidgetData(call: call, result: result)
      case "reloadWidgets":
        self?.handleReloadWidgets(result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func handleUpdateWidgetData(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any] else {
      result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
      return
    }

    let sharedDefaults = UserDefaults(suiteName: "group.com.venusone.innercycles")

    // Store all provided data
    for (key, value) in args {
      sharedDefaults?.set(value, forKey: key)
    }

    sharedDefaults?.synchronize()

    // Reload widgets
    if #available(iOS 14.0, *) {
      WidgetCenter.shared.reloadAllTimelines()
    }

    result(true)
  }

  private func handleReloadWidgets(result: @escaping FlutterResult) {
    if #available(iOS 14.0, *) {
      WidgetCenter.shared.reloadAllTimelines()
      result(true)
    } else {
      result(false)
    }
  }

  // MARK: - Notification Handling

  // Handle notification when app is in foreground
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([[.banner, .sound, .badge]])
  }

  // Handle notification tap
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    completionHandler()
  }
}
