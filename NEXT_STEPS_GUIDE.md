# NaijaPaper - Next Steps Implementation Guide

## 🚨 **CRITICAL: Run This First**

Before doing anything else, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This generates the Drift database code. **The app will not compile without this.**

---

## ✅ **What's Already Done (52% Complete)**

### **Fully Functional:**
1. ✅ Complete infrastructure (theme, routing, networking)
2. ✅ Auth screens (splash, welcome, signup, OTP, login)
3. ✅ Offline architecture (Drift DAOs, sync service)
4. ✅ **Practice Module Core:**
   - Active Mock Screen (take exams)
   - Mock Results Screen (view results)
   - Answer Review Screen (review answers)
   - Complete state management (exam_notifier)

### **What Works:**
- Students can take full mock exams
- Timer counts down, auto-submits
- Results display with animations
- Answer review with explanations
- Offline support (answers saved locally)
- Language toggle (English/Pidgin)

---

## 🎯 **Next Priority: Practice Hub & Setup Screens**

### **1. Practice Hub Screen** (2-3 hours)
**File:** `lib/features/practice/practice_hub_screen.dart`

**What to Build:**
```dart
// Main practice landing page
- Hero section with "Start Mock Exam" button
- Recent exams list (with scores)
- Quick stats (total exams, avg score, time spent)
- Feature cards:
  - Mock Exams
  - Question Bank
  - Flashcards
  - Daily Drill
```

**API Integration:**
```dart
// Use these providers
final recentExamsProvider = FutureProvider<List<ExamSession>>((ref) async {
  final repository = ref.read(examRepositoryProvider);
  return await repository.getRecentExams(limit: 5);
});

// Fetch user stats
GET /api/v1/practice/stats
Response: {
  totalExams: 15,
  avgScore: 78.5,
  totalTimeMinutes: 450,
  currentStreak: 7
}
```

**UI Components:**
- Use existing `AppCard` widget
- Use `ScoreCircle` for recent exam scores
- Use `ShimmerLoader` for loading states

---

### **2. Mock Setup Screen** (3-4 hours)
**File:** `lib/features/practice/mock_setup_screen.dart`

**What to Build:**
```dart
// Exam configuration screen
- Subject selection (multi-select chips)
- Question count slider (10-100)
- Time limit toggle + duration picker
- Year range selection (2010-2024)
- AI Proctor toggle
- Difficulty filter (Easy/Medium/Hard)
- "Start Exam" button
```

**State Management:**
```dart
class MockSetupNotifier extends StateNotifier<MockSetupState> {
  // Track selected subjects, count, time, etc.
  // Validate before creating exam
  // Call createExamProvider
}

// Use existing createExamProvider
final examSession = await ref.read(
  createExamProvider(CreateExamParams(
    examType: 'JAMB',
    subjectIds: selectedSubjects,
    questionCount: questionCount,
    isTimed: isTimed,
    aiProctorEnabled: aiProctorEnabled,
    yearFrom: yearFrom,
    yearTo: yearTo,
  )).future,
);

// Navigate to Active Mock Screen
context.go('/practice/mock/active/${examSession.id}');
```

**API Endpoints:**
```dart
// Get available subjects
GET /api/v1/subjects
Response: [
  {
    id: "sub_123",
    name: "Mathematics",
    examType: "JAMB",
    questionCount: 1500,
    downloadSizeMb: 25
  }
]

// Create exam (already implemented in exam_repository.dart)
POST /api/v1/exams/create
```

**UI Components:**
- Use `SubjectChip` for subject selection
- Use Flutter's `Slider` for question count
- Use `SwitchListTile` for toggles
- Use `AppButton` for start button

---

## 📊 **Dashboard Implementation** (Week 3)

### **3. Dashboard Screen** (4-5 hours)
**File:** `lib/features/dashboard/dashboard_screen.dart`

**What to Build:**
```dart
// Main dashboard with:
- Welcome header with user name
- Streak ring (use existing StreakRing widget)
- Today's stats card (questions answered, time spent)
- Weak topics section (with progress bars)
- Daily drill card (quick 5-question practice)
- Recent activity timeline
- Leaderboard peek (top 3 users)
```

**API Integration:**
```dart
// Dashboard summary
GET /api/v1/dashboard/summary
Response: {
  user: { name, xp, level, streak },
  todayStats: { questionsAnswered, timeSpent, xpEarned },
  weakTopics: [
    { topicName, accuracy, questionsAttempted }
  ],
  recentActivity: [
    { type, timestamp, details }
  ]
}
```

