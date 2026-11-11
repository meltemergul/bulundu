import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bulundu/features/auth/providers/auth_providers.dart';
import 'package:bulundu/features/listings/models/listing_draft.dart';
import 'package:bulundu/features/listings/providers/listing_providers.dart';
import 'package:bulundu/features/profile/providers/profile_providers.dart';

class ListingFormController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> createListing(ListingDraft draft) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return null;
    final profile = ref.read(currentUserProfileProvider).value;
    final ownerName = profile?.displayName.isNotEmpty == true
        ? profile!.displayName
        : (user.displayName ?? '');

    String? createdId;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      createdId = await ref
          .read(listingRepositoryProvider)
          .create(
            ownerId: user.uid,
            ownerName: ownerName,
            draft: draft,
            imageStorage: ref.read(listingImageStorageProvider),
          );
    });
    return state.hasError ? null : createdId;
  }

  Future<bool> updateListing({
    required String listingId,
    required ListingDraft draft,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return false;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(listingRepositoryProvider)
          .update(
            listingId: listingId,
            ownerId: user.uid,
            draft: draft,
            imageStorage: ref.read(listingImageStorageProvider),
          );
    });
    return !state.hasError;
  }

  Future<bool> markResolved(String listingId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(listingRepositoryProvider).markResolved(listingId);
    });
    return !state.hasError;
  }

  Future<bool> deleteListing(String listingId) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return false;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(listingRepositoryProvider)
          .delete(
            listingId: listingId,
            ownerId: user.uid,
            imageStorage: ref.read(listingImageStorageProvider),
          );
    });
    return !state.hasError;
  }
}

final listingFormControllerProvider =
    AsyncNotifierProvider<ListingFormController, void>(
      ListingFormController.new,
    );
