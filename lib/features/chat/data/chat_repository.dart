import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bulundu/features/chat/models/chat.dart';
import 'package:bulundu/features/chat/models/message.dart';
import 'package:bulundu/shared/utils/app_exception.dart';

class ChatRepository {
  ChatRepository(this._db);

  final FirebaseFirestore _db;

  static String buildChatId({
    required String listingId,
    required String requesterUid,
  }) => '${listingId}_$requesterUid';

  Future<String> getOrCreateChat({
    required String listingId,
    required String listingTitle,
    required String ownerId,
    required String requesterUid,
    String listingType = 'lost',
    String? listingImageUrl,
  }) async {
    if (ownerId == requesterUid) {
      throw const AppException('chat_own_listing');
    }

    final chatId = buildChatId(
      listingId: listingId,
      requesterUid: requesterUid,
    );
    final docRef = _db.collection('chats').doc(chatId);
    final snap = await docRef.get();
    if (!snap.exists) {
      final chat = Chat(
        id: chatId,
        listingId: listingId,
        listingTitle: listingTitle,
        participants: [ownerId, requesterUid],
        lastMessage: '',
        updatedAt: DateTime.now(),
        listingType: listingType,
        listingImageUrl: listingImageUrl,
      );
      await docRef.set(chat.toCreateMap());
    }
    return chatId;
  }

  Stream<List<Chat>> watchMyChats(String uid, {int limit = 50}) {
    return _db
        .collection('chats')
        .where('participants', arrayContains: uid)
        .orderBy('updatedAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => Chat.fromFirestore(d, null)).toList());
  }

  Stream<Chat?> watchChat(String chatId) {
    return _db.collection('chats').doc(chatId).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) return null;
      return Chat.fromFirestore(snap, null);
    });
  }

  Stream<List<Message>> watchMessages(String chatId, {int limit = 50}) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => Message.fromFirestore(d, null)).toList());
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || trimmed.length > 1000) return;

    final chatRef = _db.collection('chats').doc(chatId);
    final msgRef = chatRef.collection('messages').doc();

    final batch = _db.batch();
    batch.set(msgRef, {
      'senderId': senderId,
      'text': trimmed,
      'createdAt': FieldValue.serverTimestamp(),
    });
    batch.update(chatRef, {
      'lastMessage': trimmed,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await batch.commit();
  }

  Future<void> deleteAllMessagesSentByUser(String uid) async {
    final chatsSnap = await _db
        .collection('chats')
        .where('participants', arrayContains: uid)
        .get();
    for (final chatDoc in chatsSnap.docs) {
      final msgsSnap = await chatDoc.reference
          .collection('messages')
          .where('senderId', isEqualTo: uid)
          .get();
      for (final msgDoc in msgsSnap.docs) {
        await msgDoc.reference.delete();
      }
    }
  }
}