**State Management:**
```dart
final dashboardProvider = FutureProvider<DashboardSummary>((ref) async {
  final response = await ref.read(dioClientProvider).get(
    ApiConstants.dashboardSummary,
  );
  return DashboardSummary.fromJson(response.data);
});
```

---

### **4. Heatmap Screen** (3-4 hours)
**File:** `lib/features/dashboard/heatmap_screen.dart`

**What to Build:**
```dart
// Topic mastery heatmap using fl_chart
- Grid of topics (rows) x difficulty (columns)
- Color intensity based on accuracy
- Tap to see topic details
- Filter by subject
```

**Use fl_chart:**
```dart
import 'package:fl_chart/fl_chart.dart';

// Create a grid chart
// Green = high accuracy (>80%)
// Yellow = medium accuracy (50-80%)
// Red = low accuracy (<50%)
// Gray = not attempted
```

**API Integration:**
```dart
GET /api/v1/progress/heatmap?subjectId=sub_123
Response: {
  topics: [
    {
      topicId: "top_1",
      topicName: "Algebra",
      easy: 85.5,
      medium: 72.3,
      hard: 45.0
    }
  ]
}
```

---

### **5. Study Plan Screen** (3-4 hours)
**File:** `lib/features/dashboard/study_plan_screen.dart`

**What to Build:**
```dart
// 30-day study plan using table_calendar
- Calendar view with daily tasks
- Task checkboxes
- Progress indicator
- Exam countdown
```

**Use table_calendar:**
```dart
import 'package:table_calendar/table_calendar.dart';

TableCalendar(
  firstDay: DateTime.now(),
  lastDay: DateTime.now().add(Duration(days: 30)),
  focusedDay: _focusedDay,
  eventLoader: (day) => _getTasksForDay(day),
  // Style with AppColors
)
```

**API Integration:**
```dart
GET /api/v1/study-plan
Response: {
  examDate: "2026-05-15",
  dailyTasks: [
    {
      date: "2026-04-29",
      tasks: [
        { id, title, completed, type }
      ]
    }
  ]
}
```

---

## 🤖 **AI Integration** (Weeks 5-6)

### **6. AI Chat Screen** (5-6 hours)
**File:** `lib/features/ai_tutor/ai_chat_screen.dart`

**What to Build:**
```dart
// Chat interface with AI tutor
- Message list (user + AI)
- Text input with send button
- Voice input button (speech_to_text)
- Voice output toggle (flutter_tts)
- SSE streaming for AI responses
- Language toggle (English/Pidgin)
```

**SSE Streaming with Dio:**
```dart
import 'package:dio/dio.dart';

Future<void> sendMessage(String message) async {
  final response = await dio.post(
    ApiConstants.aiChat,
    data: {'message': message, 'language': 'pidgin'},
    options: Options(
      responseType: ResponseType.stream,
      headers: {'Accept': 'text/event-stream'},
    ),
  );

  final stream = response.data.stream;
  await for (final chunk in stream) {
    final text = utf8.decode(chunk);
    // Parse SSE format: "data: {json}\n\n"
    // Update UI with streaming text
  }
}
```

**Voice Integration:**
```dart
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

// Voice input
final speech = SpeechToText();
await speech.initialize();
await speech.listen(onResult: (result) {
  setState(() => _textController.text = result.recognizedWords);
});

// Voice output
final tts = FlutterTts();
await tts.setLanguage('en-NG'); // Nigerian English
await tts.speak(aiResponse);
```

---

## 🎮 **Gamification** (Weeks 7-8)

### **7. XP & Streaks** (3-4 hours)

**What to Build:**
```dart
// XP system (already calculated in exam_notifier)
- XP bar in profile
- Level up animations
- XP breakdown (questions, exams, streaks)

// Streak tracking
- Daily login streak
- Study streak
- Streak freeze (use coins)
```

**API Integration:**
```dart
GET /api/v1/gamification/xp
Response: {
  currentXp: 1250,
  level: 5,
  xpToNextLevel: 250,
  xpBreakdown: {
    questions: 800,
    exams: 300,
    streaks: 150
  }
}

GET /api/v1/gamification/streak
Response: {
  currentStreak: 7,
  longestStreak: 15,
  freezesAvailable: 2
}
```

---

### **8. Leaderboard** (2-3 hours)
**File:** `lib/features/profile/leaderboard_screen.dart`

**What to Build:**
```dart
// Leaderboard with filters
- Global/Friends/School tabs
- Podium for top 3 (gold/silver/bronze)
- List for remaining users
- User's rank highlighted
- Filter by timeframe (week/month/all-time)
```

