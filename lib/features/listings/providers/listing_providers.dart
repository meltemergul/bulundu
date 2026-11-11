import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bulundu/features/auth/providers/auth_providers.dart';
import 'package:bulundu/features/listings/data/listing_image_storage.dart';
import 'package:bulundu/features/listings/data/listing_repository.dart';
import 'package:bulundu/features/listings/models/listing.dart';
import 'package:bulundu/features/listings/models/listing_matcher.dart';
import 'package:bulundu/features/listings/providers/listing_filter_provider.dart';
import 'package:bulundu/features/map/providers/location_providers.dart';
import 'package:bulundu/features/moderation/providers/moderation_providers.dart';
import 'package:bulundu/shared/providers/firebase_providers.dart';

final listingImageStorageProvider = Provider<ListingImageStorage>(
  (ref) => ListingImageStorage(ref.watch(firebaseStorageProvider)),
);

final listingRepositoryProvider = Provider<ListingRepository>(
  (ref) => ListingRepository(ref.watch(firestoreProvider)),
);

final latestListingsProvider =
    StreamProvider.family<List<Listing>, ListingType?>((ref, type) {
      return ref.watch(listingRepositoryProvider).watchLatest(type: type);
    });

final filteredListingsProvider = Provider<AsyncValue<List<Listing>>>((ref) {
  final filter = ref.watch(listingFilterProvider);
  final listingsAsync = ref.watch(latestListingsProvider(filter.type));
  final blockedUids = ref.watch(blockedUidsProvider).value ?? const <String>{};
  final userLocation = ref.watch(userLocationProvider).value;

  return listingsAsync.whenData(
    (items) => filter.apply(
      listings: items,
      blockedUids: blockedUids,
      userLocation: userLocation,
    ),
  );
});

final listingDetailProvider = StreamProvider.family<Listing?, String>((
  ref,
  id,
) {
  return ref.watch(listingRepositoryProvider).watchById(id);
});

final myListingsProvider = StreamProvider<List<Listing>>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) {
    return Stream.value(const <Listing>[]);
  }
  return ref.watch(listingRepositoryProvider).watchByOwner(user.uid);
});

final similarListingsProvider = Provider.family<List<Listing>, Listing>((
  ref,
  target,
) {
  final allOpen = ref.watch(latestListingsProvider(null)).value ?? const [];
  final blockedUids = ref.watch(blockedUidsProvider).value ?? const <String>{};
  return ListingMatcher.findSimilar(
    target: target,
    candidates: allOpen,
    blockedUids: blockedUids,
  );
});
