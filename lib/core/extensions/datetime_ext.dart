import 'package:intl/intl.dart';

/// DateTime extensions for formatting
extension DateTimeExt on DateTime {
  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  /// Format time (e.g., "2:30 PM")
  String get formattedTime {
    return DateFormat('h:mm a').format(this);
  }

  /// Format date (e.g., "Mar 22, 2026")
  String get formattedDate {
    return DateFormat('MMM dd, yyyy').format(this);
  }

  /// Format as ISO 8601 string
  String get isoString {
    return toIso8601String();
  }

  /// Format relative time
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (isToday) {
      return 'Today at ${formattedTime}';
    } else if (isYesterday) {
      return 'Yesterday at ${formattedTime}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return formattedDate;
    }
  }

  /// Get day name (Monday, Tuesday, etc.)
  String get dayName {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday - 1];
  }
}

