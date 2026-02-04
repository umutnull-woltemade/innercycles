//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  Text+Localization.swift
//
//  Created by i18n Automation on 2/4/26.

import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Text {
    /// Creates a localized Text view using a LocalizationKey
    ///
    /// Example:
    /// ```swift
    /// Text(localizationKey: .restorePurchases, bundle: localizedBundle)
    /// ```
    init(localizationKey: LocalizationKey, bundle: Bundle) {
        self.init(localizationKey.rawValue, bundle: bundle)
    }
}

extension String {
    /// Returns a localized string for the given LocalizationKey
    ///
    /// Example:
    /// ```swift
    /// let text = String(localizationKey: .ok, in: bundle, locale: .current)
    /// ```
    init(localizationKey: LocalizationKey, in bundle: Bundle, locale: Locale = .current) {
        let localizedBundle = Localization.localizedBundle(locale)
        self = localizedBundle.localizedString(
            forKey: localizationKey.rawValue,
            value: localizationKey.rawValue,
            table: nil
        )
    }
    
    /// Returns a formatted localized string
    ///
    /// Example:
    /// ```swift
    /// let text = String(
    ///     localizationKey: .percentOff,
    ///     in: bundle,
    ///     locale: .current,
    ///     arguments: 25
    /// )
    /// // Returns: "25% off" (en) or "%25 indirim" (tr)
    /// ```
    init(localizationKey: LocalizationKey, in bundle: Bundle, locale: Locale = .current, arguments: CVarArg...) {
        let localizedBundle = Localization.localizedBundle(locale)
        let format = localizedBundle.localizedString(
            forKey: localizationKey.rawValue,
            value: localizationKey.rawValue,
            table: nil
        )
        self = String(format: format, arguments: arguments)
    }
}

// MARK: - SwiftUI Environment

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension EnvironmentValues {
    /// Access to localized bundle via environment
    ///
    /// Usage in views:
    /// ```swift
    /// @Environment(\.localizedBundle) var localizedBundle
    /// Text(localizationKey: .restore, bundle: localizedBundle)
    /// ```
    var localizedBundle: Bundle {
        get { Localization.localizedBundle(self.locale) }
    }
}

// MARK: - Deprecated Helpers (Migration Support)

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Text {
    /// **DEPRECATED:** Use `init(localizationKey:bundle:)` instead
    ///
    /// This initializer is for migration support only.
    /// Replace hardcoded strings with LocalizationKey enum values.
    @available(*, deprecated, message: "Use Text(localizationKey: .yourKey, bundle: bundle) instead of hardcoded strings")
    init(_ string: String, bundle: Bundle, tableName: String? = nil) {
        self.init(string, bundle: bundle, tableName: tableName)
    }
}
