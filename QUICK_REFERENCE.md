# NaijaPaper - Quick Reference Guide

## 📊 Current Status: 85% Complete

### ✅ Completed Modules

| Module | Progress | Screens | Status |
|--------|----------|---------|--------|
| **Core Infrastructure** | 100% | - | ✅ Complete |
| **Auth System** | 90% | 5 | ✅ Complete (OAuth pending) |
| **Onboarding** | 100% | 3 | ✅ Complete |
| **Practice Module** | 100% | 8 | ✅ Complete |
| **Dashboard** | 100% | 3 | ✅ Complete |
| **AI Tutor** | 60% | 2 | 🔄 Partial (Proctor pending) |
| **Gamification** | 100% | 3 | ✅ Complete |
| **Community** | 0% | 0/3 | ❌ Not Started |
| **Subscription** | 0% | 0/1 | ❌ Not Started |

---

## 🗂️ Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── api_constants.dart          # All API endpoints
│   ├── network/
│   │   └── dio_client.dart             # HTTP client with JWT
│   ├── router/
│   │   └── app_router.dart             # GoRouter with 42 routes
│   └── theme/
│       └── app_theme.dart              # Colors and theme
│
├── features/
│   ├── auth/                           # 5 screens (90% complete)
│   │   ├── data/
│   │   │   └── auth_repository.dart
│   │   └── presentation/
│   │       ├── splash_screen.dart
│   │       ├── welcome_screen.dart
│   │       ├── signup_screen.dart
│   │       ├── otp_screen.dart
│   │       └── login_screen.dart
│   │
│   ├── onboarding/                     # 3 screens (100% complete)
│   │   ├── profile_setup_screen.dart
│   │   ├── subject_selection_screen.dart
│   │   └── notification_permission_screen.dart
│   │
│   ├── dashboard/                      # 3 screens (100% complete)
│   │   ├── dashboard_screen.dart
│   │   ├── heatmap_screen.dart
│   │   └── study_plan_screen.dart
│   │
│   ├── practice/                       # 8 screens (100% complete)
│   │   ├── practice_hub_screen.dart
│   │   ├── mock_setup_screen.dart
│   │   ├── active_mock_screen.dart     # CRITICAL SCREEN
│   │   ├── mock_results_screen.dart
│   │   ├── answer_review_screen.dart
│   │   ├── question_bank_screen.dart
│   │   ├── flashcard_screen.dart
│   │   ├── daily_drill_screen.dart
│   │   ├── data/
│   │   │   └── exam_repository.dart
│   │   └── presentation/
│   │       └── exam_notifier.dart      # State management
│   │
│   ├── ai_tutor/                       # 2 screens (60% complete)
│   │   ├── ai_tutor_home_screen.dart
│   │   ├── ai_chat_screen.dart         # SSE streaming, voice I/O
│   │   └── ai_proctor_results_screen.dart  # TODO
│   │
│   ├── gamification/                   # 3 screens (100% complete) ✨ NEW!
│   │   ├── achievements_screen.dart    # 12+ achievements
│   │   └── challenges_screen.dart      # Time-limited challenges
│   │
│   ├── profile/
│   │   ├── leaderboard_screen.dart     # Enhanced with podium ✨ NEW!
│   │   ├── profile_screen.dart
│   │   ├── edit_profile_screen.dart
│   │   ├── settings_screen.dart
│   │   ├── offline_manager_screen.dart
│   │   ├── parent_dashboard_screen.dart
│   │   └── subscription_screen.dart    # TODO
│   │
│   ├── community/                      # 0/3 screens (TODO)
│   │   ├── study_group_screen.dart     # TODO - Socket.io
│   │   ├── forum_screen.dart           # TODO
│   │   └── live_room_screen.dart       # TODO
│   │
│   └── tracker/
│       ├── tracker_screen.dart
│       └── tracker_detail_screen.dart
│
├── shared/
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── connectivity_provider.dart
│   │   └── theme_provider.dart
│   └── widgets/
│       ├── app_button.dart
│       ├── app_card.dart
│       ├── subject_chip.dart
│       ├── score_circle.dart
│       ├── streak_ring.dart
│       └── shimmer_loader.dart
│
└── local/
    └── drift/
        ├── app_database.dart           # Drift schema
        └── daos/
            ├── questions_dao.dart
            ├── progress_dao.dart
            └── sync_queue_dao.dart
