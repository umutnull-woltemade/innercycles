# InnerCycles - App Store Submission Package

Generated: 2026-02-12

---

## 1. APP STORE REVIEW NOTES

### For Apple Review Team

**App Overview:**
InnerCycles is a personal journaling and mood tracking app designed for daily self-reflection and emotional wellness. The app provides guided journal prompts, mood tracking, dream journaling, and emotional pattern analysis.

**Entertainment Disclaimer:**
- The app displays a disclaimer on first launch before any content is accessible
- All content is clearly marked as for self-reflection and educational purposes
- No medical, psychological, financial, or legal advice is provided
- Users are explicitly directed to consult professionals for any real concerns

**Account & Authentication:**
- Apple Sign-In is the primary authentication method
- Users can also skip login to use basic features anonymously
- Email/password login available as secondary option

**In-App Purchases:**
- All purchases handled exclusively through Apple In-App Purchases via RevenueCat
- No external payment links or methods
- Two subscription tiers: Monthly and Yearly
- Restore purchases fully functional
- Clear subscription terms displayed before purchase

**Content:**
- App is suitable for ages 4+
- No user-generated public content
- No chat/messaging features
- No violent, sexual, or otherwise mature content

**Privacy & Data:**
- Privacy policy available at https://innercycles.app/privacy
- App Tracking Transparency (ATT) implemented
- Data stored locally on device via SharedPreferences
- Birth date collected only for age-appropriate content

**Test Account (if needed):**
- The app can be fully tested without login by tapping "Skip" on the login screen
- For premium features testing, please use sandbox credentials

---

## 2. APP DESCRIPTION (Turkish - Primary)

### Short Description (30 chars max)
Ruh Hali & Gunluk Takibi

### Full Description

**InnerCycles — Kisisel Gunluk ve Ruh Hali Takipcisi**

Ruh halini takip et, duygusal oruntuleri kesfet ve gunluk oz-farkindalikla buyume.

- Rehberli gunluk yansima sorulari
- Ruh hali ve oruntu takibi
- Ruya gunlugu ve sembol kutuphanesi
- Duygusal dongu haritasi
- Aylik icgoru raporlari
- Ozel ve guvenli — dusuncelerin cihazinda kalir

Bu uygulama yalnizca kisisel yansima ve egitim amaciyla tasarlanmistir. Profesyonel tibbi, psikolojik veya finansal tavsiye yerine gecmez.

**Premium Ozellikler:**
- Derin oruntu analizi
- Sinirsiz ruya yorumu
- Aylik yansima raporlari
- Reklamsiz deneyim

Abonelik otomatik olarak yenilenir. Istediginiz zaman Ayarlar > Apple ID > Abonelikler uzerinden iptal edebilirsiniz.

---

## 3. APP DESCRIPTION (English)

### Short Description
Mood & Journal Tracker

### Full Description

**InnerCycles — Your Personal Journal & Mood Tracker**

Track your moods, discover emotional patterns, and grow through daily self-awareness.

- Guided daily reflection prompts
- Mood and pattern tracking
- Dream journal with symbol library
- Emotional cycle mapping
- Monthly insight reports
- Private and secure — your thoughts stay on your device

This app is for self-reflection and educational purposes only. It does not replace professional medical, psychological, or financial advice.

**Premium Features:**
- Deep pattern analysis
- Unlimited dream interpretations
- Monthly reflection reports
- Ad-free experience

Subscription auto-renews. Cancel anytime in Settings > Apple ID > Subscriptions.

---

## 4. KEYWORDS

### Turkish Keywords (100 chars max)
gunluk,ruh hali,ruya,yansima,farkindalilik,saglik,oz-bakim,duygu,dongu,takip,meditasyon,wellness

### English Keywords
journal,mood,dream,reflection,mindfulness,wellness,self-care,emotional,cycle,tracker,meditation,diary

---

## 5. WHAT'S NEW (Version 1.0.0)

### Turkish
Ilk surum! InnerCycles ile ic dunyanizi kesfedin.

