//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  LocalizationKeys.swift
//
//  Created by i18n Automation on 2/4/26.

import Foundation

/// Centralized localization keys for RevenueCatUI
/// Prevents hardcoded strings and ensures type-safe localization
enum LocalizationKey: String, CaseIterable {
    
    // MARK: - Footer Actions
    case allSubscriptions = "all_subscriptions"
    case restorePurchases = "restore_purchases"
    case restore = "restore"
    case purchasesRestoredSuccessfully = "purchases_restored_successfully"
    case ok = "ok"
    
    // MARK: - Legal Links
    case termsAndConditions = "terms_and_conditions"
    case termsShort = "terms_short"
    case privacyPolicy = "privacy_policy"
    case privacyShort = "privacy_short"
    
    // MARK: - Package Types
    case annual = "package_annual"
    case sixMonth = "package_six_month"
    case threeMonth = "package_three_month"
    case twoMonth = "package_two_month"
    case monthly = "package_monthly"
    case weekly = "package_weekly"
    case lifetime = "package_lifetime"
    
    // MARK: - Discount Format
    case percentOff = "percent_off"
    
    /// Returns the localized string for the given locale
    func localized(in bundle: Bundle, locale: Locale = .current) -> String {
        let localizedBundle = Localization.localizedBundle(locale)
        return localizedBundle.localizedString(
            forKey: self.rawValue,
            value: self.fallbackValue,
            table: nil
        )
    }
    
    /// Fallback English values (used if localization file is missing)
    private var fallbackValue: String {
        switch self {
        case .allSubscriptions: return "All subscriptions"
        case .restorePurchases: return "Restore purchases"
        case .restore: return "Restore"
        case .purchasesRestoredSuccessfully: return "Purchases restored successfully!"
        case .ok: return "OK"
        case .termsAndConditions: return "Terms and conditions"
        case .termsShort: return "Terms"
        case .privacyPolicy: return "Privacy policy"
        case .privacyShort: return "Privacy"
        case .annual: return "Annual"
        case .sixMonth: return "6 Month"
        case .threeMonth: return "3 Month"
        case .twoMonth: return "2 Month"
        case .monthly: return "Monthly"
        case .weekly: return "Weekly"
        case .lifetime: return "Lifetime"
        case .percentOff: return "%d%% off"
        }
    }
}

extension LocalizationKey {
    /// String interpolation helper for formatted strings
    func localized(in bundle: Bundle, locale: Locale = .current, _ arguments: CVarArg...) -> String {
        let format = self.localized(in: bundle, locale: locale)
        return String(format: format, arguments: arguments)
    }
}
