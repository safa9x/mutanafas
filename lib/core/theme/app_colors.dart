import 'package:flutter/material.dart';

class AppColors {
  // ================= PRIMARY =================
  static const primary = Color(0xFF3F8F7A);
  static const secondary = Color(0xFF6BA292);

  // ================= ACCENT =================
  static const accent = Color(0xFFD4A373);
  static const gold = Color(0xFFFFD700);

  // ================= STATUS =================
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFA000);
  static const error = Color(0xFFE53935);

  // ================= EXTRA =================
  static const purple = Color(0xFF7C6AFA);
  static const blue = Color(0xFF4A90E2);

  // ================= ICON BACKGROUNDS =================
  static const iconBg1 = Color(0xFFFFF3D6);
  static const iconBg2 = Color(0xFFE9E1FF);
  static const iconBg3 = Color(0xFFFFE3D1);
  static const iconBg4 = Color(0xFFDFF5EA);
  static const iconBg5 = Color(0xFFE3ECFF);

  // ================= LIGHT MODE =================
  static const lightBackground = Color(0xFFF8F6F2);
  static const lightCard = Colors.white;
  static const lightTextPrimary = Color(0xFF1E1E1E);
  static const lightTextSecondary = Color(0xFF6B7280);

  // ================= DARK MODE =================
  static const darkBackground = Color(0xFF111827);
  static const darkCard = Color(0xFF1F2937);
  static const darkTextPrimary = Colors.white;
  static const darkTextSecondary = Colors.white70;

  // ================= HELPERS (اختياري) =================

  static Color background(bool isDark) =>
      isDark ? darkBackground : lightBackground;

  static Color card(bool isDark) =>
      isDark ? darkCard : lightCard;

  static Color textPrimary(bool isDark) =>
      isDark ? darkTextPrimary : lightTextPrimary;

  static Color textSecondary(bool isDark) =>
      isDark ? darkTextSecondary : lightTextSecondary;
}