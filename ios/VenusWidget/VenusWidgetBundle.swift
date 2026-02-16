// InnerCycles iOS Widget Bundle
// Daily reflection and mood insight widgets for Home Screen and Lock Screen

import WidgetKit
import SwiftUI

@main
struct InnerCyclesWidgetBundle: WidgetBundle {
    var body: some Widget {
        DailyReflectionWidget()
        MoodInsightWidget()
        if #available(iOSApplicationExtension 16.0, *) {
            LockScreenWidget()
        }
    }
}
