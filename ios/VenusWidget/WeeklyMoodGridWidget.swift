// InnerCycles - Weekly Mood Grid Widget
// 7-day emoji grid with sparkline and streak display

import WidgetKit
import SwiftUI

// MARK: - Timeline Provider

struct WeeklyMoodGridProvider: TimelineProvider {
    func placeholder(in context: Context) -> WeeklyMoodGridEntry {
        WeeklyMoodGridEntry(
            date: Date(),
            moodHistory: [3, 4, 2, 5, 4, 3, 4],
            moodEmojis: ["😐", "😊", "😕", "🤩", "😊", "😐", "😊"],
            dayLabels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
            streakDays: 7
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (WeeklyMoodGridEntry) -> Void) {
        let entry = loadFromUserDefaults() ?? placeholder(in: context)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WeeklyMoodGridEntry>) -> Void) {
        let entry = loadFromUserDefaults() ?? placeholder(in: context)

        // Update at midnight
        let calendar = Calendar.current
        let tomorrow = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)

        let timeline = Timeline(entries: [entry], policy: .after(tomorrow))
        completion(timeline)
    }

    private func loadFromUserDefaults() -> WeeklyMoodGridEntry? {
        let widgetData = WidgetData()
        let defaults = UserDefaults(suiteName: "group.com.venusone.innercycles")

        // Check if we have any data
        guard defaults?.string(forKey: "widget_mood_history_7d") != nil else {
            return nil
        }

        return WeeklyMoodGridEntry(
            date: Date(),
            moodHistory: widgetData.moodHistory,
            moodEmojis: widgetData.moodEmojis,
            dayLabels: widgetData.dayLabels,
            streakDays: widgetData.streakDays
        )
    }
}

// MARK: - Timeline Entry

struct WeeklyMoodGridEntry: TimelineEntry {
    let date: Date
    let moodHistory: [Int]       // 7 mood values (1-5)
    let moodEmojis: [String]     // 7 emoji strings
    let dayLabels: [String]      // 7 day abbreviations
    let streakDays: Int

    var averageMood: Int {
        let sum = moodHistory.reduce(0, +)
        return max(1, min(5, sum / max(moodHistory.count, 1)))
    }
}

// MARK: - Widget Views

struct WeeklyMoodGridWidgetEntryView: View {
    var entry: WeeklyMoodGridProvider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWeeklyGridView(entry: entry)
        case .systemMedium:
            MediumWeeklyGridView(entry: entry)
        default:
            SmallWeeklyGridView(entry: entry)
        }
    }
}

// MARK: - Small View

struct SmallWeeklyGridView: View {
    let entry: WeeklyMoodGridEntry
    private let strings = WidgetStrings()

    var body: some View {
        let gradientColors = MoodGradient.colors(for: entry.averageMood)

        ZStack {
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: 6) {
                // Title
                Text(strings.weeklyMood)
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundColor(WidgetColor.starGold)

                // 7-column emoji grid
                HStack(spacing: 4) {
                    ForEach(0..<7, id: \.self) { i in
                        VStack(spacing: 3) {
                            Text(entry.dayLabels[i].prefix(1).uppercased())
                                .font(.system(size: 8, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.5))

                            Text(entry.moodEmojis[i])
                                .font(.system(size: 16))

                            // Color dot
                            Circle()
                                .fill(moodDotColor(entry.moodHistory[i]))
                                .frame(width: 5, height: 5)
                        }
                    }
                }

                // Streak
                if entry.streakDays > 0 {
                    HStack(spacing: 3) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 9))
                        Text(strings.streakText(entry.streakDays))
                            .font(.system(size: 9, design: .rounded))
                    }
                    .foregroundColor(.white.opacity(0.6))
                }
            }
            .padding(10)
        }
        .widgetContainerBackground(colors: gradientColors)
        .widgetURL(URL(string: "innercycles:///journal/patterns"))
    }

    private func moodDotColor(_ rating: Int) -> Color {
        switch rating {
        case 1: return Color(red: 0.4, green: 0.3, blue: 0.7)
        case 2: return WidgetColor.amethyst.opacity(0.7)
        case 3: return WidgetColor.celestialGold.opacity(0.6)
        case 4: return WidgetColor.auroraStart
        case 5: return WidgetColor.sunriseStart.opacity(0.8)
        default: return Color.white.opacity(0.3)
        }
    }
}

