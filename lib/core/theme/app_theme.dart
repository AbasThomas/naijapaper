import 'package:flutter/material.dart';

/// AppColors — Single source of truth for every color in NaijaPaper.
///
/// HOW TO USE:
///   Container(color: AppColors.primary)
///   Text('Hello', style: TextStyle(color: AppColors.textPrimary))
class AppColors {
  // ─── Private constructor ──────────────────────────────────────────────────
  // Prevents anyone from creating an instance of this class.
  // All colors are static — access them directly: AppColors.primary
  AppColors._();

  // ─── Brand Colors ─────────────────────────────────────────────────────────

  /// The main NaijaPaper green — used on buttons, app bar, active icons
  static const Color primary = Color(0xFF1A7A4A);

  /// Slightly lighter green — used for hover states, selected chips
  static const Color primaryLight = Color(0xFF25A863);

  /// Dark green — used for pressed states, dark mode primary
  static const Color primaryDark = Color(0xFF115233);

  /// Gold/amber — used for premium badges, streak flames, leaderboard podium
  static const Color secondary = Color(0xFFFFB800);

  /// Light gold — used for premium card backgrounds
  static const Color secondaryLight = Color(0xFFFFF3CC);

  // ─── Semantic Colors ──────────────────────────────────────────────────────

  /// Red — used for wrong answers, errors, danger states
  static const Color error = Color(0xFFE53E3E);

  /// Light red — background for error banners
  static const Color errorLight = Color(0xFFFFF5F5);

  /// Green — used for correct answers, success states
  static const Color success = Color(0xFF38A169);

  /// Light green — background for success banners
  static const Color successLight = Color(0xFFF0FFF4);

  /// Amber/orange — used for warnings, "needs work" heatmap cells
  static const Color warning = Color(0xFFED8936);

  /// Light amber — background for warning banners
  static const Color warningLight = Color(0xFFFFFAF0);

  // ─── Heatmap Colors ───────────────────────────────────────────────────────
  // These three are used on the Weak Topic Heatmap screen

  /// Red cell — topic accuracy below 40%
  static const Color heatmapRed = Color(0xFFFC8181);

  /// Amber cell — topic accuracy between 40% and 70%
  static const Color heatmapAmber = Color(0xFFF6AD55);

  /// Green cell — topic accuracy above 70%
  static const Color heatmapGreen = Color(0xFF68D391);

  // ─── Background Colors ────────────────────────────────────────────────────

  /// Main app background — very light grey, easy on the eyes
  static const Color background = Color(0xFFF7F9FC);

  /// White — used for cards, modals, bottom sheets
  static const Color surface = Color(0xFFFFFFFF);

  /// Slightly darker surface — used for input fields, disabled buttons
  static const Color surfaceVariant = Color(0xFFF0F2F5);

  /// Dark background — used in dark mode
  static const Color backgroundDark = Color(0xFF0F1117);

  /// Dark surface — cards in dark mode
  static const Color surfaceDark = Color(0xFF1A1D27);

  // ─── Text Colors ──────────────────────────────────────────────────────────

  /// Main text — headings, body text
  static const Color textPrimary = Color(0xFF1A202C);

  /// Secondary text — subtitles, descriptions, hints
  static const Color textSecondary = Color(0xFF718096);

  /// Disabled text — placeholder text, inactive labels
  static const Color textDisabled = Color(0xFFA0AEC0);

  /// Text on primary (green) backgrounds — always white
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ─── Border & Divider Colors ──────────────────────────────────────────────

  /// Default border — input fields, cards
  static const Color border = Color(0xFFE2E8F0);

  /// Stronger border — focused input fields
  static const Color borderFocused = Color(0xFF1A7A4A);

  /// Divider line — between list items
  static const Color divider = Color(0xFFEDF2F7);

  // ─── Exam Type Colors ─────────────────────────────────────────────────────
  // Each exam type has its own color used on badges and chips

  /// WAEC badge color
  static const Color waecColor = Color(0xFF3182CE);

  /// JAMB badge color
  static const Color jambColor = Color(0xFF805AD5);

  /// NECO badge color
  static const Color necoColor = Color(0xFF319795);

  /// Post-UTME badge color
  static const Color postUtmeColor = Color(0xFFDD6B20);

  // ─── Difficulty Colors ────────────────────────────────────────────────────

  /// Easy questions — green badge
  static const Color difficultyEasy = Color(0xFF38A169);

  /// Medium questions — amber badge
  static const Color difficultyMedium = Color(0xFFED8936);

  /// Hard questions — red badge
  static const Color difficultyHard = Color(0xFFE53E3E);

  // ─── Leaderboard Podium ───────────────────────────────────────────────────

  /// 1st place — gold
  static const Color rankGold = Color(0xFFFFD700);

  /// 2nd place — silver
  static const Color rankSilver = Color(0xFFC0C0C0);

  /// 3rd place — bronze
  static const Color rankBronze = Color(0xFFCD7F32);

  // ─── Gradient ─────────────────────────────────────────────────────────────

  /// Primary gradient — used on splash screen, premium banners
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primaryDark],
  );

  /// Gold gradient — used on premium plan cards
  static const LinearGradient premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFB800), Color(0xFFFF8C00)],
  );

  // ─── Helper: Get Exam Color ───────────────────────────────────────────────

  /// Returns the color for a given exam type string.
  ///
  /// Usage:
  ///   Container(color: AppColors.examColor('WAEC'))
  static Color examColor(String examType) {
    switch (examType.toUpperCase()) {
      case 'WAEC':
        return waecColor;
      case 'JAMB':
        return jambColor;
      case 'NECO':
        return necoColor;
      case 'POST_UTME':
        return postUtmeColor;
      default:
        return primary;
    }
  }

  /// Returns the color for a heatmap cell based on accuracy percentage.
  ///
  /// Usage:
  ///   Container(color: AppColors.heatmapColor(65.0))
  static Color heatmapColor(double accuracyPct) {
    if (accuracyPct >= 70) return heatmapGreen;
    if (accuracyPct >= 40) return heatmapAmber;
    return heatmapRed;
  }

  /// Returns the color for a difficulty badge.
  ///
  /// Usage:
  ///   Text(difficulty, style: TextStyle(color: AppColors.difficultyColor('HARD')))
  static Color difficultyColor(String difficulty) {
    switch (difficulty.toUpperCase()) {
      case 'EASY':
        return difficultyEasy;
      case 'HARD':
        return difficultyHard;
      default:
        return difficultyMedium;
    }
  }
}