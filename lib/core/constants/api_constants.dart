/// API and storage constants for NaijaPaper.
class ApiConstants {
  ApiConstants._();

  // ─── Base URLs ────────────────────────────────────────────────────────────
  static const String baseUrl =
      String.fromEnvironment('API_URL', defaultValue: 'https://api.naijapaper.com');
  static const String apiVersion = '/api/v1';
  static const String apiBaseUrl = '$baseUrl$apiVersion';

  // ─── Auth ─────────────────────────────────────────────────────────────────
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String authGoogle = '/auth/google';
  static const String authApple = '/auth/apple';
  static const String authRefresh = '/auth/refresh';
  static const String authLogout = '/auth/logout';

  // ─── Users ────────────────────────────────────────────────────────────────
  static const String usersMe = '/users/me';
  static const String usersMeAvatar = '/users/me/avatar';
  static const String usersMeAvatarPresign = '/users/me/avatar/presign';
  static const String usersMeFcmToken = '/users/me/fcm-token';
  static const String usersMeSubjects = '/users/me/subjects';
  static const String usersMeAiQuota = '/users/me/ai-quota';

  // ─── Subjects ─────────────────────────────────────────────────────────────
  static const String subjects = '/subjects';
  static String subjectBundle(String id) => '/subjects/$id/bundle';

  // ─── Questions ────────────────────────────────────────────────────────────
  static const String questions = '/questions';
  static String question(String id) => '/questions/$id';

  // ─── Exams ────────────────────────────────────────────────────────────────
  static const String examsCreate = '/exams/create';
  static const String examsRecent = '/exams/recent';
  static String exam(String id) => '/exams/$id';
  static String examSubmit(String id) => '/exams/$id/submit';
  static String examResults(String id) => '/exams/$id/results';
  static String examReview(String id) => '/exams/$id/review';

  // ─── Drills ───────────────────────────────────────────────────────────────
  static const String drillsToday = '/drills/today';
  static const String drillsComplete = '/drills/complete';

  // ─── AI ───────────────────────────────────────────────────────────────────
  static String aiExplain(String questionId) => '/ai/explain/$questionId';
  static const String aiChats = '/ai/chats';
  static String aiChatMessages(String chatId) => '/ai/chats/$chatId/messages';
  static String aiProctorAnalysis(String sessionId) =>
      '/ai/proctor-analysis/$sessionId';
  static const String aiFlashcardsGenerate = '/ai/flashcards/generate';

  // ─── Flashcards ───────────────────────────────────────────────────────────
  static const String flashcardDecks = '/flashcards/decks';
  static const String flashcardsDueToday = '/flashcards/due-today';
  static String flashcardCardReview(String id) => '/flashcards/cards/$id/review';

  // ─── Study Plans ──────────────────────────────────────────────────────────
  static const String studyPlansMe = '/study-plans/me';
  static const String studyPlansRegenerate = '/study-plans/regenerate';
  static String studyPlanTask(String taskId) =>
      '/study-plans/me/tasks/$taskId';

  // ─── Progress ─────────────────────────────────────────────────────────────
  static const String progressHeatmap = '/progress/heatmap';
  static const String progressSummary = '/progress/summary';
  static const String progressStats = '/progress/stats';

  // ─── Gamification ─────────────────────────────────────────────────────────
  static const String leaderboard = '/leaderboard';
  static const String leaderboardMe = '/leaderboard/me';
  static const String achievements = '/achievements';
  static const String achievementsProgress = '/achievements/progress';
  static const String challengesActive = '/challenges/active';
  static String challengeJoin(String id) => '/challenges/$id/join';
  static String challengeLeaderboard(String id) => '/challenges/$id/leaderboard';

