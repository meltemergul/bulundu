import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bulundu/features/profile/models/user_profile.dart';

class ProfileRepository {
  ProfileRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<UserProfile> get _col => _db
      .collection('users')
      .withConverter<UserProfile>(
        fromFirestore: UserProfile.fromFirestore,
        toFirestore: (p, _) => p.toCreateMap(),
      );

  Stream<UserProfile?> watchProfile(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) return null;
      return UserProfile.fromFirestore(snap, null);
    });
  }

  Future<UserProfile?> getProfile(String uid) async {
    final snap = await _col.doc(uid).get();
    return snap.data();
  }

  Future<void> saveTermsAndProfile({
    required String uid,
    required String displayName,
    String? photoUrl,
    int termsVersion = UserProfile.currentTermsVersion,
  }) async {
    final docRef = _db.collection('users').doc(uid);
    final existing = await docRef.get();
    final trimmedName = displayName.trim();

    if (!existing.exists) {
      await docRef.set({
        'displayName': trimmedName,
        'photoUrl': ?photoUrl,
        'acceptedTermsAt': FieldValue.serverTimestamp(),
        'termsVersion': termsVersion,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      await docRef.update({
        'displayName': trimmedName,
        'photoUrl': ?photoUrl,
        'acceptedTermsAt': FieldValue.serverTimestamp(),
        'termsVersion': termsVersion,
      });
    }
  }

  Future<void> updateProfile({
    required String uid,
    String? displayName,
    String? photoUrl,
    bool removePhoto = false,
  }) async {
    final docRef = _db.collection('users').doc(uid);
    final existing = await docRef.get();
    final data = existing.data() ?? <String, dynamic>{};

    final termsAt = data['acceptedTermsAt'] ?? FieldValue.serverTimestamp();
    final termsVer = data['termsVersion'] ?? UserProfile.currentTermsVersion;

    final updates = <String, dynamic>{
      'acceptedTermsAt': termsAt,
      'termsVersion': termsVer,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (displayName != null) {
      final trimmed = displayName.trim();
      if (trimmed.isNotEmpty) {
        updates['displayName'] = trimmed;
      }
    }

    if (removePhoto) {
      updates['photoUrl'] = FieldValue.delete();
    } else if (photoUrl != null) {
      updates['photoUrl'] = photoUrl;
    }

    await docRef.set(updates, SetOptions(merge: true));
  }

  Future<void> deleteUserProfileAndBlocks(String uid) async {
    final blocksSnap = await _db
        .collection('users')
        .doc(uid)
        .collection('blocks')
        .get();
    final batch = _db.batch();
    for (final doc in blocksSnap.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(_db.collection('users').doc(uid));
    await batch.commit();
  }
}
