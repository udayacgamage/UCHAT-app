/// Simple logging utility for debugging
class AppLogger {
  static const String _tag = 'SecureChat';
  static bool _debugMode = true;

  /// Enable/disable debug mode
  static void setDebugMode(bool enabled) {
    _debugMode = enabled;
  }

  /// Log info level message
  static void info(String message) {
    if (_debugMode) {
      print('ℹ️  [$_tag] $message');
    }
  }

  /// Log error level message with optional stack trace
  static void error(String message, [StackTrace? stackTrace]) {
    if (_debugMode) {
      print('❌ [$_tag] ERROR: $message');
      if (stackTrace != null) {
        print('Stack trace: $stackTrace');
      }
    }
  }

  /// Log warning level message
  static void warn(String message) {
    if (_debugMode) {
      print('⚠️  [$_tag] WARNING: $message');
    }
  }

  /// Log debug level message
  static void debug(String message) {
    if (_debugMode) {
      print('🔍 [$_tag] DEBUG: $message');
    }
  }

  /// Log success message
  static void success(String message) {
    if (_debugMode) {
      print('✅ [$_tag] SUCCESS: $message');
    }
  }
}

