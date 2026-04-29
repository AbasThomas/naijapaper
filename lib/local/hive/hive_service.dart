import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/api_constants.dart';

/// HiveService — Local key-value storage for settings and small data
class HiveService {
  HiveService._();

  static final HiveService instance = HiveService._();

  late Box _settingsBox;
  late Box _cacheBox;

  /// Initialize Hive and open boxes
  Future<void> init() async {
    await Hive.initFlutter();
    _settingsBox = await Hive.openBox(ApiConstants.settingsBox);
    _cacheBox = await Hive.openBox(ApiConstants.cacheBox);
  }

  // ─── Settings ─────────────────────────────────────────────────────────────

  /// Get language preference (ENGLISH | PIDGIN | BOTH)
  String getLanguagePreference() {
    return _settingsBox.get(
      ApiConstants.languagePrefKey,
      defaultValue: 'ENGLISH',
    ) as String;
  }

  /// Set language preference
  Future<void> setLanguagePreference(String language) async {
    await _settingsBox.put(ApiConstants.languagePrefKey, language);
  }

  /// Get theme mode (light | dark | system)
  String getThemeMode() {
    return _settingsBox.get(
      ApiConstants.themeModeKey,
      defaultValue: 'system',
    ) as String;
  }

  /// Set theme mode
  Future<void> setThemeMode(String mode) async {
    await _settingsBox.put(ApiConstants.themeModeKey, mode);
  }

  /// Get notification preferences
  Map<String, bool> getNotificationPreferences() {
    final prefs = _settingsBox.get(
      ApiConstants.notificationsPrefKey,
      defaultValue: {
        'daily_drills': true,
        'exam_reminders': true,
        'community': true,
        'streaks': true,
        'marketing': false,
      },
    ) as Map;
    
    return Map<String, bool>.from(prefs);
  }

  /// Set notification preferences
  Future<void> setNotificationPreferences(Map<String, bool> prefs) async {
    await _settingsBox.put(ApiConstants.notificationsPrefKey, prefs);
  }

  /// Check if onboarding is complete
  bool isOnboardingComplete() {
    return _settingsBox.get(
      ApiConstants.onboardingCompleteKey,
      defaultValue: false,
    ) as bool;
  }

  /// Mark onboarding as complete
  Future<void> setOnboardingComplete() async {
    await _settingsBox.put(ApiConstants.onboardingCompleteKey, true);
  }

  /// Get last sync timestamp
  DateTime? getLastSync() {
    final timestamp = _settingsBox.get(ApiConstants.lastSyncKey) as int?;
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  /// Set last sync timestamp
  Future<void> setLastSync(DateTime dateTime) async {
    await _settingsBox.put(
      ApiConstants.lastSyncKey,
      dateTime.millisecondsSinceEpoch,
    );
  }

  // ─── Cache ────────────────────────────────────────────────────────────────

  /// Get cached value
  T? getCached<T>(String key) {
    return _cacheBox.get(key) as T?;
  }

  /// Set cached value
  Future<void> setCached(String key, dynamic value) async {
    await _cacheBox.put(key, value);
  }

  /// Remove cached value
  Future<void> removeCached(String key) async {
    await _cacheBox.delete(key);
  }

  /// Clear all cache
  Future<void> clearCache() async {
    await _cacheBox.clear();
  }

  // ─── Generic Getters/Setters ──────────────────────────────────────────────

  /// Get any value from settings
  T? get<T>(String key, {T? defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue) as T?;
  }

  /// Set any value in settings
  Future<void> set(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  /// Remove a key from settings
  Future<void> remove(String key) async {
    await _settingsBox.delete(key);
  }

  /// Clear all settings (use with caution)
  Future<void> clearAll() async {
    await _settingsBox.clear();
    await _cacheBox.clear();
  }
}
