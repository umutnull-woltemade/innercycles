# Venus One - App Store 4.3(b) Pre-Submission Checklist

## Before Submitting

### Feature Flag Verification
- [ ] `FeatureFlags.appStoreReviewMode = true` in `lib/core/config/feature_flags.dart`
- [ ] Build and verify hidden features are inaccessible
- [ ] Test: Navigate to `/horoscope` → Should redirect to `/insight`
- [ ] Test: Navigate to `/kozmoz` → Should redirect to `/insight`
- [ ] Test: Navigate to `/year-ahead` → Should redirect to `/insight`

### Onboarding Flow Verification
- [ ] Launch app fresh (clear data)
- [ ] Onboarding Page 3 shows "Profile Ready" NOT zodiac sign reveal
- [ ] No "You are a Leo!" or similar messaging
- [ ] No zodiac symbol prominently displayed

### First 2-Minute Flow Verification
- [ ] Launch shows reflection messaging, not astrology
- [ ] First screen after onboarding is Insight/Reflection
- [ ] User must type before receiving any content
- [ ] AI response contains no future claims
- [ ] Disclaimer visible on primary screens

### Language Audit
- [ ] No "destiny" visible in UI (check numerology screens)
- [ ] No "awaits you" visible anywhere
- [ ] No "fortune" or "fate" visible
- [ ] No "stars say" or "cosmic reveals" visible
- [ ] No "what does your future hold" visible

### App Store Metadata
- [ ] Description uploaded from `app_store_metadata/description.txt`
- [ ] Subtitle: "Mindful Journaling & Insights"
- [ ] Keywords exclude: astrology, horoscope, zodiac, fortune, tarot, prediction
- [ ] App Review Notes copied from `app_store_metadata/app_review_notes.txt`
- [ ] Screenshots show journaling interface, not horoscopes

### Build Steps
1. [ ] Run `flutter clean`
2. [ ] Run `flutter pub get`
3. [ ] Run `flutter build ios --release`
4. [ ] Archive in Xcode
5. [ ] Upload to App Store Connect
6. [ ] Update all metadata
7. [ ] Submit for review

## Common Re-Rejection Risks

| Risk | How to Verify |
|------|---------------|
| Hidden features discovered | Test all blocked routes return 404 or redirect |
| Zodiac sign appears anywhere | Search codebase for `.sunSign` usage |
| "Daily" tied to zodiac | Ensure no sign-based content on home |
| Tarot spreads visible | Verify tarot feature is hidden |
| Dream interpretation too mystical | Check dream responses are psychological only |
| Numerology says "destiny" | Verify "Expression Number" label used |
| AI generates prediction | Test with sample inputs, check responses |

## After Approval

When the app is approved, you can re-enable features:

1. Set `FeatureFlags.appStoreReviewMode = false`
2. Build and submit update
3. Features will gradually become available

## Emergency Rollback

If rejected again:
1. Review rejection reason carefully
2. Identify specific triggering content
3. Add to blocked routes/feature flags
4. Resubmit with updated App Review Notes explaining changes
