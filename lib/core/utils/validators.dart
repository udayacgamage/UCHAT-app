/// Email, password, and form validation utilities
class Validators {
  /// Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    // Basic email regex pattern
    const pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(pattern);
    
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    
    return null;
  }

  /// Validate password strength (min 8 chars, 1 uppercase, 1 number, 1 special)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    
    // Check for uppercase
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain an uppercase letter';
    }
    
    // Check for number
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain a number';
    }
    
    // Check for special character
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain a special character';
    }
    
    return null;
  }

  /// Validate that two passwords match
  static String? validatePasswordMatch(String? password, String? confirmPassword) {
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validate full name
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    if (value.trim().length > 50) {
      return 'Name must be less than 50 characters';
    }
    
    return null;
  }

  /// Validate phone number (10+ digits)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    final digits = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digits.length < 10) {
      return 'Enter a valid phone number (at least 10 digits)';
    }
    
    return null;
  }

  /// Get password strength level
  static PasswordStrength checkPasswordStrength(String password) {
    if (password.isEmpty) {
      return PasswordStrength.weak;
    }
    
    int score = 0;
    
    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    
    // Character type checks
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;
    
    if (score < 2) return PasswordStrength.weak;
    if (score < 4) return PasswordStrength.fair;
    if (score < 6) return PasswordStrength.strong;
    return PasswordStrength.veryStrong;
  }
}

/// Password strength enumeration
enum PasswordStrength {
  weak,
  fair,
  strong,
  veryStrong,
}

extension PasswordStrengthExt on PasswordStrength {
  String get label {
    switch (this) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.fair:
        return 'Fair';
      case PasswordStrength.strong:
        return 'Strong';
      case PasswordStrength.veryStrong:
        return 'Very Strong';
    }
  }

  double get value {
    switch (this) {
      case PasswordStrength.weak:
        return 0.25;
      case PasswordStrength.fair:
        return 0.5;
      case PasswordStrength.strong:
        return 0.75;
      case PasswordStrength.veryStrong:
        return 1.0;
    }
  }

  // ignore: constant_identifier_names
  static const Map<PasswordStrength, int> COLOR_MAP = {
    PasswordStrength.weak: 0xFFE53935,      // Red
    PasswordStrength.fair: 0xFFFFA726,      // Orange
    PasswordStrength.strong: 0xFF42A5F5,    // Blue
    PasswordStrength.veryStrong: 0xFF4CAF50, // Green
  };

  int get color => COLOR_MAP[this]!;
}

