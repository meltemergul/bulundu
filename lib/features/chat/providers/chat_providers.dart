import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bulundu/features/auth/providers/auth_providers.dart';
import 'package:bulundu/features/chat/data/chat_repository.dart';
import 'package:bulundu/features/chat/models/chat.dart';
import 'package:bulundu/features/chat/models/message.dart';
import 'package:bulundu/features/listings/models/listing.dart';
import 'package:bulundu/features/moderation/providers/moderation_providers.dart';
import 'package:bulundu/shared/providers/firebase_providers.dart';

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRepository(ref.watch(firestoreProvider)),
);

final myChatsProvider = StreamProvider<List<Chat>>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) {
    return Stream.value(const <Chat>[]);
  }
  final blockedUids = ref.watch(blockedUidsProvider).value ?? const <String>{};
  return ref
      .watch(chatRepositoryProvider)
      .watchMyChats(user.uid)
      .map(
        (chats) => chats
            .where(
              (c) => !blockedUids.contains(c.otherParticipantUid(user.uid)),
            )
            .toList(),
      );
});

final chatByIdProvider = StreamProvider.family<Chat?, String>((ref, chatId) {
  return ref.watch(chatRepositoryProvider).watchChat(chatId);
});

final chatMessagesProvider = StreamProvider.family<List<Message>, String>((
  ref,
  chatId,
) {
  return ref.watch(chatRepositoryProvider).watchMessages(chatId);
});

class ChatController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> startOrOpenChat(Listing listing) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return null;

    String? chatId;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      chatId = await ref
          .read(chatRepositoryProvider)
          .getOrCreateChat(
            listingId: listing.id,
            listingTitle: listing.title,
            ownerId: listing.ownerId,
            requesterUid: user.uid,
            listingType: listing.type.name,
            listingImageUrl: listing.imageUrls.isNotEmpty
                ? listing.imageUrls.first
                : null,
          );
    });
    return state.hasError ? null : chatId;
  }

  Future<bool> sendMessage({
    required String chatId,
    required String text,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return false;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(chatRepositoryProvider)
          .sendMessage(chatId: chatId, senderId: user.uid, text: text);
    });
    return !state.hasError;
  }
}

final chatControllerProvider = AsyncNotifierProvider<ChatController, void>(
  ChatController.new,
);
