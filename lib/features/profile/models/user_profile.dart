import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  const UserProfile({
    required this.uid,
    required this.displayName,
    this.photoUrl,
    required this.acceptedTermsAt,
    required this.termsVersion,
    required this.createdAt,
  });

  static const int currentTermsVersion = 1;

  final String uid;
  final String displayName;
  final String? photoUrl;
  final DateTime acceptedTermsAt;
  final int termsVersion;
  final DateTime createdAt;

  bool get hasAcceptedCurrentTerms => termsVersion >= currentTermsVersion;

  factory UserProfile.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snap,
    SnapshotOptions? _,
  ) {
    final d = snap.data()!;
    return UserProfile(
      uid: snap.id,
      displayName: (d['displayName'] as String?) ?? '',
      photoUrl: d['photoUrl'] as String?,
      acceptedTermsAt:
          (d['acceptedTermsAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      termsVersion: (d['termsVersion'] as num?)?.toInt() ?? 0,
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toCreateMap() => {
    'displayName': displayName,
    'photoUrl': ?photoUrl,
    'acceptedTermsAt': FieldValue.serverTimestamp(),
    'termsVersion': termsVersion,
    'createdAt': FieldValue.serverTimestamp(),
  };
}
