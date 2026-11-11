import 'package:flutter/material.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/chat/models/message.dart';
import 'package:bulundu/features/moderation/models/report_reason.dart';
import 'package:bulundu/features/moderation/presentation/widgets/report_menu_button.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/utils/date_format.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.chatId,
    required this.message,
    required this.isMine,
  });

  final String chatId;
  final Message message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final maxBubbleWidth = MediaQuery.sizeOf(context).width * 0.8;
    final locale = Localizations.localeOf(context).toString();
    final timeStr = AppDateFormat.formatTime(message.createdAt, locale);

    final bgColor = isMine
        ? colors.primaryContainer
        : colors.surfaceContainerHighest;
    final fgColor = isMine ? colors.onPrimaryContainer : colors.onSurface;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxBubbleWidth),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SelectionArea(
                      child: Text(
                        message.text,
                        style: context.textStyles.bodyLarge?.copyWith(
                          color: fgColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      timeStr,
                      style: context.textStyles.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!isMine)
              ReportMenuButton(
                targetType: ReportTargetType.message,
                targetId: '$chatId/${message.id}',
                targetOwnerId: message.senderId,
              ),
          ],
        ),
      ),
    );
  }
}
