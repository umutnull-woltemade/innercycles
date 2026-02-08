// ════════════════════════════════════════════════════════════════════════════
// @lumera/content-safety
// ════════════════════════════════════════════════════════════════════════════
//
// Content safety filter for Apple App Store 4.3(b) compliance.
// Blocks astrology, prediction, and fortune-telling language.
//
// USAGE:
// ```typescript
// import { safetyFilter } from '@lumera/content-safety';
//
// // Quick check
// if (safetyFilter.isSafe(content, 'en')) {
//   // Content is safe
// }
//
// // Full filter with sanitization
// const result = safetyFilter.filter(content, 'en');
// console.log(result.sanitized);
// console.log(result.action); // 'pass' | 'rewrite' | 'block'
// ```
// ════════════════════════════════════════════════════════════════════════════

// Main filter
export {
  ContentSafetyFilter,
  safetyFilter,
  type Locale,
  type SafetyAction,
  type SafetyResult,
  type SafetyEvent,
  type Violation
} from './safety-filter';

// Forbidden phrases and utilities
export {
  FORBIDDEN_PHRASES_EN,
  FORBIDDEN_PHRASES_TR,
  FORBIDDEN_REGEX_EN,
  FORBIDDEN_REGEX_TR,
  SAFE_REPLACEMENTS,
  categorizePhrase,
  type ViolationCategory
} from './forbidden-phrases';
