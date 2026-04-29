# NaijaPaper - Architecture Diagram

## 🏗️ **System Architecture Overview**

```
┌─────────────────────────────────────────────────────────────────┐
│                         PRESENTATION LAYER                       │
│                        (Flutter Widgets)                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │   Auth       │  │   Practice   │  │  Dashboard   │         │
│  │   Screens    │  │   Screens    │  │   Screens    │         │
│  │              │  │              │  │              │         │
│  │ • Splash     │  │ • Hub        │  │ • Summary    │         │
│  │ • Welcome    │  │ • Setup      │  │ • Heatmap    │         │
│  │ • Signup     │  │ • Active ✅  │  │ • Study Plan │         │
│  │ • OTP        │  │ • Results ✅ │  │              │         │
│  │ • Login      │  │ • Review ✅  │  │              │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
│                                                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │  AI Tutor    │  │  Community   │  │   Profile    │         │
│  │  Screens     │  │   Screens    │  │   Screens    │         │
│  │              │  │              │  │              │         │
│  │ • Chat       │  │ • Groups     │  │ • Settings   │         │
│  │ • Proctor    │  │ • Forum      │  │ • Leaderboard│         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      STATE MANAGEMENT LAYER                      │
│                      (Riverpod Providers)                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Global Providers                                         │  │
│  │  • authStateProvider ✅                                   │  │
│  │  • connectivityProvider ✅                                │  │
│  │  • themeProvider ✅                                       │  │
│  │  • appDatabaseProvider ✅                                 │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Feature Providers                                        │  │
│  │  • examNotifierProvider ✅ (per session)                  │  │
│  │  • createExamProvider ✅                                  │  │
│  │  • recentExamsProvider ✅                                 │  │
│  │  • dashboardProvider (TODO)                               │  │
│  │  • aiChatProvider (TODO)                                  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                        BUSINESS LOGIC LAYER                      │
│                         (Repositories)                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │   Auth       │  │    Exam      │  │  Dashboard   │         │
│  │  Repository  │  │  Repository  │  │  Repository  │         │
│  │      ✅      │  │      ✅      │  │    (TODO)    │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                          DATA LAYER                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌────────────────────────┐    ┌────────────────────────┐      │
│  │   REMOTE DATA SOURCE   │    │   LOCAL DATA SOURCE    │      │
│  │                        │    │                        │      │
│  │  ┌──────────────────┐ │    │  ┌──────────────────┐ │      │
│  │  │   Dio Client ✅  │ │    │  │  Drift DB ✅     │ │      │
│  │  │                  │ │    │  │                  │ │      │
│  │  │ • JWT Interceptor│ │    │  │ • Questions DAO  │ │      │
│  │  │ • Retry Logic    │ │    │  │ • Progress DAO   │ │      │
│  │  │ • Error Handling │ │    │  │ • Sync Queue DAO │ │      │
│  │  └──────────────────┘ │    │  └──────────────────┘ │      │
│  │                        │    │                        │      │
│  │  ┌──────────────────┐ │    │  ┌──────────────────┐ │      │
│  │  │  Socket.io       │ │    │  │  Hive Storage ✅ │ │      │
│  │  │   (TODO)         │ │    │  │                  │ │      │
│  │  │                  │ │    │  │ • Auth Tokens    │ │      │
│  │  │ • Study Groups   │ │    │  │ • Settings       │ │      │
│  │  │ • Live Chat      │ │    │  │ • Cache          │ │      │
│  │  └──────────────────┘ │    │  └──────────────────┘ │      │
│  └────────────────────────┘    └────────────────────────┘      │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                         SYNC SERVICE ✅                          │
│                                                                  │
│  • Monitors connectivity                                        │
│  • Queues offline operations                                    │
│  • Syncs when back online                                       │
│  • Handles conflicts                                            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔄 **Data Flow: Taking an Exam**

```
┌─────────────────────────────────────────────────────────────────┐
│                        USER INTERACTION                          │
└─────────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  1. User taps "Start Exam" in Mock Setup Screen                 │
└─────────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  2. createExamProvider called with params                        │
│     • examType: "JAMB"                                           │
│     • subjectIds: ["math", "english"]                            │
│     • questionCount: 40                                          │
│     • isTimed: true                                              │
└─────────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  3. ExamRepository.createExam()                                  │
│     POST /api/v1/exams/create                                    │
└─────────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  4. Server returns ExamSession with questions                    │
│     { id, questions[], durationMinutes, startedAt }              │
└─────────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  5. Navigate to Active Mock Screen                               │
│     /practice/mock/active/{sessionId}                            │
└─────────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  6. examNotifierProvider loads session                           │
│     • Fetches from API if online                                 │
│     • Saves questions to Drift                                   │
│     • Starts timer                                               │
└─────────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  7. User answers questions                                       │
│     • Each answer saved to Drift immediately                     │
│     • Progress tracked locally                                   │
└─────────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  8. User submits exam (or auto-submit on timeout)               │
└─────────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  9. examNotifier.submitExam()                                    │
│     IF ONLINE:                                                   │
│       • POST /api/v1/exams/{id}/submit                           │
│       • Update local progress with correct answers               │
│     IF OFFLINE:                                                  │
│       • Queue submission in sync_queue                           │
│       • Calculate local result                                   │
└─────────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  10. Navigate to Mock Results Screen                             │
│      /practice/mock/results/{sessionId}                          │
└─────────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  11. Display animated results                                    │
│      • Score circle                                              │
│      • Grade badge                                               │
│      • Subject breakdown                                         │
│      • XP earned                                                 │
└─────────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  12. User taps "Review Answers"                                  │
│      Navigate to Answer Review Screen                            │
└─────────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  13. Display questions with correct/wrong indicators             │
│      • Filter by status                                          │
│      • Toggle language                                           │
│      • Expand explanations                                       │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔌 **Offline-First Architecture**

