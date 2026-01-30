# Venus Logo A/B Testing Specification

## Overview

This document outlines the A/B testing strategy for the Venus logo implementation across the AstroBoBo (Venus One) application.

---

## Test Objectives

### Primary Goals
- Validate user preference for pearl/blush aesthetic vs alternatives
- Measure brand recognition and recall
- Optimize logo placement for engagement
- Determine ideal sizing across breakpoints

### Success Metrics
| Metric | Target | Measurement Method |
|--------|--------|-------------------|
| Brand recall | >70% | Post-session survey |
| Logo click-through | +15% vs control | Analytics events |
| Time to first action | -10% | Session tracking |
| User preference | >60% majority | In-app feedback |

---

## Test Variants

### Test 1: Color Temperature

**Hypothesis:** Pearl/blush warm tones increase trust and engagement for astrology content.

| Variant | Description | Colors |
|---------|-------------|--------|
| A (Control) | Pearl/Blush gradient | `#FFF5F0` → `#D8968E` |
| B | Cool lavender gradient | `#F5F0FF` → `#8E8ED8` |
| C | Neutral silver gradient | `#F5F5F5` → `#9E9E9E` |

**Duration:** 2 weeks
**Traffic Split:** 34% / 33% / 33%
**Segment:** New users only

---

### Test 2: Logo Complexity

**Hypothesis:** Simplified logo performs better on mobile; detailed logo on desktop.

| Variant | Description | Use Case |
|---------|-------------|----------|
| A (Control) | Full gradient with highlights | All devices |
| B | Simplified flat version | Mobile only |
| C | Adaptive (full desktop, flat mobile) | Responsive |

**Duration:** 3 weeks
**Traffic Split:** 33% / 33% / 34%
**Segment:** All users

---

### Test 3: Logo Placement (Mobile)

**Hypothesis:** Header placement drives more brand awareness; nav placement drives more engagement.

| Variant | Position | Behavior |
|---------|----------|----------|
| A (Control) | Top header, centered | Static |
| B | Top header, left-aligned | Static |
| C | Bottom nav, icon only | Interactive |

**Duration:** 2 weeks
**Traffic Split:** 34% / 33% / 33%
**Segment:** Mobile users only

---

### Test 4: Splash Screen Duration

**Hypothesis:** Optimal splash duration balances brand exposure with user patience.

| Variant | Duration | Animation |
|---------|----------|-----------|
| A (Control) | 2.0s | Fade in/out |
| B | 1.5s | Quick fade |
| C | 2.5s | Pulse + fade |

**Duration:** 2 weeks
**Traffic Split:** 34% / 33% / 33%
**Segment:** All users

---

### Test 5: Favicon Recognition

**Hypothesis:** Simplified favicon improves browser tab recognition.

| Variant | Style | Detail Level |
|---------|-------|--------------|
| A (Control) | Full gradient | High |
| B | Solid blush fill | Medium |
| C | Outline only | Low |

**Duration:** 4 weeks
**Traffic Split:** 34% / 33% / 33%
**Segment:** Web users only

---

## Implementation Guidelines

### Event Tracking

```javascript
// Logo impression
analytics.track('logo_impression', {
  variant: 'A',
  test_id: 'color_temperature_v1',
  placement: 'header',
  device_type: 'mobile'
});

// Logo interaction
analytics.track('logo_click', {
  variant: 'A',
  test_id: 'color_temperature_v1',
  destination: 'home'
});
```

### Flutter Implementation

```dart
// Feature flag check
final logoVariant = RemoteConfig.getString('logo_variant');

// Conditional rendering
Widget buildLogo() {
  switch (logoVariant) {
    case 'B':
      return VenusLogoCool();
    case 'C':
      return VenusLogoNeutral();
    default:
      return VenusLogoPearlBlush(); // Control
  }
}
```

### Asset Requirements per Variant

Each variant requires:
- [ ] Master SVG
- [ ] PNG exports (256, 512, 1024)
- [ ] Favicon set (16, 32, ICO)
- [ ] PWA icons (192, 512)
- [ ] Splash screens (iOS, Android)

---

## Statistical Significance

### Sample Size Requirements

| Test | Min Sample/Variant | Power | Confidence |
|------|-------------------|-------|------------|
| Color Temperature | 1,500 | 80% | 95% |
| Logo Complexity | 2,000 | 80% | 95% |
| Placement | 1,000 | 80% | 95% |
| Splash Duration | 1,500 | 80% | 95% |
| Favicon | 3,000 | 80% | 95% |

### Analysis Plan

1. **Primary analysis:** Chi-square test for categorical outcomes
2. **Secondary analysis:** T-test for continuous metrics
3. **Segmentation:** Device type, user tenure, zodiac sign
4. **Guardrail metrics:** App crashes, load time, bounce rate

---

## Rollout Plan

### Phase 1: Internal Testing (Week 1)
- Deploy all variants to internal team
- Validate tracking implementation
- QA visual consistency

### Phase 2: Beta Testing (Weeks 2-3)
- 10% of users receive test variants
- Monitor guardrail metrics
- Collect qualitative feedback

### Phase 3: Full Testing (Weeks 4-7)
- Scale to full traffic allocation
- Run each test to statistical significance
- Document interim learnings

### Phase 4: Winner Rollout (Week 8+)
- Graduate winning variants to 100%
- Archive losing variants
- Update brand assets accordingly

---

## Risk Mitigation

| Risk | Mitigation |
|------|------------|
| Brand confusion | Limit tests to new users initially |
| Performance impact | Lazy-load variant assets |
| Tracking gaps | Pre-launch QA checklist |
| Inconclusive results | Extend duration, not traffic |

---

## Stakeholder Sign-off

| Role | Name | Approved |
|------|------|----------|
| Product | | ☐ |
| Design | | ☐ |
| Engineering | | ☐ |
| Marketing | | ☐ |

---

## Appendix

### Related Documents
- Brand Guidelines: `BRAND_GUIDELINES.md`
- Color Definitions: `lib/core/theme/mystical_colors.dart`
- PWA Manifest: `pwa/manifest.json`

### Version History
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-31 | — | Initial specification |
