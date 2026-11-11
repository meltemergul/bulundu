import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bulundu/features/auth/providers/auth_providers.dart';
import 'package:bulundu/features/chat/providers/chat_providers.dart';
import 'package:bulundu/features/listings/providers/listing_providers.dart';
import 'package:bulundu/features/profile/providers/profile_providers.dart';

class DeleteAccountController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  bool get requiresPasswordReauth => true;

  Future<bool> deleteAccount({required String password}) async {
    final authRepo = ref.read(authRepositoryProvider);
    final user = authRepo.currentUser;
    if (user == null) return false;
    final uid = user.uid;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // 1. Re-authenticate with password first
      await authRepo.reauthenticateWithPassword(password);

      // 2. Delete user's listing photos (Storage) and listings (Firestore)
      await ref
          .read(listingRepositoryProvider)
          .deleteAllForUser(
            uid: uid,
            imageStorage: ref.read(listingImageStorageProvider),
          );

      // 3. Delete messages sent by the user (chat docs remain)
      await ref.read(chatRepositoryProvider).deleteAllMessagesSentByUser(uid);

      // 4. Delete user blocks and profile document
      await ref.read(profileRepositoryProvider).deleteUserProfileAndBlocks(uid);

      // 5. Delete Firebase Auth account last
      await authRepo.deleteAuthUser();
    });

    return !state.hasError;
  }
}

final deleteAccountControllerProvider =
    AsyncNotifierProvider<DeleteAccountController, void>(
      DeleteAccountController.new,
    );
