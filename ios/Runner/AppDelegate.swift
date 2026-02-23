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

    // Setup notification delegate
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
      case "getWidgetData":
        self?.handleGetWidgetData(call: call, result: result)
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

    // Targeted widget reload based on which keys changed
    if #available(iOS 14.0, *) {
      let keys = Set(args.keys)
      reloadAffectedWidgets(keys: keys)
    }

    result(true)
  }

  private func handleGetWidgetData(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
          let keys = args["keys"] as? [String] else {
      result(FlutterError(code: "INVALID_ARGS", message: "Expected 'keys' array", details: nil))
      return
    }

    let sharedDefaults = UserDefaults(suiteName: "group.com.venusone.innercycles")
    var data: [String: Any] = [:]

    for key in keys {
      if let value = sharedDefaults?.object(forKey: key) {
        data[key] = value
      }
    }

    result(data)
  }

  private func handleReloadWidgets(result: @escaping FlutterResult) {
    if #available(iOS 14.0, *) {
      WidgetCenter.shared.reloadAllTimelines()
      result(true)
    } else {
      result(false)
    }
  }

  // MARK: - Targeted Widget Reload

  @available(iOS 14.0, *)
  private func reloadAffectedWidgets(keys: Set<String>) {
    let reflectionKeys: Set<String> = ["widget_mood_emoji", "widget_mood_label", "widget_daily_prompt",
                                        "widget_focus_area", "widget_streak_days", "widget_mood_rating"]
    let moodKeys: Set<String> = ["widget_current_mood", "widget_mood_emoji", "widget_mood_advice",
                                  "widget_energy_level", "widget_week_trend"]
    let cycleKeys: Set<String> = ["widget_emotional_phase", "widget_phase_emoji", "widget_phase_label",
                                   "widget_cycle_day", "widget_cycle_length"]
    let lockKeys: Set<String> = ["widget_mood_emoji", "widget_accent_emoji", "widget_short_message",
                                  "widget_lock_energy"]
    let weeklyKeys: Set<String> = ["widget_mood_history_7d", "widget_mood_history_emojis_7d",
                                    "widget_mood_history_dates_7d", "widget_streak_days"]
    let metaKeys: Set<String> = ["widget_language", "widget_last_updated"]

    var reloaded = Set<String>()

    if !keys.isDisjoint(with: reflectionKeys) || !keys.isDisjoint(with: metaKeys) {
      WidgetCenter.shared.reloadTimelines(ofKind: "DailyReflectionWidget")
      reloaded.insert("DailyReflectionWidget")
    }
    if !keys.isDisjoint(with: moodKeys) || !keys.isDisjoint(with: metaKeys) {
      WidgetCenter.shared.reloadTimelines(ofKind: "MoodInsightWidget")
      reloaded.insert("MoodInsightWidget")
    }
    if !keys.isDisjoint(with: cycleKeys) || !keys.isDisjoint(with: metaKeys) {
      WidgetCenter.shared.reloadTimelines(ofKind: "CyclePositionWidget")
      reloaded.insert("CyclePositionWidget")
    }
    if !keys.isDisjoint(with: lockKeys) {
      WidgetCenter.shared.reloadTimelines(ofKind: "LockScreenWidget")
      reloaded.insert("LockScreenWidget")
    }
    if !keys.isDisjoint(with: weeklyKeys) || !keys.isDisjoint(with: metaKeys) {
      WidgetCenter.shared.reloadTimelines(ofKind: "WeeklyMoodGridWidget")
      reloaded.insert("WeeklyMoodGridWidget")
    }

    // Fallback: if no specific match, reload all
    if reloaded.isEmpty {
      WidgetCenter.shared.reloadAllTimelines()
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
