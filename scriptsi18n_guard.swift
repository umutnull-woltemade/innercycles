#!/usr/bin/env swift

//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  i18n_guard.swift
//
//  CI script to enforce i18n compliance
//  Exits with non-zero status on violations
//
//  Usage: swift scripts/i18n_guard.swift
//

import Foundation

// MARK: - Configuration

struct I18nConfig {
    static let supportedLocales = ["en", "tr"]
    static let resourcesPath = "Resources"
    static let sourcePaths = ["Sources", "RevenueCatUI", "."]
    
    // Turkish-specific characters that should NOT appear in EN strings
    static let turkishCharacterPattern = "[ğüşöçıİĞÜŞÖÇ]"
    
    // Patterns that indicate hardcoded user-facing strings
    static let hardcodedStringPatterns = [
        "Text\\(\"[^\"]+\"\\)",  // Text("hardcoded")
        "Text\\(\"[^\"]+\", bundle:" // Partial - should use LocalizationKey
    ]
}

// MARK: - Main Execution

final class I18nGuard {
    private var violations: [Violation] = []
    private let fileManager = FileManager.default
    
    struct Violation {
        let file: String
        let line: Int?
        let severity: Severity
        let message: String
        
        enum Severity: String {
            case error = "ERROR"
            case warning = "WARNING"
        }
        
        var description: String {
            let lineInfo = line.map { ":\($0)" } ?? ""
            return "[\(severity.rawValue)] \(file)\(lineInfo): \(message)"
        }
    }
    
    func run() -> Int32 {
        print("🔍 Running i18n compliance checks...\n")
        
        checkLocalizationFilesSynced()
        checkForHardcodedStrings()
        checkForTurkishInEnglish()
        checkForMissingLocalizations()
        
        printResults()
        
        return violations.contains { $0.severity == .error } ? 1 : 0
    }
    
    // MARK: - Check 1: Localization Files Synced
    
    private func checkLocalizationFilesSynced() {
        print("📋 Checking localization file synchronization...")
        
        var allKeys: [String: Set<String>] = [:]
        
        for locale in I18nConfig.supportedLocales {
            let localeDir = "\(I18nConfig.resourcesPath)/\(locale).lproj"
            let stringsFile = "\(localeDir)/Localizable.strings"
            
            guard let keys = parseStringsFile(stringsFile) else {
                violations.append(Violation(
                    file: stringsFile,
                    line: nil,
                    severity: .error,
                    message: "Could not read localization file"
                ))
                continue
            }
            
            allKeys[locale] = keys
        }
        
        // Check all locales have the same keys
        guard let enKeys = allKeys["en"] else {
            violations.append(Violation(
                file: "en.lproj/Localizable.strings",
                line: nil,
                severity: .error,
                message: "English localization file is missing or empty"
            ))
            return
        }
        
        for (locale, keys) in allKeys where locale != "en" {
            let missingKeys = enKeys.subtracting(keys)
            let extraKeys = keys.subtracting(enKeys)
            
            if !missingKeys.isEmpty {
                violations.append(Violation(
                    file: "\(locale).lproj/Localizable.strings",
                    line: nil,
                    severity: .error,
                    message: "Missing keys in \(locale): \(missingKeys.joined(separator: ", "))"
                ))
            }
            
            if !extraKeys.isEmpty {
                violations.append(Violation(
                    file: "\(locale).lproj/Localizable.strings",
                    line: nil,
                    severity: .warning,
                    message: "Extra keys in \(locale) not in en: \(extraKeys.joined(separator: ", "))"
                ))
            }
        }
    }
    
    private func parseStringsFile(_ path: String) -> Set<String>? {
        guard let content = try? String(contentsOfFile: path, encoding: .utf8) else {
            return nil
        }
        
        // Simple parser for .strings files: "key" = "value";
        let pattern = "^\"([^\"]+)\"\\s*=\\s*\"[^\"]*\";$"
        let regex = try! NSRegularExpression(pattern: pattern, options: .anchorsMatchLines)
        
        let nsString = content as NSString
        let matches = regex.matches(in: content, range: NSRange(location: 0, length: nsString.length))
        
        var keys = Set<String>()
        for match in matches {
            if match.numberOfRanges > 1 {
                let keyRange = match.range(at: 1)
                let key = nsString.substring(with: keyRange)
                keys.insert(key)
            }
        }
        
        return keys
    }
    
    // MARK: - Check 2: No Hardcoded Strings
    
