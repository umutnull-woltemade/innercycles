# InnerCycles - App Store Pre-Submission Checklist

## Before Submitting

### Content Compliance Verification
- [ ] No prediction language visible ("will happen", "your future", "destiny")
- [ ] No astrology/horoscope/zodiac terminology in user-facing text
- [ ] All personality content uses archetype framing (The Pioneer, The Builder, etc.)
- [ ] Dream interpretations use psychological framing, not mystical
- [ ] All reflective language: "past entries suggest...", "you may notice..."
- [ ] Disclaimers visible on primary screens

### Onboarding Flow Verification
- [ ] Launch app fresh (clear data)
- [ ] Onboarding introduces journaling and mood tracking
- [ ] No zodiac sign reveal or astrology messaging
- [ ] Sign in with Apple works correctly
- [ ] "Continue as Guest" path works correctly

### First 2-Minute Flow Verification
- [ ] Launch shows journaling/reflection messaging
- [ ] Home screen displays daily reflection prompt and mood check-in
- [ ] User can write a journal entry
- [ ] Pattern tracking shows after multiple entries
- [ ] Dream journal accessible and functional

### App Store Metadata
- [ ] Title: "InnerCycles - Mood Journal" (26 chars)
- [ ] Subtitle: "Daily Mood & Dream Diary" (25 chars)
- [ ] Keywords from `app_store_metadata/keywords.txt` (no astrology terms)
- [ ] Description from `app_store_metadata/description.txt`
- [ ] App Review Notes from `app_store_metadata/app_review_notes.txt`
- [ ] Primary Category: Lifestyle
- [ ] Secondary Category: Health & Fitness
- [ ] Age Rating: 12+
- [ ] Screenshots show journaling interface (mood tracking, patterns, dreams)

### Build Steps
1. [ ] Run `flutter clean`
2. [ ] Run `flutter pub get`
3. [ ] Run `dart analyze lib/` — verify 0 issues
4. [ ] Run `flutter build ios --release`
5. [ ] Archive in Xcode
6. [ ] Upload to App Store Connect via Xcode or Transporter
7. [ ] Update all metadata in App Store Connect
8. [ ] Paste App Review Notes
9. [ ] Submit for review

### iPad Verification
- [ ] Test on iPad (landscape and portrait)
- [ ] All screens render correctly
- [ ] No layout overflow issues
- [ ] Navigation works on larger screen

### Privacy & Permissions
- [ ] Microphone usage description is accurate (voice journaling)
- [ ] Speech recognition usage description is accurate
- [ ] ATT dialog appears correctly
- [ ] Privacy policy URL works: https://innercycles.app/privacy
- [ ] Terms of use URL works: https://innercycles.app/terms

## Common Re-Rejection Risks

| Risk | How to Verify |
|------|---------------|
| Astrology language surfaces | Search codebase: no "horoscope", "zodiac", "fortune" in UI |
| Prediction language appears | Search for "will happen", "destiny", "fate" in UI strings |
| Dream interpretation too mystical | Verify dream responses use psychological framing |
| Screenshots show astrology content | All screenshots must show journaling features |
| Old metadata not updated | Verify all App Store Connect fields match this checklist |