```
┌─────────────────────────────────────────────────────────────────┐
│                      CONNECTIVITY MONITOR                        │
│                   (connectivityProvider)                         │
└─────────────────────────────────────────────────────────────────┘
                              ▼
                    ┌─────────┴─────────┐
                    │                   │
                 ONLINE              OFFLINE
                    │                   │
                    ▼                   ▼
        ┌───────────────────┐  ┌───────────────────┐
        │  WRITE TO API     │  │  WRITE TO DRIFT   │
        │  THEN DRIFT       │  │  QUEUE FOR SYNC   │
        └───────────────────┘  └───────────────────┘
                    │                   │
                    └─────────┬─────────┘
                              ▼
                    ┌───────────────────┐
                    │   DRIFT DATABASE  │
                    │                   │
                    │ • Questions       │
                    │ • Progress        │
                    │ • Sync Queue      │
                    │ • Exam Sessions   │
                    │ • AI Cache        │
                    └───────────────────┘
                              ▼
                    ┌───────────────────┐
                    │   SYNC SERVICE    │
                    │                   │
                    │ • Monitors queue  │
                    │ • Syncs on WiFi   │
                    │ • Retries failed  │
                    │ • Resolves conflicts│
                    └───────────────────┘
```

---

## 🎨 **UI Component Hierarchy**

```
App (MaterialApp)
│
├── GoRouter
│   │
│   ├── Auth Flow
│   │   ├── SplashScreen
│   │   ├── WelcomeScreen
│   │   ├── SignupScreen
│   │   ├── OTPScreen
│   │   └── LoginScreen
│   │
│   ├── Main Flow (requires auth)
│   │   │
│   │   ├── Dashboard
│   │   │   ├── DashboardScreen
│   │   │   ├── HeatmapScreen
│   │   │   └── StudyPlanScreen
│   │   │
│   │   ├── Practice
│   │   │   ├── PracticeHubScreen
│   │   │   ├── MockSetupScreen
│   │   │   ├── ActiveMockScreen ✅
│   │   │   ├── MockResultsScreen ✅
│   │   │   ├── AnswerReviewScreen ✅
│   │   │   ├── QuestionBankScreen
│   │   │   ├── FlashcardScreen
│   │   │   └── DailyDrillScreen
│   │   │
│   │   ├── AI Tutor
│   │   │   ├── AITutorHomeScreen
│   │   │   ├── AIChatScreen
│   │   │   └── AIProctorResultsScreen
│   │   │
│   │   ├── Community
│   │   │   ├── CommunityHubScreen
│   │   │   ├── StudyGroupScreen
│   │   │   ├── ForumScreen
│   │   │   └── LiveRoomScreen
│   │   │
│   │   └── Profile
│   │       ├── ProfileScreen
│   │       ├── SettingsScreen
│   │       ├── LeaderboardScreen
│   │       └── SubscriptionScreen
│   │
│   └── Onboarding
│       ├── ProfileSetupScreen
│       ├── SubjectSelectionScreen
│       └── NotificationPermissionScreen
│
└── Shared Widgets
    ├── AppButton ✅
    ├── AppCard ✅
    ├── SubjectChip ✅
    ├── ScoreCircle ✅
    ├── StreakRing ✅
    └── ShimmerLoader ✅
```

---

## 🔐 **Authentication Flow**

```
┌─────────────────────────────────────────────────────────────────┐
│  1. App Launch → SplashScreen                                    │
└─────────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  2. authStateProvider checks token in Hive                       │
└─────────────────────────────────────────────────────────────────┘
                              ▼
                    ┌─────────┴─────────┐
                    │                   │
              TOKEN EXISTS         NO TOKEN
                    │                   │
                    ▼                   ▼
        ┌───────────────────┐  ┌───────────────────┐
        │  Validate Token   │  │  WelcomeScreen    │
        │  GET /auth/me     │  │                   │
        └───────────────────┘  └───────────────────┘
                    │                   │
            ┌───────┴───────┐           │
            │               │           │
         VALID          INVALID         │
            │               │           │
            ▼               └───────────┘
    ┌───────────────┐              │
    │  Dashboard    │              ▼
    └───────────────┘      ┌───────────────┐
                           │  Login Flow   │
                           │               │
                           │ 1. Phone      │
                           │ 2. OTP        │
                           │ 3. Dashboard  │
                           └───────────────┘
```

