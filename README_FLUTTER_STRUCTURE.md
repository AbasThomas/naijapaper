# NaijaPaper Flutter Frontend - Structure Documentation

## 📁 Project Structure

The Flutter frontend follows a clean architecture pattern with feature-based organization:

```
lib/
├── main.dart                          # App entry point
├── core/                              # Core functionality
│   ├── theme/
│   │   ├── app_theme.dart            # Complete theme with ThemeData
│   │   └── app_colors.dart           # Color palette (#1A7A4A primary)
│   ├── router/
│   │   └── app_router.dart           # GoRouter with all 42 routes
│   ├── constants/
│   │   └── api_constants.dart        # API URLs, endpoints, storage keys
│   ├── network/
│   │   ├── dio_client.dart           # Dio singleton with interceptors
│   │   └── jwt_interceptor.dart      # Auto-refresh JWT on 401
│   └── utils/
│       ├── date_utils.dart           # Date formatting helpers
│       └── validators.dart           # Form validation functions
│
├── features/                          # Feature modules
│   ├── auth/                         # ✅ IMPLEMENTED
│   │   ├── data/
│   │   │   └── auth_repository.dart
│   │   ├── domain/
│   │   │   └── auth_user.dart
│   │   └── presentation/
│   │       ├── splash_screen.dart
│   │       ├── welcome_screen.dart
│   │       ├── signup_screen.dart
│   │       ├── otp_screen.dart
│   │       └── login_screen.dart
│   │
│   ├── onboarding/                   # ⚠️ PLACEHOLDER
│   │   ├── profile_setup_screen.dart
│   │   ├── subject_selection_screen.dart
│   │   └── notification_permission_screen.dart
│   │
│   ├── dashboard/                    # ⚠️ PLACEHOLDER
│   │   ├── dashboard_screen.dart
│   │   ├── heatmap_screen.dart
│   │   └── study_plan_screen.dart
│   │
│   ├── practice/                     # ⚠️ PLACEHOLDER
│   │   ├── practice_hub_screen.dart
│   │   ├── mock_setup_screen.dart
│   │   ├── active_mock_screen.dart
│   │   ├── mock_results_screen.dart
│   │   ├── answer_review_screen.dart
│   │   ├── question_bank_screen.dart
│   │   ├── flashcard_screen.dart
│   │   └── daily_drill_screen.dart
│   │
│   ├── ai_tutor/                     # ⚠️ PLACEHOLDER
│   │   ├── ai_tutor_home_screen.dart
│   │   ├── ai_chat_screen.dart
│   │   └── ai_proctor_results_screen.dart
│   │
│   ├── community/                    # ⚠️ PLACEHOLDER
│   │   ├── community_hub_screen.dart
│   │   ├── study_group_screen.dart
│   │   ├── forum_screen.dart
│   │   ├── forum_question_screen.dart
│   │   └── live_room_screen.dart
│   │
│   ├── profile/                      # ⚠️ PLACEHOLDER
│   │   ├── profile_screen.dart
│   │   ├── edit_profile_screen.dart
│   │   ├── settings_screen.dart
│   │   ├── offline_manager_screen.dart
│   │   ├── parent_dashboard_screen.dart
│   │   ├── subscription_screen.dart
│   │   └── leaderboard_screen.dart
│   │
│   ├── gamification/                 # ⚠️ PLACEHOLDER
│   │   ├── achievements_screen.dart
│   │   └── challenges_screen.dart
│   │
│   └── tracker/                      # ⚠️ PLACEHOLDER
│       ├── tracker_screen.dart
│       └── tracker_detail_screen.dart
│
├── shared/                            # Shared widgets & providers
│   ├── widgets/
│   │   ├── app_button.dart           # ✅ Reusable button component
│   │   ├── app_card.dart             # ✅ Card component
│   │   ├── subject_chip.dart         # ✅ Subject tag chip
│   │   ├── score_circle.dart         # ✅ Animated score circle
│   │   ├── streak_ring.dart          # ✅ Streak ring with flame
│   │   └── shimmer_loader.dart       # ✅ Loading skeletons
│   └── providers/
│       ├── auth_provider.dart        # TODO
│       ├── connectivity_provider.dart # TODO
│       └── theme_provider.dart       # TODO
│
└── local/                             # Local storage
    ├── drift/
    │   ├── app_database.dart         # ✅ Drift DB definition
    │   └── daos/                     # TODO: Implement DAOs
    │       ├── questions_dao.dart
    │       ├── progress_dao.dart
    │       └── sync_queue_dao.dart
    └── hive/
        └── hive_service.dart         # ✅ Hive key-value storage
```

## 🎨 Design System

### Colors (AppColors)
- **Primary**: `#1A7A4A` (NaijaPaper green)
- **Secondary**: `#FFB800` (Gold for premium/streaks)
- **Success**: `#38A169` (Correct answers)
- **Error**: `#E53E3E` (Wrong answers)
- **Warning**: `#ED8936` (Needs work)

### Typography
- Display: 32px/28px/24px (bold)
- Headline: 20px (semi-bold)
- Body: 16px/14px
- All using system font

## 🔧 Key Dependencies

```yaml
# State Management
flutter_riverpod: ^2.5.1
hooks_riverpod: ^2.5.1

# Navigation
go_router: ^13.2.0

# Networking
dio: ^5.4.3

# Local Storage
drift: ^2.18.0
hive_flutter: ^1.1.0
flutter_secure_storage: ^9.0.0

# Realtime
socket_io_client: ^2.0.3+1

# Auth
google_sign_in: ^6.2.1
sign_in_with_apple: ^6.1.0

# Firebase
firebase_core: ^2.31.1
firebase_messaging: ^14.9.1

# AI/Voice
speech_to_text: 6.6.0
flutter_tts: ^4.0.2

# UI
lottie: ^3.1.2
flutter_animate: ^4.5.0
shimmer: ^3.0.0
fl_chart: ^0.68.0
```

