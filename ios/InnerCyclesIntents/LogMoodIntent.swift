// InnerCycles - Siri Shortcuts & Widget Intents
// LogMoodIntent: "Hey Siri, log my mood in InnerCycles"
// QuickMoodIntent: Interactive widget button (iOS 17+)

import AppIntents
import Foundation
import WidgetKit

@available(iOS 16.0, *)
enum MoodLevel: String, AppEnum {
    case difficult = "difficult"
    case low = "low"
    case neutral = "neutral"
    case good = "good"
    case great = "great"

    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Mood Level")

    static var caseDisplayRepresentations: [MoodLevel: DisplayRepresentation] = [
        .difficult: DisplayRepresentation(title: "\u{1F614} Difficult", subtitle: "Rating: 1/5"),
        .low: DisplayRepresentation(title: "\u{1F615} Low", subtitle: "Rating: 2/5"),
        .neutral: DisplayRepresentation(title: "\u{1F610} Neutral", subtitle: "Rating: 3/5"),
        .good: DisplayRepresentation(title: "\u{1F60A} Good", subtitle: "Rating: 4/5"),
        .great: DisplayRepresentation(title: "\u{1F929} Great", subtitle: "Rating: 5/5"),
    ]

    var emoji: String {
        switch self {
        case .difficult: return "\u{1F614}"
        case .low: return "\u{1F615}"
        case .neutral: return "\u{1F610}"
        case .good: return "\u{1F60A}"
        case .great: return "\u{1F929}"
        }
    }

    var rating: Int {
        switch self {
        case .difficult: return 1
        case .low: return 2
        case .neutral: return 3
        case .good: return 4
        case .great: return 5
        }
    }
}

// MARK: - Siri Shortcuts Intent

@available(iOS 16.0, *)
struct LogMoodIntent: AppIntent {
    static var title: LocalizedStringResource = "Log Mood"
    static var description = IntentDescription("Quickly log your current mood in InnerCycles")

    @Parameter(title: "Mood")
    var mood: MoodLevel

    static var parameterSummary: some ParameterSummary {
        Summary("Log mood as \(\.$mood)")
    }

    func perform() async throws -> some IntentResult & ProvidesDialog {
        let defaults = UserDefaults(suiteName: "group.com.venusone.innercycles")

        defaults?.set(mood.emoji, forKey: "widget_mood_emoji")
        defaults?.set(mood.rawValue.capitalized, forKey: "widget_mood_label")
        defaults?.set(mood.rating, forKey: "widget_mood_rating")
        defaults?.set(Date().timeIntervalSince1970, forKey: "watch_mood_timestamp")
        defaults?.synchronize()

        return .result(dialog: "Logged: \(mood.emoji) \(mood.rawValue.capitalized)")
    }
}

// MARK: - Quick Mood Intent (iOS 17+ Widget Interactive Button)

@available(iOS 17.0, *)
struct QuickMoodIntent: AppIntent {
    static var title: LocalizedStringResource = "Quick Mood Log"
    static var description = IntentDescription("Log mood directly from widget")
    static var isDiscoverable: Bool = false

    @Parameter(title: "Mood Emoji")
    var moodValue: String

    init() {
        self.moodValue = "\u{1F610}" // default neutral
    }

    init(moodValue: String) {
        self.moodValue = moodValue
    }

    func perform() async throws -> some IntentResult {
        let defaults = UserDefaults(suiteName: "group.com.venusone.innercycles")

        // Map emoji to rating and label
        let (rating, label) = emojiToRatingLabel(moodValue)

        defaults?.set(moodValue, forKey: "widget_mood_emoji")
        defaults?.set(label, forKey: "widget_mood_label")
        defaults?.set(rating, forKey: "widget_mood_rating")
        defaults?.set(Date().timeIntervalSince1970, forKey: "widget_last_updated")
        defaults?.synchronize()

        // Reload all widget timelines
        WidgetCenter.shared.reloadAllTimelines()

        return .result()
    }

    private func emojiToRatingLabel(_ emoji: String) -> (Int, String) {
        switch emoji {
        case "\u{1F614}", "\u{1F622}": return (1, "Difficult")
        case "\u{1F615}": return (2, "Low")
        case "\u{1F610}": return (3, "Neutral")
        case "\u{1F60A}": return (4, "Good")
        case "\u{1F929}", "\u{1F31F}": return (5, "Great")
        default: return (3, "Neutral")
        }
    }
}

// MARK: - Shortcuts Provider

@available(iOS 16.0, *)
struct InnerCyclesShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: LogMoodIntent(),
            phrases: [
                "Log my mood in \(.applicationName)",
                "How do I feel in \(.applicationName)",
                "Record mood in \(.applicationName)",
            ],
            shortTitle: "Log Mood",
            systemImageName: "heart.circle"
        )
    }
}
