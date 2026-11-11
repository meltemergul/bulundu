import 'package:flutter/material.dart';
import 'package:bulundu/shared/extensions/context_x.dart';

class BlockConfirmDialog extends StatelessWidget {
  const BlockConfirmDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showAdaptiveDialog<bool>(
      context: context,
      builder: (_) => const BlockConfirmDialog(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog.adaptive(
      title: Text(l10n.blockConfirmTitle),
      content: Text(l10n.blockUserConfirm),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancelButton),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.blockConfirmButton),
        ),
      ],
    );
  }
}
