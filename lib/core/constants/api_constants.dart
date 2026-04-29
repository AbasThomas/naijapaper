/// API Constants — Base URLs, endpoints, and storage keys
class ApiConstants {
  ApiConstants._();

  // ─── Base URLs ────────────────────────────────────────────────────────────
  
  /// Production API base URL
  static const String baseUrl = 'https://api.naijapaper.com/api/v1';
  
  /// Staging API base URL (for testing)
  static const String stagingUrl = 'https://staging-api.naijapaper.com/api/v1';
  
  /// WebSocket base URL
  static const String wsUrl = 'https://api.naijapaper.com';
  
  /// R2 CDN base URL for assets
  static const String cdnUrl = 'https://r2.naijapaper.com';

  // ─── API Endpoints ────────────────────────────────────────────────────────
  
  // Auth
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String googleAuth = '/auth/google';
  static const String appleAuth = '/auth/apple';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  
  // Users
  static const String userMe = '/users/me';
  static const String userAvatar = '/users/me/avatar';
  static const String userAvatarPresign = '/users/me/avatar/presign';
  static const String userFcmToken = '/users/me/fcm-token';
  static const String userAiQuota = '/users/me/ai-quota';
  static const String userSubjects = '/users/me/subjects';
  
  // Subjects & Questions
  static const String subjects = '/subjects';
  static const String questions = '/questions';
  
  // Exams
  static const String examsCreate = '/exams/create';
  static const String examsRecent = '/exams/recent';
  
  // Drills
  static const String drillsToday = '/drills/today';
  static const String drillsComplete = '/drills/complete';
  
  // Progress
  static const String progressHeatmap = '/progress/heatmap';
  static const String progressSummary = '/progress/summary';
  static const String progressStats = '/progress/stats';
  
  // AI
  static const String aiChats = '/ai/chats';
  static const String aiFlashcardsGenerate = '/ai/flashcards/generate';
  
  // Gamification
  static const String leaderboard = '/leaderboard';
  static const String leaderboardMe = '/leaderboard/me';
  static const String achievements = '/achievements';
  static const String achievementsProgress = '/achievements/progress';
  static const String challengesActive = '/challenges/active';
  
  // Flashcards
  static const String flashcardsDecks = '/flashcards/decks';
  static const String flashcardsDueToday = '/flashcards/due-today';
  
  // Study Plans
  static const String studyPlansMe = '/study-plans/me';
  static const String studyPlansRegenerate = '/study-plans/regenerate';
  
  // Community
  static const String groups = '/groups';
  static const String forumsQuestions = '/forums/questions';
  static const String forumsTrending = '/forums/trending';
  static const String liveRoomsUpcoming = '/live-rooms/upcoming';
  
  // Notifications
  static const String notifications = '/notifications';
  static const String notificationsReadAll = '/notifications/read-all';
  
  // Payments & Subscriptions
  static const String subscriptionsPlans = '/subscriptions/plans';
  static const String subscriptionsInitiate = '/subscriptions/initiate';
  static const String subscriptionsMe = '/subscriptions/me';
  
  // Tracker
  static const String trackerExams = '/tracker/exams';
  static const String trackerScholarships = '/tracker/scholarships';
  static const String trackerReminders = '/tracker/reminders';
  
  // Parents
  static const String parentsInvite = '/parents/invite';
  static const String parentsJoin = '/parents/join';
  
  // Admin
  static const String adminOverview = '/admin/overview';
  static const String adminStudents = '/admin/students';
  static const String adminBroadcast = '/admin/broadcast';
  
  // Reports
  static const String reportsGenerate = '/reports/generate';
  
  // Sync
  static const String syncBatch = '/sync/batch';
  
  // Dashboard
  static const String dashboardSummary = '/dashboard/summary';
  static const String dashboardUpcoming = '/dashboard/upcoming';
  
  // Bookmarks
  static const String bookmarks = '/bookmarks';
  
  // Referrals
  static const String referralsApply = '/referrals/apply';

  // ─── Storage Keys ─────────────────────────────────────────────────────────
  
  /// Secure storage keys (flutter_secure_storage)
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  
  /// Hive box names
  static const String settingsBox = 'settings';
  static const String cacheBox = 'cache';
  
  /// Hive keys
  static const String languagePrefKey = 'language_pref';
  static const String themeModeKey = 'theme_mode';
  static const String notificationsPrefKey = 'notifications_pref';
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String lastSyncKey = 'last_sync';

  // ─── App Constants ────────────────────────────────────────────────────────
  
  /// Request timeout duration
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  /// Pagination
  static const int defaultPageSize = 20;
  static const int questionsPerPage = 50;
  
  /// Free tier limits
  static const int freeTierSubjects = 2;
  static const int freeTierAiQueries = 5;
  
  /// Nigeria country code
  static const String nigeriaCountryCode = '+234';
  
  /// OTP length
  static const int otpLength = 6;
  
  /// Exam durations (minutes)
  static const int jambDuration = 120;
  static const int waecDuration = 180;
  static const int necoDuration = 180;
}