```

---

## 🎯 Key Features by Module

### Auth (90%)
- Phone OTP authentication
- Google/Apple OAuth (UI ready, SDK pending)
- JWT token management
- Secure storage

### Onboarding (100%)
- Profile setup (name, school, exam, year)
- Subject selection (min 4 subjects)
- Notification permission request

### Practice (100%)
- Mock exam creation and configuration
- Active exam with timer and navigation
- Results with animated score breakdown
- Answer review with AI explanations
- Question bank with filters
- Flashcards with spaced repetition
- Daily drill (5 quick questions)

### Dashboard (100%)
- Welcome header with user name
- Animated streak ring
- XP progress bar with level
- Today's stats (questions, time, XP)
- Quick actions grid
- Weak topics section
- Daily drill card
- Leaderboard peek
- Recent activity timeline

### AI Tutor (60%)
- AI chat with SSE streaming
- Voice input (speech-to-text)
- Voice output (text-to-speech)
- Language toggle (English/Pidgin)
- AI Proctor (TODO)

### Gamification (100%) ✨ NEW!
- **Achievements:** 12+ achievements across 4 categories
- **Challenges:** Time-limited challenges with dual rewards
- **Leaderboard:** Podium display with Global/Friends/School scopes

### Community (0%)
- Study Groups (TODO - Socket.io)
- Forum (TODO)
- Live Rooms (TODO)

### Subscription (0%)
- Paystack integration (TODO)
- Plan management (TODO)

---

## 🚀 Quick Commands

### Development:
```bash
# Generate Drift code (REQUIRED before first run)
dart run build_runner build --delete-conflicting-outputs

# Run app
flutter run

# Run on specific device
flutter run -d chrome
flutter run -d android
flutter run -d ios

# Hot reload
r

# Hot restart
R

# Clean build
flutter clean
flutter pub get
```

### Testing:
```bash
# Run all tests
flutter test

# Run specific test
flutter test test/features/practice/exam_notifier_test.dart

# Run with coverage
flutter test --coverage
```

### Build:
```bash
# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release

# Build web
flutter build web --release
```

---

## 📱 Navigation Routes

### Auth:
- `/splash` - Splash screen
- `/onboarding/welcome` - Welcome screen
- `/auth/signup` - Signup with phone
- `/auth/verify-otp` - OTP verification
- `/auth/login` - Login screen

### Onboarding:
- `/onboarding/profile` - Profile setup
- `/onboarding/subjects` - Subject selection
- `/onboarding/notifications` - Notification permission

### Main:
- `/dashboard` - Main dashboard
- `/dashboard/heatmap` - Topic heatmap
- `/dashboard/study-plan` - 30-day study plan

### Practice:
- `/practice` - Practice hub
- `/practice/mock/setup` - Mock exam setup
- `/practice/mock/active/:sessionId` - Active exam
- `/practice/mock/results/:sessionId` - Exam results
- `/practice/mock/review/:sessionId` - Answer review
- `/practice/question-bank` - Question bank
- `/practice/flashcards` - Flashcards
- `/practice/daily-drill` - Daily drill

### AI:
- `/ai-tutor` - AI tutor home
- `/ai-tutor/chat` - AI chat

### Gamification:
- `/achievements` - Achievements screen ✨ NEW!
- `/challenges` - Challenges screen ✨ NEW!
- `/leaderboard` - Leaderboard ✨ ENHANCED!

### Profile:
- `/profile` - User profile
- `/profile/edit` - Edit profile
- `/settings` - Settings
- `/subscription` - Subscription plans

### Community:
- `/community` - Community hub
- `/community/groups/:groupId` - Study group
- `/community/forum` - Forum
- `/community/live/:roomId` - Live room

---

## 🎨 Theme Colors

```dart
// Brand Colors
AppColors.primary           // #1A7A4A (NaijaPaper green)
AppColors.primaryLight      // #25A863
AppColors.primaryDark       // #115233
AppColors.secondary         // #FFB800 (Gold)

// Semantic Colors
AppColors.error             // #E53E3E (Red)
AppColors.success           // #38A169 (Green)
AppColors.warning           // #ED8936 (Amber)
AppColors.info              // #3182CE (Blue)

// Backgrounds
AppColors.background        // #F7F9FC (Light grey)
AppColors.surface           // #FFFFFF (White)
AppColors.surfaceVariant    // #F0F2F5

// Text
AppColors.textPrimary       // #1A202C
AppColors.textSecondary     // #718096
AppColors.textDisabled      // #A0AEC0
AppColors.textOnPrimary     // #FFFFFF

// Exam Types
AppColors.waecColor         // #3182CE (Blue)
AppColors.jambColor         // #805AD5 (Purple)
AppColors.necoColor         // #319795 (Teal)
AppColors.postUtmeColor     // #DD6B20 (Orange)

// Leaderboard
AppColors.rankGold          // #FFD700
AppColors.rankSilver        // #C0C0C0
AppColors.rankBronze        // #CD7F32
```

---

## 📊 State Management Patterns

### Riverpod Providers:
```dart
// Simple provider
final authProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(dioClientProvider));
});

