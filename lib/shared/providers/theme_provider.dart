import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../local/hive/hive_service.dart';

// Theme mode provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final HiveService _hiveService = HiveService.instance;

  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final mode = _hiveService.getThemeMode();
    state = _themeModeFromString(mode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _hiveService.setThemeMode(_themeModeToString(mode));
  }

  ThemeMode _themeModeFromString(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }
}

// Language preference provider
final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<String> {
  final HiveService _hiveService = HiveService.instance;

  LanguageNotifier() : super('ENGLISH') {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    state = _hiveService.getLanguagePreference();
  }

  Future<void> setLanguage(String language) async {
    state = language;
    await _hiveService.setLanguagePreference(language);
  }
}
