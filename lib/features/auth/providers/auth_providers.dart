import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bulundu/features/auth/data/auth_repository.dart';
import 'package:bulundu/features/profile/models/user_profile.dart';
import 'package:bulundu/features/profile/providers/profile_providers.dart';
import 'package:bulundu/shared/providers/firebase_providers.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(firebaseAuthProvider)),
);

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

class AuthController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(authRepositoryProvider)
          .signInWithEmail(email: email, password: password);
    });
    return !state.hasError;
  }

  Future<bool> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final credential = await ref
          .read(authRepositoryProvider)
          .registerWithEmail(
            email: email,
            password: password,
            displayName: displayName,
          );
      final user = credential.user;
      if (user != null) {
        await ref
            .read(profileRepositoryProvider)
            .saveTermsAndProfile(
              uid: user.uid,
              displayName: displayName,
              photoUrl: user.photoURL,
              termsVersion: UserProfile.currentTermsVersion,
            );
      }
    });
    return !state.hasError;
  }

  Future<bool> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signInWithGoogle();
    });
    return !state.hasError;
  }

  Future<bool> signInWithApple() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signInWithApple();
    });
    return !state.hasError;
  }

  Future<bool> acceptTerms({required String displayName}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = ref.read(authRepositoryProvider).currentUser;
      if (user == null) return;
      final trimmed = displayName.trim();
      if (trimmed.isNotEmpty && user.displayName != trimmed) {
        await user.updateDisplayName(trimmed);
      }
      await ref
          .read(profileRepositoryProvider)
          .saveTermsAndProfile(
            uid: user.uid,
            displayName: trimmed,
            photoUrl: user.photoURL,
            termsVersion: UserProfile.currentTermsVersion,
          );
    });
    return !state.hasError;
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signOut();
    });
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  AuthController.new,
);
