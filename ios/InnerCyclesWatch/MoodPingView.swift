// InnerCycles Watch - Mood Ping View
// Quick emotion log: tap a mood emoji to write to shared UserDefaults

import SwiftUI
import WatchKit

struct MoodPingView: View {
    @State private var selectedMood: Int? = nil
    @State private var showConfirmation = false
    @State private var currentStreak: Int = 0

    private let moods: [(emoji: String, label: String, rating: Int)] = [
        ("\u{1F614}", "Difficult", 1),
        ("\u{1F615}", "Low", 2),
        ("\u{1F610}", "Neutral", 3),
        ("\u{1F60A}", "Good", 4),
        ("\u{1F929}", "Great", 5),
    ]

    private let starGold = Color(red: 212/255, green: 165/255, blue: 116/255)
    private let deepBg = Color(red: 0.05, green: 0.05, blue: 0.1)

    var body: some View {
        NavigationStack {
            ZStack {
                deepBg.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        // Header
                        Text("How do you feel?")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.top, 4)

                        // Mood grid: 3 + 2 layout for watch screen
                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                ForEach(0..<3, id: \.self) { index in
                                    moodButton(moods[index], index: index)
                                }
                            }
                            HStack(spacing: 12) {
                                ForEach(3..<5, id: \.self) { index in
                                    moodButton(moods[index], index: index)
                                }
                            }
                        }

                        // Streak display
                        if currentStreak > 0 {
                            HStack(spacing: 4) {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 10))
                                    .foregroundColor(starGold)
                                Text("\(currentStreak) day streak")
                                    .font(.system(size: 11))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding(.horizontal, 8)
                }
            }
            .navigationTitle("InnerCycles")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            loadCurrentStreak()
        }
        .overlay {
            if showConfirmation, let mood = selectedMood {
                confirmationOverlay(mood: moods[mood])
            }
        }
    }

    // MARK: - Mood Button

    private func moodButton(_ mood: (emoji: String, label: String, rating: Int), index: Int) -> some View {
        Button {
            WKInterfaceDevice.current().play(.click)
            selectedMood = index
            logMood(mood)
        } label: {
            VStack(spacing: 4) {
                Text(mood.emoji)
                    .font(.system(size: 28))
                Text(mood.label)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        selectedMood == index
                            ? starGold.opacity(0.25)
                            : Color.white.opacity(0.08)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        selectedMood == index
                            ? starGold.opacity(0.5)
                            : Color.clear,
                        lineWidth: 1.5
                    )
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Confirmation Overlay

    private func confirmationOverlay(mood: (emoji: String, label: String, rating: Int)) -> some View {
        ZStack {
            deepBg.opacity(0.9).ignoresSafeArea()

            VStack(spacing: 12) {
                Text(mood.emoji)
                    .font(.system(size: 48))

                Text("Logged!")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)

                Text(mood.label)
                    .font(.system(size: 13))
                    .foregroundColor(starGold)
            }
        }
        .transition(.opacity)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeOut(duration: 0.3)) {
                    showConfirmation = false
                    selectedMood = nil
                }
            }
        }
    }

    // MARK: - Data

    private func logMood(_ mood: (emoji: String, label: String, rating: Int)) {
        let defaults = UserDefaults(suiteName: "group.com.venusone.innercycles")

        // Write watch-specific keys
        defaults?.set(mood.emoji, forKey: "watch_mood_emoji")
        defaults?.set(mood.label, forKey: "watch_mood_label")
        defaults?.set(mood.rating, forKey: "watch_mood_rating")
        defaults?.set(Date().timeIntervalSince1970, forKey: "watch_mood_timestamp")

        // Also update the widget keys so iOS widgets refresh
        defaults?.set(mood.emoji, forKey: "widget_mood_emoji")
        defaults?.set(mood.label, forKey: "widget_mood_label")
        defaults?.set(mood.rating, forKey: "widget_mood_rating")

        defaults?.synchronize()

        withAnimation(.easeIn(duration: 0.2)) {
            showConfirmation = true
        }
    }

    private func loadCurrentStreak() {
        let defaults = UserDefaults(suiteName: "group.com.venusone.innercycles")
        currentStreak = defaults?.integer(forKey: "widget_streak_days") ?? 0
    }
}

// MARK: - Preview

#Preview {
    MoodPingView()
}
