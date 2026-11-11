import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ListingImageStorage {
  ListingImageStorage(this._storage);

  // Storage instance kept for architecture compatibility
  // ignore: unused_field
  final FirebaseStorage _storage;

  Future<String> upload({
    required String uid,
    required String listingId,
    required int index,
    required XFile file,
    Uint8List? bytes,
  }) async {
    final uploadBytes = bytes ?? await file.readAsBytes();
    final isPng = uploadBytes.length >= 8 &&
        uploadBytes[0] == 0x89 &&
        uploadBytes[1] == 0x50 &&
        uploadBytes[2] == 0x4E &&
        uploadBytes[3] == 0x47;
    final mimeType = isPng ? 'image/png' : 'image/jpeg';

    // Firestore inline Base64 storage: 100% free, 0 TL, no credit card required.
    final base64String = base64Encode(uploadBytes);
    return 'data:$mimeType;base64,$base64String';
  }

  Future<void> deleteListingImages({
    required String uid,
    required String listingId,
  }) async {
    // When stored in Firestore, deleting the listing document automatically deletes images.
  }
}
