# NaijaPaper - Quick Reference Card

## 🚀 **Getting Started**

### **First Time Setup:**
```bash
# 1. Install dependencies
flutter pub get

# 2. Generate Drift code (REQUIRED!)
dart run build_runner build --delete-conflicting-outputs

# 3. Run the app
flutter run
```

### **After Modifying Database:**
```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## 📁 **Project Structure**

```
lib/
├── main.dart                    # App entry point
├── core/                        # Core utilities
│   ├── theme/                   # AppTheme, AppColors
│   ├── router/                  # GoRouter config
│   ├── constants/               # API endpoints
│   ├── network/                 # Dio client
│   └── utils/                   # Validators, helpers
├── features/                    # Feature modules
│   ├── auth/                    # Authentication
│   ├── practice/                # Exam practice ✅
│   ├── dashboard/               # Dashboard
│   ├── ai_tutor/                # AI features
│   ├── community/               # Social features
│   └── profile/                 # User profile
├── shared/                      # Shared code
│   ├── widgets/                 # Reusable widgets
│   └── providers/               # Global providers
└── local/                       # Local storage
    ├── drift/                   # SQLite database
    └── hive/                    # Key-value storage
```

---

## 🎨 **Colors**

```dart
import '../../core/theme/app_colors.dart';

// Primary Colors
AppColors.primary              // #1A7A4A (Green)
AppColors.primaryLight         // #2D9B5F
AppColors.primaryDark          // #0F5A35

// Semantic Colors
AppColors.success              // #10B981
AppColors.error                // #EF4444
AppColors.warning              // #F59E0B
AppColors.info                 // #3B82F6

// Difficulty Colors
AppColors.difficultyEasy       // #10B981
AppColors.difficultyMedium     // #F59E0B
AppColors.difficultyHard       // #EF4444

// Text Colors
AppColors.textPrimary          // #1F2937
AppColors.textSecondary        // #6B7280
AppColors.textOnPrimary        // #FFFFFF

// Surface Colors
AppColors.surface              // #FFFFFF
AppColors.surfaceVariant       // #F3F4F6
AppColors.border               // #E5E7EB
```

---

## 🧭 **Navigation**

```dart
import 'package:go_router/go_router.dart';

// Navigate to a route
context.go('/practice/mock/active/session_123');

// Navigate with parameters
context.go('/practice/mock/results/$sessionId');

// Navigate with extra data
context.go('/ai-tutor/chat', extra: {
  'initialMessage': 'Help me with this question',
});

// Go back
context.pop();

// Replace current route
context.replace('/dashboard');
```

### **Available Routes:**
```dart
// Auth
'/splash'
'/welcome'
'/signup'
'/otp'
'/login'

// Main
'/dashboard'
'/practice'
'/practice/mock/setup'
'/practice/mock/active/:sessionId'
'/practice/mock/results/:sessionId'
'/practice/mock/review/:sessionId'
'/ai-tutor'
'/ai-tutor/chat'
'/community'
'/profile'
```

---

## 🔌 **API Calls**

```dart
import '../../core/network/dio_client.dart';
import '../../core/constants/api_constants.dart';

// GET request
final response = await DioClient.instance.get(
  ApiConstants.dashboardSummary,
);

// POST request
final response = await DioClient.instance.post(
  ApiConstants.examsCreate,
  data: {
    'examType': 'JAMB',
    'subjectIds': ['math', 'english'],
    'questionCount': 40,
  },
);

// With query parameters
final response = await DioClient.instance.get(
  ApiConstants.examsRecent,
  queryParameters: {'limit': 10},
);
```

### **Common Endpoints:**
```dart
ApiConstants.authSendOtp          // POST /auth/send-otp
ApiConstants.authVerifyOtp        // POST /auth/verify-otp
ApiConstants.examsCreate          // POST /exams/create
ApiConstants.examsRecent          // GET /exams/recent
ApiConstants.dashboardSummary     // GET /dashboard/summary
ApiConstants.aiChat               // POST /ai/chat
```

---

## 🗄️ **Database (Drift)**

```dart
import '../../local/drift/app_database.dart';

// Get database instance
final database = ref.read(appDatabaseProvider);

// Insert question
await database.into(database.questions).insert(
  QuestionsCompanion.insert(
    id: 'q_123',
    subjectId: 'sub_math',
    topicId: 'top_algebra',
    questionText: 'What is 2+2?',
    // ... other fields
  ),
);

