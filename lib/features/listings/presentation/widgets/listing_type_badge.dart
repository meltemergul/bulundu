import 'package:flutter/material.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/listings/models/listing.dart';
import 'package:bulundu/shared/extensions/context_x.dart';

class ListingTypeBadge extends StatelessWidget {
  const ListingTypeBadge({
    super.key,
    required this.type,
    this.status = ListingStatus.open,
  });

  final ListingType type;
  final ListingStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    final (
      Color bg,
      Color fg,
      Color dotColor,
      String label,
    ) = status == ListingStatus.resolved
        ? (
            colors.surfaceContainerLow,
            colors.onSurfaceVariant,
            colors.onSurfaceVariant,
            l10n.listingStatusResolved,
          )
        : switch (type) {
            ListingType.lost => (
              colors.secondaryContainer,
              colors.onSecondaryContainer,
              colors.secondary,
              l10n.listingTypeLost,
            ),
            ListingType.found => (
              colors.tertiaryContainer,
              colors.onTertiaryContainer,
              colors.tertiary,
              l10n.listingTypeFound,
            ),
          };

    return Container(
      constraints: const BoxConstraints(minHeight: AppSpacing.lg),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status == ListingStatus.resolved)
            Icon(Icons.check_circle, size: AppSpacing.sm, color: fg)
          else
            Container(
              width: AppSpacing.sm,
              height: AppSpacing.sm,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: context.textStyles.labelSmall?.copyWith(color: fg),
          ),
        ],
      ),
    );
  }
}
