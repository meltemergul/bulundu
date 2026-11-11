import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bulundu/features/listings/models/listing.dart';

class SelectedMapListingNotifier extends Notifier<Listing?> {
  @override
  Listing? build() => null;

  void select(Listing? listing) {
    state = listing;
  }
}

final selectedMapListingProvider =
    NotifierProvider<SelectedMapListingNotifier, Listing?>(
      SelectedMapListingNotifier.new,
    );
