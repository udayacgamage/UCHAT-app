/// Custom exception for the app
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  AppException({
    required this.message,
    this.code,
    this.originalException,
  });

  @override
  String toString() => message;
}

/// Auth-related exceptions
class AuthException extends AppException {
  AuthException({
    required String message,
    String? code,
    dynamic originalException,
  }) : super(
    message: message,
    code: code,
    originalException: originalException,
  );
}

/// Firestore-related exceptions
class FirestoreException extends AppException {
  FirestoreException({
    required String message,
    String? code,
    dynamic originalException,
  }) : super(
    message: message,
    code: code,
    originalException: originalException,
  );
}

/// Network-related exceptions
class NetworkException extends AppException {
  NetworkException({
    required String message,
    String? code,
    dynamic originalException,
  }) : super(
    message: message,
    code: code,
    originalException: originalException,
  );
}

/// Storage-related exceptions
class StorageException extends AppException {
  StorageException({
    required String message,
    String? code,
    dynamic originalException,
  }) : super(
    message: message,
    code: code,
    originalException: originalException,
  );
}

