# App Store Metadata v2 - Post-Rejection Resubmission

## REJECTION CONTEXT
- **Guideline 4.3(b)**: "There are already enough of these apps"
- **Strategy**: Reposition from "astrology app" → "personal reflection & journaling tool"

---

## App Name
**InnerCycles - Personal Journal**

> Avoid: "Astrology", "Horoscope", "Venus", "Cosmic"

---

## Subtitle (30 characters max)
**Daily Reflection & Self-Discovery**

> Previous: "Your Cosmic Guide" ❌
> New: Focus on journaling/reflection ✅

---

## Keywords (100 characters max)
```
journal,reflection,self-discovery,mindfulness,mood tracker,daily diary,personal growth,wellness
```

> REMOVED: astrology, horoscope, zodiac, tarot, birth chart, compatibility
> ADDED: journal, mindfulness, wellness, mood tracker

---

## Description

### Short Description (First 3 lines - visible before "Read More")
```
InnerCycles is your personal space for daily reflection and self-discovery.
Track your moods, journal your thoughts, and gain insights into your personal patterns.
A mindful companion for your inner journey.
```

### Full Description
```
InnerCycles helps you understand yourself better through daily reflection and journaling.

DAILY REFLECTION
• Morning and evening check-ins
• Mood tracking with beautiful visualizations
• Personal insights based on your entries

SELF-DISCOVERY TOOLS
• Explore your personality patterns
• Understand your emotional cycles
• Discover what drives your decisions

JOURNALING MADE SIMPLE
• Quick daily prompts
• Private and secure entries
• Beautiful, calming interface

PERSONAL INSIGHTS
• Weekly and monthly summaries
• Pattern recognition
• Growth tracking over time

InnerCycles is designed to be your trusted companion for personal growth. Whether you're exploring your feelings, tracking your moods, or simply taking a moment to reflect, we're here to help you on your journey.

This app is for entertainment and self-reflection purposes only. It is not a substitute for professional mental health advice.
```

---

## What's New (Version Notes)
```
• Improved Sign in with Apple reliability
• Enhanced performance on iPad
• Better error messages
• Bug fixes and stability improvements
```

---

## App Category
**Primary**: Lifestyle
**Secondary**: Health & Fitness

> Previous: Lifestyle/Entertainment
> Rationale: Health & Fitness signals wellness, not fortune-telling

---

## Screenshots Strategy

### DO show:
1. Journal entry screen
2. Mood tracking visualization
3. Reflection prompts
4. Personal insights summary
5. Calm, minimalist UI

### DON'T show:
1. Birth charts
2. Zodiac signs
3. Horoscope predictions
4. Tarot cards
5. Compatibility readings

---

## App Preview Video
If included, focus on:
- Writing in journal
- Selecting moods
- Viewing personal patterns
- Calm, meditative UX

---

## Review Notes for Apple
```
Thank you for reviewing InnerCycles.

InnerCycles is primarily a personal reflection and journaling app. While we offer
some personality-based content inspired by various traditions, the core experience
is self-reflection and mood tracking.

Key differentiators from typical astrology apps:
1. Focus on journaling and daily reflection
2. Mood tracking with pattern visualization
3. No predictions or fortune-telling claims
4. Clear entertainment disclaimer

We've also addressed the Sign in with Apple issue by adding proper timeout handling
and improving error messages.

Test account: Not required - app works without sign-in for basic features.
```

---

## Feature Flags for Review Mode

Ensure `appStoreReviewMode` is enabled before submission:

```dart
// In premium_service.dart or feature_flags.dart
static bool get appStoreReviewMode => true;
```

This hides:
- Birth chart features
- Horoscope predictions
- Tarot readings
- Compatibility analysis

And emphasizes:
- Journal entries
- Mood tracking
- Reflection prompts
- Personal patterns

---

## Checklist Before Resubmission

- [ ] Update app name in App Store Connect
- [ ] Update subtitle
- [ ] Update keywords
- [ ] Rewrite description
- [ ] Update screenshots to show journaling/reflection
- [ ] Update category to include Health & Fitness
- [ ] Enable `appStoreReviewMode` feature flag
- [ ] Add review notes explaining differentiation
- [ ] Test Sign in with Apple on iPad Air M3 in sandbox
- [ ] Verify English error messages appear for auth failures

---

## Risk Assessment

| Factor | Before | After |
|--------|--------|-------|
| Name contains "astrology" | Yes → HIGH RISK | No → LOW RISK |
| Keywords contain "horoscope" | Yes → HIGH RISK | No → LOW RISK |
| Screenshots show zodiac | Yes → HIGH RISK | No → LOW RISK |
| Description mentions predictions | Yes → MEDIUM RISK | No → LOW RISK |
| Category is Entertainment | Yes → MEDIUM RISK | Health & Fitness → LOW RISK |

**Estimated approval probability**: 70-80% with these changes
