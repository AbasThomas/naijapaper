# NaijaPaper Flutter - Implementation Guide

This guide provides step-by-step instructions for implementing each feature module.

## 🎯 Phase 1: Core Setup (Week 1)

### Step 1: Generate Drift Code

```bash
# Install build_runner if not already installed
flutter pub get

# Generate Drift database code
dart run build_runner build --delete-conflicting-outputs

# For continuous generation during development
dart run build_runner watch
```

### Step 2: Add Firebase Configuration

1. Download `google-services.json` from Firebase Console
2. Place in `android/app/`
3. Download `GoogleService-Info.plist`
4. Place in `ios/Runner/`

### Step 3: Create Shared Providers

Create `lib/shared/providers/auth_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/domain/auth_user.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AsyncValue<AuthUser?>>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AsyncValue<AuthUser?>> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AsyncValue.loading()) {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    try {
      final isAuth = await _repository.isAuthenticated();
      if (isAuth) {
        final user = await _repository.getCurrentUser();
        state = AsyncValue.data(user);
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> sendOtp(String phone) async {
    await _repository.sendOtp(phone);
  }

  Future<void> verifyOtp(String phone, String otp) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.verifyOtp(phone, otp);
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AsyncValue.data(null);
  }
}
```

Create `lib/shared/providers/connectivity_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final connectivityProvider = StreamProvider<ConnectivityResult>((ref) {
  return Connectivity().onConnectivityChanged;
});

final isOnlineProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return connectivity.when(
    data: (result) => result != ConnectivityResult.none,
    loading: () => true,
    error: (_, __) => false,
  );
});
```

## 🎯 Phase 2: Auth Flow (Week 1-2)

### Implement OAuth Sign-In

Update `signup_screen.dart` and `login_screen.dart`:

```dart
// Google Sign-In
Future<void> _googleSignIn() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    
    // Call auth repository
    await ref.read(authStateProvider.notifier).googleSignIn(googleAuth.idToken!);
    
    if (!mounted) return;
    context.go('/dashboard');
  } catch (e) {
    // Handle error
  }
}

// Apple Sign-In
Future<void> _appleSignIn() async {
  try {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    
    // Call auth repository
    await ref.read(authStateProvider.notifier).appleSignIn(credential.identityToken!);
    
    if (!mounted) return;
    context.go('/dashboard');
  } catch (e) {
    // Handle error
  }
}
```

### Update Splash Screen with Auth Check

```dart
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;

    final authState = ref.read(authStateProvider);
    
    authState.when(
      data: (user) {
        if (user != null) {
          context.go('/dashboard');
        } else {
          context.go('/onboarding/welcome');
        }
      },
      loading: () => context.go('/onboarding/welcome'),
      error: (_, __) => context.go('/onboarding/welcome'),
    );
  }
}
```

## 🎯 Phase 3: Dashboard Implementation (Week 2)

### Create Dashboard Data Models

Create `lib/features/dashboard/domain/dashboard_summary.dart`:

```dart
class DashboardSummary {
  final int currentStreak;
  final int xpTotal;
  final int daysUntilExam;
  final List<WeakTopic> weakTopics;
  final ExamSession? recentMock;
  final TrackerEvent? upcomingDeadline;
  final bool hasDrillToday;

  DashboardSummary({
    required this.currentStreak,
    required this.xpTotal,
    required this.daysUntilExam,
    required this.weakTopics,
    this.recentMock,
    this.upcomingDeadline,
    required this.hasDrillToday,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      currentStreak: json['currentStreak'] as int,
      xpTotal: json['xpTotal'] as int,
      daysUntilExam: json['daysUntilExam'] as int,
      weakTopics: (json['weakTopics'] as List)
          .map((e) => WeakTopic.fromJson(e))
          .toList(),
      recentMock: json['recentMock'] != null
          ? ExamSession.fromJson(json['recentMock'])
          : null,
      upcomingDeadline: json['upcomingDeadline'] != null
          ? TrackerEvent.fromJson(json['upcomingDeadline'])
          : null,
      hasDrillToday: json['hasDrillToday'] as bool,
    );
  }
}
```

### Create Dashboard Repository

Create `lib/features/dashboard/data/dashboard_repository.dart`:

```dart
class DashboardRepository {
  final DioClient _dioClient;

  DashboardRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient.instance;

  Future<DashboardSummary> getSummary() async {
    final response = await _dioClient.get(ApiConstants.dashboardSummary);
    return DashboardSummary.fromJson(response.data);
  }

  Future<List<TrackerEvent>> getUpcoming() async {
    final response = await _dioClient.get(ApiConstants.dashboardUpcoming);
    return (response.data as List)
        .map((e) => TrackerEvent.fromJson(e))
        .toList();
  }
}
```

### Create Dashboard Provider

```dart
@riverpod
class DashboardNotifier extends _$DashboardNotifier {
  @override
  Future<DashboardSummary> build() async {
    return await ref.read(dashboardRepositoryProvider).getSummary();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(dashboardRepositoryProvider).getSummary();
    });
  }
}
```

### Update Dashboard Screen

