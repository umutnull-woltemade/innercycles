//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  CustomerCenterIcons.swift
//
//  Created on 2/2/26.

import Foundation

#if os(iOS)

/// Centralized constants for SF Symbol names used throughout the Customer Center.
/// This ensures consistency and makes icon updates easier to manage.
@available(iOS 15.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
enum CustomerCenterIcons {
    
    // MARK: - Navigation Icons
    
    /// Chevron pointing forward, used for navigation and drill-down actions
    static let chevronForward = "chevron.forward"
    
    // MARK: - Status Icons
    
    /// Success indicator - filled circle with checkmark
    static let success = "checkmark.circle.fill"
    
    /// Error indicator - filled circle with X mark
    static let error = "xmark.circle.fill"
    
    /// Warning indicator - filled triangle with exclamation mark
    static let warning = "exclamationmark.triangle.fill"
    
    /// Info indicator - filled circle with info symbol
    static let info = "info.circle.fill"
    
    /// Unknown/Question state indicator - filled circle with question mark
    static let unknown = "questionmark.circle.fill"
    
    // MARK: - Action Icons
    
    /// Update/Upload action - filled circle with upward arrow
    static let update = "arrow.up.circle.fill"
    
    // MARK: - Icon Sizes
    
    enum Size {
        /// Standard size for chevron icons in navigation contexts
        static let chevron: CGFloat = 12
        
        /// Standard size for status and info icons
        static let statusIcon: CGFloat = 16
        
        /// Standard size for large action icons
        static let actionIcon: CGFloat = 24
    }
    
    // MARK: - Icon Weights
    
    enum Weight {
        /// Bold weight for chevrons and navigation indicators
        static let chevronWeight = Font.Weight.bold
    }
}

#endif