## 🚀 Getting Started

### 1. Generate Drift Database Code

```bash
dart run build_runner build --delete-conflicting-outputs
```

This generates `app_database.g.dart` from the Drift schema.

### 2. Run the App

```bash
flutter run
```

## 📝 Implementation Checklist

### ✅ Completed
- [x] Core theme and colors
- [x] API constants and endpoints
- [x] Dio client with JWT interceptor
- [x] Date utilities and validators
- [x] GoRouter with all 42 routes
- [x] Shared widgets (button, card, chips, score circle, streak ring, shimmer)
- [x] Hive service for settings
- [x] Drift database schema
- [x] Auth screens (splash, welcome, signup, OTP, login)
- [x] Auth repository and domain model

### ⚠️ TODO - High Priority
- [ ] **Drift DAOs**: Implement data access objects for questions, progress, sync queue
- [ ] **Riverpod Providers**: Create auth, connectivity, and theme providers
- [ ] **Auth Flow**: Connect auth screens to repository and implement OAuth
- [ ] **Dashboard Screen**: Implement full dashboard with real data
- [ ] **Practice Screens**: Build mock exam flow (setup → active → results → review)
- [ ] **Offline Sync**: Implement sync queue processor and connectivity handling

### 📋 TODO - Feature Implementation
- [ ] **Onboarding**: Complete profile setup, subject selection with API integration
- [ ] **Heatmap**: Implement topic mastery visualization with fl_chart
- [ ] **Study Plan**: Build 30-day calendar view with TableCalendar
- [ ] **Question Bank**: Implement filtering, search, and infinite scroll
- [ ] **Flashcards**: Build flip card interface with spaced repetition
- [ ] **AI Tutor**: Implement SSE streaming chat with voice input/output
- [ ] **Community**: Build WebSocket chat, forum, and live rooms
- [ ] **Gamification**: Implement achievements, badges, leaderboard
- [ ] **Tracker**: Build exam/scholarship tracker with reminders
- [ ] **Profile**: Complete settings, offline manager, subscription flow
- [ ] **Parent Dashboard**: Implement read-only student progress view

## 🏗️ Architecture Patterns

### Feature Module Structure
Each feature follows this pattern:

```
feature_name/
├── data/
│   ├── *_repository.dart      # API calls and data sources
│   └── *_remote_ds.dart        # Remote data source (optional)
├── domain/
│   └── *.dart                  # Domain models (pure Dart classes)
└── presentation/
    ├── *_notifier.dart         # Riverpod state management
    ├── *_screen.dart           # UI screens
    └── widgets/                # Feature-specific widgets
```

### State Management (Riverpod)
```dart
// Example provider pattern
@riverpod
class ExamNotifier extends _$ExamNotifier {
  @override
  ExamState build() => ExamState.initial();

  Future<void> createExam(CreateExamDto dto) async {
    state = state.copyWith(status: Status.loading);
    final result = await ref.read(examRepositoryProvider).create(dto);
    // Handle result...
  }
}
```

### Offline-First Pattern
1. Write to Drift immediately (instant feedback)
2. Add to SyncQueue table
3. On connectivity restore, sync to NestJS
4. Update local state with server response

## 🔐 Authentication Flow

1. **Splash** → Check token → Route to Welcome or Dashboard
2. **Welcome** → Onboarding carousel → Signup
3. **Signup** → Phone OTP or OAuth → Verify OTP
4. **OTP** → Verify → Profile Setup
5. **Profile Setup** → Subject Selection → Notification Permission → Dashboard

## 📱 Screen Routes

All 42 routes are defined in `app_router.dart`:

- `/splash` - App launch
- `/onboarding/welcome` - Onboarding carousel
- `/auth/signup` - Sign up
- `/auth/verify-otp` - OTP verification
- `/auth/login` - Log in
- `/onboarding/profile` - Profile setup
- `/onboarding/subjects` - Subject selection
- `/onboarding/notifications` - Notification permission
- `/dashboard` - Main dashboard
- `/practice` - Practice hub
- `/ai-tutor` - AI tutor home
- `/community` - Community hub
- `/profile` - User profile
- ... and 29 more routes

## 🎯 Next Steps

1. **Run build_runner** to generate Drift code
2. **Implement Riverpod providers** for auth, connectivity, theme
3. **Connect auth screens** to repository
4. **Build dashboard** with real API integration
5. **Implement offline sync** logic
6. **Add Firebase** configuration files
7. **Test on physical device** for offline functionality

## 📚 Resources

- [PRD Document](./NaijaPaper_PRD_v2.0.pdf) - Full product requirements
- [API Documentation](./NaijaPaper_API.yaml) - OpenAPI spec
- [Drift Documentation](https://drift.simonbinder.eu/)
- [Riverpod Documentation](https://riverpod.dev/)
- [GoRouter Documentation](https://pub.dev/packages/go_router)

## 🐛 Known Issues

- Firebase configuration files not included (add `google-services.json` and `GoogleService-Info.plist`)
- Drift generated code needs to be created with build_runner
- Some placeholder screens need full implementation

## 💡 Tips

- Use `flutter pub run build_runner watch` during development for auto-generation
- Test offline functionality on physical devices (simulators don't accurately reflect network conditions)
- Use Flutter DevTools for Riverpod state inspection
- Check `dio` logs in console for API debugging

---

**Status**: Foundation complete, ready for feature implementation
**Last Updated**: 2026-04-29
