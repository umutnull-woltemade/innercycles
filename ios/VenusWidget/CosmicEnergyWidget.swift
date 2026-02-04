// Venus One - Cosmic Energy Widget
// Displays current planetary alignments and cosmic energy

import WidgetKit
import SwiftUI

// MARK: - Timeline Provider

struct CosmicEnergyProvider: TimelineProvider {
    func placeholder(in context: Context) -> CosmicEnergyEntry {
        CosmicEnergyEntry(
            date: Date(),
            moonPhase: "Waxing Crescent",
            moonEmoji: "🌒",
            planetaryFocus: "Venus in Pisces",
            energyLevel: 75,
            advice: "Focus on creativity and emotional connections",
            currentTransit: "Mercury trine Jupiter"
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (CosmicEnergyEntry) -> Void) {
        let entry = loadCosmicFromUserDefaults() ?? placeholder(in: context)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CosmicEnergyEntry>) -> Void) {
        let entry = loadCosmicFromUserDefaults() ?? placeholder(in: context)

        // Update every 4 hours for cosmic shifts
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 4, to: Date())!

        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    private func loadCosmicFromUserDefaults() -> CosmicEnergyEntry? {
        let sharedDefaults = UserDefaults(suiteName: "group.com.umut.astrologyApp")

        guard let moonPhase = sharedDefaults?.string(forKey: "widget_moon_phase"),
              let moonEmoji = sharedDefaults?.string(forKey: "widget_moon_emoji"),
              let planetaryFocus = sharedDefaults?.string(forKey: "widget_planetary_focus"),
              let advice = sharedDefaults?.string(forKey: "widget_cosmic_advice") else {
            return nil
        }

        let energyLevel = sharedDefaults?.integer(forKey: "widget_energy_level") ?? 50
        let currentTransit = sharedDefaults?.string(forKey: "widget_current_transit") ?? ""

        return CosmicEnergyEntry(
            date: Date(),
            moonPhase: moonPhase,
            moonEmoji: moonEmoji,
            planetaryFocus: planetaryFocus,
            energyLevel: energyLevel,
            advice: advice,
            currentTransit: currentTransit
        )
    }
}

// MARK: - Timeline Entry

struct CosmicEnergyEntry: TimelineEntry {
    let date: Date
    let moonPhase: String
    let moonEmoji: String
    let planetaryFocus: String
    let energyLevel: Int // 0-100
    let advice: String
    let currentTransit: String
}

// MARK: - Widget Views

struct CosmicEnergyWidgetEntryView: View {
    var entry: CosmicEnergyProvider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallCosmicView(entry: entry)
        case .systemMedium:
            MediumCosmicView(entry: entry)
        default:
            SmallCosmicView(entry: entry)
        }
    }
}

struct SmallCosmicView: View {
    let entry: CosmicEnergyEntry

    var energyColor: Color {
        if entry.energyLevel >= 70 {
            return Color.green
        } else if entry.energyLevel >= 40 {
            return Color.orange
        } else {
            return Color.red.opacity(0.8)
        }
    }

    var body: some View {
        ZStack {
            // Deep space gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.02, green: 0.02, blue: 0.08),
                    Color(red: 0.08, green: 0.03, blue: 0.15)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(spacing: 10) {
                // Moon phase
                Text(entry.moonEmoji)
                    .font(.system(size: 36))

                Text(entry.moonPhase)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))

                // Energy gauge
                VStack(spacing: 4) {
                    Text("Energy")
                        .font(.system(size: 9))
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
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(energyColor)
                }
            }
            .padding()
        }
    }
}

struct MediumCosmicView: View {
    let entry: CosmicEnergyEntry

    var energyColor: Color {
        if entry.energyLevel >= 70 {
            return Color.green
        } else if entry.energyLevel >= 40 {
            return Color.orange
        } else {
            return Color.red.opacity(0.8)
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.02, green: 0.02, blue: 0.08),
                    Color(red: 0.08, green: 0.03, blue: 0.15)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )

            HStack(spacing: 20) {
                // Left: Moon & Energy
                VStack(spacing: 8) {
                    Text(entry.moonEmoji)
                        .font(.system(size: 44))

                    Text(entry.moonPhase)
                        .font(.system(size: 12, weight: .medium))
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
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(energyColor)
                    }
                }
                .frame(width: 90)

                // Right: Planetary info
                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Planetary Focus")
                            .font(.system(size: 10))
                            .foregroundColor(Color(red: 1.0, green: 0.84, blue: 0.0).opacity(0.8))

                        Text(entry.planetaryFocus)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white)
                    }

                    if !entry.currentTransit.isEmpty {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Current Transit")
                                .font(.system(size: 9))
                                .foregroundColor(.white.opacity(0.5))

                            Text(entry.currentTransit)
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }

                    Spacer()

                    Text(entry.advice)
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(2)
                }
            }
            .padding()
        }
    }
}

// MARK: - Widget Configuration

struct CosmicEnergyWidget: Widget {
    let kind: String = "CosmicEnergyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CosmicEnergyProvider()) { entry in
            CosmicEnergyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Cosmic Energy")
        .description("Track moon phases and planetary alignments.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Preview

struct CosmicEnergyWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CosmicEnergyWidgetEntryView(entry: CosmicEnergyEntry(
                date: Date(),
                moonPhase: "Full Moon",
                moonEmoji: "🌕",
                planetaryFocus: "Venus in Pisces",
                energyLevel: 85,
                advice: "Perfect for manifestation and emotional healing",
                currentTransit: "Mercury trine Jupiter"
            ))
            .previewContext(WidgetPreviewContext(family: .systemSmall))

            CosmicEnergyWidgetEntryView(entry: CosmicEnergyEntry(
                date: Date(),
                moonPhase: "Full Moon",
                moonEmoji: "🌕",
                planetaryFocus: "Venus in Pisces",
                energyLevel: 85,
                advice: "Perfect for manifestation and emotional healing work",
                currentTransit: "Mercury trine Jupiter"
            ))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
