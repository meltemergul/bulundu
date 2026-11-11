import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  const Chat({
    required this.id,
    required this.listingId,
    required this.listingTitle,
    required this.participants,
    required this.lastMessage,
    required this.updatedAt,
  });

  final String id;
  final String listingId;
  final String listingTitle;
  final List<String> participants;
  final String lastMessage;
  final DateTime updatedAt;

  String otherParticipantUid(String currentUid) {
    if (participants.isEmpty) return '';
    return participants.first == currentUid && participants.length > 1
        ? participants[1]
        : participants.first;
  }

  factory Chat.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snap,
    SnapshotOptions? _,
  ) {
    final d = snap.data()!;
    return Chat(
      id: snap.id,
      listingId: (d['listingId'] as String?) ?? '',
      listingTitle: (d['listingTitle'] as String?) ?? '',
      participants: List<String>.from(d['participants'] as List? ?? const []),
      lastMessage: (d['lastMessage'] as String?) ?? '',
      updatedAt: (d['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toCreateMap() => {
    'listingId': listingId,
    'listingTitle': listingTitle,
    'participants': participants,
    'lastMessage': lastMessage,
    'updatedAt': FieldValue.serverTimestamp(),
  };
}
