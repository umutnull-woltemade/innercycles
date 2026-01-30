/// CRITICAL UI REGISTRY
///
/// This file defines the PROTECTED SET of UI elements that MUST remain
/// functional at all times. Any failure to render, click, or navigate
/// correctly is a HARD FAILURE that blocks deployment.
///
/// To add a new critical element:
/// 1. Add entry to [criticalUIElements]
/// 2. Tests are auto-generated from this registry
/// 3. CI will automatically enforce protection
library;

import 'package:flutter/material.dart';
import 'package:astrology_app/core/constants/routes.dart';

/// Classification of critical UI element types
enum CriticalUIType {
  /// Navigation elements (bottom nav, tabs, drawer)
  navigation,
  /// Primary action buttons
  primaryAction,
  /// Authentication-related buttons
  auth,
  /// Subscription/paywall triggers
  paywall,
  /// Settings and profile access
  settings,
  /// Search functionality
  search,
  /// Core user flow elements
  coreFlow,
}

/// Severity of failure for a critical element
enum FailureSeverity {
  /// App is unusable - blocks all flows
  critical,
  /// Major feature broken - significant user impact
  major,
  /// Important feature degraded - user workaround exists
  important,
}

/// Definition of a critical UI element
class CriticalUIElement {
  const CriticalUIElement({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.severity,
    required this.sourceRoute,
    this.targetRoute,
    this.targetAction,
    required this.findStrategy,
    this.authRequired = false,
    this.premiumRequired = false,
  });

  /// Unique identifier for this element
  final String id;

  /// Human-readable name
  final String name;

  /// Description of what this element does
  final String description;

  /// Classification type
  final CriticalUIType type;

  /// How severe is a failure of this element
  final FailureSeverity severity;

  /// Route where this element is found
  final String sourceRoute;

  /// Route this element navigates to (if navigation element)
  final String? targetRoute;

  /// Action this element triggers (if not navigation)
  final String? targetAction;

  /// Strategy to find this element in the widget tree
  final CriticalUIFindStrategy findStrategy;

  /// Whether this element requires authenticated user
  final bool authRequired;

  /// Whether this element requires premium subscription
  final bool premiumRequired;
}

/// Strategy for finding a critical UI element
class CriticalUIFindStrategy {
  const CriticalUIFindStrategy({
    this.byKey,
    this.byIcon,
    this.byText,
    this.byType,
    this.byTooltip,
    this.bySemanticLabel,
  });

  /// Find by ValueKey
  final String? byKey;

  /// Find by Icon
  final IconData? byIcon;

  /// Find by text content
  final String? byText;

  /// Find by widget type name
  final String? byType;

  /// Find by tooltip
  final String? byTooltip;

  /// Find by semantic label (accessibility)
  final String? bySemanticLabel;

  /// Returns true if at least one strategy is defined
  bool get isValid =>
      byKey != null ||
      byIcon != null ||
      byText != null ||
      byType != null ||
      byTooltip != null ||
      bySemanticLabel != null;
}

/// ═══════════════════════════════════════════════════════════════════════════
/// PROTECTED SET - Critical UI Elements Registry
/// ═══════════════════════════════════════════════════════════════════════════
///
/// This list defines ALL critical UI elements that must be protected.
/// Each element will have:
/// - Existence tests
/// - Visibility tests
/// - Clickability tests
/// - Navigation/action verification tests
/// - Chaos resilience tests
///
/// MODIFYING THIS LIST REQUIRES REVIEW - it affects CI gates
/// ═══════════════════════════════════════════════════════════════════════════

