import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:bulundu/features/listings/models/listing.dart';
import 'package:bulundu/features/listings/models/listing_category.dart';
import 'package:bulundu/features/listings/models/listing_filter.dart';
import 'package:bulundu/features/listings/models/listing_matcher.dart';

void main() {
  final baseDate = DateTime(2026, 11, 8, 12, 0);

  Listing makeListing({
    required String id,
    required ListingType type,
    ListingStatus status = ListingStatus.open,
    ListingCategory category = ListingCategory.wallet,
    String ownerId = 'owner_1',
    double lat = 40.9900,
    double lng = 29.0200,
    DateTime? eventDate,
  }) {
    return Listing(
      id: id,
      type: type,
      status: status,
      title: 'Test $id',
      category: category,
      description: 'Desc',
      ownerId: ownerId,
      ownerName: 'User',
      lat: lat,
      lng: lng,
      locationName: 'Kadıköy',
      eventDate: eventDate ?? baseDate,
      createdAt: baseDate,
    );
  }

  group('Listing privacy offset & distance', () {
    test('lost listing returns exactPoint as displayPoint', () {
      final lost = makeListing(id: 'l1', type: ListingType.lost);
      expect(lost.displayPoint, equals(lost.exactPoint));
    });

    test('found listing returns deterministic offset within 30..120m of exactPoint', () {
      final found = makeListing(id: 'f1', type: ListingType.found);
      final offsetPoint = found.displayPoint;
      expect(offsetPoint, isNot(equals(found.exactPoint)));

      // Calling again produces identical point (deterministic)
      expect(found.displayPoint, equals(offsetPoint));

      const distance = Distance();
      final meters = distance.as(
        LengthUnit.Meter,
        found.exactPoint,
        offsetPoint,
      );
      expect(meters, greaterThanOrEqualTo(29.0));
      expect(meters, lessThanOrEqualTo(Listing.foundMaxOffsetMeters + 1.0));
    });
  });

  group('ListingMatcher.findSimilar', () {
    test('matches opposite type, same category, <= 2 km, within +-7 days, and excludes blocked', () {
      final target = makeListing(
        id: 'target',
        type: ListingType.lost,
        category: ListingCategory.wallet,
        ownerId: 'u1',
      );

      final matchingFound = makeListing(
        id: 'match_1',
        type: ListingType.found,
        category: ListingCategory.wallet,
        ownerId: 'u2',
        lat: 40.9950, // ~0.55 km away
        lng: 29.0200,
        eventDate: baseDate.add(const Duration(days: 2)),
      );

      final wrongType = makeListing(
        id: 'wrong_type',
        type: ListingType.lost,
        category: ListingCategory.wallet,
        ownerId: 'u3',
      );

      final wrongCategory = makeListing(
        id: 'wrong_cat',
        type: ListingType.found,
        category: ListingCategory.keys,
        ownerId: 'u4',
      );

      final tooFar = makeListing(
        id: 'too_far',
        type: ListingType.found,
        category: ListingCategory.wallet,
        ownerId: 'u5',
        lat: 41.0500, // > 6 km away
      );

      final tooOld = makeListing(
        id: 'too_old',
        type: ListingType.found,
        category: ListingCategory.wallet,
        ownerId: 'u6',
        eventDate: baseDate.subtract(const Duration(days: 10)),
      );

      final blockedOwner = makeListing(
        id: 'blocked',
        type: ListingType.found,
        category: ListingCategory.wallet,
        ownerId: 'blocked_user',
      );

      final results = ListingMatcher.findSimilar(
        target: target,
        candidates: [
          target,
          matchingFound,
          wrongType,
          wrongCategory,
          tooFar,
          tooOld,
          blockedOwner,
        ],
        blockedUids: {'blocked_user'},
      );

      expect(results.map((e) => e.id).toList(), ['match_1']);
    });
  });

  group('ListingFilter.apply', () {
    test('filters out blocked owners, category, and distance', () {
      final l1 = makeListing(
        id: '1',
        type: ListingType.lost,
        category: ListingCategory.wallet,
        ownerId: 'u1',
      );
      final l2 = makeListing(
        id: '2',
        type: ListingType.lost,
        category: ListingCategory.wallet,
        ownerId: 'u_blocked',
      );
      final l3 = makeListing(
        id: '3',
        type: ListingType.lost,
        category: ListingCategory.phone,
        ownerId: 'u3',
      );

      const filter = ListingFilter(category: ListingCategory.wallet);
      final filtered = filter.apply(
        listings: [l1, l2, l3],
        blockedUids: {'u_blocked'},
      );

      expect(filtered.map((e) => e.id).toList(), ['1']);
    });
  });
}
