import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bulundu/app/router/routes.dart';
import 'package:bulundu/app/theme/app_shadows.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/auth/providers/auth_providers.dart';
import 'package:bulundu/features/chat/providers/chat_providers.dart';
import 'package:bulundu/features/listings/models/listing.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/widgets/app_button.dart';

class ListingContactSection extends ConsumerStatefulWidget {
  const ListingContactSection({
    super.key,
    required this.listing,
    required this.isOwner,
  });

  final Listing listing;
  final bool isOwner;

  @override
  ConsumerState<ListingContactSection> createState() =>
      _ListingContactSectionState();
}

class _ListingContactSectionState extends ConsumerState<ListingContactSection> {
  final _messageController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  List<String> get _quickSuggestions {
    if (widget.listing.isLost) {
      return [
        'Eşyanızı buldum, detayları görüşelim!',
        'Eşya nerede kayboldu?',
        'Nasıl teslim edebilirim?',
      ];
    } else {
      return [
        'Bu eşya bana ait, teslim alabilir miyim?',
        'Detayları doğrulamak istiyorum.',
        'Nerede buluşabiliriz?',
      ];
    }
  }

  Future<void> _sendMessage([String? textToSend]) async {
    final text = (textToSend ?? _messageController.text).trim();
    final l10n = context.l10n;
    final currentUid = ref.read(authStateChangesProvider).value?.uid;

    if (currentUid == widget.listing.ownerId) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.cannotMessageOwnListing)));
      return;
    }

    setState(() => _isSending = true);
    try {
      final chatId = await ref
          .read(chatControllerProvider.notifier)
          .startOrOpenChat(widget.listing, text.isNotEmpty ? text : null);

      if (!mounted) return;
      if (chatId != null) {
        _messageController.clear();
        context.push(AppRoutes.chatDetail(chatId));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final textStyles = context.textStyles;
    final brightness = Theme.of(context).brightness;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(
          color: colors.primary.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: AppShadows.card(brightness),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Icon + Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: colors.primaryContainer.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chat_bubble_outline,
                  color: colors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.contactSectionTitle,
                      style:
                          (textStyles.titleMedium ??
                                  const TextStyle(fontSize: 16))
                              .copyWith(
                                fontWeight: FontWeight.w700,
                                color: colors.onSurface,
                              ),
                    ),
                    Text(
                      widget.listing.ownerName.isNotEmpty
                          ? '${widget.listing.ownerName} (${widget.listing.isLost ? l10n.listingTypeLost : l10n.listingTypeFound})'
                          : l10n.deletedUser,
                      style: textStyles.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          if (widget.isOwner) ...[
            // Owner view: Helpful notice and link to all chats
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 18, color: colors.primary),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          l10n.ownListingNotice,
                          style: textStyles.bodySmall?.copyWith(
                            color: colors.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppButton(
                    label: l10n.viewListingMessages,
                    icon: Icons.forum_outlined,
                    variant: AppButtonVariant.secondary,
                    onPressed: () => context.go(AppRoutes.chats),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Non-owner view: Subtitle + quick chips + text input
            Text(
              widget.listing.isLost
                  ? l10n.contactSectionSubtitleLost
                  : l10n.contactSectionSubtitleFound,
              style: textStyles.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Quick suggestion chips
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: _quickSuggestions.map((suggestion) {
                return ActionChip(
                  label: Text(suggestion),
                  labelStyle: TextStyle(fontSize: 12, color: colors.onSurface),
                  avatar: Icon(Icons.bolt, size: 14, color: colors.secondary),
                  backgroundColor: colors.surfaceContainerLow,
                  side: BorderSide(
                    color: colors.outlineVariant.withValues(alpha: 0.5),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  onPressed: _isSending
                      ? null
                      : () {
                          _messageController.text = suggestion;
                          _sendMessage(suggestion);
                        },
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Message text input with integrated send button
            Container(
              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: colors.outlineVariant),
              ),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      enabled: !_isSending,
                      minLines: 1,
                      maxLines: 3,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: l10n.quickMessagePlaceholder,
                        hintStyle: TextStyle(
                          color: colors.onSurfaceVariant.withValues(alpha: 0.7),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sm,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  IconButton(
                    onPressed: _isSending ? null : () => _sendMessage(),
                    icon: _isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(Icons.send, color: colors.primary),
                    tooltip: l10n.sendDirectMessage,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Main "İlan Sahibine Mesaj Gönder" Button
            AppButton(
              label: l10n.sendMessageToOwner,
              icon: Icons.chat_bubble_outline,
              isLoading: _isSending,
              onPressed: () => _sendMessage(),
            ),
          ],
        ],
      ),
    );
  }
}
