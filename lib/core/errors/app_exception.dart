import 'package:firebase_auth/firebase_auth.dart';

/// Base type for app-level errors surfaced to the UI.
sealed class AppException implements Exception {
  const AppException(this.userMessage, {this.debugMessage});

  final String userMessage;
  final String? debugMessage;

  @override
  String toString() => debugMessage ?? userMessage;
}

final class NetworkException extends AppException {
  const NetworkException(super.userMessage, {super.debugMessage});
}

final class AuthException extends AppException {
  const AuthException(super.userMessage, {super.debugMessage, this.code});

  final String? code;

  factory AuthException.fromFirebase(FirebaseAuthException error) {
    final message = switch (error.code) {
      'user-not-found' => 'No account found with this email.',
      'wrong-password' => 'Incorrect password.',
      'email-already-in-use' => 'An account already exists with this email.',
      'invalid-email' => 'Please enter a valid email address.',
      'weak-password' => 'Password is too weak.',
      'invalid-credential' => 'Invalid email or password.',
      _ => error.message ?? 'Authentication failed. Please try again.',
    };
    return AuthException(message, code: error.code, debugMessage: error.message);
  }
}

final class FirestoreException extends AppException {
  const FirestoreException(super.userMessage, {super.debugMessage});
}

final class CacheException extends AppException {
  const CacheException(super.userMessage, {super.debugMessage});
}

final class UnknownAppException extends AppException {
  const UnknownAppException(super.userMessage, {super.debugMessage});
}

/// Returns a user-friendly message for any error object.
String userMessageFrom(Object error) {
  if (error is AppException) return error.userMessage;

  final text = error.toString();
  if (text.startsWith('Exception: ')) {
    return text.substring('Exception: '.length);
  }
  return 'Something went wrong. Please try again.';
}
