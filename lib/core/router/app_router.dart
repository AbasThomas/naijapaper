import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Auth screens
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/welcome_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/auth/presentation/otp_screen.dart';
import '../../features/auth/presentation/login_screen.dart';

// Onboarding screens
import '../../features/onboarding/profile_setup_screen.dart';
import '../../features/onboarding/subject_selection_screen.dart';
import '../../features/onboarding/notification_permission_screen.dart';

// Dashboard screens
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/dashboard/heatmap_screen.dart';
import '../../features/dashboard/study_plan_screen.dart';
import '../../features/dashboard/notifications_screen.dart';

// Practice screens
import '../../features/practice/practice_hub_screen.dart';
import '../../features/practice/mock_setup_screen.dart';
import '../../features/practice/active_mock_screen.dart';
import '../../features/practice/mock_results_screen.dart';
import '../../features/practice/answer_review_screen.dart';
import '../../features/practice/question_bank_screen.dart';
import '../../features/practice/flashcard_screen.dart';
import '../../features/practice/daily_drill_screen.dart';
import '../../features/practice/bookmarks_screen.dart';
import '../../features/practice/practice_history_screen.dart';

// AI Tutor screens
import '../../features/ai_tutor/ai_tutor_home_screen.dart';
import '../../features/ai_tutor/ai_chat_screen.dart';
import '../../features/ai_tutor/ai_proctor_results_screen.dart';

// Community screens
import '../../features/community/community_hub_screen.dart';
import '../../features/community/study_group_screen.dart';
import '../../features/community/forum_screen.dart';
import '../../features/community/forum_question_screen.dart';
import '../../features/community/live_room_screen.dart';

// Profile screens
import '../../features/profile/profile_screen.dart';
import '../../features/profile/edit_profile_screen.dart';
import '../../features/profile/settings_screen.dart';
import '../../features/profile/offline_manager_screen.dart';
import '../../features/profile/parent_dashboard_screen.dart';
import '../../features/profile/subscription_screen.dart';
import '../../features/profile/leaderboard_screen.dart';

// Gamification screens
import '../../features/gamification/achievements_screen.dart';
import '../../features/gamification/challenges_screen.dart';

// Tracker screens
import '../../features/tracker/tracker_screen.dart';
import '../../features/tracker/tracker_detail_screen.dart';

// Admin screens
import '../../features/admin/admin_dashboard_screen.dart';
import '../../features/admin/admin_student_detail_screen.dart';
import '../../features/admin/admin_setup_screen.dart';

