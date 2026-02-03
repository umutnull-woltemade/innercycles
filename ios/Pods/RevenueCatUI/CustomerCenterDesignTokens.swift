//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  CustomerCenterDesignTokens.swift
//
//  Created on 2/2/26.
//
//  Design tokens for consistent UI implementation across Customer Center.
//  Use these constants to maintain visual consistency and make global design changes easier.

import SwiftUI

#if os(iOS)

@available(iOS 15.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
enum CustomerCenterDesignTokens {
    
    // MARK: - Spacing
    
    /// Standard spacing values used throughout the Customer Center UI
    enum Spacing {
        /// Extra tiny spacing - 2pt
        static let extraTiny: CGFloat = 2
        
        /// Tiny spacing - 4pt (used between related elements)
        static let tiny: CGFloat = 4
        
        /// Small spacing - 8pt (used for compact layouts)
        static let small: CGFloat = 8
        
        /// Medium spacing - 12pt (used for element groups)
        static let medium: CGFloat = 12
        
        /// Standard spacing - 16pt (default section spacing)
        static let standard: CGFloat = 16
        
        /// Large spacing - 24pt (used between major sections)
        static let large: CGFloat = 24
        
        /// Extra large spacing - 32pt (used for major section breaks)
        static let extraLarge: CGFloat = 32
    }
    
    // MARK: - Corner Radius
    
    /// Standard corner radius values for consistent rounded corners
    enum CornerRadius {
        /// Badge corner radius - 4pt
        static let badge: CGFloat = 4
        
        /// Button corner radius - 8pt
        static let button: CGFloat = 8
        
        /// Card/Container corner radius - 10pt (most common)
        static let card: CGFloat = 10
        
        /// Modal/Sheet corner radius - 16pt
        static let modal: CGFloat = 16
    }
    
    // MARK: - Animation
    
    /// Standard animation durations for consistent motion
    enum AnimationDuration {
        /// Fast animation - 0.15s (for micro-interactions)
        static let fast: TimeInterval = 0.15
        
        /// Standard animation - 0.3s (default for most transitions)
        static let standard: TimeInterval = 0.3
        
        /// Slow animation - 0.6s (for major state changes)
        static let slow: TimeInterval = 0.6
    }
    
    /// Standard animation curves
    enum AnimationCurve {
        /// Ease in-out curve for smooth transitions
        static let easeInOut = Animation.easeInOut(duration: AnimationDuration.standard)
        
        /// Default spring animation
        static let spring = Animation.spring()
        
        /// Default animation (system default)
        static let `default` = Animation.default
    }
    
    // MARK: - Badge Colors
    
    /// Color configurations for purchase status badges
    enum BadgeColor {
        /// Cancelled state - Red tint
        static let cancelled = Color(red: 242/256, green: 84/256, blue: 91/256, opacity: 0.15)
        
        /// Border color for bordered badges
        static let border = Color(red: 60/256, green: 60/256, blue: 67/256, opacity: 0.29)
        
        /// Free trial state - Yellow tint
        static let freeTrial = Color(red: 245/256, green: 202/256, blue: 92/256, opacity: 0.2)
        
        /// Active state - Green tint
        static let active = Color(red: 52/256, green: 199/256, blue: 89/256, opacity: 0.2)
        
        /// Expired state - Gray tint
        static let expired = Color(red: 242/256, green: 242/256, blue: 247/256, opacity: 0.2)
    }
    
    // MARK: - Typography
    
    /// Standard font configurations
    enum Typography {
        /// Title font for cards and sections
        static let cardTitle = Font.headline
        
        /// Subtitle font for secondary information
        static let subtitle = Font.subheadline
        
        /// Caption font for additional details
        static let caption = Font.caption
        
        /// Badge font for status badges
        static let badge = Font.caption2
    }
    
    // MARK: - Adaptive Colors
    
    /// Helper methods for adaptive color schemes
    enum AdaptiveColor {
        /// Get primary card background color for current color scheme
        static func cardBackground(for colorScheme: ColorScheme) -> Color {
            Color(colorScheme == .light
                  ? UIColor.systemBackground
                  : UIColor.secondarySystemBackground)
        }
        
        /// Get secondary card background color for current color scheme
        static func secondaryCardBackground(for colorScheme: ColorScheme) -> Color {
            Color(colorScheme == .light
                  ? UIColor.secondarySystemFill
                  : UIColor.tertiarySystemBackground)
        }
        
        /// Get screen background color for current color scheme
        static func screenBackground(for colorScheme: ColorScheme) -> Color {
            Color(colorScheme == .light
                  ? UIColor.secondarySystemBackground
                  : UIColor.systemBackground)
        }
        
        /// Get tint color for buttons in current color scheme
        static func buttonTint(for colorScheme: ColorScheme) -> Color {
            colorScheme == .dark ? .white : .black
        }
    }
    
    // MARK: - Layout
    
    /// Standard layout constraints
    enum Layout {
        /// Standard horizontal padding for full-width elements
        static let horizontalPadding: CGFloat = Spacing.standard
        
        /// Standard vertical padding for sections
        static let verticalPadding: CGFloat = Spacing.large
        
        /// Minimum touch target size (for accessibility)
        static let minTouchTarget: CGFloat = 44
    }
}

// MARK: - View Extensions

@available(iOS 15.0, *)
extension View {
    
    /// Apply standard card styling with adaptive background and corner radius
    /// - Parameter colorScheme: The current color scheme
    /// - Returns: Modified view with card styling
    func customerCenterCardStyle(colorScheme: ColorScheme) -> some View {
        self
            .background(CustomerCenterDesignTokens.AdaptiveColor.cardBackground(for: colorScheme))
            .cornerRadius(CustomerCenterDesignTokens.CornerRadius.card)
    }
    
    /// Apply standard horizontal padding
    /// - Returns: Modified view with horizontal padding
    func customerCenterHorizontalPadding() -> some View {
        self.padding(.horizontal, CustomerCenterDesignTokens.Layout.horizontalPadding)
    }
    
    /// Apply standard section spacing
    /// - Returns: Modified view with section spacing
    func customerCenterSectionSpacing() -> some View {
        self.padding(.vertical, CustomerCenterDesignTokens.Layout.verticalPadding)
    }
}

#endif
