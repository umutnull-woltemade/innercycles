# SURVIVAL RELEASE PLAN — InnerCycles v1.0

**Branch**: `survival_release`
**Created**: 2026-02-19
**Objective**: Apple-safe, focused, retention-optimized release

---

## COMMIT CHECKPOINT PLAN

| # | Commit Message | Scope |
|---|---|---|
| 1 | `chore: survival_release bootstrap — feature flags + plan docs` | Feature flags, plan doc |
| 2 | `refactor: 5-tab nav rewrite — Home/Journal/Insights/Breathe/Profile` | Shell, router, routes |
| 3 | `refactor: home screen single-CTA core loop` | Home redesign |
| 4 | `refactor: remove fake AI chat, rebrand to Reflection Prompts` | Insight screen, metadata |
| 5 | `fix: ATT contextual trigger, permission audit` | main.dart, Info.plist |
| 6 | `refactor: soft-archive secondary features, route isolation` | Feature hiding, imports |

---

## STEP 1 — FEATURE VISIBILITY MATRIX

### CORE (5-tab visible, routable)

| Feature | Tab | Route | Screen |
|---|---|---|---|
| Home (Today) | Home | `/today` | TodayFeedScreen (rebuilt) |
| Journal Entry | Journal | `/journal` | DailyEntryScreen |
| Journal Detail | Journal | `/journal/entry/:id` | EntryDetailScreen |
| Journal Archive | Journal | `/journal/archive` | ArchiveScreen |
| Journal Patterns | Journal | `/journal/patterns` | PatternsScreen |
| Monthly Reflection | Journal | `/journal/monthly` | MonthlyReflectionScreen |
| Streak Stats | Home | `/streak/stats` | StreakStatsScreen |
| Mood Trends | Insights | `/mood/trends` | MoodTrendsScreen |
| Calendar Heatmap | Insights | `/calendar` | CalendarHeatmapScreen |
| Emotional Cycles | Insights | `/emotional-cycles` | EmotionalCycleScreen |
| Breathing | Breathe | `/breathing` | BreathingTimerScreen |
| Meditation | Breathe | `/meditation` | MeditationTimerScreen |
| Profile | Profile | `/profile-hub` | ProfileHubScreen |
| Profile Edit | Profile | `/profile` | ProfileScreen |
| Settings | Profile | `/settings` | SettingsScreen |
| Premium | Profile | `/premium` | PremiumScreen |
| Notifications | Profile | `/notifications` | NotificationScheduleScreen |
| Export | Profile | `/export` | ExportScreen |
| App Lock | System | `/app-lock` | AppLockScreen |
| Admin | System | `/admin/*` | AdminLoginScreen/DashboardScreen |
| Onboarding | System | `/onboarding` | OnboardingScreen |
| Disclaimer | System | `/disclaimer` | DisclaimerScreen |

### SECONDARY (hidden, NOT routable, code preserved)

