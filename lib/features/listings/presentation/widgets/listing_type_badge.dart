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
    final colors = context.colors;
    final textStyles = context.textStyles;

    final (
      Color bg,
      Color fg,
      Color dotColor,
      String label,
      bool isResolved,
    ) = status == ListingStatus.resolved
        ? (
            colors.tertiaryContainer,
            colors.onTertiaryContainer,
            colors.tertiary,
            'TESLİM EDİLDİ',
            true,
          )
        : switch (type) {
            ListingType.lost => (
              colors.secondaryContainer,
              colors.onSecondaryContainer,
              colors.secondary,
              'KAYIP',
              false,
            ),
            ListingType.found => (
              colors.primaryContainer,
              colors.onPrimaryContainer,
              colors.primary,
              'BULUNDU',
              false,
            ),
          };

    return Container(
      constraints: const BoxConstraints(minHeight: 24),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isResolved)
            Icon(Icons.check_circle, size: 14, color: fg)
          else
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: (textStyles.labelSmall ?? const TextStyle(fontSize: 12))
                .copyWith(
                  color: fg,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.24,
                ),
          ),
        ],
      ),
    );
  }
}
