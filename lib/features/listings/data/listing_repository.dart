import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bulundu/features/listings/data/listing_image_storage.dart';
import 'package:bulundu/features/listings/models/listing.dart';
import 'package:bulundu/features/listings/models/listing_draft.dart';

class ListingRepository {
  ListingRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Listing> get _col => _db
      .collection('listings')
      .withConverter<Listing>(
        fromFirestore: Listing.fromFirestore,
        toFirestore: (l, _) => l.toCreateMap(),
      );

  Stream<List<Listing>> watchLatest({ListingType? type, int limit = 50}) {
    Query<Map<String, dynamic>> q = _db
        .collection('listings')
        .where('status', isEqualTo: ListingStatus.open.name);
    if (type != null) {
      q = q.where('type', isEqualTo: type.name);
    }
    q = q.orderBy('createdAt', descending: true).limit(limit);
    return q.snapshots().map(
      (s) => s.docs.map((d) => Listing.fromFirestore(d, null)).toList(),
    );
  }

  Stream<List<Listing>> watchByOwner(String ownerId, {int limit = 50}) {
    return _db
        .collection('listings')
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => Listing.fromFirestore(d, null)).toList());
  }

  Stream<Listing?> watchById(String listingId) {
    return _db.collection('listings').doc(listingId).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) return null;
      return Listing.fromFirestore(snap, null);
    });
  }

  Future<Listing?> getById(String listingId) async {
    final snap = await _col.doc(listingId).get();
    return snap.data();
  }

  Future<String> create({
    required String ownerId,
    required String ownerName,
    required ListingDraft draft,
    required ListingImageStorage imageStorage,
  }) async {
    final docRef = _db.collection('listings').doc();
    final listingId = docRef.id;

    final uploadedUrls = <String>[...draft.existingImageUrls];
    for (
      var i = 0;
      i < draft.newImages.length && uploadedUrls.length < 3;
      i++
    ) {
      final index = uploadedUrls.length;
      final imageBytes =
          i < draft.newImageBytes.length ? draft.newImageBytes[i] : null;
      try {
        final url = await imageStorage.upload(
          uid: ownerId,
          listingId: listingId,
          index: index,
          file: draft.newImages[i],
          bytes: imageBytes,
        );
        uploadedUrls.add(url);
      } catch (e) {
        throw Exception('Görsel işlenemedi: $e');
      }
    }

    final listing = Listing(
      id: listingId,
      type: draft.type,
      status: ListingStatus.open,
      title: draft.title.trim(),
      category: draft.category,
      description: draft.description.trim(),
      ownerId: ownerId,
      ownerName: ownerName.trim(),
      lat: draft.lat,
      lng: draft.lng,
      locationName: draft.locationName.trim(),
      eventDate: draft.eventDate,
      createdAt: DateTime.now(),
      imageUrls: uploadedUrls,
    );

    await docRef.set(listing.toCreateMap());
    return listingId;
  }

  Future<void> update({
    required String listingId,
    required String ownerId,
    required ListingDraft draft,
    required ListingImageStorage imageStorage,
  }) async {
    final uploadedUrls = <String>[...draft.existingImageUrls];
    for (
      var i = 0;
      i < draft.newImages.length && uploadedUrls.length < 3;
      i++
    ) {
      final index = uploadedUrls.length;
      final imageBytes =
          i < draft.newImageBytes.length ? draft.newImageBytes[i] : null;
      try {
        final url = await imageStorage.upload(
          uid: ownerId,
          listingId: listingId,
          index: index,
          file: draft.newImages[i],
          bytes: imageBytes,
        );
        uploadedUrls.add(url);
      } catch (e) {
        throw Exception('Görsel işlenemedi: $e');
      }
    }

    await _db.collection('listings').doc(listingId).update({
      'type': draft.type.name,
      'title': draft.title.trim(),
      'category': draft.category.name,
      'description': draft.description.trim(),
      'lat': draft.lat,
      'lng': draft.lng,
      'locationName': draft.locationName.trim(),
      'eventDate': Timestamp.fromDate(draft.eventDate),
      'imageUrls': uploadedUrls,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> markResolved(String listingId) async {
    await _db.collection('listings').doc(listingId).update({
      'status': ListingStatus.resolved.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> delete({
    required String listingId,
    required String ownerId,
    required ListingImageStorage imageStorage,
  }) async {
    await imageStorage.deleteListingImages(uid: ownerId, listingId: listingId);
    await _db.collection('listings').doc(listingId).delete();
  }

  Future<void> deleteAllForUser({
    required String uid,
    required ListingImageStorage imageStorage,
  }) async {
    final snap = await _db
        .collection('listings')
        .where('ownerId', isEqualTo: uid)
        .get();
    for (final doc in snap.docs) {
      await imageStorage.deleteListingImages(uid: uid, listingId: doc.id);
      await doc.reference.delete();
    }
  }
}
