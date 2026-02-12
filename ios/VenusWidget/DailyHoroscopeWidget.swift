// InnerCycles - Daily Reflection Widget
// Displays daily mood and reflection prompt on Home Screen

import WidgetKit
import SwiftUI

// MARK: - Timeline Provider

struct DailyReflectionProvider: TimelineProvider {
    func placeholder(in context: Context) -> DailyReflectionEntry {
        DailyReflectionEntry(
            date: Date(),
            moodEmoji: "😊",
            moodLabel: "Good",
            dailyPrompt: "What are you grateful for today?",
            streakDays: 7,
            focusArea: "Emotional Wellness",
            moodRating: 4
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (DailyReflectionEntry) -> Void) {
        let entry = loadFromUserDefaults() ?? placeholder(in: context)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DailyReflectionEntry>) -> Void) {
        let entry = loadFromUserDefaults() ?? placeholder(in: context)

        // Update at midnight for fresh daily content
        let calendar = Calendar.current
        let tomorrow = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)

        let timeline = Timeline(entries: [entry], policy: .after(tomorrow))
        completion(timeline)
    }

    private func loadFromUserDefaults() -> DailyReflectionEntry? {
        let sharedDefaults = UserDefaults(suiteName: "group.com.venusone.innercycles")

        guard let moodEmoji = sharedDefaults?.string(forKey: "widget_mood_emoji"),
              let moodLabel = sharedDefaults?.string(forKey: "widget_mood_label"),
              let dailyPrompt = sharedDefaults?.string(forKey: "widget_daily_prompt"),
              let focusArea = sharedDefaults?.string(forKey: "widget_focus_area") else {
            return nil
        }

        let streakDays = sharedDefaults?.integer(forKey: "widget_streak_days") ?? 0
        let moodRating = sharedDefaults?.integer(forKey: "widget_mood_rating") ?? 3

        return DailyReflectionEntry(
            date: Date(),
            moodEmoji: moodEmoji,
            moodLabel: moodLabel,
            dailyPrompt: dailyPrompt,
            streakDays: streakDays,
            focusArea: focusArea,
            moodRating: moodRating
        )
    }
}

// MARK: - Timeline Entry

struct DailyReflectionEntry: TimelineEntry {
    let date: Date
    let moodEmoji: String
    let moodLabel: String
    let dailyPrompt: String
    let streakDays: Int
    let focusArea: String
    let moodRating: Int // 1-5
}

// MARK: - Widget Views

struct DailyReflectionWidgetEntryView: View {
    var entry: DailyReflectionProvider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallReflectionView(entry: entry)
        case .systemMedium:
            MediumReflectionView(entry: entry)
        case .systemLarge:
            LargeReflectionView(entry: entry)
        default:
            SmallReflectionView(entry: entry)
        }
    }
}

struct SmallReflectionView: View {
    let entry: DailyReflectionEntry

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.1),
                    Color(red: 0.1, green: 0.05, blue: 0.15)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: 8) {
                Text(entry.moodEmoji)
                    .font(.system(size: 36))

                Text(entry.moodLabel)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)

                // Mood dots
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { index in
                        Circle()
                            .fill(index <= entry.moodRating ? Color(red: 1.0, green: 0.84, blue: 0.0) : Color.white.opacity(0.3))
                            .frame(width: 6, height: 6)
                    }
                }

                if entry.streakDays > 0 {
                    Text("\(entry.streakDays) day streak")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding()
        }
    }
}

struct MediumReflectionView: View {
    let entry: DailyReflectionEntry

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.1),
                    Color(red: 0.1, green: 0.05, blue: 0.15)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            HStack(spacing: 16) {
                // Left: Mood info
                VStack(spacing: 8) {
                    Text(entry.moodEmoji)
                        .font(.system(size: 44))

                    Text(entry.moodLabel)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)

                    Text(entry.focusArea)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))

                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { index in
                            Circle()
                                .fill(index <= entry.moodRating ? Color(red: 1.0, green: 0.84, blue: 0.0) : Color.white.opacity(0.3))
                                .frame(width: 6, height: 6)
                        }
                    }
                }
                .frame(width: 80)

                // Right: Daily prompt
                VStack(alignment: .leading, spacing: 8) {
                    Text("Today's Reflection")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 1.0, green: 0.84, blue: 0.0))

                    Text(entry.dailyPrompt)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(4)
                        .multilineTextAlignment(.leading)

                    Spacer()

                    HStack {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 10))
                        Text("\(entry.streakDays) day streak")
                            .font(.system(size: 11))
                    }
                    .foregroundColor(.white.opacity(0.6))
                }
            }
            .padding()
        }
    }
}

struct LargeReflectionView: View {
    let entry: DailyReflectionEntry

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.1),
                    Color(red: 0.1, green: 0.05, blue: 0.15),
                    Color(red: 0.08, green: 0.03, blue: 0.12)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: 16) {
                // Header
                HStack {
                    Text(entry.moodEmoji)
                        .font(.system(size: 48))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.moodLabel)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)

                        Text(entry.focusArea)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.6))
                    }

                    Spacer()

                    // Mood indicator
                    VStack(spacing: 4) {
                        Text("Mood")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.5))
                        HStack(spacing: 2) {
                            ForEach(1...5, id: \.self) { index in
                                Circle()
                                    .fill(index <= entry.moodRating ? Color(red: 1.0, green: 0.84, blue: 0.0) : Color.white.opacity(0.3))
                                    .frame(width: 8, height: 8)
                            }
                        }
                    }
                }

                Divider()
                    .background(Color.white.opacity(0.2))

                // Main prompt
                VStack(alignment: .leading, spacing: 8) {
                    Text("Daily Reflection Prompt")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 1.0, green: 0.84, blue: 0.0))

                    Text(entry.dailyPrompt)
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(6)
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                // Footer
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                        Text("\(entry.streakDays) day streak")
                    }
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))

                    Spacer()

                    Text("InnerCycles")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(Color(red: 1.0, green: 0.84, blue: 0.0).opacity(0.6))
                }
            }
            .padding()
        }
    }
}

// MARK: - Widget Configuration

struct DailyReflectionWidget: Widget {
    let kind: String = "DailyReflectionWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DailyReflectionProvider()) { entry in
            DailyReflectionWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Daily Reflection")
        .description("Your daily mood and reflection prompt at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Preview

struct DailyReflectionWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DailyReflectionWidgetEntryView(entry: DailyReflectionEntry(
                date: Date(),
                moodEmoji: "😊",
                moodLabel: "Good",
                dailyPrompt: "What brought you joy today? Take a moment to notice the small things that made your day better.",
                streakDays: 14,
                focusArea: "Emotional Wellness",
                moodRating: 4
            ))
            .previewContext(WidgetPreviewContext(family: .systemSmall))

            DailyReflectionWidgetEntryView(entry: DailyReflectionEntry(
                date: Date(),
                moodEmoji: "😊",
                moodLabel: "Good",
                dailyPrompt: "What brought you joy today? Take a moment to notice the small things that made your day better.",
                streakDays: 14,
                focusArea: "Emotional Wellness",
                moodRating: 4
            ))
            .previewContext(WidgetPreviewContext(family: .systemMedium))

            DailyReflectionWidgetEntryView(entry: DailyReflectionEntry(
                date: Date(),
                moodEmoji: "😊",
                moodLabel: "Good",
                dailyPrompt: "What brought you joy today? Take a moment to notice the small things that made your day better. Reflecting on positive moments helps build emotional resilience.",
                streakDays: 14,
                focusArea: "Emotional Wellness",
                moodRating: 4
            ))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