// State provider
final themeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system;
});

// Future provider
final dashboardProvider = FutureProvider<DashboardSummary>((ref) async {
  return await ref.read(dashboardRepositoryProvider).getSummary();
});

// Family provider (with parameter)
final leaderboardProvider = FutureProvider.family<List<User>, String>(
  (ref, scope) async {
    return await ref.read(leaderboardRepositoryProvider).getLeaderboard(scope);
  },
);

// StateNotifier
class ExamNotifier extends StateNotifier<ExamState> {
  ExamNotifier() : super(ExamState.initial());
  
  void selectAnswer(int questionIndex, String answer) {
    state = state.copyWith(/* update */);
  }
}

final examProvider = StateNotifierProvider<ExamNotifier, ExamState>((ref) {
  return ExamNotifier();
});
```

---

## 🗄️ Database (Drift)

### Tables:
- `questions` - Question bank
- `exam_sessions` - Exam history
- `user_answers` - Answer history
- `progress` - Topic progress
- `sync_queue` - Offline sync queue

### DAOs:
- `QuestionsDao` - CRUD for questions
- `ProgressDao` - Progress tracking
- `SyncQueueDao` - Sync management

### Usage:
```dart
// Get database instance
final db = ref.read(appDatabaseProvider);

// Query questions
final questions = await db.questionsDao.getQuestionsBySubject('Mathematics');

// Insert answer
await db.questionsDao.insertUserAnswer(answer);

// Update progress
await db.progressDao.updateTopicProgress(topicId, accuracy);
```

---

## 🌐 API Integration

### Base URL:
```dart
ApiConstants.baseUrl = 'https://api.naijapaper.com/api/v1';
```

### Key Endpoints:
```dart
// Auth
POST /auth/send-otp
POST /auth/verify-otp
POST /auth/refresh

// Exams
POST /exams/create
GET /exams/recent

// Progress
GET /progress/heatmap
GET /progress/summary

// AI
POST /ai/chats (SSE streaming)

// Gamification
GET /achievements
GET /achievements/progress
GET /challenges/active
GET /leaderboard?scope=global&timeframe=week

// Community
WS /socket.io (WebSocket for chat)
```

---

## 📝 Common Tasks

### Add a new screen:
1. Create file in `lib/features/[module]/[screen_name]_screen.dart`
2. Add route in `lib/core/router/app_router.dart`
3. Add navigation in relevant screen

### Add a new API endpoint:
1. Add constant in `lib/core/constants/api_constants.dart`
2. Create repository method
3. Create Riverpod provider
4. Use in UI with `ref.watch(provider)`

### Add a new Drift table:
1. Add table class in `lib/local/drift/app_database.dart`
2. Run `dart run build_runner build --delete-conflicting-outputs`
3. Create DAO if needed
4. Use in repository

### Add a new animation:
```dart
import 'package:flutter_animate/flutter_animate.dart';

Widget.animate()
  .fadeIn(delay: 300.ms)
  .slideY(begin: 0.2, end: 0)
  .scale(curve: Curves.elasticOut);
```

---

## 🐛 Troubleshooting

### Build errors:
```bash
# Clean and rebuild
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### Drift errors:
```bash
# Regenerate Drift code
dart run build_runner build --delete-conflicting-outputs
```

### Hot reload not working:
```bash
# Hot restart instead
R
```

### Import errors:
- Check that all dependencies are in `pubspec.yaml`
- Run `flutter pub get`
- Restart IDE

---

## 📚 Documentation Files

- `PHASE_5_COMPLETE.md` - Latest completion summary
- `PHASE_5_SUMMARY.md` - Detailed Phase 5 documentation
- `PHASE_4_SUMMARY.md` - Phase 4 documentation
- `COMPLETE_IMPLEMENTATION_STATUS.md` - Overall status
- `NEXT_STEPS_GUIDE.md` - Implementation guide
- `ARCHITECTURE_DIAGRAM.md` - Architecture overview
- `QUICK_REFERENCE.md` - This file

---

## 🎯 Next Steps

### Phase 6 - Community & Subscription (15% remaining)

1. **Study Groups** (5%)
   - Socket.io integration
   - Real-time chat
   - Member management

2. **Forum** (3%)
   - Question posting
   - Voting system
   - AI moderation

3. **Live Rooms** (2%)
   - Voice chat
   - Shared timer
   - Participant list

4. **Subscription** (3%)
   - Paystack WebView
   - Plan management
   - Payment verification

5. **Polish** (2%)
   - Performance optimization
   - Testing
   - Bug fixes

**Estimated Time:** 1-2 weeks

---

**Current Status:** 85% Complete | 38/42 Screens | ~22,500 LOC

**Last Updated:** Phase 5 Completion
