import 'package:latlong2/latlong.dart';
import 'package:bulundu/features/listings/models/listing.dart';
import 'package:bulundu/features/listings/models/listing_category.dart';

class ListingFilter {
  const ListingFilter({this.type, this.category, this.maxDistanceKm});

  final ListingType? type;
  final ListingCategory? category;
  final double? maxDistanceKm;

  bool get hasActiveFilters =>
      type != null || category != null || maxDistanceKm != null;

  ListingFilter copyWith({
    ListingType? Function()? type,
    ListingCategory? Function()? category,
    double? Function()? maxDistanceKm,
  }) {
    return ListingFilter(
      type: type != null ? type() : this.type,
      category: category != null ? category() : this.category,
      maxDistanceKm: maxDistanceKm != null
          ? maxDistanceKm()
          : this.maxDistanceKm,
    );
  }

  List<Listing> apply({
    required List<Listing> listings,
    required Set<String> blockedUids,
    LatLng? userLocation,
  }) {
    const distance = Distance();
    return listings.where((item) {
      if (blockedUids.contains(item.ownerId)) {
        return false;
      }
      if (type != null && item.type != type) {
        return false;
      }
      if (category != null && item.category != category) {
        return false;
      }
      if (maxDistanceKm != null && userLocation != null) {
        final km = distance.as(
          LengthUnit.Kilometer,
          userLocation,
          item.exactPoint,
        );
        if (km > maxDistanceKm!) {
          return false;
        }
      }
      return true;
    }).toList();
  }
}