// MARK: - Medium View

struct MediumWeeklyGridView: View {
    let entry: WeeklyMoodGridEntry
    private let strings = WidgetStrings()

    var body: some View {
        let gradientColors = MoodGradient.colors(for: entry.averageMood)

        ZStack {
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            HStack(spacing: 16) {
                // Left: 7-column emoji grid (larger)
                VStack(spacing: 4) {
                    Text(strings.weeklyMood)
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundColor(WidgetColor.starGold)

                    HStack(spacing: 6) {
                        ForEach(0..<7, id: \.self) { i in
                            VStack(spacing: 3) {
                                Text(entry.dayLabels[i].prefix(2).uppercased())
                                    .font(.system(size: 8, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.5))

                                Text(entry.moodEmojis[i])
                                    .font(.system(size: 20))

                                // Color dot
                                Circle()
                                    .fill(moodDotColor(entry.moodHistory[i]))
                                    .frame(width: 6, height: 6)
                            }
                        }
                    }
                }

                // Right: Sparkline + streak + last updated
                VStack(alignment: .leading, spacing: 8) {
                    Text(strings.weeklyTrend)
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(WidgetColor.starGold.opacity(0.8))

                    MoodSparklineView(values: entry.moodHistory, height: 36)

                    Spacer()

                    if entry.streakDays > 0 {
                        HStack(spacing: 3) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 10))
                            Text(strings.streakText(entry.streakDays))
                                .font(.system(size: 10, design: .rounded))
                        }
                        .foregroundColor(.white.opacity(0.6))
                    }

                    LastUpdatedView(strings: strings)
                }
                .frame(minWidth: 80)
            }
            .padding()
        }
        .widgetContainerBackground(colors: gradientColors)
        .widgetURL(URL(string: "innercycles:///journal/patterns"))
    }

    private func moodDotColor(_ rating: Int) -> Color {
        switch rating {
        case 1: return Color(red: 0.4, green: 0.3, blue: 0.7)
        case 2: return WidgetColor.amethyst.opacity(0.7)
        case 3: return WidgetColor.celestialGold.opacity(0.6)
        case 4: return WidgetColor.auroraStart
        case 5: return WidgetColor.sunriseStart.opacity(0.8)
        default: return Color.white.opacity(0.3)
        }
    }
}

// MARK: - Widget Configuration

struct WeeklyMoodGridWidget: Widget {
    let kind: String = "WeeklyMoodGridWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WeeklyMoodGridProvider()) { entry in
            WeeklyMoodGridWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Weekly Mood")
        .description("See your mood patterns over the past week.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Preview

struct WeeklyMoodGridWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WeeklyMoodGridWidgetEntryView(entry: WeeklyMoodGridEntry(
                date: Date(),
                moodHistory: [3, 4, 2, 5, 4, 3, 4],
                moodEmojis: ["😐", "😊", "😕", "🤩", "😊", "😐", "😊"],
                dayLabels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
                streakDays: 7
            ))
            .previewContext(WidgetPreviewContext(family: .systemSmall))

            WeeklyMoodGridWidgetEntryView(entry: WeeklyMoodGridEntry(
                date: Date(),
                moodHistory: [3, 4, 2, 5, 4, 3, 4],
                moodEmojis: ["😐", "😊", "😕", "🤩", "😊", "😐", "😊"],
                dayLabels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
                streakDays: 14
            ))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
