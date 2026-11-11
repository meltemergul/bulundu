import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ListingImageStorage {
  ListingImageStorage(this._storage);

  final FirebaseStorage _storage;

  Future<String> upload({
    required String uid,
    required String listingId,
    required int index,
    required XFile file,
  }) async {
    final bytes = await file.readAsBytes();
    final ref = _storage.ref('listings/$uid/$listingId/$index.jpg');
    await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
    return ref.getDownloadURL();
  }

  Future<void> deleteListingImages({
    required String uid,
    required String listingId,
  }) async {
    for (var i = 0; i < 3; i++) {
      try {
        await _storage.ref('listings/$uid/$listingId/$i.jpg').delete();
      } catch (_) {
        // Ignore if index does not exist
      }
    }
  }
}
