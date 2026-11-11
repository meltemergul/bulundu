import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bulundu/app/router/routes.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/auth/providers/auth_providers.dart';
import 'package:bulundu/features/chat/presentation/widgets/chat_tile.dart';
import 'package:bulundu/features/chat/providers/chat_providers.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/widgets/empty_state.dart';
import 'package:bulundu/shared/widgets/error_view.dart';
import 'package:bulundu/shared/widgets/loading_view.dart';
import 'package:bulundu/shared/widgets/max_width_body.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final currentUid = ref.watch(authStateChangesProvider).value?.uid ?? '';
    final chatsAsync = ref.watch(myChatsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.chatsTitle)),
      body: chatsAsync.when(
        loading: () => const LoadingView(),
        error: (_, _) => ErrorView(
          message: l10n.errorGeneric,
          onRetry: () => ref.invalidate(myChatsProvider),
        ),
        data: (chats) {
          if (chats.isEmpty) {
            return MaxWidthBody(
              child: EmptyState(
                icon: Icons.chat_bubble_outline,
                title: l10n.chatsEmptyTitle,
                message: l10n.chatsEmptyMessage,
              ),
            );
          }
          return MaxWidthBody(
            child: ListView.separated(
              itemCount: chats.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ChatTile(
                  chat: chat,
                  currentUid: currentUid,
                  onTap: () => context.push(AppRoutes.chatDetail(chat.id)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