const List<CriticalUIElement> criticalUIElements = [
  // ═══════════════════════════════════════════════════════════════════════════
  // HOME SCREEN - Primary Hub
  // ═══════════════════════════════════════════════════════════════════════════

  CriticalUIElement(
    id: 'home_settings_button',
    name: 'Settings Button (Home)',
    description: 'Settings gear icon in home header - opens settings screen',
    type: CriticalUIType.settings,
    severity: FailureSeverity.major,
    sourceRoute: Routes.home,
    targetRoute: Routes.settings,
    findStrategy: CriticalUIFindStrategy(
      byIcon: Icons.settings,
      byKey: 'home_settings_button',
      byTooltip: 'Ayarlar',
    ),
  ),

  CriticalUIElement(
    id: 'home_search_button',
    name: 'Search Button (Home)',
    description: 'Search icon in home header - opens search dialog or glossary',
    type: CriticalUIType.search,
    severity: FailureSeverity.major,
    sourceRoute: Routes.home,
    targetAction: 'show_search_dialog',
    findStrategy: CriticalUIFindStrategy(
      byIcon: Icons.search,
      byKey: 'home_search_button',
    ),
  ),

  CriticalUIElement(
    id: 'home_profile_button',
    name: 'Profile Button (Home)',
    description: 'Profile/add person icon - manages user profiles',
    type: CriticalUIType.settings,
    severity: FailureSeverity.major,
    sourceRoute: Routes.home,
    targetAction: 'show_profile_dialog',
    findStrategy: CriticalUIFindStrategy(
      byIcon: Icons.person_add,
      byKey: 'home_profile_button',
    ),
  ),

  CriticalUIElement(
    id: 'home_kozmoz_button',
    name: 'KOZMOZ Button (Home)',
    description: 'Main KOZMOZ entry point - all services hub',
    type: CriticalUIType.primaryAction,
    severity: FailureSeverity.critical,
    sourceRoute: Routes.home,
    targetRoute: Routes.kozmoz,
    findStrategy: CriticalUIFindStrategy(
      byKey: 'home_kozmoz_button',
      byText: 'KOZMOZ',
    ),
  ),

  CriticalUIElement(
    id: 'home_chatbot_button',
    name: 'Kozmik İletişim Button',
    description: 'AI Chatbot entry point - cosmic communication',
    type: CriticalUIType.primaryAction,
    severity: FailureSeverity.major,
    sourceRoute: Routes.home,
    targetRoute: Routes.kozmikIletisim,
    findStrategy: CriticalUIFindStrategy(
      byKey: 'home_chatbot_button',
      byText: 'Kozmik İletişim',
    ),
  ),

  CriticalUIElement(
    id: 'home_dream_oracle_button',
    name: 'Rüya Döngüsü Button',
    description: 'Dream Oracle entry point - 7-dimension form',
    type: CriticalUIType.primaryAction,
    severity: FailureSeverity.major,
    sourceRoute: Routes.home,
    targetRoute: Routes.ruyaDongusu,
    findStrategy: CriticalUIFindStrategy(
      byKey: 'home_dream_oracle_button',
      byText: 'Rüya Döngüsü',
    ),
  ),

  CriticalUIElement(
    id: 'home_all_services_button',
    name: 'All Services Button',
    description: 'Navigates to complete services catalog',
    type: CriticalUIType.navigation,
    severity: FailureSeverity.major,
    sourceRoute: Routes.home,
    targetRoute: Routes.allServices,
    findStrategy: CriticalUIFindStrategy(
      byKey: 'home_all_services_button',
      byText: 'Tüm Çözümlemeler',
    ),
  ),

  CriticalUIElement(
    id: 'home_cosmic_share_button',
    name: 'Cosmic Share Button',
    description: 'Share cosmic insights - viral feature',
    type: CriticalUIType.primaryAction,
    severity: FailureSeverity.important,
    sourceRoute: Routes.home,
    targetRoute: Routes.cosmicShare,
    findStrategy: CriticalUIFindStrategy(
      byKey: 'home_cosmic_share_button',
    ),
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // ONBOARDING - User Setup Flow
  // ═══════════════════════════════════════════════════════════════════════════

  CriticalUIElement(
    id: 'onboarding_next_button',
    name: 'Onboarding Next Button',
    description: 'Advances to next onboarding step',
    type: CriticalUIType.coreFlow,
    severity: FailureSeverity.critical,
    sourceRoute: Routes.onboarding,
    targetAction: 'next_page',
    findStrategy: CriticalUIFindStrategy(
      byKey: 'onboarding_next_button',
      byText: 'Devam',
    ),
  ),

  CriticalUIElement(
    id: 'onboarding_complete_button',
    name: 'Onboarding Complete Button',
    description: 'Completes onboarding and navigates to home',
    type: CriticalUIType.coreFlow,
    severity: FailureSeverity.critical,
    sourceRoute: Routes.onboarding,
    targetRoute: Routes.home,
    findStrategy: CriticalUIFindStrategy(
      byKey: 'onboarding_complete_button',
      byText: 'Başla',
    ),
  ),

  CriticalUIElement(
    id: 'onboarding_name_input',
    name: 'Name Input Field',
    description: 'User enters their name - required for profile',
    type: CriticalUIType.coreFlow,
    severity: FailureSeverity.critical,
    sourceRoute: Routes.onboarding,
    targetAction: 'input_name',
    findStrategy: CriticalUIFindStrategy(
      byKey: 'onboarding_name_input',
      byType: 'TextField',
    ),
  ),

  CriticalUIElement(
    id: 'onboarding_birthdate_picker',
    name: 'Birth Date Picker',
    description: 'User selects birth date - required for astrology',
    type: CriticalUIType.coreFlow,
    severity: FailureSeverity.critical,
    sourceRoute: Routes.onboarding,
    targetAction: 'select_birthdate',
    findStrategy: CriticalUIFindStrategy(
      byKey: 'onboarding_birthdate_picker',
    ),
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // AUTHENTICATION - Login/Logout
  // ═══════════════════════════════════════════════════════════════════════════

  CriticalUIElement(
    id: 'login_apple_button',
    name: 'Apple Sign In Button',
    description: 'Sign in with Apple - primary auth method',
    type: CriticalUIType.auth,
    severity: FailureSeverity.critical,
    sourceRoute: '/login',
    targetAction: 'sign_in_apple',
    findStrategy: CriticalUIFindStrategy(
      byKey: 'login_apple_button',
      byText: 'Apple ile Giriş',
    ),
  ),

  CriticalUIElement(
    id: 'login_email_button',
    name: 'Email Sign In Button',
    description: 'Sign in with email - alternative auth',
    type: CriticalUIType.auth,
    severity: FailureSeverity.major,
    sourceRoute: '/login',
    targetAction: 'navigate_email_login',
    findStrategy: CriticalUIFindStrategy(
      byKey: 'login_email_button',
      byText: 'E-posta ile Giriş',
    ),
  ),

  CriticalUIElement(
    id: 'login_skip_button',
    name: 'Skip Login Button',
    description: 'Skip authentication - go to onboarding',
    type: CriticalUIType.auth,
    severity: FailureSeverity.major,
    sourceRoute: '/login',
    targetRoute: Routes.onboarding,
    findStrategy: CriticalUIFindStrategy(
      byKey: 'login_skip_button',
      byText: 'Atla',
    ),
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // SETTINGS SCREEN
  // ═══════════════════════════════════════════════════════════════════════════

  CriticalUIElement(
    id: 'settings_back_button',
    name: 'Settings Back Button',
    description: 'Returns from settings to previous screen',
    type: CriticalUIType.navigation,
    severity: FailureSeverity.major,
    sourceRoute: Routes.settings,
    targetAction: 'pop',
    findStrategy: CriticalUIFindStrategy(
      byIcon: Icons.arrow_back,
      byKey: 'settings_back_button',
    ),
  ),

  CriticalUIElement(
    id: 'settings_theme_toggle',
    name: 'Theme Toggle',
    description: 'Switch between light/dark mode',
    type: CriticalUIType.settings,
    severity: FailureSeverity.important,
    sourceRoute: Routes.settings,
    targetAction: 'toggle_theme',
    findStrategy: CriticalUIFindStrategy(
      byKey: 'settings_theme_toggle',
    ),
  ),

  CriticalUIElement(
    id: 'settings_language_selector',
    name: 'Language Selector',
    description: 'Change app language',
    type: CriticalUIType.settings,
    severity: FailureSeverity.important,
    sourceRoute: Routes.settings,
    targetAction: 'change_language',
    findStrategy: CriticalUIFindStrategy(
      byKey: 'settings_language_selector',
    ),
  ),

  CriticalUIElement(
    id: 'settings_profile_link',
    name: 'Profile Settings Link',
    description: 'Navigate to profile management',
    type: CriticalUIType.settings,
    severity: FailureSeverity.major,
    sourceRoute: Routes.settings,
    targetRoute: Routes.profile,
    findStrategy: CriticalUIFindStrategy(
      byKey: 'settings_profile_link',
      byText: 'Profil',
    ),
  ),

  CriticalUIElement(
    id: 'settings_saved_profiles_link',
    name: 'Saved Profiles Link',
    description: 'Navigate to saved profiles list',
    type: CriticalUIType.settings,
    severity: FailureSeverity.major,
    sourceRoute: Routes.settings,
    targetRoute: Routes.savedProfiles,
    findStrategy: CriticalUIFindStrategy(
      byKey: 'settings_saved_profiles_link',
      byText: 'Kayıtlı Profiller',
    ),
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // PREMIUM / PAYWALL
  // ═══════════════════════════════════════════════════════════════════════════

  CriticalUIElement(
    id: 'premium_close_button',
    name: 'Premium Close Button',
    description: 'Close premium screen without purchasing',
    type: CriticalUIType.paywall,
    severity: FailureSeverity.critical,
    sourceRoute: Routes.premium,
    targetAction: 'pop',
    findStrategy: CriticalUIFindStrategy(
      byIcon: Icons.close,
      byKey: 'premium_close_button',
    ),
  ),

  CriticalUIElement(
    id: 'premium_purchase_button',
    name: 'Premium Purchase Button',
    description: 'Initiates in-app purchase flow',
    type: CriticalUIType.paywall,
    severity: FailureSeverity.critical,
    sourceRoute: Routes.premium,
    targetAction: 'purchase',
    findStrategy: CriticalUIFindStrategy(
      byKey: 'premium_purchase_button',
      byText: 'Satın Al',
    ),
  ),

  CriticalUIElement(
    id: 'premium_restore_button',
    name: 'Restore Purchases Button',
    description: 'Restores previous purchases',
    type: CriticalUIType.paywall,
    severity: FailureSeverity.major,
    sourceRoute: Routes.premium,
    targetAction: 'restore_purchases',
    findStrategy: CriticalUIFindStrategy(
      byKey: 'premium_restore_button',
      byText: 'Satın Alımları Geri Yükle',
    ),
  ),

  CriticalUIElement(
    id: 'premium_plan_yearly',
    name: 'Yearly Plan Option',
    description: 'Select yearly subscription plan',
    type: CriticalUIType.paywall,
    severity: FailureSeverity.major,
    sourceRoute: Routes.premium,
    targetAction: 'select_yearly',
    findStrategy: CriticalUIFindStrategy(
      byKey: 'premium_plan_yearly',
    ),
  ),

  CriticalUIElement(
    id: 'premium_plan_monthly',
    name: 'Monthly Plan Option',
    description: 'Select monthly subscription plan',
    type: CriticalUIType.paywall,
    severity: FailureSeverity.major,
    sourceRoute: Routes.premium,
    targetAction: 'select_monthly',
    findStrategy: CriticalUIFindStrategy(
      byKey: 'premium_plan_monthly',
    ),
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // PROFILE MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════

  CriticalUIElement(
    id: 'profile_back_button',
    name: 'Profile Back Button',
    description: 'Returns from profile to previous screen',
    type: CriticalUIType.navigation,
    severity: FailureSeverity.major,
    sourceRoute: Routes.profile,
    targetAction: 'pop',
    findStrategy: CriticalUIFindStrategy(
      byIcon: Icons.arrow_back,
      byKey: 'profile_back_button',
    ),
  ),

  CriticalUIElement(
    id: 'profile_edit_button',
    name: 'Profile Edit Button',
    description: 'Enable profile editing mode',
    type: CriticalUIType.settings,
    severity: FailureSeverity.major,
    sourceRoute: Routes.profile,
    targetAction: 'edit_profile',
    findStrategy: CriticalUIFindStrategy(
      byIcon: Icons.edit,
      byKey: 'profile_edit_button',
    ),
  ),

  CriticalUIElement(
    id: 'saved_profiles_add_button',
    name: 'Add Profile Button',
    description: 'Add a new profile to saved list',
    type: CriticalUIType.settings,
    severity: FailureSeverity.major,
    sourceRoute: Routes.savedProfiles,
    targetAction: 'add_profile',
    findStrategy: CriticalUIFindStrategy(
      byIcon: Icons.add,
      byKey: 'saved_profiles_add_button',
    ),
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // SEARCH / GLOSSARY
  // ═══════════════════════════════════════════════════════════════════════════

  CriticalUIElement(
    id: 'glossary_search_input',
    name: 'Glossary Search Input',
    description: 'Search field in glossary screen',
    type: CriticalUIType.search,
    severity: FailureSeverity.major,
    sourceRoute: Routes.glossary,
    targetAction: 'search',
    findStrategy: CriticalUIFindStrategy(
      byKey: 'glossary_search_input',
      byType: 'TextField',
    ),
  ),

  CriticalUIElement(
    id: 'glossary_back_button',
    name: 'Glossary Back Button',
    description: 'Returns from glossary to previous screen',
    type: CriticalUIType.navigation,
    severity: FailureSeverity.major,
    sourceRoute: Routes.glossary,
    targetAction: 'pop',
    findStrategy: CriticalUIFindStrategy(
      byIcon: Icons.arrow_back,
      byKey: 'glossary_back_button',
    ),
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // ALL SERVICES HUB
  // ═══════════════════════════════════════════════════════════════════════════

  CriticalUIElement(
    id: 'all_services_back_button',
    name: 'All Services Back Button',
    description: 'Returns from services catalog',
    type: CriticalUIType.navigation,
    severity: FailureSeverity.major,
    sourceRoute: Routes.allServices,
    targetAction: 'pop',
    findStrategy: CriticalUIFindStrategy(
      byIcon: Icons.arrow_back,
      byKey: 'all_services_back_button',
    ),
  ),

  CriticalUIElement(
    id: 'all_services_horoscope_card',
    name: 'Horoscope Service Card',
    description: 'Navigates to horoscope feature',
    type: CriticalUIType.navigation,
    severity: FailureSeverity.major,
    sourceRoute: Routes.allServices,
    targetRoute: Routes.horoscope,
    findStrategy: CriticalUIFindStrategy(
      byKey: 'all_services_horoscope_card',
    ),
  ),

  CriticalUIElement(
    id: 'all_services_numerology_card',
    name: 'Numerology Service Card',
    description: 'Navigates to numerology feature',
    type: CriticalUIType.navigation,
    severity: FailureSeverity.major,
    sourceRoute: Routes.allServices,
    targetRoute: Routes.numerology,
    findStrategy: CriticalUIFindStrategy(
      byKey: 'all_services_numerology_card',
    ),
  ),

  CriticalUIElement(
    id: 'all_services_tarot_card',
    name: 'Tarot Service Card',
    description: 'Navigates to tarot feature',
    type: CriticalUIType.navigation,
    severity: FailureSeverity.major,
    sourceRoute: Routes.allServices,
    targetRoute: Routes.tarot,
    findStrategy: CriticalUIFindStrategy(
      byKey: 'all_services_tarot_card',
    ),
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // HOROSCOPE - Core Feature
  // ═══════════════════════════════════════════════════════════════════════════

  CriticalUIElement(
    id: 'horoscope_back_button',
    name: 'Horoscope Back Button',
    description: 'Returns from horoscope screen',
    type: CriticalUIType.navigation,
    severity: FailureSeverity.major,
    sourceRoute: Routes.horoscope,
    targetAction: 'pop',
    findStrategy: CriticalUIFindStrategy(
      byIcon: Icons.arrow_back,
      byKey: 'horoscope_back_button',
    ),
  ),

  CriticalUIElement(
    id: 'horoscope_sign_card',
    name: 'Zodiac Sign Card',
    description: 'Tappable zodiac sign card for detail view',
    type: CriticalUIType.navigation,
    severity: FailureSeverity.major,
    sourceRoute: Routes.horoscope,
    targetRoute: Routes.horoscopeDetail,
    findStrategy: CriticalUIFindStrategy(
      byKey: 'horoscope_sign_card',
    ),
  ),

  // ═══════════════════════════════════════════════════════════════════════════
  // ADMIN ACCESS
  // ═══════════════════════════════════════════════════════════════════════════

  CriticalUIElement(
    id: 'admin_login_submit',
    name: 'Admin Login Submit',
    description: 'Submit PIN for admin access',
    type: CriticalUIType.auth,
    severity: FailureSeverity.important,
    sourceRoute: Routes.adminLogin,
    targetRoute: Routes.admin,
    findStrategy: CriticalUIFindStrategy(
      byKey: 'admin_login_submit',
      byText: 'Giriş',
    ),
    authRequired: true,
  ),
];

/// ═══════════════════════════════════════════════════════════════════════════
/// HELPER FUNCTIONS
/// ═══════════════════════════════════════════════════════════════════════════

/// Get all critical elements for a specific route
List<CriticalUIElement> getCriticalElementsForRoute(String route) {
  return criticalUIElements
      .where((e) => e.sourceRoute == route)
      .toList();
}

/// Get all critical elements by type
List<CriticalUIElement> getCriticalElementsByType(CriticalUIType type) {
  return criticalUIElements
      .where((e) => e.type == type)
      .toList();
}

/// Get all critical elements by severity
List<CriticalUIElement> getCriticalElementsBySeverity(FailureSeverity severity) {
  return criticalUIElements
      .where((e) => e.severity == severity)
      .toList();
}

/// Get all CRITICAL severity elements (must never fail)
List<CriticalUIElement> getMustNotFailElements() {
  return getCriticalElementsBySeverity(FailureSeverity.critical);
}

/// Get count of critical elements
int get criticalElementCount => criticalUIElements.length;

/// Get count by severity
Map<FailureSeverity, int> get criticalElementCountBySeverity {
  return {
    for (final severity in FailureSeverity.values)
      severity: criticalUIElements.where((e) => e.severity == severity).length,
  };
}
