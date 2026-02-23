// InnerCycles - Lock Screen Widgets (iOS 16+) (A++ Quality)
// Deep link, bilingual, StandBy mode support

import WidgetKit
import SwiftUI

// MARK: - Lock Screen Provider

@available(iOSApplicationExtension 16.0, *)
struct LockScreenProvider: TimelineProvider {
    func placeholder(in context: Context) -> LockScreenEntry {
        LockScreenEntry(
            date: Date(),
            moodEmoji: "😊",
            accentEmoji: "✨",
            shortMessage: "Reflect on what matters",
            energyLevel: 4 // 1-5 scale for lock screen
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (LockScreenEntry) -> Void) {
        let entry = loadFromUserDefaults() ?? placeholder(in: context)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<LockScreenEntry>) -> Void) {
        let entry = loadFromUserDefaults() ?? placeholder(in: context)

        // Update at midnight
        let calendar = Calendar.current
        let tomorrow = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)

        let timeline = Timeline(entries: [entry], policy: .after(tomorrow))
        completion(timeline)
    }

    private func loadFromUserDefaults() -> LockScreenEntry? {
        let sharedDefaults = UserDefaults(suiteName: "group.com.venusone.innercycles")

        guard let moodEmoji = sharedDefaults?.string(forKey: "widget_mood_emoji"),
              let accentEmoji = sharedDefaults?.string(forKey: "widget_accent_emoji"),
              let shortMessage = sharedDefaults?.string(forKey: "widget_short_message") else {
            return nil
        }

        let energyLevel = sharedDefaults?.integer(forKey: "widget_lock_energy") ?? 3

        return LockScreenEntry(
            date: Date(),
            moodEmoji: moodEmoji,
            accentEmoji: accentEmoji,
            shortMessage: shortMessage,
            energyLevel: energyLevel
        )
    }
}

// MARK: - Lock Screen Entry

struct LockScreenEntry: TimelineEntry {
    let date: Date
    let moodEmoji: String
    let accentEmoji: String
    let shortMessage: String
    let energyLevel: Int // 1-5
}

// MARK: - Lock Screen Views

@available(iOSApplicationExtension 16.0, *)
struct LockScreenWidgetEntryView: View {
    var entry: LockScreenProvider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .accessoryCircular:
            CircularLockScreenView(entry: entry)
        case .accessoryRectangular:
            RectangularLockScreenView(entry: entry)
        case .accessoryInline:
            InlineLockScreenView(entry: entry)
        default:
            CircularLockScreenView(entry: entry)
        }
    }
}

@available(iOSApplicationExtension 16.0, *)
struct CircularLockScreenView: View {
    let entry: LockScreenEntry

    var body: some View {
        ZStack {
            AccessoryWidgetBackground()

            VStack(spacing: 2) {
                Text(entry.moodEmoji)
                    .font(.system(size: 20))

                // Energy dots
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { index in
                        Circle()
                            .fill(index <= entry.energyLevel ? Color.white : Color.white.opacity(0.3))
                            .frame(width: 4, height: 4)
                    }
                }
            }
        }
        .widgetURL(URL(string: "innercycles:///today"))
    }
}

@available(iOSApplicationExtension 16.0, *)
struct RectangularLockScreenView: View {
    let entry: LockScreenEntry

    var body: some View {
        HStack(spacing: 8) {
            VStack(spacing: 2) {
                Text(entry.moodEmoji)
                    .font(.system(size: 24))
                Text(entry.accentEmoji)
                    .font(.system(size: 14))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(entry.shortMessage)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .lineLimit(2)

                // Energy indicator
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= entry.energyLevel ? "star.fill" : "star")
                            .font(.system(size: 8))
                    }
                }
            }
        }
        .widgetURL(URL(string: "innercycles:///today"))
    }
}

@available(iOSApplicationExtension 16.0, *)
struct InlineLockScreenView: View {
    let entry: LockScreenEntry

    var body: some View {
        HStack(spacing: 4) {
            Text(entry.moodEmoji)
            Text(entry.shortMessage)
                .lineLimit(1)
        }
        .widgetURL(URL(string: "innercycles:///today"))
    }
}

// MARK: - Widget Configuration

@available(iOSApplicationExtension 16.0, *)
struct LockScreenWidget: Widget {
    let kind: String = "LockScreenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LockScreenProvider()) { entry in
            LockScreenWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Quick Glance")
        .description("Your mood and reflection at a glance.")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

// MARK: - Preview

@available(iOSApplicationExtension 16.0, *)
struct LockScreenWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LockScreenWidgetEntryView(entry: LockScreenEntry(
                date: Date(),
                moodEmoji: "😊",
                accentEmoji: "✨",
                shortMessage: "Reflect on what matters today",
                energyLevel: 4
            ))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))

            LockScreenWidgetEntryView(entry: LockScreenEntry(
                date: Date(),
                moodEmoji: "😊",
                accentEmoji: "✨",
                shortMessage: "Reflect on what matters today",
                energyLevel: 4
            ))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))

            LockScreenWidgetEntryView(entry: LockScreenEntry(
                date: Date(),
                moodEmoji: "😊",
                accentEmoji: "✨",
                shortMessage: "Reflect on what matters",
                energyLevel: 4
            ))
            .previewContext(WidgetPreviewContext(family: .accessoryInline))
        }
    }
}
