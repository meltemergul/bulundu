import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bulundu/features/chat/data/chat_repository.dart';
import 'package:bulundu/shared/utils/app_exception.dart';

void main() {
  group('ChatRepository', () {
    test('prevents owner from starting chat on own listing', () async {
      final db = FakeFirebaseFirestore();
      final repo = ChatRepository(db);

      expect(
        () => repo.getOrCreateChat(
          listingId: 'listing_1',
          listingTitle: 'Kayıp Anahtar',
          ownerId: 'user_1',
          requesterUid: 'user_1',
        ),
        throwsA(isA<AppException>()),
      );
    });

    test(
      'creates chat, sends messages with WriteBatch, and deletes user messages',
      () async {
        final db = FakeFirebaseFirestore();
        final repo = ChatRepository(db);

        final chatId = await repo.getOrCreateChat(
          listingId: 'listing_1',
          listingTitle: 'Kayıp Cüzdan',
          ownerId: 'owner_1',
          requesterUid: 'req_1',
        );
        expect(chatId, 'listing_1_req_1');

        await repo.sendMessage(
          chatId: chatId,
          senderId: 'req_1',
          text: 'Merhaba, cüzdanı buldum.',
        );
        await repo.sendMessage(
          chatId: chatId,
          senderId: 'owner_1',
          text: 'Çok teşekkürler!',
        );

        final chatSnap = await db.collection('chats').doc(chatId).get();
        expect(chatSnap.data()?['lastMessage'], 'Çok teşekkürler!');

        final messagesBefore = await repo.watchMessages(chatId).first;
        expect(messagesBefore.length, 2);

        // Delete messages sent by req_1 (account deletion step)
        await repo.deleteAllMessagesSentByUser('req_1');

        final messagesAfter = await repo.watchMessages(chatId).first;
        expect(messagesAfter.length, 1);
        expect(messagesAfter.first.senderId, 'owner_1');
        // Chat document remains for the other participant
        expect((await db.collection('chats').doc(chatId).get()).exists, isTrue);
      },
    );
  });
}