// Query questions
final questions = await database.select(database.questions).get();

// Query with filter
final mathQuestions = await (
  database.select(database.questions)
    ..where((q) => q.subjectId.equals('sub_math'))
).get();

// Update
await (database.update(database.progress)
  ..where((p) => p.id.equals('prog_123'))
).write(ProgressCompanion(
  accuracyPct: Value(85.5),
));

// Delete
await (database.delete(database.questions)
  ..where((q) => q.id.equals('q_123'))
).go();
```

---

## 🎭 **State Management (Riverpod)**

### **Reading Providers:**
```dart
// In ConsumerWidget
@override
Widget build(BuildContext context, WidgetRef ref) {
  final user = ref.watch(currentUserProvider);
  final isOnline = ref.watch(connectivityProvider).value ?? false;
  
  return Text('Hello ${user?.name}');
}

// In ConsumerStatefulWidget
final examAsync = ref.watch(examNotifierProvider(sessionId));

examAsync.when(
  data: (exam) => Text('Exam loaded'),
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => Text('Error: $error'),
);
```

### **Modifying State:**
```dart
// Call a method on notifier
ref.read(examNotifierProvider(sessionId).notifier).loadSession();

// Update auth state
ref.read(authStateProvider.notifier).logout();
```

### **Creating Providers:**
```dart
// Simple provider
final myProvider = Provider<MyService>((ref) {
  return MyService();
});

// Future provider
final dataProvider = FutureProvider<Data>((ref) async {
  final api = ref.read(apiProvider);
  return await api.fetchData();
});

// State notifier provider
final counterProvider = StateNotifierProvider<Counter, int>((ref) {
  return Counter();
});

class Counter extends StateNotifier<int> {
  Counter() : super(0);
  
  void increment() => state++;
}
```

---

## 🎨 **Common Widgets**

### **AppButton:**
```dart
import '../../shared/widgets/app_button.dart';

AppButton(
  text: 'Start Exam',
  onPressed: () => _startExam(),
  isLoading: _isLoading,
  icon: Icons.play_arrow,
)
```

### **AppCard:**
```dart
import '../../shared/widgets/app_card.dart';

AppCard(
  title: 'Recent Exams',
  subtitle: 'View your exam history',
  icon: Icons.history,
  onTap: () => context.go('/practice/history'),
)
```

### **ScoreCircle:**
```dart
import '../../shared/widgets/score_circle.dart';

ScoreCircle(
  score: 85.5,
  size: 200,
)
```

### **SubjectChip:**
```dart
import '../../shared/widgets/subject_chip.dart';

SubjectChip(
  label: 'Mathematics',
  isSelected: _selectedSubjects.contains('math'),
  onTap: () => _toggleSubject('math'),
)
```

### **ShimmerLoader:**
```dart
import '../../shared/widgets/shimmer_loader.dart';

ShimmerLoader(
  width: double.infinity,
  height: 100,
  borderRadius: 12,
)
```

---

## 🎬 **Animations**

```dart
import 'package:flutter_animate/flutter_animate.dart';

// Fade in
Text('Hello').animate().fadeIn(duration: 300.ms);

// Slide in
Container().animate().slideX(begin: -0.3, end: 0);

// Scale
Icon(Icons.star).animate().scale(
  duration: 400.ms,
  curve: Curves.elasticOut,
);

// Chain animations
Text('Chained')
  .animate()
  .fadeIn(delay: 100.ms)
  .then()
  .slideY(begin: 0.2, end: 0);

// Stagger multiple widgets
Column(
  children: items.map((item) {
    final index = items.indexOf(item);
    return ItemWidget(item)
      .animate()
      .fadeIn(delay: (100 * index).ms);
  }).toList(),
)
```

---

## 🔔 **Snackbars & Dialogs**

### **Snackbar:**
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Exam submitted successfully!'),
    action: SnackBarAction(
      label: 'View',
      onPressed: () => context.go('/results'),
    ),
  ),
);
```

### **Dialog:**
```dart
final confirmed = await showDialog<bool>(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Submit Exam?'),
    content: Text('Are you sure?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: () => Navigator.pop(context, true),
        child: Text('Submit'),
      ),
    ],
  ),
);

if (confirmed == true) {
  // Submit exam
}
```