| Feature | Current Route | Action |
|---|---|---|
| Dream Interpretation | `/dream-interpretation` | Remove from router |
| Dream Glossary | `/dream-glossary` | Remove from router |
| 12 Canonical Dream pages | `/dreams/*` | Remove from router |
| Dream Archive | `/dreams/archive` | Remove from router |
| Insight Chat (fake AI) | `/insight` | Rebuild as Reflection Prompts |
| Insights Discovery | `/insights-discovery` | Remove from router |
| Quiz Hub | `/quiz` | Remove from router |
| Attachment Quiz | `/quiz/attachment` | Remove from router |
| Generic Quiz | `/quiz/:quizId` | Remove from router |
| Share Card Gallery | `/share-cards` | Remove from router |
| Growth Dashboard | `/growth` | Remove from router |
| Rituals | `/rituals` | Remove from router |
| Ritual Create | `/rituals/create` | Remove from router |
| Wellness Detail | `/wellness` | Remove from router |
| Energy Map | `/energy-map` | Remove from router |
| Programs | `/programs` | Remove from router |
| Program Detail | `/programs/:id` | Remove from router |
| Program Completion | `/programs/completion` | Remove from router |
| Seasonal | `/seasonal` | Remove from router |
| Moon Calendar | `/moon-calendar` | Remove from router |
| Challenges | `/challenges` + `/challenge-hub` | Remove from router |
| Weekly Digest | `/weekly-digest` | Remove from router |
| Archetype | `/archetype` | Remove from router |
| Compatibility | `/compatibility` | Remove from router |
| Blind Spot | `/blind-spot` | Remove from router |
| Prompt Library | `/prompts` | Remove from router |
| Milestones | `/milestones` | Remove from router |
| Year Review | `/year-review` | Remove from router |
| Habit Suggestions | `/habits` | Remove from router |
| Daily Habits | `/habits/daily` | Remove from router |
| Gratitude | `/gratitude` | Remove from router |
| Gratitude Archive | `/gratitude/archive` | Remove from router |
| Sleep Detail | `/sleep` | Remove from router |
| Sleep Trends | `/sleep/trends` | Remove from router |
| Affirmations | `/affirmations` | Remove from router |
| Emotional Vocabulary | `/emotions` | Remove from router |
| Articles | `/articles` | Remove from router |
| Search | `/search` | Remove from router |
| Tools Catalog | `/tools` | Remove from tab |
| Challenge Hub | `/challenge-hub` | Remove from tab |
| Library Hub | `/library` | Remove from tab |

### DEPRECATED (no code changes, already in `_archived/`)

All astrology features (numerology, tarot, chakra, etc.) — already archived.

---

## STEP 2 — NEW 5-TAB NAVIGATION

### Tab Structure

```
Home | Journal | Insights | Breathe | Profile
  |       |         |          |         |
Today  Daily     Mood       Breathing  ProfileHub
Feed   Entry    Trends      Timer      → Settings
       Archive  Calendar    Meditation → Premium
       Patterns Cycles                 → Export
       Monthly                         → Notifications
       Detail
```

### Routes to KEEP in production router

Core system: `/`, `/disclaimer`, `/onboarding`, `/onboarding/quiz`, `/home`, `/app-lock`
Home tab: `/today`, `/streak/stats`
Journal tab: `/journal`, `/journal/entry/:id`, `/journal/patterns`, `/journal/archive`, `/journal/monthly`
Insights tab: `/mood/trends`, `/calendar`, `/emotional-cycles`
Breathe tab: `/breathing`, `/meditation`
Profile tab: `/profile-hub`, `/profile`, `/settings`, `/premium`, `/notifications`, `/export`
Admin: `/admin/login`, `/admin`

### Routes to REMOVE from production router

Everything else — ~50 routes removed. All SECONDARY feature routes.

---

## STEP 3 — HOME SINGLE-CTA CORE LOOP

### Layout Blueprint (text wireframe)

```
┌─────────────────────────┐
│     [Streak Circle]     │  ← "Day 7" with ring animation
│      How are you        │
│    feeling today?       │
│                         │
│  😊  😐  😔  😤  😴   │  ← 5 mood options (tap)
│                         │
│  ┌─────────────────┐    │
│  │ Start Journaling │    │  ← Primary CTA (after mood select)
│  └─────────────────┘    │
│                         │
│  ── Today's Insight ──  │  ← 1-2 line pattern note (if data)
│  "You tend to feel      │
│   calmer on Wednesdays" │
│                         │
│  ── Recent Entries ──   │  ← Last 3 journal entries (compact)
│  Feb 19 - Calm  ●●●●○  │
│  Feb 18 - Happy ●●●●●  │
│  Feb 17 - Tired ●●○○○  │
└─────────────────────────┘
```

### Event Flow

1. **Open** → See streak + mood question
2. **Tap mood** → Mood recorded, CTA pulses
3. **Tap "Start Journaling"** → Opens DailyEntryScreen with mood pre-filled
4. **Save journal** → Return to Home, show micro-celebration (confetti subtle)
5. **See insight** → Pattern-based note appears if 3+ entries exist
6. **Done** → User closes app satisfied

