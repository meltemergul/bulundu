import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bulundu/features/chat/models/chat.dart';
import 'package:bulundu/features/profile/providers/profile_providers.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/utils/date_format.dart';

class ChatTile extends ConsumerWidget {
  const ChatTile({
    super.key,
    required this.chat,
    required this.currentUid,
    required this.onTap,
  });

  final Chat chat;
  final String currentUid;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final otherUid = chat.otherParticipantUid(currentUid);
    final otherProfile = ref.watch(userProfileByIdProvider(otherUid)).value;
    final otherName = otherProfile?.displayName.isNotEmpty == true
        ? otherProfile!.displayName
        : l10n.deletedUser;

    final locale = Localizations.localeOf(context).toString();
    final timeStr = AppDateFormat.formatTime(chat.updatedAt, locale);

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: context.colors.primaryContainer,
          foregroundColor: context.colors.onPrimaryContainer,
          child: const Icon(Icons.chat_bubble_outline),
        ),
        title: Text(
          chat.listingTitle,
          style: context.textStyles.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          chat.lastMessage.isNotEmpty
              ? '$otherName: ${chat.lastMessage}'
              : otherName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          timeStr,
          style: context.textStyles.labelSmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
