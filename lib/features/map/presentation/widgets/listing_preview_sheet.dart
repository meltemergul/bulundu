import 'package:flutter/material.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/listings/models/listing.dart';
import 'package:bulundu/features/listings/presentation/widgets/listing_type_badge.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/widgets/app_button.dart';

class ListingPreviewSheet extends StatelessWidget {
  const ListingPreviewSheet({
    super.key,
    required this.listing,
    required this.onViewDetails,
    this.onMessage,
    required this.onClose,
  });

  final Listing listing;
  final VoidCallback onViewDetails;
  final VoidCallback? onMessage;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Card(
      margin: const EdgeInsets.all(AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ListingTypeBadge(type: listing.type, status: listing.status),
                const Spacer(),
                IconButton(
                  tooltip: l10n.cancelButton,
                  onPressed: onClose,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              listing.title,
              style: context.textStyles.titleMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Icon(
                  Icons.place_outlined,
                  size: AppSpacing.md,
                  color: colors.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    listing.locationName,
                    style: context.textStyles.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (listing.isFound) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.foundPrivacyNotice,
                style: context.textStyles.labelSmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: l10n.viewDetailsButton,
                    variant: onMessage != null
                        ? AppButtonVariant.secondary
                        : AppButtonVariant.primary,
                    onPressed: onViewDetails,
                  ),
                ),
                if (onMessage != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppButton(
                      label: l10n.cardActionMessage,
                      icon: Icons.chat_bubble_outline,
                      onPressed: onMessage,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
