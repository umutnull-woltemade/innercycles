// InnerCycles - Siri Shortcuts: Log Mood Intent
// "Hey Siri, log my mood in InnerCycles"

import AppIntents
import Foundation

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
