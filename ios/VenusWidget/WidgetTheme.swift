// InnerCycles - Shared Widget Theme Infrastructure
// Colors, gradients, bilingual strings, sparkline, container background

import WidgetKit
import SwiftUI

// MARK: - Widget Colors (ported from AppColors.dart)

struct WidgetColor {
    static let starGold = Color(red: 1.0, green: 0.843, blue: 0.0)             // FFD700
    static let cosmicPurple = Color(red: 0.102, green: 0.102, blue: 0.180)     // 1A1A2E
    static let amethyst = Color(red: 0.608, green: 0.349, blue: 0.714)         // 9B59B6
    static let auroraStart = Color(red: 0.400, green: 0.494, blue: 0.918)      // 667EEA
    static let auroraEnd = Color(red: 0.463, green: 0.294, blue: 0.635)        // 764BA2
    static let deepSpace = Color(red: 0.051, green: 0.051, blue: 0.102)        // 0D0D1A
    static let nebulaPurple = Color(red: 0.086, green: 0.129, blue: 0.243)     // 16213E
    static let twilightEnd = Color(red: 0.557, green: 0.329, blue: 0.914)      // 8E54E9
    static let sunriseStart = Color(red: 0.941, green: 0.576, blue: 0.984)     // F093FB
    static let sunriseEnd = Color(red: 0.961, green: 0.341, blue: 0.424)       // F5576C
    static let warmCrimson = Color(red: 0.737, green: 0.329, blue: 0.294)      // BC544B
    static let deepAmber = Color(red: 0.545, green: 0.353, blue: 0.169)        // 8B5A2B
    static let celestialGold = Color(red: 0.957, green: 0.769, blue: 0.188)    // F4C430
}

// MARK: - Mood Gradient (ported from EmotionalGradient.dart)

struct MoodGradient {
    /// Returns 3-color gradient for mood rating 1-5
    static func colors(for rating: Int) -> [Color] {
        let clamped = max(1, min(5, rating))
        switch clamped {
        case 1:
            // Deep introspective - indigo/deep space
            return [WidgetColor.deepSpace, WidgetColor.nebulaPurple, WidgetColor.cosmicPurple]
        case 2:
            // Low/transitional - purple tones
            return [WidgetColor.nebulaPurple, WidgetColor.cosmicPurple, WidgetColor.amethyst.opacity(0.6)]
        case 3:
            // Balanced - amber/aurora blend
            return [WidgetColor.cosmicPurple, WidgetColor.deepAmber.opacity(0.7), WidgetColor.auroraStart.opacity(0.6)]
        case 4:
            // Good - warm gold/aurora
            return [WidgetColor.auroraEnd.opacity(0.8), WidgetColor.auroraStart, WidgetColor.celestialGold.opacity(0.7)]
        case 5:
            // Great - vibrant sunrise
            return [WidgetColor.auroraStart, WidgetColor.sunriseStart.opacity(0.8), WidgetColor.sunriseEnd.opacity(0.7)]
        default:
            return [WidgetColor.deepSpace, WidgetColor.cosmicPurple, WidgetColor.nebulaPurple]
        }
    }

    /// Returns gradient colors for emotional phase
    static func phaseGradient(_ phase: String) -> [Color] {
        switch phase.lowercased() {
        case "expansion":
            return [WidgetColor.auroraStart, WidgetColor.celestialGold.opacity(0.6), WidgetColor.starGold.opacity(0.4)]
        case "stabilization":
            return [WidgetColor.cosmicPurple, WidgetColor.auroraEnd.opacity(0.5), WidgetColor.amethyst.opacity(0.4)]
        case "contraction":
            return [WidgetColor.deepSpace, WidgetColor.nebulaPurple, WidgetColor.twilightEnd.opacity(0.3)]
        case "reflection":
            return [WidgetColor.nebulaPurple, WidgetColor.amethyst.opacity(0.5), WidgetColor.twilightEnd.opacity(0.4)]
        case "recovery":
            return [WidgetColor.cosmicPurple, WidgetColor.auroraStart.opacity(0.4), WidgetColor.celestialGold.opacity(0.3)]
        default:
            return [WidgetColor.deepSpace, WidgetColor.cosmicPurple, WidgetColor.nebulaPurple]
        }
    }
}

// MARK: - Bilingual Strings

struct WidgetStrings {
    let isEnglish: Bool

    init() {
        let defaults = UserDefaults(suiteName: "group.com.venusone.innercycles")
        let lang = defaults?.string(forKey: "widget_language") ?? "en"
        isEnglish = lang != "tr"
    }

    var todaysReflection: String { isEnglish ? "Today's Reflection" : "Gunun Yansimasi" }
    var dailyReflectionPrompt: String { isEnglish ? "Daily Reflection Prompt" : "Gunluk Yansima Sorusu" }
    var mood: String { isEnglish ? "Mood" : "Ruh Hali" }
    var energy: String { isEnglish ? "Energy" : "Enerji" }
    var weeklyTrend: String { isEnglish ? "Weekly Trend" : "Haftalik Egilim" }
    var cyclePosition: String { isEnglish ? "Cycle Position" : "Dongu Konumu" }
    var weeklyMood: String { isEnglish ? "Weekly Mood" : "Haftalik Ruh Hali" }
    var appName: String { "InnerCycles" }
    var logMood: String { isEnglish ? "Quick Log" : "Hizli Kayit" }
    var noData: String { isEnglish ? "Open app to sync" : "Senkronize etmek icin uygulamayi acin" }
    var lastUpdated: String { isEnglish ? "Updated" : "Guncellendi" }

