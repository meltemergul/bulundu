import 'package:latlong2/latlong.dart';
import 'package:bulundu/features/listings/models/listing.dart';

abstract final class ListingMatcher {
  static const double maxDistanceKm = 2.0;
  static const int maxDaysDifference = 7;

  /// Finds similar open listings:
  /// - Same category
  /// - Opposite type (`lost` <-> `found`)
  /// - Distance <= 2 km
  /// - Event date within +-7 days
  static List<Listing> findSimilar({
    required Listing target,
    required List<Listing> candidates,
    Set<String> blockedUids = const {},
  }) {
    const distance = Distance();
    final oppositeType = target.type == ListingType.lost
        ? ListingType.found
        : ListingType.lost;

    return candidates.where((candidate) {
      if (candidate.id == target.id) return false;
      if (candidate.status != ListingStatus.open) return false;
      if (blockedUids.contains(candidate.ownerId)) return false;
      if (candidate.type != oppositeType) return false;
      if (candidate.category != target.category) return false;

      final dayDiff = candidate.eventDate
          .difference(target.eventDate)
          .inDays
          .abs();
      if (dayDiff > maxDaysDifference) return false;

      final km = distance.as(
        LengthUnit.Kilometer,
        target.exactPoint,
        candidate.exactPoint,
      );
      return km <= maxDistanceKm;
    }).toList();
  }
}
