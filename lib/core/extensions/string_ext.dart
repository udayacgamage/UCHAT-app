/// String extensions for common operations
extension StringExt on String {
  /// Check if string is valid email
  bool get isEmail {
    const pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    return RegExp(pattern).hasMatch(this);
  }

  /// Check if string is valid password
  bool get isValidPassword {
    return length >= 8 &&
        contains(RegExp(r'[A-Z]')) &&
        contains(RegExp(r'[0-9]')) &&
        contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  /// Get initials from name (e.g., "John Doe" → "JD")
  String get initials {
    return trim()
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
        .take(2)
        .join();
  }

  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  /// Truncate string with ellipsis
  String truncate(int length) {
    if (this.length <= length) {
      return this;
    }
    return '${substring(0, length)}...';
  }

  /// Remove all whitespace
  String removeWhitespace() {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// Check if string contains only letters and spaces
  bool get isAlphabetic {
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(this);
  }

  /// Convert to slug format (for URLs)
  String get toSlug {
    return toLowerCase()
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'[^\w-]'), '');
  }

  /// Check if string is a valid URL
  bool get isUrl {
    try {
      Uri.parse(this);
      return true;
    } catch (e) {
      return false;
    }
  }
}