---

## 📦 **Package Dependencies**

```
┌─────────────────────────────────────────────────────────────────┐
│                      CORE DEPENDENCIES                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  State Management:                                               │
│  • flutter_riverpod ^2.5.1 ✅                                   │
│  • hooks_riverpod ^2.5.1 ✅                                     │
│  • flutter_hooks ^0.20.5 ✅                                     │
│                                                                  │
│  Navigation:                                                     │
│  • go_router ^13.2.0 ✅                                         │
│                                                                  │
│  Networking:                                                     │
│  • dio ^5.4.3 ✅                                                │
│  • retrofit ^4.1.0 ✅                                           │
│                                                                  │
│  Local Storage:                                                  │
│  • drift ^2.18.0 ✅                                             │
│  • sqlite3_flutter_libs ^0.5.0 ✅                               │
│  • hive_flutter ^1.1.0 ✅                                       │
│  • flutter_secure_storage ^9.0.0 ✅                             │
│                                                                  │
│  Realtime:                                                       │
│  • socket_io_client ^2.0.3+1 (TODO)                             │
│                                                                  │
│  Auth:                                                           │
│  • google_sign_in ^6.2.1 (TODO)                                 │
│  • sign_in_with_apple ^6.1.0 (TODO)                             │
│                                                                  │
│  AI/Voice:                                                       │
│  • speech_to_text 6.6.0 (TODO)                                  │
│  • flutter_tts ^4.0.2 (TODO)                                    │
│                                                                  │
│  UI/Animations:                                                  │
│  • lottie ^3.1.2 ✅                                             │
│  • flutter_animate ^4.5.0 ✅                                    │
│  • shimmer ^3.0.0 ✅                                            │
│  • cached_network_image ^3.3.1 ✅                               │
│  • flip_card ^0.7.0 (TODO)                                      │
│  • fl_chart ^0.68.0 (TODO)                                      │
│  • table_calendar ^3.1.2 (TODO)                                 │
│                                                                  │
│  Utilities:                                                      │
│  • connectivity_plus ^6.0.3 ✅                                  │
│  • share_plus ^9.0.0 ✅                                         │
│  • path_provider ^2.1.3 ✅                                      │
│  • intl ^0.19.0 ✅                                              │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🎯 **Feature Completion Status**

```
┌─────────────────────────────────────────────────────────────────┐
│  FEATURE                          STATUS        COMPLETION       │
├─────────────────────────────────────────────────────────────────┤
│  Core Infrastructure              ✅ Done         100%           │
│  Auth System                      ✅ Done          90%           │
│  Practice Module                  🔄 In Progress   85%           │
│    ├─ Active Mock Screen          ✅ Done         100%           │
│    ├─ Results Screen              ✅ Done         100%           │
│    ├─ Review Screen               ✅ Done         100%           │
│    ├─ Hub Screen                  ❌ TODO           0%           │
│    ├─ Setup Screen                ❌ TODO           0%           │
│    ├─ Question Bank               ❌ TODO           0%           │
│    ├─ Flashcards                  ❌ TODO           0%           │
│    └─ Daily Drill                 ❌ TODO           0%           │
│  Dashboard                        ❌ TODO          30%           │
│  AI Tutor                         ❌ TODO           0%           │
│  Gamification                     ❌ TODO           0%           │
│  Community                        ❌ TODO           0%           │
│  Subscription                     ❌ TODO           0%           │
│  Offline Sync                     ✅ Done          85%           │
│                                                                  │
│  OVERALL PROGRESS:                🔄              52%           │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🚀 **Next Implementation Targets**

```
WEEK 3:
┌─────────────────────────────────────────────────────────────────┐
│  1. Practice Hub Screen           [████░░░░░░] 40%              │
│  2. Mock Setup Screen             [████░░░░░░] 40%              │
│  3. Dashboard Screen              [███░░░░░░░] 30%              │
└─────────────────────────────────────────────────────────────────┘

WEEK 4:
┌─────────────────────────────────────────────────────────────────┐
│  4. Heatmap Screen                [░░░░░░░░░░]  0%              │
│  5. Study Plan Screen             [░░░░░░░░░░]  0%              │
│  6. Question Bank Screen          [░░░░░░░░░░]  0%              │
└─────────────────────────────────────────────────────────────────┘

WEEKS 5-6:
┌─────────────────────────────────────────────────────────────────┐
│  7. AI Chat Screen                [░░░░░░░░░░]  0%              │
│  8. Voice Integration             [░░░░░░░░░░]  0%              │
│  9. SSE Streaming                 [░░░░░░░░░░]  0%              │
└─────────────────────────────────────────────────────────────────┘
```

---

**Legend:**
- ✅ Done - Fully implemented and tested
- 🔄 In Progress - Partially implemented
- ❌ TODO - Not started
- [████░░░░░░] - Progress bar (40% = 4/10 blocks filled)

---

**Last Updated:** Current Session
**Overall Progress:** 52%
**Next Milestone:** 60% (Complete Practice Hub + Dashboard)
