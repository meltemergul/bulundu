import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/auth/providers/auth_providers.dart';
import 'package:bulundu/features/chat/presentation/widgets/message_bubble.dart';
import 'package:bulundu/features/chat/presentation/widgets/message_input.dart';
import 'package:bulundu/features/chat/providers/chat_providers.dart';
import 'package:bulundu/features/moderation/models/report_reason.dart';
import 'package:bulundu/features/moderation/presentation/widgets/report_menu_button.dart';
import 'package:bulundu/features/profile/providers/profile_providers.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/widgets/empty_state.dart';
import 'package:bulundu/shared/widgets/error_view.dart';
import 'package:bulundu/shared/widgets/loading_view.dart';
import 'package:bulundu/shared/widgets/max_width_body.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key, required this.chatId});

  final String chatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final currentUid = ref.watch(authStateChangesProvider).value?.uid ?? '';
    final chatAsync = ref.watch(chatByIdProvider(chatId));
    final messagesAsync = ref.watch(chatMessagesProvider(chatId));
    final controllerState = ref.watch(chatControllerProvider);

    final chat = chatAsync.value;
    final otherUid = chat?.otherParticipantUid(currentUid) ?? '';
    final otherProfile = otherUid.isNotEmpty
        ? ref.watch(userProfileByIdProvider(otherUid)).value
        : null;
    final otherName = otherProfile?.displayName.isNotEmpty == true
        ? otherProfile!.displayName
        : l10n.deletedUser;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chat?.listingTitle ?? l10n.chatsTitle,
              style: context.textStyles.titleMedium,
            ),
            if (otherUid.isNotEmpty)
              Text(
                otherName,
                style: context.textStyles.labelSmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
          ],
        ),
        actions: [
          if (otherUid.isNotEmpty)
            ReportMenuButton(
              targetType: ReportTargetType.user,
              targetId: otherUid,
              targetOwnerId: otherUid,
              onBlocked: () {
                if (context.canPop()) context.pop();
              },
            ),
        ],
      ),
      body: Column(
        children: [
          MaxWidthBody(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              0,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: colors.secondaryContainer.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(
                  color: colors.secondary.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    size: AppSpacing.md,
                    color: colors.onSecondaryContainer,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l10n.safetyBannerMessage,
                      style: context.textStyles.labelSmall?.copyWith(
                        color: colors.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: messagesAsync.when(
              loading: () => const LoadingView(),
              error: (_, _) => ErrorView(
                message: l10n.errorGeneric,
                onRetry: () => ref.invalidate(chatMessagesProvider(chatId)),
              ),
              data: (messages) {
                if (messages.isEmpty) {
                  return MaxWidthBody(
                    child: EmptyState(
                      icon: Icons.chat_bubble_outline,
                      title: l10n.chatsEmptyTitle,
                      message: l10n.chatsEmptyMessage,
                    ),
                  );
                }
                return MaxWidthBody(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      return MessageBubble(
                        chatId: chatId,
                        message: msg,
                        isMine: msg.senderId == currentUid,
                      );
                    },
                  ),
                );
              },
            ),
          ),
          MaxWidthBody(
            padding: EdgeInsets.zero,
            child: MessageInput(
              isSending: controllerState.isLoading,
              onSend: (text) async {
                final ok = await ref
                    .read(chatControllerProvider.notifier)
                    .sendMessage(chatId: chatId, text: text);
                if (!context.mounted) return;
                if (!ok) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