- Rehberli gunluk yansima sorulari
- Ruh hali ve oruntu takibi
- Ruya gunlugu ve sembol kutuphanesi
- Duygusal dongu haritasi
- 2 dil destegi

### English
First release! Explore your inner world with InnerCycles.

- Guided daily reflection prompts
- Mood and pattern tracking
- Dream journal with symbol library
- Emotional cycle mapping
- 2 language support

---

## 6. PROMOTIONAL TEXT (170 chars max)

### Turkish
Ruh halini takip et, duygusal oruntuleri kesfet. Gunluk yansima, ruya gunlugu ve oruntu analizi.

### English
Track your moods, discover emotional patterns. Daily reflection, dream journal, and pattern analysis.

---

## 7. SUPPORT & PRIVACY URLS

- **Support URL:** https://innercycles.app/support
- **Privacy Policy URL:** https://innercycles.app/privacy
- **Marketing URL:** https://innercycles.app
- **Terms of Use URL:** https://innercycles.app/terms

---

## 8. APP CATEGORY

- **Primary Category:** Lifestyle
- **Secondary Category:** Health & Fitness

---

## 9. AGE RATING QUESTIONNAIRE ANSWERS

| Question | Answer |
|----------|--------|
| Cartoon or Fantasy Violence | None |
| Realistic Violence | None |
| Sexual Content or Nudity | None |
| Profanity or Crude Humor | None |
| Alcohol, Tobacco, or Drug Use | None |
| Medical/Treatment Information | None |
| Simulated Gambling | None |
| Horror/Fear Themes | None |
| Mature/Suggestive Themes | None |
| Unrestricted Web Access | No |
| Contests | No |
| **Age Rating Result:** | **4+** |

---

## 10. APP PRIVACY DETAILS

### Data Types Collected

**Contact Info:**
- Email Address (for account creation)
- Name (optional, for personalization)

**User Content:**
- Dream journal entries (stored locally)
- Mood entries (stored locally)

**Identifiers:**
- User ID (internal app use)

**Usage Data:**
- Product Interaction (screens viewed, features used)

### Data Use

| Data Type | Purpose | Linked to Identity |
|-----------|---------|-------------------|
| Email | Account, Support | Yes |
| Usage Data | Analytics, Product Improvement | No |

### Data Not Collected
- Financial Info
- Health & Fitness
- Contacts
- Browsing History
- Location (real-time)
- Purchases (handled by Apple)

---

## 11. TECHNICAL EXPLANATION (for Review Team)

### Architecture
- **Framework:** Flutter 3.x (cross-platform)
- **Local Storage:** SharedPreferences, Hive
- **Analytics:** Firebase Analytics
- **Payments:** RevenueCat (Apple StoreKit wrapper)

### Third-Party SDKs
1. Firebase (Analytics)
2. RevenueCat (Subscription management)
3. Sign in with Apple SDK

### Dream Interpretation
- Keyword-based symbol matching from local database
- User content is stored only on device

---

## 12. SUBMISSION CHECKLIST

### Before Submitting

- [ ] Fill RevenueCat API keys in AppConstants
- [ ] Change aps-environment to "production"
- [ ] Verify privacy policy is live at innercycles.app/privacy
- [ ] Verify support page is live at innercycles.app/support
- [ ] Test Apple Sign-In on real device
- [ ] Test subscription flow in sandbox
- [ ] Upload app screenshots (6.5", 5.5", iPad Pro)
- [ ] Set pricing for subscription products in App Store Connect
- [ ] Complete App Store Connect app privacy details
- [ ] Archive and upload build via Xcode

### App Store Connect Settings

- **Availability:** All countries except sanctioned regions
- **Price Schedule:** Free (with IAP)
- **Pre-order:** Disabled
- **Automatic Updates:** Enabled

---

## 13. CONTACT INFO

**Developer:** Venus One
**Email:** support@innercycles.app
**Website:** https://innercycles.app

---

*This document was prepared as part of the App Store submission preparation process.*