/// AppRouter — GoRouter configuration with all 42 routes
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      // ─── Auth Routes ────────────────────────────────────────────────────
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/auth/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/auth/verify-otp',
        name: 'verify-otp',
        builder: (context, state) {
          final phone = state.extra as String?;
          return OtpScreen(phoneNumber: phone ?? '');
        },
      ),
      GoRoute(
        path: '/auth/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // ─── Onboarding Routes ──────────────────────────────────────────────
      GoRoute(
        path: '/onboarding/profile',
        name: 'profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: '/onboarding/subjects',
        name: 'subject-selection',
        builder: (context, state) => const SubjectSelectionScreen(),
      ),
      GoRoute(
        path: '/onboarding/notifications',
        name: 'notification-permission',
        builder: (context, state) => const NotificationPermissionScreen(),
      ),

      // ─── Main App Shell with Bottom Navigation ──────────────────────────
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/dashboard/heatmap',
        name: 'heatmap',
        builder: (context, state) => const HeatmapScreen(),
      ),
      GoRoute(
        path: '/dashboard/study-plan',
        name: 'study-plan',
        builder: (context, state) => const StudyPlanScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),

      // ─── Practice Routes ────────────────────────────────────────────────
      GoRoute(
        path: '/practice',
        name: 'practice',
        builder: (context, state) => const PracticeHubScreen(),
      ),
      GoRoute(
        path: '/practice/mock/setup',
        name: 'mock-setup',
        builder: (context, state) => const MockSetupScreen(),
      ),
      GoRoute(
        path: '/practice/mock/active/:sessionId',
        name: 'active-mock',
        builder: (context, state) {
          final sessionId = state.pathParameters['sessionId']!;
          return ActiveMockScreen(sessionId: sessionId);
        },
      ),
      GoRoute(
        path: '/practice/mock/results/:sessionId',
        name: 'mock-results',
        builder: (context, state) {
          final sessionId = state.pathParameters['sessionId']!;
          return MockResultsScreen(sessionId: sessionId);
        },
      ),
      GoRoute(
        path: '/practice/mock/review/:sessionId',
        name: 'answer-review',
        builder: (context, state) {
          final sessionId = state.pathParameters['sessionId']!;
          return AnswerReviewScreen(sessionId: sessionId);
        },
      ),
      GoRoute(
        path: '/practice/questions',
        name: 'question-bank',
        builder: (context, state) => const QuestionBankScreen(),
      ),
      GoRoute(
        path: '/practice/flashcards',
        name: 'flashcards',
        builder: (context, state) => const FlashcardScreen(),
      ),
      GoRoute(
        path: '/practice/drill',
        name: 'daily-drill',
        builder: (context, state) => const DailyDrillScreen(),
      ),
      GoRoute(
        path: '/practice/bookmarks',
        name: 'bookmarks',
        builder: (context, state) => const BookmarksScreen(),
      ),
      GoRoute(
        path: '/practice/history',
        name: 'practice-history',
        builder: (context, state) => const PracticeHistoryScreen(),
      ),

      // ─── AI Tutor Routes ────────────────────────────────────────────────
      GoRoute(
        path: '/ai-tutor',
        name: 'ai-tutor',
        builder: (context, state) => const AITutorHomeScreen(),
      ),
      GoRoute(
        path: '/ai-tutor/chat',
        name: 'ai-chat',
        builder: (context, state) {
          return const AIChatScreen();
        },
      ),
      GoRoute(
        path: '/ai-tutor/proctor-results/:sessionId',
        name: 'ai-proctor-results',
        builder: (context, state) {
          final sessionId = state.pathParameters['sessionId']!;
          return AiProctorResultsScreen(sessionId: sessionId);
        },
      ),

      // ─── Community Routes ───────────────────────────────────────────────
      GoRoute(
        path: '/community',
        name: 'community',
        builder: (context, state) => const CommunityHubScreen(),
      ),
      GoRoute(
        path: '/community/groups/:groupId',
        name: 'study-group',
        builder: (context, state) {
          final groupId = state.pathParameters['groupId']!;
          return StudyGroupScreen(groupId: groupId);
        },
      ),
      GoRoute(
        path: '/community/forum',
        name: 'forum',
        builder: (context, state) => const ForumScreen(),
      ),
      GoRoute(
        path: '/community/forum/:questionId',
        name: 'forum-question',
        builder: (context, state) {
          final questionId = state.pathParameters['questionId']!;
          return ForumQuestionScreen(questionId: questionId);
        },
      ),
      GoRoute(
        path: '/community/live/:roomId',
        name: 'live-room',
        builder: (context, state) {
          final roomId = state.pathParameters['roomId']!;
          return LiveRoomScreen(roomId: roomId);
        },
      ),

      // ─── Profile Routes ─────────────────────────────────────────────────
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        name: 'edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/settings/offline',
        name: 'offline-manager',
        builder: (context, state) => const OfflineManagerScreen(),
      ),
      GoRoute(
        path: '/parent/:studentId',
        name: 'parent-dashboard',
        builder: (context, state) {
          final studentId = state.pathParameters['studentId']!;
          return ParentDashboardScreen(studentId: studentId);
        },
      ),
      GoRoute(
        path: '/subscription',
        name: 'subscription',
        builder: (context, state) => const SubscriptionScreen(),
      ),
      GoRoute(
        path: '/leaderboard',
        name: 'leaderboard',
        builder: (context, state) => const LeaderboardScreen(),
      ),

      // ─── Gamification Routes ────────────────────────────────────────────
      GoRoute(
        path: '/achievements',
        name: 'achievements',
        builder: (context, state) => const AchievementsScreen(),
      ),
      GoRoute(
        path: '/challenges',
        name: 'challenges',
        builder: (context, state) => const ChallengesScreen(),
      ),

      // ─── Tracker Routes ─────────────────────────────────────────────────
      GoRoute(
        path: '/tracker',
        name: 'tracker',
        builder: (context, state) => const TrackerScreen(),
      ),
      GoRoute(
        path: '/tracker/:type/:itemId',
        name: 'tracker-detail',
        builder: (context, state) {
          final type = state.pathParameters['type']!;
          final itemId = state.pathParameters['itemId']!;
          return TrackerDetailScreen(type: type, itemId: itemId);
        },
      ),

      // ─── Institution Admin Routes ─────────────────────────────────────────────
      GoRoute(
        path: '/admin',
        name: 'admin-dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin/students/:studentId',
        name: 'admin-student-detail',
        builder: (context, state) {
          final studentId = state.pathParameters['studentId']!;
          return AdminStudentDetailScreen(studentId: studentId);
        },
      ),
      GoRoute(
        path: '/admin/setup',
        name: 'admin-setup',
        builder: (context, state) => const AdminSetupScreen(),
      ),
    ],
  );
});
