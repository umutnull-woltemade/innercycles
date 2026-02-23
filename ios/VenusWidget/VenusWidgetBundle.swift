// InnerCycles iOS Widget Bundle
// Daily reflection, mood insight, cycle position, weekly mood grid,
// and lock screen widgets for Home Screen, StandBy, and Lock Screen

import WidgetKit
import SwiftUI

@main
struct InnerCyclesWidgetBundle: WidgetBundle {
    var body: some Widget {
        DailyReflectionWidget()
        MoodInsightWidget()
        CyclePositionWidget()
        WeeklyMoodGridWidget()
        if #available(iOSApplicationExtension 16.0, *) {
            LockScreenWidget()
        }
    }
}
