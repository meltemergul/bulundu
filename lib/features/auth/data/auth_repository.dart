import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:bulundu/shared/utils/app_exception.dart';

class AuthRepository {
  AuthRepository(this._auth);

  final FirebaseAuth _auth;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    }
  }

  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await credential.user?.updateDisplayName(displayName.trim());
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> reauthenticateWithPassword(String password) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw const AppException('auth_generic');
    }
    try {
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(cred);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    }
  }

  Future<void> deleteAuthUser() async {
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    }
  }

  AppException _mapFirebaseAuthException(FirebaseAuthException e) {
    if (kDebugMode) {
      debugPrint('FirebaseAuthException [${e.code}]: ${e.message}');
    }
    return switch (e.code) {
      'invalid-credential' ||
      'wrong-password' ||
      'user-not-found' ||
      'invalid-email' => const AppException('auth_invalid_credentials'),
      'email-already-in-use' => const AppException('auth_email_in_use'),
      'weak-password' => const AppException('auth_weak_password'),
      'network-request-failed' => const AppException('auth_network'),
      _ => const AppException('auth_generic'),
    };
  }
}
