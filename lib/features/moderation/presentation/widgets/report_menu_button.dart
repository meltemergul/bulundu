import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/auth/providers/auth_providers.dart';
import 'package:bulundu/features/moderation/models/report_reason.dart';
import 'package:bulundu/features/moderation/presentation/widgets/block_confirm_dialog.dart';
import 'package:bulundu/features/moderation/presentation/widgets/report_sheet.dart';
import 'package:bulundu/features/moderation/providers/moderation_providers.dart';
import 'package:bulundu/shared/extensions/context_x.dart';

enum _ModerationAction { report, block }

class ReportMenuButton extends ConsumerWidget {
  const ReportMenuButton({
    super.key,
    required this.targetType,
    required this.targetId,
    required this.targetOwnerId,
    this.onBlocked,
  });

  final ReportTargetType targetType;
  final String targetId;
  final String targetOwnerId;
  final VoidCallback? onBlocked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUid = ref.watch(authStateChangesProvider).value?.uid;
    if (currentUid == null || currentUid == targetOwnerId) {
      return const SizedBox.shrink();
    }

    final l10n = context.l10n;
    return PopupMenuButton<_ModerationAction>(
      tooltip: l10n.moreActionsTooltip,
      icon: const Icon(Icons.more_vert),
      onSelected: (action) async {
        switch (action) {
          case _ModerationAction.report:
            final submitted = await ReportSheet.show(
              context,
              targetType: targetType,
              targetId: targetId,
              targetOwnerId: targetOwnerId,
            );
            if (!context.mounted) return;
            if (submitted == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.reportReceivedMessage)),
              );
            }
          case _ModerationAction.block:
            final confirmed = await BlockConfirmDialog.show(context);
            if (!context.mounted || !confirmed) return;
            final ok = await ref
                .read(moderationControllerProvider.notifier)
                .blockUser(targetOwnerId);
            if (!context.mounted) return;
            if (ok) {
              onBlocked?.call();
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
            }
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _ModerationAction.report,
          child: Row(
            children: [
              const Icon(Icons.flag_outlined),
              const SizedBox(width: AppSpacing.sm),
              Text(l10n.reportAction),
            ],
          ),
        ),
        PopupMenuItem(
          value: _ModerationAction.block,
          child: Row(
            children: [
              const Icon(Icons.block_outlined),
              const SizedBox(width: AppSpacing.sm),
              Text(l10n.blockUserAction),
            ],
          ),
        ),
      ],
    );
  }
}