    private func checkForHardcodedStrings() {
        print("🔒 Scanning for hardcoded UI strings...")
        
        for sourcePath in I18nConfig.sourcePaths {
            guard fileManager.fileExists(atPath: sourcePath) else { continue }
            
            scanDirectory(sourcePath) { file, content in
                guard file.hasSuffix(".swift") else { return }
                
                // Skip test files and generated files
                if file.contains("/Tests/") || file.contains("Generated") {
                    return
                }
                
                let lines = content.components(separatedBy: .newlines)
                
                for (index, line) in lines.enumerated() {
                    // Skip comments
                    if line.trimmingCharacters(in: .whitespaces).hasPrefix("//") {
                        continue
                    }
                    
                    // Check for Text("literal") without bundle or LocalizationKey
                    if line.contains("Text(\"") &&
                       !line.contains("LocalizationKey") &&
                       !line.contains("bundle:") &&
                       !line.contains("// swiftlint:disable") {
                        
                        // Allow certain patterns (like system images)
                        if line.contains("Image(systemName:") {
                            continue
                        }
                        
                        violations.append(Violation(
                            file: file,
                            line: index + 1,
                            severity: .warning,
                            message: "Possible hardcoded string - use LocalizationKey instead"
                        ))
                    }
                }
            }
        }
    }
    
    // MARK: - Check 3: No Turkish in English
    
    private func checkForTurkishInEnglish() {
        print("🇬🇧 Checking English strings for Turkish characters...")
        
        let enStringsFile = "\(I18nConfig.resourcesPath)/en.lproj/Localizable.strings"
        
        guard let content = try? String(contentsOfFile: enStringsFile, encoding: .utf8) else {
            return
        }
        
        let turkishRegex = try! NSRegularExpression(pattern: I18nConfig.turkishCharacterPattern)
        let lines = content.components(separatedBy: .newlines)
        
        for (index, line) in lines.enumerated() {
            let nsLine = line as NSString
            let matches = turkishRegex.matches(
                in: line,
                range: NSRange(location: 0, length: nsLine.length)
            )
            
            if !matches.isEmpty {
                let chars = matches.map { nsLine.substring(with: $0.range) }.joined(separator: ", ")
                violations.append(Violation(
                    file: enStringsFile,
                    line: index + 1,
                    severity: .error,
                    message: "Turkish characters found in English: \(chars)"
                ))
            }
        }
    }
    
    // MARK: - Check 4: Missing Localizations
    
    private func checkForMissingLocalizations() {
        print("🔎 Checking for missing localization implementations...")
        
        // Verify LocalizationKey enum has entries
        for sourcePath in I18nConfig.sourcePaths {
            guard fileManager.fileExists(atPath: sourcePath) else { continue }
            
            scanDirectory(sourcePath) { file, content in
                guard file.hasSuffix("LocalizationKeys.swift") else { return }
                
                if !content.contains("enum LocalizationKey") {
                    violations.append(Violation(
                        file: file,
                        line: nil,
                        severity: .error,
                        message: "LocalizationKey enum not found"
                    ))
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func scanDirectory(_ path: String, handler: (String, String) -> Void) {
        guard let enumerator = fileManager.enumerator(atPath: path) else {
            return
        }
        
        for case let file as String in enumerator {
            let fullPath = "\(path)/\(file)"
            
            guard let content = try? String(contentsOfFile: fullPath, encoding: .utf8) else {
                continue
            }
            
            handler(fullPath, content)
        }
    }
    
    private func printResults() {
        print("\n" + String(repeating: "=", count: 60))
        
        if violations.isEmpty {
            print("✅ All i18n checks passed!")
            print(String(repeating: "=", count: 60))
            return
        }
        
        let errors = violations.filter { $0.severity == .error }
        let warnings = violations.filter { $0.severity == .warning }
        
        if !errors.isEmpty {
            print("\n❌ ERRORS (\(errors.count)):\n")
            errors.forEach { print($0.description) }
        }
        
        if !warnings.isEmpty {
            print("\n⚠️  WARNINGS (\(warnings.count)):\n")
            warnings.forEach { print($0.description) }
        }
        
        print("\n" + String(repeating: "=", count: 60))
        print("Total violations: \(violations.count) (\(errors.count) errors, \(warnings.count) warnings)")
        print(String(repeating: "=", count: 60))
    }
}

// MARK: - Entry Point

let guard = I18nGuard()
exit(guard.run())
