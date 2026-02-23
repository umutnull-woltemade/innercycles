// InnerCycles - Cycle Position Widget (A++ Quality)
// Phase-based gradients, bilingual, deep link, rounded fonts

import WidgetKit
import SwiftUI

// MARK: - Timeline Provider

struct CyclePositionProvider: TimelineProvider {
    func placeholder(in context: Context) -> CyclePositionEntry {
        CyclePositionEntry(
            date: Date(),
            emotionalPhase: "Expansion",
            phaseEmoji: "\u{1F31F}",
            phaseLabel: "Expansion Phase",
            cycleDay: 5,
            cycleLength: 21
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (CyclePositionEntry) -> Void) {
        let entry = loadFromUserDefaults() ?? placeholder(in: context)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CyclePositionEntry>) -> Void) {
        let entry = loadFromUserDefaults() ?? placeholder(in: context)

        // Update every 6 hours
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 6, to: Date())!

        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    private func loadFromUserDefaults() -> CyclePositionEntry? {
        let sharedDefaults = UserDefaults(suiteName: "group.com.venusone.innercycles")

        guard let emotionalPhase = sharedDefaults?.string(forKey: "widget_emotional_phase"),
              let phaseEmoji = sharedDefaults?.string(forKey: "widget_phase_emoji"),
              let phaseLabel = sharedDefaults?.string(forKey: "widget_phase_label") else {
            return nil
        }

        let cycleDay = sharedDefaults?.integer(forKey: "widget_cycle_day") ?? 1
        let cycleLength = sharedDefaults?.integer(forKey: "widget_cycle_length") ?? 21

        return CyclePositionEntry(
            date: Date(),
            emotionalPhase: emotionalPhase,
            phaseEmoji: phaseEmoji,
            phaseLabel: phaseLabel,
            cycleDay: max(cycleDay, 1),
            cycleLength: max(cycleLength, 1)
        )
    }
}

// MARK: - Timeline Entry

struct CyclePositionEntry: TimelineEntry {
    let date: Date
    let emotionalPhase: String
    let phaseEmoji: String
    let phaseLabel: String
    let cycleDay: Int
    let cycleLength: Int

    var progress: Double {
        return min(Double(cycleDay) / Double(cycleLength), 1.0)
    }
}

// MARK: - Widget Views

struct CyclePositionWidgetEntryView: View {
    var entry: CyclePositionProvider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallCycleView(entry: entry)
        case .systemMedium:
            MediumCycleView(entry: entry)
        default:
            SmallCycleView(entry: entry)
        }
    }
}

// MARK: - Small View

struct SmallCycleView: View {
    let entry: CyclePositionEntry

    var body: some View {
        let gradientColors = MoodGradient.phaseGradient(entry.emotionalPhase)

        ZStack {
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: 8) {
                // Circular progress ring with emoji center
                ZStack {
                    // Background ring
                    Circle()
                        .stroke(Color.white.opacity(0.15), lineWidth: 5)
                        .frame(width: 72, height: 72)

                    // Progress ring
                    Circle()
                        .trim(from: 0, to: entry.progress)
                        .stroke(
                            WidgetColor.starGold,
                            style: StrokeStyle(lineWidth: 5, lineCap: .round)
                        )
                        .frame(width: 72, height: 72)
                        .rotationEffect(.degrees(-90))

                    // Phase emoji in center
                    Text(entry.phaseEmoji)
                        .font(.system(size: 28))
                }

                // Phase label
                Text(entry.phaseLabel)
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .padding()
        }
        .widgetContainerBackground(colors: gradientColors)
        .widgetURL(URL(string: "innercycles:///emotional-cycles"))
    }
}

// MARK: - Medium View

struct MediumCycleView: View {
    let entry: CyclePositionEntry
    private let strings = WidgetStrings()

    var body: some View {
        let gradientColors = MoodGradient.phaseGradient(entry.emotionalPhase)

        ZStack {
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            HStack(spacing: 20) {
                // Left: Circular progress ring
                ZStack {
                    // Background ring
                    Circle()
                        .stroke(Color.white.opacity(0.15), lineWidth: 6)
                        .frame(width: 90, height: 90)

                    // Progress ring
                    Circle()
                        .trim(from: 0, to: entry.progress)
                        .stroke(
                            WidgetColor.starGold,
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 90, height: 90)
                        .rotationEffect(.degrees(-90))

                    // Phase emoji in center
                    Text(entry.phaseEmoji)
                        .font(.system(size: 34))
                }

                // Right: Phase details
                VStack(alignment: .leading, spacing: 6) {
                    Text(strings.cyclePosition)
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(WidgetColor.starGold.opacity(0.8))

                    Text(entry.phaseLabel)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)

                    Text(strings.dayOf(entry.cycleDay, entry.cycleLength))
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))

                    Spacer()

                    // Progress percentage
                    HStack(spacing: 4) {
                        // Mini progress bar
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.white.opacity(0.15))
                                .frame(height: 4)

                            Capsule()
                                .fill(WidgetColor.starGold)
                                .frame(
                                    width: max(CGFloat(entry.progress) * 80, 4),
                                    height: 4
                                )
                        }
                        .frame(width: 80)

                        Text("\(Int(entry.progress * 100))%")
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                            .foregroundColor(WidgetColor.starGold)
                    }

                    Text(strings.appName)
                        .font(.system(size: 9, weight: .medium, design: .rounded))
                        .foregroundColor(WidgetColor.starGold.opacity(0.5))
                }
            }
            .padding()
        }
        .widgetContainerBackground(colors: gradientColors)
        .widgetURL(URL(string: "innercycles:///emotional-cycles"))
    }
}

// MARK: - Widget Configuration

struct CyclePositionWidget: Widget {
    let kind: String = "CyclePositionWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CyclePositionProvider()) { entry in
            CyclePositionWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Cycle Position")
        .description("See where you are in your emotional cycle.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Preview

struct CyclePositionWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CyclePositionWidgetEntryView(entry: CyclePositionEntry(
                date: Date(),
                emotionalPhase: "Expansion",
                phaseEmoji: "\u{1F31F}",
                phaseLabel: "Expansion Phase",
                cycleDay: 5,
                cycleLength: 21
            ))
            .previewContext(WidgetPreviewContext(family: .systemSmall))

            CyclePositionWidgetEntryView(entry: CyclePositionEntry(
                date: Date(),
                emotionalPhase: "Expansion",
                phaseEmoji: "\u{1F31F}",
                phaseLabel: "Expansion Phase",
                cycleDay: 5,
                cycleLength: 21
            ))
            .previewContext(WidgetPreviewContext(family: .systemMedium))

            CyclePositionWidgetEntryView(entry: CyclePositionEntry(
                date: Date(),
                emotionalPhase: "Reflection",
                phaseEmoji: "\u{1FA9E}",
                phaseLabel: "Reflection Phase",
                cycleDay: 14,
                cycleLength: 21
            ))
            .previewContext(WidgetPreviewContext(family: .systemSmall))

            CyclePositionWidgetEntryView(entry: CyclePositionEntry(
                date: Date(),
                emotionalPhase: "Recovery",
                phaseEmoji: "\u{1F331}",
                phaseLabel: "Recovery Phase",
                cycleDay: 19,
                cycleLength: 21
            ))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
