import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/listings/models/listing.dart';
import 'package:bulundu/features/listings/presentation/widgets/category_chip_bar.dart';
import 'package:bulundu/features/listings/presentation/widgets/listing_type_badge.dart';
import 'package:bulundu/features/moderation/models/report_reason.dart';
import 'package:bulundu/features/moderation/presentation/widgets/report_menu_button.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/utils/date_format.dart';

class ListingCard extends StatefulWidget {
  const ListingCard({
    super.key,
    required this.listing,
    required this.onTap,
    this.userLocation,
  });

  final Listing listing;
  final VoidCallback onTap;
  final LatLng? userLocation;

  @override
  State<ListingCard> createState() => _ListingCardState();
}

class _ListingCardState extends State<ListingCard> {
  bool _isHovered = false;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final listing = widget.listing;
    final locale = Localizations.localeOf(context).toString();
    final dateStr = AppDateFormat.formatShortDate(listing.eventDate, locale);
    final typeLabel = listing.isLost
        ? l10n.listingTypeLost
        : l10n.listingTypeFound;

    final distanceStr = widget.userLocation != null
        ? ' · ${l10n.distanceAwayKm(listing.roundedDistanceKmFrom(widget.userLocation!).toStringAsFixed(1))}'
        : '';

    final semanticLabel = l10n.listingCardSemantics(
      typeLabel,
      listing.title,
      listing.locationName,
      dateStr,
    );

    final ctaLabel = listing.isLost
        ? l10n.cardActionMessage
        : l10n.cardActionMine;

    return Semantics(
      button: true,
      label: semanticLabel,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
                blurRadius: _isHovered ? AppSpacing.md : AppSpacing.sm,
                offset: const Offset(0, AppSpacing.xs),
              ),
            ],
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              side: BorderSide(
                color: _isHovered ? colors.primary : colors.outlineVariant,
                width: _isHovered ? 2 : 1,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: widget.onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        listing.imageUrls.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: listing.imageUrls.first,
                                fit: BoxFit.cover,
                                fadeInDuration: context.reduceMotion
                                    ? Duration.zero
                                    : const Duration(milliseconds: 180),
                                placeholder: (context, _) => Container(
                                  color: colors.surfaceContainerLow,
                                ),
                                errorWidget: (context, _, _) =>
                                    _PlaceholderCover(
                                      icon: listing.category.icon,
                                      isLost: listing.isLost,
                                    ),
                              )
                            : _PlaceholderCover(
                                icon: listing.category.icon,
                                isLost: listing.isLost,
                              ),
                        Positioned(
                          top: AppSpacing.sm,
                          left: AppSpacing.sm,
                          child: ListingTypeBadge(
                            type: listing.type,
                            status: listing.status,
                          ),
                        ),
                        Positioned(
                          top: AppSpacing.xs,
                          right: AppSpacing.xs,
                          child: IconButton(
                            tooltip: l10n.favoriteTooltip,
                            style: IconButton.styleFrom(
                              backgroundColor: colors.surface.withValues(
                                alpha: 0.9,
                              ),
                            ),
                            onPressed: () {
                              setState(() => _isFavorite = !_isFavorite);
                            },
                            icon: Icon(
                              _isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: AppSpacing.md,
                              color: _isFavorite
                                  ? colors.error
                                  : colors.onSurface,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: AppSpacing.sm,
                          left: AppSpacing.sm,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: colors.inverseSurface.withValues(
                                alpha: 0.8,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusFull,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: AppSpacing.sm + AppSpacing.xs,
                                  color: colors.onInverseSurface,
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                Text(
                                  dateStr,
                                  style: context.textStyles.labelSmall
                                      ?.copyWith(
                                        color: colors.onInverseSurface,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                listing.title,
                                style: context.textStyles.titleMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: colors.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusFull,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    size: AppSpacing.sm + AppSpacing.xs,
                                    color: colors.primary,
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Text(
                                    l10n.verifiedBadgeLabel,
                                    style: context.textStyles.labelSmall
                                        ?.copyWith(color: colors.primary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            Icon(
                              Icons.place_outlined,
                              size: AppSpacing.md,
                              color: colors.primary,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Expanded(
                              child: Text(
                                '${listing.locationName}$distanceStr',
                                style: context.textStyles.bodyMedium?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        if (listing.description.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            listing.description,
                            style: context.textStyles.bodyMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: AppSpacing.sm),
                        const Divider(),
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            Icon(
                              listing.category.icon,
                              size: AppSpacing.md,
                              color: colors.onSurfaceVariant,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Expanded(
                              child: Text(
                                listing.category.localizedLabel(context),
                                style: context.textStyles.labelSmall?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            ReportMenuButton(
                              targetType: ReportTargetType.listing,
                              targetId: listing.id,
                              targetOwnerId: listing.ownerId,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            FilledButton.tonal(
                              onPressed: widget.onTap,
                              style: FilledButton.styleFrom(
                                minimumSize: const Size(
                                  AppSpacing.minTouchTarget,
                                  AppSpacing.xl + AppSpacing.xs,
                                ),
                                backgroundColor: listing.isLost
                                    ? colors.primaryContainer
                                    : colors.tertiaryContainer,
                                foregroundColor: listing.isLost
                                    ? colors.onPrimaryContainer
                                    : colors.onTertiaryContainer,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.xs,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusFull,
                                  ),
                                ),
                              ),
                              child: Text(ctaLabel),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaceholderCover extends StatelessWidget {
  const _PlaceholderCover({required this.icon, required this.isLost});

  final IconData icon;
  final bool isLost;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bgColor = isLost
        ? colors.secondaryContainer.withValues(alpha: 0.55)
        : colors.tertiaryContainer.withValues(alpha: 0.55);
    final iconColor = isLost
        ? colors.onSecondaryContainer
        : colors.onTertiaryContainer;

    return ExcludeSemantics(
      child: Container(
        color: bgColor,
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: 0.85),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: AppSpacing.xl, color: iconColor),
        ),
      ),
    );
  }
}