**API Integration:**
```dart
GET /api/v1/leaderboard?scope=global&timeframe=week
Response: {
  userRank: 42,
  users: [
    {
      rank: 1,
      userId: "usr_123",
      name: "Chidi Okafor",
      xp: 5000,
      avatar: "url"
    }
  ]
}
```

---

## 💬 **Community Features** (Weeks 9-10)

### **9. Study Groups with WebSocket** (6-8 hours)
**File:** `lib/features/community/study_group_screen.dart`

**What to Build:**
```dart
// Real-time chat using Socket.io
- Message list
- Text input
- Online members list
- Typing indicators
- Message reactions
```

**Socket.io Integration:**
```dart
import 'package:socket_io_client/socket_io_client.dart' as IO;

final socket = IO.io(
  'https://api.naijapaper.com',
  IO.OptionBuilder()
    .setTransports(['websocket'])
    .setAuth({'token': authToken})
    .build(),
);

socket.on('connect', (_) => print('Connected'));
socket.on('message', (data) => _handleMessage(data));
socket.emit('join_group', {'groupId': groupId});
socket.emit('send_message', {'text': message, 'groupId': groupId});
```

---

## 💳 **Subscription** (Week 11)

### **10. Paystack Integration** (4-5 hours)
**File:** `lib/features/profile/subscription_screen.dart`

**What to Build:**
```dart
// Subscription plans
- Free vs Premium comparison
- Plan cards with features
- "Upgrade" button
- Paystack WebView checkout
```

**Paystack WebView:**
```dart
import 'package:webview_flutter/webview_flutter.dart';

// Initialize payment
POST /api/v1/payments/initialize
Response: {
  authorizationUrl: "https://checkout.paystack.com/...",
  reference: "ref_123"
}

// Open WebView
WebView(
  initialUrl: authorizationUrl,
  javascriptMode: JavascriptMode.unrestricted,
  onPageFinished: (url) {
    if (url.contains('callback')) {
      // Verify payment
      GET /api/v1/payments/verify?reference=ref_123
    }
  },
)
```

---

## 📝 **Testing Checklist**

Before marking any feature as complete:

- [ ] Test on Android
- [ ] Test on iOS
- [ ] Test offline mode
- [ ] Test with slow network
- [ ] Test error states
- [ ] Test empty states
- [ ] Test loading states
- [ ] Test with real API
- [ ] Check for memory leaks
- [ ] Verify animations are smooth

---

## 🎯 **Priority Order**

1. **Week 3:** Practice Hub + Mock Setup + Dashboard
2. **Week 4:** Heatmap + Study Plan
3. **Week 5-6:** AI Chat + Voice
4. **Week 7-8:** Gamification (XP, Streaks, Leaderboard)
5. **Week 9-10:** Community (Study Groups, Forum)
6. **Week 11:** Subscription + Paystack
7. **Week 12:** Polish + Testing

---

## 📚 **Useful Resources**

### **Documentation:**
- `COMPLETE_IMPLEMENTATION_STATUS.md` - Overall progress
- `IMPLEMENTATION_GUIDE.md` - Detailed code examples
- `SESSION_SUMMARY.md` - What was done this session
- `README_FLUTTER_STRUCTURE.md` - Architecture overview

### **Key Files:**
- `lib/core/constants/api_constants.dart` - All API endpoints
- `lib/core/theme/app_colors.dart` - Color palette
- `lib/core/router/app_router.dart` - All routes
- `lib/shared/providers/` - Global providers

### **Dependencies Already Installed:**
- flutter_riverpod (state management)
- go_router (navigation)
- dio (networking)
- drift (database)
- socket_io_client (WebSocket)
- speech_to_text (voice input)
- flutter_tts (voice output)
- fl_chart (charts)
- table_calendar (calendar)
- flutter_animate (animations)
- share_plus (sharing)

---

## 💡 **Tips for Success**

1. **Always run build_runner** after modifying Drift tables
2. **Use existing widgets** from `lib/shared/widgets/`
3. **Follow the color scheme** in `app_colors.dart`
4. **Test offline mode** for every feature
5. **Add loading states** for all API calls
6. **Handle errors gracefully** with user-friendly messages
7. **Use Riverpod providers** for state management
8. **Keep code DRY** - extract reusable components
9. **Comment complex logic** for future developers
10. **Test on real devices** not just emulators

---

## 🚀 **Let's Build!**

The foundation is solid. The practice module core is working. Now it's time to complete the remaining features and launch NaijaPaper! 🎓

**Questions?** Check the documentation files or review existing implementations for patterns.

**Good luck!** 💪
