import 'package:flutter/material.dart';

/// App color constants for light and dark themes
class AppColors {
  // Primary brand colors
  static const Color primary = Color(0xFF6C63FF);        // vibrant purple
  static const Color primaryDark = Color(0xFF4B44CC);    // darker purple
  static const Color primaryLight = Color(0xFFEDECFF);   // light purple tint

  // Surface colors
  static const Color background = Color(0xFFF7F8FC);     // light bg
  static const Color surface = Color(0xFFFFFFFF);        // white
  static const Color surfaceDark = Color(0xFF1A1A2E);    // dark mode bg
  static const Color cardDark = Color(0xFF16213E);       // dark card bg

  // Chat bubble colors
  static const Color sentBubble = Color(0xFF6C63FF);     // sender = purple
  static const Color receivedBubble = Color(0xFFFFFFFF); // receiver = white
  static const Color sentText = Color(0xFFFFFFFF);       // white text on purple
  static const Color receivedText = Color(0xFF1A1A2E);   // dark text on white

  // Status / semantic colors
  static const Color online = Color(0xFF4CAF50);         // green online indicator
  static const Color offline = Color(0xFF9E9E9E);        // grey offline indicator
  static const Color success = Color(0xFF4CAF50);        // green success
  static const Color error = Color(0xFFE53935);          // red errors
  static const Color warning = Color(0xFFFFA726);        // orange warnings
  static const Color typing = Color(0xFF6C63FF);         // typing indicator color

  // Borders / dividers
  static const Color divider = Color(0xFFEEEEEE);        // light divider
  static const Color inputBorder = Color(0xFFE0E0E0);    // input field border

  // Dark mode variants
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color lightTextPrimary = Color(0xFF1A1A2E);
  static const Color lightTextSecondary = Color(0xFF666666);
}

