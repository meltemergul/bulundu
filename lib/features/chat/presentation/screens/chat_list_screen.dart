import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bulundu/app/router/routes.dart';
import 'package:bulundu/app/theme/app_shadows.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/auth/providers/auth_providers.dart';
import 'package:bulundu/features/chat/presentation/screens/chat_screen.dart';
import 'package:bulundu/features/chat/presentation/widgets/chat_tile.dart';
import 'package:bulundu/features/chat/presentation/widgets/safety_tip_banner.dart';
import 'package:bulundu/features/chat/providers/chat_providers.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/utils/breakpoints.dart';
import 'package:bulundu/shared/widgets/empty_state.dart';
import 'package:bulundu/shared/widgets/error_view.dart';
import 'package:bulundu/shared/widgets/loading_view.dart';
import 'package:bulundu/shared/widgets/max_width_body.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key, this.selectedChatId});

  final String? selectedChatId;

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _activeChatId;

  @override
  void initState() {
    super.initState();
    _activeChatId = widget.selectedChatId;
  }

  @override
  void didUpdateWidget(ChatListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedChatId != oldWidget.selectedChatId) {
      _activeChatId = widget.selectedChatId;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final brightness = Theme.of(context).brightness;
    final currentUid = ref.watch(authStateChangesProvider).value?.uid ?? '';
    final chatsAsync = ref.watch(myChatsProvider);
    final isExpanded = context.isExpanded;

    final listContent = Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.xs,
          ),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: colors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              boxShadow: AppShadows.soft(brightness),
            ),
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              cursorColor: colors.primary,
              onChanged: (val) =>
                  setState(() => _searchQuery = val.trim().toLowerCase()),
              decoration: InputDecoration(
                hintText: l10n.searchMessagesHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),

        // Safety Tip Banner
        const SafetyTipBanner(),

        // Chat List
        Expanded(
          child: chatsAsync.when(
            loading: () => const LoadingView(),
            error: (_, _) => ErrorView(
              message: l10n.errorGeneric,
              onRetry: () => ref.invalidate(myChatsProvider),
            ),
            data: (chats) {
              final filtered = _searchQuery.isEmpty
                  ? chats
                  : chats.where((c) {
                      return c.listingTitle.toLowerCase().contains(
                            _searchQuery,
                          ) ||
                          c.lastMessage.toLowerCase().contains(_searchQuery);
                    }).toList();

              if (filtered.isEmpty) {
                return EmptyState(
                  icon: Icons.chat_bubble_outline,
                  title: l10n.chatsEmptyTitle,
                  message: l10n.chatsEmptyMessage,
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: filtered.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final chat = filtered[index];
                  final isSelected = isExpanded && _activeChatId == chat.id;

                  return ChatTile(
                    chat: chat,
                    currentUid: currentUid,
                    isSelected: isSelected,
                    onTap: () {
                      if (isExpanded) {
                        setState(() => _activeChatId = chat.id);
                      } else {
                        context.push(AppRoutes.chatDetail(chat.id));
                      }
                    },
                  );
                },
              );
            },
          ),
        ),

        // Bottom notice
        Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Text(
            l10n.chatSecurityNotice,
            textAlign: TextAlign.center,
            style: context.textStyles.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );

    if (isExpanded) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.chatsTitle)),
        body: Row(
          children: [
            SizedBox(width: 360, child: listContent),
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(
              child: _activeChatId != null
                  ? ChatScreen(chatId: _activeChatId!)
                  : Center(
                      child: EmptyState(
                        icon: Icons.chat_outlined,
                        title: l10n.chatsTitle,
                        message: l10n.chatsEmptyMessage,
                      ),
                    ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.chatsTitle)),
      body: MaxWidthBody(maxWidth: Breakpoints.maxContent, child: listContent),
    );
  }
}
