import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bulundu/features/listings/models/listing.dart';
import 'package:bulundu/features/listings/models/listing_category.dart';
import 'package:bulundu/features/listings/models/listing_filter.dart';

class ListingFilterNotifier extends Notifier<ListingFilter> {
  @override
  ListingFilter build() => const ListingFilter();

  void setType(ListingType? type) {
    state = state.copyWith(type: () => type);
  }

  void setCategory(ListingCategory? category) {
    state = state.copyWith(category: () => category);
  }

  void setMaxDistanceKm(double? maxDistanceKm) {
    state = state.copyWith(maxDistanceKm: () => maxDistanceKm);
  }

  void clear() {
    state = const ListingFilter();
  }
}

final listingFilterProvider =
    NotifierProvider<ListingFilterNotifier, ListingFilter>(
      ListingFilterNotifier.new,
    );
