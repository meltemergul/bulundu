import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bulundu/features/moderation/models/report.dart';

class ModerationRepository {
  ModerationRepository(this._db);

  final FirebaseFirestore _db;

  Stream<Set<String>> watchBlockedUids(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('blocks')
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.id).toSet());
  }

  Future<void> blockUser({
    required String uid,
    required String blockedUid,
  }) async {
    if (uid == blockedUid) return;
    await _db
        .collection('users')
        .doc(uid)
        .collection('blocks')
        .doc(blockedUid)
        .set({'createdAt': FieldValue.serverTimestamp()});
  }

  Future<void> unblockUser({
    required String uid,
    required String blockedUid,
  }) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('blocks')
        .doc(blockedUid)
        .delete();
  }

  Future<void> submitReport(ModerationReport report) async {
    await _db.collection('reports').add(report.toCreateMap());
  }
}
