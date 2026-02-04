// Venus One - Daily Horoscope Widget
// Displays personalized daily horoscope on Home Screen

import WidgetKit
import SwiftUI

// MARK: - Timeline Provider

struct DailyHoroscopeProvider: TimelineProvider {
    func placeholder(in context: Context) -> DailyHoroscopeEntry {
        DailyHoroscopeEntry(
            date: Date(),
            zodiacSign: "Aries",
            zodiacEmoji: "♈️",
            dailyMessage: "The stars align for new beginnings today...",
            luckyNumber: 7,
            element: "Fire",
            moodRating: 4
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (DailyHoroscopeEntry) -> Void) {
        let entry = loadHoroscopeFromUserDefaults() ?? placeholder(in: context)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DailyHoroscopeEntry>) -> Void) {
        let entry = loadHoroscopeFromUserDefaults() ?? placeholder(in: context)

        // Update at midnight for fresh daily content
        let calendar = Calendar.current
        let tomorrow = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)

        let timeline = Timeline(entries: [entry], policy: .after(tomorrow))
        completion(timeline)
    }

    private func loadHoroscopeFromUserDefaults() -> DailyHoroscopeEntry? {
        let sharedDefaults = UserDefaults(suiteName: "group.com.umut.astrologyApp")

        guard let zodiacSign = sharedDefaults?.string(forKey: "widget_zodiac_sign"),
              let zodiacEmoji = sharedDefaults?.string(forKey: "widget_zodiac_emoji"),
              let dailyMessage = sharedDefaults?.string(forKey: "widget_daily_message"),
              let element = sharedDefaults?.string(forKey: "widget_element") else {
            return nil
        }

        let luckyNumber = sharedDefaults?.integer(forKey: "widget_lucky_number") ?? 7
        let moodRating = sharedDefaults?.integer(forKey: "widget_mood_rating") ?? 3

        return DailyHoroscopeEntry(
            date: Date(),
            zodiacSign: zodiacSign,
            zodiacEmoji: zodiacEmoji,
            dailyMessage: dailyMessage,
            luckyNumber: luckyNumber,
            element: element,
            moodRating: moodRating
        )
    }
}

// MARK: - Timeline Entry

struct DailyHoroscopeEntry: TimelineEntry {
    let date: Date
    let zodiacSign: String
    let zodiacEmoji: String
    let dailyMessage: String
    let luckyNumber: Int
    let element: String
    let moodRating: Int // 1-5
}

// MARK: - Widget Views

struct DailyHoroscopeWidgetEntryView: View {
    var entry: DailyHoroscopeProvider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallHoroscopeView(entry: entry)
        case .systemMedium:
            MediumHoroscopeView(entry: entry)
        case .systemLarge:
            LargeHoroscopeView(entry: entry)
        default:
            SmallHoroscopeView(entry: entry)
        }
    }
}

struct SmallHoroscopeView: View {
    let entry: DailyHoroscopeEntry

    var body: some View {
        ZStack {
            // Venus gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.1),
                    Color(red: 0.1, green: 0.05, blue: 0.15)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: 8) {
                Text(entry.zodiacEmoji)
                    .font(.system(size: 36))

                Text(entry.zodiacSign)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)

                // Mood stars
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= entry.moodRating ? "star.fill" : "star")
                            .font(.system(size: 8))
                            .foregroundColor(Color(red: 1.0, green: 0.84, blue: 0.0)) // Gold
                    }
                }

                Text("Lucky: \(entry.luckyNumber)")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding()
        }
    }
}

struct MediumHoroscopeView: View {
    let entry: DailyHoroscopeEntry

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
                // Left: Sign info
                VStack(spacing: 8) {
                    Text(entry.zodiacEmoji)
                        .font(.system(size: 44))

                    Text(entry.zodiacSign)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)

                    Text(entry.element)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))

                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { index in
                            Image(systemName: index <= entry.moodRating ? "star.fill" : "star")
                                .font(.system(size: 10))
                                .foregroundColor(Color(red: 1.0, green: 0.84, blue: 0.0))
                        }
                    }
                }
                .frame(width: 80)

                // Right: Daily message
                VStack(alignment: .leading, spacing: 8) {
                    Text("Today's Energy")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 1.0, green: 0.84, blue: 0.0))

                    Text(entry.dailyMessage)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(4)
                        .multilineTextAlignment(.leading)

                    Spacer()

                    HStack {
                        Image(systemName: "sparkles")
                            .font(.system(size: 10))
                        Text("Lucky: \(entry.luckyNumber)")
                            .font(.system(size: 11))
                    }
                    .foregroundColor(.white.opacity(0.6))
                }
            }
            .padding()
        }
    }
}

struct LargeHoroscopeView: View {
    let entry: DailyHoroscopeEntry

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
                    Text(entry.zodiacEmoji)
                        .font(.system(size: 48))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.zodiacSign)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)

                        Text(entry.element + " Element")
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
                                Image(systemName: index <= entry.moodRating ? "star.fill" : "star")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(red: 1.0, green: 0.84, blue: 0.0))
                            }
                        }
                    }
                }

                Divider()
                    .background(Color.white.opacity(0.2))

                // Main message
                VStack(alignment: .leading, spacing: 8) {
                    Text("Daily Cosmic Message")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 1.0, green: 0.84, blue: 0.0))

                    Text(entry.dailyMessage)
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(6)
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                // Footer
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "sparkles")
                        Text("Lucky Number: \(entry.luckyNumber)")
                    }
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))

                    Spacer()

                    Text("Venus One")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(Color(red: 1.0, green: 0.84, blue: 0.0).opacity(0.6))
                }
            }
            .padding()
        }
    }
}

// MARK: - Widget Configuration

struct DailyHoroscopeWidget: Widget {
    let kind: String = "DailyHoroscopeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DailyHoroscopeProvider()) { entry in
            DailyHoroscopeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Daily Horoscope")
        .description("Your personalized daily horoscope at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Preview

struct DailyHoroscopeWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DailyHoroscopeWidgetEntryView(entry: DailyHoroscopeEntry(
                date: Date(),
                zodiacSign: "Scorpio",
                zodiacEmoji: "♏️",
                dailyMessage: "Today brings profound insights. Trust your intuition as Venus aligns with your ruling planet, opening doors to deeper connections and hidden truths.",
                luckyNumber: 8,
                element: "Water",
                moodRating: 4
            ))
            .previewContext(WidgetPreviewContext(family: .systemSmall))

            DailyHoroscopeWidgetEntryView(entry: DailyHoroscopeEntry(
                date: Date(),
                zodiacSign: "Scorpio",
                zodiacEmoji: "♏️",
                dailyMessage: "Today brings profound insights. Trust your intuition as Venus aligns with your ruling planet, opening doors to deeper connections and hidden truths.",
                luckyNumber: 8,
                element: "Water",
                moodRating: 4
            ))
            .previewContext(WidgetPreviewContext(family: .systemMedium))

            DailyHoroscopeWidgetEntryView(entry: DailyHoroscopeEntry(
                date: Date(),
                zodiacSign: "Scorpio",
                zodiacEmoji: "♏️",
                dailyMessage: "Today brings profound insights. Trust your intuition as Venus aligns with your ruling planet, opening doors to deeper connections and hidden truths. The cosmic energy supports transformation and emotional depth.",
                luckyNumber: 8,
                element: "Water",
                moodRating: 4
            ))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
