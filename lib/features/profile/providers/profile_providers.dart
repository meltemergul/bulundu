import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bulundu/features/auth/providers/auth_providers.dart';
import 'package:bulundu/features/profile/data/profile_repository.dart';
import 'package:bulundu/features/profile/models/user_profile.dart';
import 'package:bulundu/shared/providers/firebase_providers.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.watch(firestoreProvider)),
);

final currentUserProfileProvider = StreamProvider<UserProfile?>((ref) {
  final authUser = ref.watch(authStateChangesProvider).value;
  if (authUser == null) {
    return Stream.value(null);
  }
  return ref.watch(profileRepositoryProvider).watchProfile(authUser.uid);
});

final userProfileByIdProvider = StreamProvider.family<UserProfile?, String>((
  ref,
  uid,
) {
  return ref.watch(profileRepositoryProvider).watchProfile(uid);
});