### D1 Retention Boosters
- Streak feedback on every open
- "Come back tomorrow" gentle note after save
- Personalized notification with DailyHookService message

---

## STEP 4 — FAKE AI REMOVAL

### Screens to Modify
- `/insight` → Rebuild as "Daily Reflection Prompt" (NOT a chat)
- Remove: Chat UI, typing animation, message bubbles, "AI assistant" language
- Replace with: Single reflection prompt card with guided question

### UI Text Replacements
| Old | New |
|---|---|
| "Insight Assistant" | "Reflection Prompt" |
| "AI-powered reflection" | "Guided self-reflection" |
| "Ask me anything" | "Today's reflection question" |
| "decode dreams" | "explore dream themes" |
| "predict" / "forecast" | "patterns suggest" / "you may notice" |

### Metadata Rewrite (App Store)
- **Title**: "InnerCycles - Daily Journal" (24 chars)
- **Subtitle**: "Mood, Patterns & Reflection" (28 chars)
- **Description**: Remove "AI", "decode", "predict". Focus on journaling + mood tracking + personal patterns.

---

## STEP 5 — ATT & PERMISSIONS

### ATT Fix
- Remove from `main.dart` cold launch (line 263-274)
- Move to AdService.initialize() — trigger right before first ad load
- Only request if ads are actually enabled (free tier)

### Permission Audit
| Permission | Used By | In CORE? | Action |
|---|---|---|---|
| Camera | Journal photo | YES | KEEP |
| Microphone | Voice journal | YES | KEEP |
| Speech Recognition | Voice-to-text | YES | KEEP |
| Face ID | App Lock | YES | KEEP |
| Photo Library | Journal photo | YES | KEEP |
| Tracking (ATT) | AdMob | YES (free) | KEEP but move trigger |

All permissions are used by CORE features. No removals needed.

---

## STEP 6 — PAYWALL BOUNDARY

### FREE Tier
- Mood check-in (unlimited)
- Journal entries (unlimited)
- Streak tracking
- 7-day pattern summary
- Breathing timer
- Basic meditation
- 3 entries/week insight

### PREMIUM Tier
- 30+ day analytics
- Emotional cycle analysis
- Calendar heatmap (full history)
- Monthly reflection reports
- Voice journaling
- Export (full history, all formats)
- Ad-free experience

### Paywall Timing
- First paywall: After 3 completed journal entries
- Context: "See your 30-day patterns" when they've built enough data
- No paywall before value is experienced

---

## STEP 7 — SOFT ARCHIVE

### Isolation Strategy
- SECONDARY features stay in `lib/features/` (no file moves needed)
- Remove their imports from `router_service.dart`
- Remove their routes from `router_service.dart`
- Remove references from Home/Today screen
- Remove from BottomNav tabs (Tools, Challenges, Library)
- The code compiles but is unreachable

### Verification
- `grep -r "ToolCatalogScreen\|ChallengeHubScreen\|LibraryHubScreen" lib/shared/` → should return 0 after cleanup
- `flutter analyze` → 0 errors
- Manual: No way to navigate to hidden features from any CORE screen

---

## POST-FIX PROJECTIONS

| Metric | Before | After |
|---|---|---|
| Apple Rejection Risk | 40-45% | **<10%** |
| D1 Retention | 35-40% | **42-48%** |
| Screens Visible | 133 | **~22** |
| Routes Registered | ~80 | **~25** |
| Feature Surface Area | 46 features | **5 core areas** |
| Cognitive Load | CRITICAL | LOW |
| Core Loop Clarity | NONE | CLEAR |

---

## 30/60/90 DAY SURVIVAL KPIs

| KPI | 30-Day | 60-Day | 90-Day |
|---|---|---|---|
| D1 Retention | 42% | 45% | 48% |
| D7 Retention | 22% | 25% | 28% |
| Conversion Rate | 2% | 3.5% | 5% |
| App Store Rating | 4.2 | 4.4 | 4.6 |
| Crash-free Rate | 99.5% | 99.7% | 99.8% |
