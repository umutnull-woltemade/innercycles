// Venus One iOS Widget Bundle
// Daily horoscope and cosmic energy widgets for Home Screen and Lock Screen

import WidgetKit
import SwiftUI

@main
struct VenusWidgetBundle: WidgetBundle {
    var body: some Widget {
        DailyHoroscopeWidget()
        CosmicEnergyWidget()
        if #available(iOSApplicationExtension 16.0, *) {
            LockScreenWidget()
        }
    }
}
