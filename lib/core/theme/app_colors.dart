import 'package:flutter/material.dart';

/// Centralized color tokens for SolarCare following the design system.
class AppColors {
  AppColors._();

  // Brand colors
  static const Color primaryEmerald = Color(0xFF137A4B);
  static const Color emeraldDark = Color(0xFF0D5735);
  static const Color emeraldLight = Color(0xFF1E9B61);
  static const Color mint = Color(0xFFE8F5EC);
  static const Color mintLight = Color(0xFFF2FAF5);

  // Background and Surfaces
  static const Color background = Color(0xFFF7F9F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color borderSubtle = Color(0xFFE2EDE6);
  static const Color divider = Color(0xFFEBF1ED);

  // Text colors
  static const Color textPrimary = Color(0xFF25352D);
  static const Color textSecondary = Color(0xFF5D7368);
  static const Color textMuted = Color(0xFF8B9E94);
  static const Color textOnEmerald = Color(0xFFFFFFFF);

  // Status & Severity colors
  static const Color statusSuccess = Color(0xFF137A4B);
  static const Color statusSuccessBg = Color(0xFFE8F5EC);

  static const Color statusWarning = Color(0xFFD97706);
  static const Color statusWarningBg = Color(0xFFFEF3C7);

  static const Color statusDanger = Color(0xFFDC2626);
  static const Color statusDangerBg = Color(0xFFFEE2E2);

  static const Color statusInfo = Color(0xFF0284C7);
  static const Color statusInfoBg = Color(0xFFE0F2FE);

  // Shadow colors
  static final Color shadow = const Color(0xFF25352D).withValues(alpha: 0.06);
}
