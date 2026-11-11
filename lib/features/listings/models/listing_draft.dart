import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:bulundu/features/listings/models/listing.dart';
import 'package:bulundu/features/listings/models/listing_category.dart';

class PickedImageItem {
  const PickedImageItem({required this.file, required this.bytes});

  final XFile file;
  final Uint8List bytes;
}

class ListingDraft {
  const ListingDraft({
    required this.type,
    required this.title,
    required this.category,
    required this.description,
    required this.lat,
    required this.lng,
    required this.locationName,
    required this.eventDate,
    this.existingImageUrls = const [],
    this.newImages = const [],
    this.newImageBytes = const [],
  });

  final ListingType type;
  final String title;
  final ListingCategory category;
  final String description;
  final double lat;
  final double lng;
  final String locationName;
  final DateTime eventDate;
  final List<String> existingImageUrls;
  final List<XFile> newImages;
  final List<Uint8List> newImageBytes;
}
