import 'package:firebase_auth/firebase_auth.dart';

import '../../core/errors/app_exception.dart';
import '../../services/auth_service.dart';

class AuthRepository {
  AuthRepository(this._authService);

  final AuthService _authService;

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  User? get currentUser => _authService.currentUser;

  Future<UserCredential?> signUp(String email, String password) async {
    try {
      return await _authService.signUp(email, password);
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebase(e);
    } catch (e) {
      throw UnknownAppException(
        'Unable to create account. Please try again.',
        debugMessage: e.toString(),
      );
    }
  }

  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _authService.signIn(email, password);
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebase(e);
    } catch (e) {
      throw UnknownAppException(
        'Unable to sign in. Please try again.',
        debugMessage: e.toString(),
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      throw UnknownAppException(
        'Unable to sign out. Please try again.',
        debugMessage: e.toString(),
      );
    }
  }
}
