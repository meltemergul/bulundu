import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/moderation/models/report_reason.dart';
import 'package:bulundu/features/moderation/providers/moderation_providers.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/utils/breakpoints.dart';
import 'package:bulundu/shared/widgets/app_button.dart';
import 'package:bulundu/shared/widgets/app_text_field.dart';

class ReportSheet extends ConsumerStatefulWidget {
  const ReportSheet({
    super.key,
    required this.targetType,
    required this.targetId,
    required this.targetOwnerId,
  });

  final ReportTargetType targetType;
  final String targetId;
  final String targetOwnerId;

  static Future<bool?> show(
    BuildContext context, {
    required ReportTargetType targetType,
    required String targetId,
    required String targetOwnerId,
  }) {
    if (context.isWide) {
      return showDialog<bool>(
        context: context,
        builder: (_) => Dialog(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.maxFormWidth,
            ),
            child: ReportSheet(
              targetType: targetType,
              targetId: targetId,
              targetOwnerId: targetOwnerId,
            ),
          ),
        ),
      );
    }
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => ReportSheet(
        targetType: targetType,
        targetId: targetId,
        targetOwnerId: targetOwnerId,
      ),
    );
  }

  @override
  ConsumerState<ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends ConsumerState<ReportSheet> {
  ReportReason _selectedReason = ReportReason.spam;
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  String _reasonLabel(BuildContext context, ReportReason reason) {
    final l10n = context.l10n;
    return switch (reason) {
      ReportReason.spam => l10n.reportReasonSpam,
      ReportReason.inappropriate => l10n.reportReasonInappropriate,
      ReportReason.scam => l10n.reportReasonScam,
      ReportReason.harassment => l10n.reportReasonHarassment,
      ReportReason.other => l10n.reportReasonOther,
    };
  }

  Future<void> _submit() async {
    final ok = await ref
        .read(moderationControllerProvider.notifier)
        .submitReport(
          targetType: widget.targetType,
          targetId: widget.targetId,
          targetOwnerId: widget.targetOwnerId,
          reason: _selectedReason,
          note: _noteController.text,
        );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.errorGeneric)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(moderationControllerProvider);
    final isLoading = state.isLoading;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.reportSheetTitle, style: context.textStyles.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          RadioGroup<ReportReason>(
            groupValue: _selectedReason,
            onChanged: (val) {
              if (val != null) setState(() => _selectedReason = val);
            },
            child: Column(
              children: ReportReason.values.map((reason) {
                return RadioListTile<ReportReason>(
                  value: reason,
                  title: Text(_reasonLabel(context, reason)),
                  contentPadding: EdgeInsets.zero,
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: l10n.reportNoteLabel,
            controller: _noteController,
            maxLines: 3,
            maxLength: 300,
            enabled: !isLoading,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: l10n.cancelButton,
                  variant: AppButtonVariant.secondary,
                  onPressed: isLoading
                      ? null
                      : () => Navigator.of(context).pop(false),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton(
                  label: l10n.reportSubmitButton,
                  isLoading: isLoading,
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