  // ─── Community ────────────────────────────────────────────────────────────
  static const String groups = '/groups';
  static String groupMessages(String id) => '/groups/$id/messages';
  static String groupJoin(String id) => '/groups/$id/join';
  static String groupLeave(String id) => '/groups/$id/leave';
  static const String forumQuestions = '/forums/questions';
  static String forumQuestion(String id) => '/forums/questions/$id';
  static String forumQuestionAnswers(String id) =>
      '/forums/questions/$id/answers';
  static String forumAnswerVote(String id) => '/forums/answers/$id/vote';
  static String forumQuestionVote(String id) => '/forums/questions/$id/vote';
  static String forumAnswerAccept(String id) => '/forums/answers/$id/accept';
  static const String forumsTrending = '/forums/trending';
  static const String liveRoomsUpcoming = '/live-rooms/upcoming';

  // ─── Notifications ────────────────────────────────────────────────────────
  static const String notifications = '/notifications';
  static String notificationRead(String id) => '/notifications/$id/read';
  static const String notificationsReadAll = '/notifications/read-all';

  // ─── Subscriptions ────────────────────────────────────────────────────────
  static const String subscriptionPlans = '/subscriptions/plans';
  static const String subscriptionInitiate = '/subscriptions/initiate';
  static const String subscriptionMe = '/subscriptions/me';

  // ─── Tracker ──────────────────────────────────────────────────────────────
  static const String trackerExams = '/tracker/exams';
  static const String trackerScholarships = '/tracker/scholarships';
  static String trackerItem(String type, String id) => '/tracker/$type/$id';
  static const String trackerReminders = '/tracker/reminders';

  // ─── Parents ──────────────────────────────────────────────────────────────
  static const String parentsInvite = '/parents/invite';
  static const String parentsJoin = '/parents/join';
  static String parentStudentSummary(String id) =>
      '/parents/students/$id/summary';
  static String parentStudentHeatmap(String id) =>
      '/parents/students/$id/heatmap';
  static String parentStudentActivity(String id) =>
      '/parents/students/$id/activity';
  static const String parentsNotificationPrefs =
      '/parents/notifications/preferences';

  // ─── Admin ────────────────────────────────────────────────────────────────
  static const String adminOverview = '/admin/overview';
  static const String adminStudents = '/admin/students';
  static String adminStudent(String id) => '/admin/students/$id';
  static const String adminBroadcast = '/admin/broadcast';
  static const String adminInstitutions = '/admin/institutions';
  static const String adminCohortReport = '/admin/reports/cohort';

  // ─── Reports ──────────────────────────────────────────────────────────────
  static const String reportsGenerate = '/reports/generate';

  // ─── Sync ─────────────────────────────────────────────────────────────────
  static const String syncBatch = '/sync/batch';

  // ─── Dashboard ────────────────────────────────────────────────────────────
  static const String dashboardSummary = '/dashboard/summary';
  static const String dashboardUpcoming = '/dashboard/upcoming';

  // ─── Bookmarks ────────────────────────────────────────────────────────────
  static const String bookmarks = '/bookmarks';
  static String bookmark(String questionId) => '/bookmarks/$questionId';

  // ─── Referrals ────────────────────────────────────────────────────────────
  static const String referralsApply = '/referrals/apply';
}

/// Hive box names and key constants.
class StorageKeys {
  StorageKeys._();

  // Hive box names
  static const String settingsBox = 'settings';
  static const String cacheBox = 'cache';

  // Secure storage keys
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';

  // Settings keys
  static const String languagePref = 'language_pref';
  static const String darkMode = 'dark_mode';
  static const String fontSize = 'font_size';
  static const String highContrast = 'high_contrast';
  static const String wifiOnlyDownload = 'wifi_only_download';
  static const String offlineBannerDismissed = 'offline_banner_dismissed';
  static const String onboardingComplete = 'onboarding_complete';
  static const String notifDrills = 'notif_drills';
  static const String notifExams = 'notif_exams';
  static const String notifCommunity = 'notif_community';
  static const String notifStreaks = 'notif_streaks';
  static const String notifMarketing = 'notif_marketing';
}