---

## 🐛 **Debugging**

### **Print Statements:**
```dart
print('Debug: $variable');
debugPrint('Debug message');
```

### **Riverpod Logger:**
```dart
// In main.dart
ProviderContainer(
  observers: [ProviderLogger()],
  child: MyApp(),
);

class ProviderLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    print('Provider ${provider.name ?? provider.runtimeType} updated');
  }
}
```

### **Dio Logging:**
```dart
// Already configured in DioClient
// Check console for API requests/responses
```

---

## 📱 **Platform-Specific Code**

```dart
import 'dart:io';

if (Platform.isAndroid) {
  // Android-specific code
} else if (Platform.isIOS) {
  // iOS-specific code
}
```

---

## 🧪 **Testing**

### **Widget Test:**
```dart
testWidgets('AppButton shows loading', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: AppButton(
          text: 'Submit',
          onPressed: () {},
          isLoading: true,
        ),
      ),
    ),
  );
  
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

### **Provider Test:**
```dart
test('Counter increments', () {
  final container = ProviderContainer();
  
  expect(container.read(counterProvider), 0);
  
  container.read(counterProvider.notifier).increment();
  
  expect(container.read(counterProvider), 1);
});
```

---

## 🔧 **Common Issues & Solutions**

### **Issue: Build runner fails**
```bash
# Solution: Clean and rebuild
flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### **Issue: Provider not found**
```dart
// Solution: Make sure you're using ConsumerWidget or Consumer
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Now ref is available
  }
}
```

### **Issue: Database not updating**
```bash
# Solution: Regenerate Drift code
dart run build_runner build --delete-conflicting-outputs
```

### **Issue: Navigation not working**
```dart
// Solution: Use context.go() instead of Navigator.push()
context.go('/dashboard');
```

---

## 📚 **Useful Commands**

```bash
# Run app
flutter run

# Run on specific device
flutter run -d chrome
flutter run -d emulator-5554

# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release

# Analyze code
flutter analyze

# Format code
dart format .

# Clean build
flutter clean

# Update dependencies
flutter pub upgrade

# Check outdated packages
flutter pub outdated
```

---

## 🎯 **Code Snippets**

### **Create a new screen:**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyScreen extends ConsumerWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Screen'),
      ),
      body: Center(
        child: Text('Hello World'),
      ),
    );
  }
}
```

### **Create a repository:**
```dart
import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_constants.dart';

class MyRepository {
  final DioClient _dioClient;

  MyRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient.instance;

  Future<Data> fetchData() async {
    final response = await _dioClient.get(ApiConstants.myEndpoint);
    return Data.fromJson(response.data);
  }
}
```

### **Create a provider:**
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myRepositoryProvider = Provider<MyRepository>((ref) {
  return MyRepository();
});

final myDataProvider = FutureProvider<Data>((ref) async {
  final repository = ref.read(myRepositoryProvider);
  return await repository.fetchData();
});
```

---

## 🚀 **Performance Tips**

1. **Use const constructors** wherever possible
2. **Avoid rebuilding entire trees** - use Consumer for specific parts
3. **Cache network images** with cached_network_image
4. **Use ListView.builder** for long lists
5. **Implement pagination** for large datasets
6. **Profile with DevTools** to find bottlenecks
7. **Use Drift indexes** for faster queries
8. **Batch database operations** when possible

---

## 📖 **Documentation Links**

- **Flutter:** https://flutter.dev/docs
- **Riverpod:** https://riverpod.dev
- **GoRouter:** https://pub.dev/packages/go_router
- **Drift:** https://drift.simonbinder.eu
- **Dio:** https://pub.dev/packages/dio
- **fl_chart:** https://pub.dev/packages/fl_chart

---

## 💡 **Pro Tips**

1. Always run build_runner after modifying Drift tables
2. Use `ref.read()` for one-time reads, `ref.watch()` for reactive updates
3. Keep widgets small and focused
4. Extract reusable components to shared/widgets/
5. Use AppColors instead of hardcoded colors
6. Test offline mode for every feature
7. Add loading and error states for all async operations
8. Use meaningful variable names
9. Comment complex logic
10. Keep functions under 50 lines

---

**Last Updated:** Current Session
**Version:** 1.0.0
**Progress:** 52%
