import 'package:flutter/material.dart';

enum ListingCategory {
  wallet,
  phone,
  keys,
  bag,
  documents,
  electronics,
  accessories,
  clothing,
  pet,
  other;

  IconData get icon => switch (this) {
    ListingCategory.wallet => Icons.account_balance_wallet_outlined,
    ListingCategory.phone => Icons.smartphone_outlined,
    ListingCategory.keys => Icons.key_outlined,
    ListingCategory.bag => Icons.backpack_outlined,
    ListingCategory.documents => Icons.badge_outlined,
    ListingCategory.electronics => Icons.devices_outlined,
    ListingCategory.accessories => Icons.watch_outlined,
    ListingCategory.clothing => Icons.checkroom_outlined,
    ListingCategory.pet => Icons.pets_outlined,
    ListingCategory.other => Icons.category_outlined,
  };
}