```dart
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => context.push('/notifications'),
          ),
        ],
      ),
      body: dashboardAsync.when(
        data: (summary) => _buildDashboard(context, summary),
        loading: () => const ShimmerList(),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, DashboardSummary summary) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(dashboardNotifierProvider.notifier).refresh();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with greeting and streak
            _buildHeader(context, summary),
            const SizedBox(height: 24),
            
            // Daily Drill card
            if (summary.hasDrillToday) _buildDrillCard(context),
            const SizedBox(height: 16),
            
            // Upcoming deadline
            if (summary.upcomingDeadline != null)
              _buildDeadlineCard(context, summary.upcomingDeadline!),
            const SizedBox(height: 16),
            
            // Weak topics
            if (summary.weakTopics.isNotEmpty)
              _buildWeakTopicsCard(context, summary.weakTopics),
            const SizedBox(height: 16),
            
            // Recent mock
            if (summary.recentMock != null)
              _buildRecentMockCard(context, summary.recentMock!),
          ],
        ),
      ),
    );
  }
}
```

## 🎯 Phase 4: Practice Module (Week 3-4)

### Mock Exam Flow

1. **Mock Setup Screen**: Configure exam parameters
2. **Active Mock Screen**: CBT simulation with timer
3. **Mock Results Screen**: Score display with animations
4. **Answer Review Screen**: Question-by-question review

### Implement Active Mock Screen

```dart
class ActiveMockScreen extends ConsumerStatefulWidget {
  final String sessionId;
  const ActiveMockScreen({super.key, required this.sessionId});

  @override
  ConsumerState<ActiveMockScreen> createState() => _ActiveMockScreenState();
}

class _ActiveMockScreenState extends ConsumerState<ActiveMockScreen> {
  int _currentQuestionIndex = 0;
  Map<int, String> _answers = {};
  Timer? _timer;
  int _remainingSeconds = 7200; // 2 hours for JAMB

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _submitExam();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _submitExam() async {
    // Save to Drift first
    await ref.read(examRepositoryProvider).saveAnswersLocally(
      widget.sessionId,
      _answers,
    );

    // Submit to API
    try {
      await ref.read(examRepositoryProvider).submitExam(
        widget.sessionId,
        _answers,
      );
    } catch (e) {
      // Queue for sync if offline
      await ref.read(syncQueueProvider).addToQueue(
        'EXAM_SUBMIT',
        {'sessionId': widget.sessionId, 'answers': _answers},
      );
    }

    if (!mounted) return;
    context.go('/practice/mock/results/${widget.sessionId}');
  }

  @override
  Widget build(BuildContext context) {
    final examAsync = ref.watch(examSessionProvider(widget.sessionId));

    return WillPopScope(
      onWillPop: () async {
        // Prevent accidental exit
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit Exam?'),
            content: const Text('Your progress will be saved.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Exit'),
              ),
            ],
          ),
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Question ${_currentQuestionIndex + 1}'),
          actions: [
            // Timer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                AppDateUtils.formatTimerLong(_remainingSeconds),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: examAsync.when(
          data: (exam) => _buildExamInterface(exam),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}
```

## 🎯 Phase 5: Offline Sync (Week 4-5)

### Implement Sync Service

Create `lib/features/sync/sync_service.dart`:

```dart
class SyncService {
  final DioClient _dioClient;
  final AppDatabase _database;

  SyncService(this._dioClient, this._database);

  Future<void> syncAll() async {
    // Get all unsynced items
    final queue = await _database.getUnsyncedQueue();
    
    if (queue.isEmpty) return;

    try {
      // Batch sync to API
      final response = await _dioClient.post(
        ApiConstants.syncBatch,
        data: {
          'records': queue.map((item) => {
            'action': item.action,
            'payload': jsonDecode(item.payloadJson),
          }).toList(),
        },
      );

      // Mark as synced
      final syncedIds = (response.data['syncedIds'] as List)
          .map((id) => id as int)
          .toList();
      
      await _database.markQueueSynced(syncedIds);

      // Update local state with server response
      if (response.data['serverProgress'] != null) {
        await _updateLocalProgress(response.data['serverProgress']);
      }
    } catch (e) {
      // Sync will retry on next connectivity restore
      print('Sync failed: $e');
    }
  }

  Future<void> _updateLocalProgress(Map<String, dynamic> serverProgress) async {
    // Update XP, streak, etc. from server
    // This ensures server is authoritative
  }
}
```

### Add Connectivity Listener

Update `main.dart`:

```dart
class NaijaPaperApp extends ConsumerStatefulWidget {
  const NaijaPaperApp({super.key});

  @override
  ConsumerState<NaijaPaperApp> createState() => _NaijaPaperAppState();
}

class _NaijaPaperAppState extends ConsumerState<NaijaPaperApp> {
  @override
  void initState() {
    super.initState();
    _setupConnectivityListener();
  }

  void _setupConnectivityListener() {
    ref.listen(connectivityProvider, (previous, next) {
      next.whenData((result) {
        if (result != ConnectivityResult.none) {
          // Trigger sync when coming online
          ref.read(syncServiceProvider).syncAll();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // ... existing build code
  }
}
```

## 🎯 Testing Checklist

### Unit Tests
- [ ] Validators (phone, email, OTP)
- [ ] Date utilities
- [ ] Auth repository
- [ ] Dashboard repository

### Widget Tests
- [ ] Auth screens
- [ ] Dashboard cards
- [ ] Shared widgets

### Integration Tests
- [ ] Complete auth flow
- [ ] Mock exam flow
- [ ] Offline sync

## 📚 Additional Resources

- **Riverpod Code Generation**: https://riverpod.dev/docs/concepts/about_code_generation
- **Drift Migrations**: https://drift.simonbinder.eu/docs/advanced-features/migrations/
- **GoRouter Deep Linking**: https://pub.dev/packages/go_router#deep-linking

---

**Next**: Start with Phase 1 (Core Setup) and work through each phase sequentially.
