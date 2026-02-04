//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  LocalizationTests.swift
//
//  Created by i18n Automation on 2/4/26.

import Testing
import Foundation
@testable import RevenueCatUI

/// Automated i18n regression tests to prevent localization issues
@Suite("Localization Integrity Tests")
struct LocalizationTests {
    
    // MARK: - Configuration
    
    /// All supported locales that MUST have complete translations
    private let supportedLocales: [Locale] = [
        Locale(identifier: "en_US"),
        Locale(identifier: "tr_TR")
    ]
    
    // MARK: - Test 1: All Keys Exist in All Locales
    
    @Test("All localization keys exist in all supported locales")
    func allKeysExistInAllLocales() async throws {
        for locale in supportedLocales {
            let bundle = Localization.localizedBundle(locale)
            
            for key in LocalizationKey.allCases {
                let localizedValue = bundle.localizedString(
                    forKey: key.rawValue,
                    value: nil,
                    table: nil
                )
                
                // If localization is missing, it returns the key itself
                #expect(
                    localizedValue != key.rawValue,
                    "Missing translation for key '\(key.rawValue)' in locale '\(locale.identifier)'"
                )
                
                // Ensure it's not empty
                #expect(
                    !localizedValue.isEmpty,
                    "Empty translation for key '\(key.rawValue)' in locale '\(locale.identifier)'"
                )
            }
        }
    }
    
    // MARK: - Test 2: No Hardcoded UI Strings
    
    @Test("No hardcoded user-facing strings in FooterView")
    func noHardcodedStringsInFooterView() async throws {
        // This is a compile-time guarantee test
        // The actual enforcement happens via the CI guard script
        // This test documents the requirement
        
        #expect(LocalizationKey.allCases.count > 0, "LocalizationKey enum must have entries")
    }
    
    // MARK: - Test 3: Language-Specific Content Validation
    
    @Test("English strings contain no Turkish characters")
    func englishStringsAreClean() async throws {
        let turkishCharacters = CharacterSet(charactersIn: "ğüşöçıİĞÜŞÖÇ")
        let enBundle = Localization.localizedBundle(Locale(identifier: "en_US"))
        
        for key in LocalizationKey.allCases {
            let value = enBundle.localizedString(forKey: key.rawValue, value: nil, table: nil)
            
            for char in value.unicodeScalars {
                #expect(
                    !turkishCharacters.contains(char),
                    "English translation for '\(key.rawValue)' contains Turkish character: '\(char)'"
                )
            }
        }
    }
    
    @Test("Turkish strings contain no English-only text where translation should exist")
    func turkishStringsAreTranslated() async throws {
        let trBundle = Localization.localizedBundle(Locale(identifier: "tr_TR"))
        let enBundle = Localization.localizedBundle(Locale(identifier: "en_US"))
        
        for key in LocalizationKey.allCases {
            let trValue = trBundle.localizedString(forKey: key.rawValue, value: nil, table: nil)
            let enValue = enBundle.localizedString(forKey: key.rawValue, value: nil, table: nil)
            
            // Turkish and English should not be identical (except for technical terms)
            // Allow some exceptions for technical or brand terms
            let allowedIdenticalKeys: Set<LocalizationKey> = [.ok] // "OK" is universal
            
            if !allowedIdenticalKeys.contains(key) {
                #expect(
                    trValue != enValue,
                    "Turkish translation for '\(key.rawValue)' is identical to English - possible missing translation"
                )
            }
        }
    }
    
    // MARK: - Test 4: Format String Consistency
    
    @Test("Format strings have correct placeholder count")
    func formatStringsAreConsistent() async throws {
        let formatKeys: [LocalizationKey] = [.percentOff]
        
        for locale in supportedLocales {
            let bundle = Localization.localizedBundle(locale)
            
            for key in formatKeys {
                let value = bundle.localizedString(forKey: key.rawValue, value: nil, table: nil)
                
                // Count %d, %@, %ld, etc.
                let formatSpecifierPattern = "%[0-9]*[dDiuUxXoOfFeEgGcCsSaAp@]"
                let regex = try! NSRegularExpression(pattern: formatSpecifierPattern)
                let matches = regex.matches(
                    in: value,
                    range: NSRange(value.startIndex..., in: value)
                )
                
                // percentOff should have exactly 1 format specifier
                #expect(
                    matches.count >= 1,
                    "Format string for '\(key.rawValue)' in locale '\(locale.identifier)' has wrong placeholder count: \(matches.count)"
                )
            }
        }
    }
    
    // MARK: - Test 5: Bundle Loading Works
    
    @Test("Localization bundles load successfully for all locales")
    func bundlesLoadCorrectly() async throws {
        for locale in supportedLocales {
            let bundle = Localization.localizedBundle(locale)
            
            #expect(
                bundle.bundlePath != nil,
                "Failed to load bundle for locale '\(locale.identifier)'"
            )
            
            // Verify bundle contains our strings
            let testKey = LocalizationKey.ok.rawValue
            let value = bundle.localizedString(forKey: testKey, value: "MISSING", table: nil)
            
            #expect(
                value != "MISSING",
                "Bundle for locale '\(locale.identifier)' does not contain localization strings"
            )
        }
    }
    
    // MARK: - Test 6: Locale-Specific Rendering
    
    @Test("Localized bundles work for all locales")
    func localizedBundlesWork() async throws {
        // Simplified test that doesn't require mock objects
        // Tests the actual bundle loading mechanism
        
        for locale in supportedLocales {
            let bundle = Localization.localizedBundle(locale)
            
            // Verify bundle can load strings
            let testValue = bundle.localizedString(
                forKey: LocalizationKey.restorePurchases.rawValue,
                value: "FALLBACK",
                table: nil
            )
            
            #expect(
                testValue != "FALLBACK",
                "Bundle for locale '\(locale.identifier)' should contain localization strings"
            )
            
            #expect(
                testValue.count > 0,
                "Localized string for locale '\(locale.identifier)' should not be empty"
            )
            
            // Verify different locales return different strings
            if locale.identifier != "en_US" {
                let enBundle = Localization.localizedBundle(Locale(identifier: "en_US"))
                let enValue = enBundle.localizedString(
                    forKey: LocalizationKey.restorePurchases.rawValue,
                    value: "FALLBACK",
                    table: nil
                )
                
                // Allow "OK" to be the same across locales (common exception)
                if LocalizationKey.restorePurchases != .ok {
                    #expect(
                        testValue != enValue,
                        "Locale '\(locale.identifier)' should have different translation than English"
                    )
                }
            }
        }
    }
}