    func dayOf(_ current: Int, _ total: Int) -> String {
        isEnglish ? "Day \(current) of \(total)" : "Gun \(current) / \(total)"
    }

    func streakText(_ days: Int) -> String {
        if days == 0 { return isEnglish ? "Start your streak!" : "Serini basla!" }
        return isEnglish ? "\(days) day streak" : "\(days) gunluk seri"
    }
}

// MARK: - Mood Sparkline View

struct MoodSparklineView: View {
    let values: [Int] // 7 mood values (1-5)
    var height: CGFloat = 24
    var lineColor: Color = WidgetColor.starGold
    var fillColor: Color = WidgetColor.starGold.opacity(0.15)

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let count = max(values.count, 1)
            let stepX = w / CGFloat(count - 1 > 0 ? count - 1 : 1)
            let minVal: CGFloat = 1
            let maxVal: CGFloat = 5
            let range = maxVal - minVal

            // Compute points
            let points: [CGPoint] = values.enumerated().map { i, val in
                let x = CGFloat(i) * stepX
                let normalized = (CGFloat(val) - minVal) / range
                let y = h - normalized * h
                return CGPoint(x: x, y: y)
            }

            if points.count > 1 {
                // Fill area
                Path { path in
                    path.move(to: CGPoint(x: points[0].x, y: h))
                    for pt in points { path.addLine(to: pt) }
                    path.addLine(to: CGPoint(x: points.last!.x, y: h))
                    path.closeSubpath()
                }
                .fill(fillColor)

                // Line
                Path { path in
                    path.move(to: points[0])
                    for pt in points.dropFirst() { path.addLine(to: pt) }
                }
                .stroke(lineColor, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))

                // Dots
                ForEach(0..<points.count, id: \.self) { i in
                    Circle()
                        .fill(lineColor)
                        .frame(width: 4, height: 4)
                        .position(points[i])
                }
            }
        }
        .frame(height: height)
    }
}

// MARK: - Last Updated View

struct LastUpdatedView: View {
    let strings: WidgetStrings

    var body: some View {
        let defaults = UserDefaults(suiteName: "group.com.venusone.innercycles")
        let timestamp = defaults?.double(forKey: "widget_last_updated") ?? 0

        if timestamp > 0 {
            let date = Date(timeIntervalSince1970: timestamp)
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .abbreviated
            let relative = formatter.localizedString(for: date, relativeTo: Date())

            Text("\(strings.lastUpdated) \(relative)")
                .font(.system(size: 9, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.4))
        }
    }
}

// MARK: - Container Background Extension

extension View {
    @ViewBuilder
    func widgetContainerBackground(colors: [Color]) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            self.containerBackground(for: .widget) {
                LinearGradient(
                    gradient: Gradient(colors: colors),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        } else {
            self
        }
    }
}

// MARK: - Widget Data Helper

struct WidgetData {
    let defaults: UserDefaults?
    let strings: WidgetStrings

    init() {
        defaults = UserDefaults(suiteName: "group.com.venusone.innercycles")
        strings = WidgetStrings()
    }

    /// Returns 7-day mood history as [Int]
    var moodHistory: [Int] {
        guard let raw = defaults?.string(forKey: "widget_mood_history_7d") else {
            return [3, 3, 3, 3, 3, 3, 3] // default neutral
        }
        let vals = raw.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        if vals.count >= 7 { return Array(vals.prefix(7)) }
        // Pad with 3 if less than 7
        return vals + Array(repeating: 3, count: 7 - vals.count)
    }

    /// Returns 7-day mood emojis
    var moodEmojis: [String] {
        guard let raw = defaults?.string(forKey: "widget_mood_history_emojis_7d") else {
            return Array(repeating: "😐", count: 7)
        }
        let emojis = raw.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
        if emojis.count >= 7 { return Array(emojis.prefix(7)) }
        return emojis + Array(repeating: "😐", count: 7 - emojis.count)
    }

    /// Returns 7-day date labels (Mon, Tue, ...)
    var dayLabels: [String] {
        guard let raw = defaults?.string(forKey: "widget_mood_history_dates_7d") else {
            return ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        }
        let labels = raw.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
        if labels.count >= 7 { return Array(labels.prefix(7)) }
        return labels + Array(repeating: "-", count: 7 - labels.count)
    }

    /// Average mood for 7 days (rounded)
    var averageMood: Int {
        let history = moodHistory
        let sum = history.reduce(0, +)
        return max(1, min(5, sum / max(history.count, 1)))
    }

    /// Streak days
    var streakDays: Int {
        defaults?.integer(forKey: "widget_streak_days") ?? 0
    }
}
