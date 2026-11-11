import 'package:flutter/material.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/shared/extensions/context_x.dart';

class SocialSignInButtons extends StatelessWidget {
  const SocialSignInButtons({
    super.key,
    required this.onGooglePressed,
    required this.onApplePressed,
    this.isLoading = false,
  });

  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: AppSpacing.minTouchTarget,
          child: FilledButton.icon(
            onPressed: isLoading ? null : onApplePressed,
            style: FilledButton.styleFrom(
              backgroundColor: colors.onSurface,
              foregroundColor: colors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
            icon: const Icon(Icons.apple, size: AppSpacing.lg),
            label: Text(l10n.continueWithApple),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: AppSpacing.minTouchTarget,
          child: OutlinedButton.icon(
            onPressed: isLoading ? null : onGooglePressed,
            style: OutlinedButton.styleFrom(
              backgroundColor: colors.surface,
              foregroundColor: colors.onSurface,
              side: BorderSide(color: colors.outline),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
            icon: Text(
              'G',
              style: context.textStyles.titleMedium?.copyWith(
                color: colors.primary,
              ),
            ),
            label: Text(l10n.continueWithGoogle),
          ),
        ),
      ],
    );
  }
}
