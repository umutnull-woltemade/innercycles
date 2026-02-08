// ════════════════════════════════════════════════════════════════════════════
// CONTENT SAFETY FILTER - App Store 4.3(b) Runtime Compliance
// ════════════════════════════════════════════════════════════════════════════
//
// This service filters AI-generated content to ensure App Store compliance.
// It blocks prediction/fortune-telling language and replaces with safe alternatives.
//
// USAGE:
// ```typescript
// import { safetyFilter } from '@lumera/content-safety';
// const result = safetyFilter.filter(aiResponse, 'en');
// ```
// ════════════════════════════════════════════════════════════════════════════

import {
  FORBIDDEN_REGEX_EN,
  FORBIDDEN_REGEX_TR,
  SAFE_REPLACEMENTS,
  categorizePhrase,
  ViolationCategory
} from './forbidden-phrases';

// ══════════════════════════════════════════════════════════════════════════
// TYPES
// ══════════════════════════════════════════════════════════════════════════

export type Locale = 'en' | 'tr';
export type SafetyAction = 'pass' | 'rewrite' | 'block';

export interface Violation {
  phrase: string;
  position: number;
  category: ViolationCategory;
  replacement?: string;
}

export interface SafetyResult {
  safe: boolean;
  original: string;
  sanitized: string;
  violations: Violation[];
  action: SafetyAction;
}

export interface SafetyEvent {
  timestamp: string;
  source: string;
  locale: Locale;
  action: SafetyAction;
  violationCount: number;
  violationCategories: ViolationCategory[];
}

// ══════════════════════════════════════════════════════════════════════════
// NEUTRAL FALLBACKS
// ══════════════════════════════════════════════════════════════════════════

const NEUTRAL_FALLBACKS: Record<Locale, string> = {
  en: 'Take a moment to reflect on your thoughts and feelings today.',
  tr: 'Bugün düşünceleriniz ve duygularınız üzerine düşünmek için bir an ayırın.'
};

// ══════════════════════════════════════════════════════════════════════════
// CONTENT SAFETY FILTER CLASS
// ══════════════════════════════════════════════════════════════════════════

export class ContentSafetyFilter {
  private static instance: ContentSafetyFilter;

  private constructor() {}

  /**
   * Get singleton instance
   */
  static getInstance(): ContentSafetyFilter {
    if (!ContentSafetyFilter.instance) {
      ContentSafetyFilter.instance = new ContentSafetyFilter();
    }
    return ContentSafetyFilter.instance;
  }

  /**
   * Main filter method - sanitizes content for Apple compliance
   */
  filter(content: string, locale: Locale = 'en'): SafetyResult {
    if (!content || content.trim().length === 0) {
      return {
        safe: true,
        original: content,
        sanitized: content,
        violations: [],
        action: 'pass'
      };
    }

    const violations = this.detectViolations(content, locale);

    if (violations.length === 0) {
      return {
        safe: true,
        original: content,
        sanitized: content,
        violations: [],
        action: 'pass'
      };
    }

    // Attempt rewrite
    const rewriteResult = this.attemptRewrite(content, violations);

    if (rewriteResult.success) {
      return {
        safe: false,
        original: content,
        sanitized: rewriteResult.content,
        violations,
        action: 'rewrite'
      };
    }

    // Cannot rewrite - block with neutral fallback
    return {
      safe: false,
      original: content,
      sanitized: NEUTRAL_FALLBACKS[locale],
      violations,
      action: 'block'
    };
  }

  /**
   * Quick check without sanitization
   */
  isSafe(content: string, locale: Locale = 'en'): boolean {
    if (!content || content.trim().length === 0) {
      return true;
    }

    const regex = locale === 'en' ? FORBIDDEN_REGEX_EN : FORBIDDEN_REGEX_TR;
    // Reset regex lastIndex
    regex.lastIndex = 0;
    return !regex.test(content);
  }

  /**
   * Detect all violations in content
   */
  detectViolations(content: string, locale: Locale = 'en'): Violation[] {
    const violations: Violation[] = [];
    const regex = locale === 'en' ? FORBIDDEN_REGEX_EN : FORBIDDEN_REGEX_TR;

    // Reset regex lastIndex
    regex.lastIndex = 0;

    let match;
    while ((match = regex.exec(content)) !== null) {
      const phrase = match[0];
      const lowerPhrase = phrase.toLowerCase();

      violations.push({
        phrase,
        position: match.index,
        category: categorizePhrase(phrase),
        replacement: SAFE_REPLACEMENTS[lowerPhrase]
      });
    }

    return violations;
  }

  /**
   * Attempt to rewrite content by replacing violations
   */
  private attemptRewrite(
    content: string,
    violations: Violation[]
  ): { success: boolean; content: string } {
    let result = content;
    let allReplaced = true;

    for (const violation of violations) {
      if (violation.replacement) {
        // Preserve original case pattern
        const replacement = this.matchCase(violation.phrase, violation.replacement);
        result = result.replace(
          new RegExp(`\\b${this.escapeRegex(violation.phrase)}\\b`, 'gi'),
          replacement
        );
      } else {
        allReplaced = false;
      }
    }

    return {
      success: allReplaced,
      content: result
    };
  }

  /**
   * Match the case pattern of the original phrase
   */
  private matchCase(original: string, replacement: string): string {
    if (original === original.toUpperCase()) {
      return replacement.toUpperCase();
    }
    if (original[0] === original[0].toUpperCase()) {
      return replacement.charAt(0).toUpperCase() + replacement.slice(1);
    }
    return replacement.toLowerCase();
  }

  /**
   * Escape special regex characters
   */
  private escapeRegex(str: string): string {
    return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  }

  /**
   * Create a safety event object for logging
   */
  createEvent(
    result: SafetyResult,
    context: { source: string; locale: Locale }
  ): SafetyEvent {
    return {
      timestamp: new Date().toISOString(),
      source: context.source,
      locale: context.locale,
      action: result.action,
      violationCount: result.violations.length,
      violationCategories: result.violations.map(v => v.category)
    };
  }

  /**
   * Log safety event (privacy-safe - no content logged)
   */
  logEvent(event: SafetyEvent): void {
    console.log('[SAFETY]', JSON.stringify(event));
  }

  /**
   * Filter and log in one step
   */
  filterAndLog(
    content: string,
    context: { source: string; locale: Locale }
  ): SafetyResult {
    const result = this.filter(content, context.locale);

    if (!result.safe) {
      const event = this.createEvent(result, context);
      this.logEvent(event);
    }

    return result;
  }
}

// ══════════════════════════════════════════════════════════════════════════
// EXPORTS
// ══════════════════════════════════════════════════════════════════════════

export const safetyFilter = ContentSafetyFilter.getInstance();

// Re-export types and utilities
export { ViolationCategory, categorizePhrase } from './forbidden-phrases';
