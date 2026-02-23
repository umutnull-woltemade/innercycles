// InnerCycles - Mood Insight Widget (A++ Quality)
// Dynamic gradients, bilingual, sparkline, deep link, rounded fonts

import WidgetKit
import SwiftUI

// MARK: - Timeline Provider

struct MoodInsightProvider: TimelineProvider {
    func placeholder(in context: Context) -> MoodInsightEntry {
        MoodInsightEntry(
            date: Date(),
            currentMood: "Calm",
            moodEmoji: "😌",
            energyLevel: 75,
            advice: "You may find creative work and emotional connections rewarding",
            weekTrend: "Improving",
            moodHistory: [3, 4, 3, 4, 5, 4, 4]
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (MoodInsightEntry) -> Void) {
        let entry = loadFromUserDefaults() ?? placeholder(in: context)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MoodInsightEntry>) -> Void) {
        let entry = loadFromUserDefaults() ?? placeholder(in: context)

        // Update every 4 hours
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 4, to: Date())!

        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    private func loadFromUserDefaults() -> MoodInsightEntry? {
        let sharedDefaults = UserDefaults(suiteName: "group.com.venusone.innercycles")

        guard let currentMood = sharedDefaults?.string(forKey: "widget_current_mood"),
              let moodEmoji = sharedDefaults?.string(forKey: "widget_mood_emoji"),
              let advice = sharedDefaults?.string(forKey: "widget_mood_advice") else {
            return nil
        }

        let energyLevel = sharedDefaults?.integer(forKey: "widget_energy_level") ?? 50
        let weekTrend = sharedDefaults?.string(forKey: "widget_week_trend") ?? "Steady"
        let widgetData = WidgetData()

        return MoodInsightEntry(
            date: Date(),
            currentMood: currentMood,
            moodEmoji: moodEmoji,
            energyLevel: energyLevel,
            advice: advice,
            weekTrend: weekTrend,
            moodHistory: widgetData.moodHistory
        )
    }
}

// MARK: - Timeline Entry

struct MoodInsightEntry: TimelineEntry {
    let date: Date
    let currentMood: String
    let moodEmoji: String
    let energyLevel: Int // 0-100
    let advice: String
    let weekTrend: String
    let moodHistory: [Int] // 7-day history
}

// MARK: - Widget Views

struct MoodInsightWidgetEntryView: View {
    var entry: MoodInsightProvider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallMoodView(entry: entry)
        case .systemMedium:
            MediumMoodView(entry: entry)
        default:
            SmallMoodView(entry: entry)
        }
    }
}

struct SmallMoodView: View {
    let entry: MoodInsightEntry
    private let strings = WidgetStrings()

    var energyColor: Color {
        if entry.energyLevel >= 70 {
            return Color.green
        } else if entry.energyLevel >= 40 {
            return Color.orange
        } else {
            return Color.red.opacity(0.8)
        }
    }

    var gradientColors: [Color] {
        MoodGradient.colors(for: max(1, min(5, entry.energyLevel / 20)))
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(spacing: 10) {
                Text(entry.moodEmoji)
                    .font(.system(size: 36))

                Text(entry.currentMood)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))

                // Energy gauge
                VStack(spacing: 4) {
                    Text(strings.energy)
                        .font(.system(size: 9, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))

                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.2))
                            .frame(height: 6)

                        Capsule()
                            .fill(energyColor)
                            .frame(width: CGFloat(entry.energyLevel) * 0.6, height: 6)
                    }
                    .frame(width: 60)

                    Text("\(entry.energyLevel)%")
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundColor(energyColor)
                }
            }
            .padding()
        }
        .widgetContainerBackground(colors: gradientColors)
        .widgetURL(URL(string: "innercycles:///mood/trends"))
    }
}

struct MediumMoodView: View {
    let entry: MoodInsightEntry
    private let strings = WidgetStrings()

    var energyColor: Color {
        if entry.energyLevel >= 70 {
            return Color.green
        } else if entry.energyLevel >= 40 {
            return Color.orange
        } else {
            return Color.red.opacity(0.8)
        }
    }

    var gradientColors: [Color] {
        MoodGradient.colors(for: max(1, min(5, entry.energyLevel / 20)))
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .top,
                endPoint: .bottom
            )

            HStack(spacing: 20) {
                // Left: Mood & Energy
                VStack(spacing: 8) {
                    Text(entry.moodEmoji)
                        .font(.system(size: 44))

                    Text(entry.currentMood)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))

                    // Circular energy indicator
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 4)
                            .frame(width: 40, height: 40)

                        Circle()
                            .trim(from: 0, to: CGFloat(entry.energyLevel) / 100)
                            .stroke(energyColor, lineWidth: 4)
                            .frame(width: 40, height: 40)
                            .rotationEffect(.degrees(-90))

                        Text("\(entry.energyLevel)")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(energyColor)
                    }
                }
                .frame(width: 90)

                // Right: Insights + Sparkline
                VStack(alignment: .leading, spacing: 6) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(strings.weeklyTrend)
                            .font(.system(size: 10, design: .rounded))
                            .foregroundColor(WidgetColor.starGold.opacity(0.8))

                        Text(entry.weekTrend)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                    }

                    Text(entry.advice)
                        .font(.system(size: 11, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(2)

                    Spacer()

                    MoodSparklineView(values: entry.moodHistory, height: 24)

                    LastUpdatedView(strings: strings)
                }
            }
            .padding()
        }
        .widgetContainerBackground(colors: gradientColors)
        .widgetURL(URL(string: "innercycles:///mood/trends"))
    }
}

// MARK: - Widget Configuration

struct MoodInsightWidget: Widget {
    let kind: String = "MoodInsightWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MoodInsightProvider()) { entry in
            MoodInsightWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Mood Insight")
        .description("Track your mood trends and energy levels.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Preview

struct MoodInsightWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MoodInsightWidgetEntryView(entry: MoodInsightEntry(
                date: Date(),
                currentMood: "Calm",
                moodEmoji: "😌",
                energyLevel: 85,
                advice: "You may find creative work and deep reflection rewarding",
                weekTrend: "Improving",
                moodHistory: [3, 4, 2, 5, 4, 3, 4]
            ))
            .previewContext(WidgetPreviewContext(family: .systemSmall))

            MoodInsightWidgetEntryView(entry: MoodInsightEntry(
                date: Date(),
                currentMood: "Calm",
                moodEmoji: "😌",
                energyLevel: 85,
                advice: "You may find creative work and deep reflection rewarding",
                weekTrend: "Improving",
                moodHistory: [3, 4, 2, 5, 4, 3, 4]
            ))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
