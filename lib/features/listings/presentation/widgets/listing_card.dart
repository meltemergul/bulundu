import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:bulundu/app/theme/app_colors.dart';
import 'package:bulundu/app/theme/app_shadows.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/listings/models/listing.dart';
import 'package:bulundu/features/listings/presentation/widgets/category_chip_bar.dart';
import 'package:bulundu/features/listings/presentation/widgets/listing_type_badge.dart';
import 'package:bulundu/features/moderation/models/report_reason.dart';
import 'package:bulundu/features/moderation/presentation/widgets/report_menu_button.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/utils/date_format.dart';
import 'package:bulundu/shared/widgets/app_image.dart';

class ListingCard extends StatefulWidget {
  const ListingCard({
    super.key,
    required this.listing,
    required this.onTap,
    this.userLocation,
    this.onActionTap,
  });

  final Listing listing;
  final VoidCallback onTap;
  final LatLng? userLocation;
  final VoidCallback? onActionTap;

  @override
  State<ListingCard> createState() => _ListingCardState();
}

class _ListingCardState extends State<ListingCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final textStyles = context.textStyles;
    final brightness = Theme.of(context).brightness;
    final listing = widget.listing;
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final isOwner = currentUid != null && currentUid == listing.ownerId;

    final locale = Localizations.localeOf(context).toString();
    final dateStr = AppDateFormat.formatShortDate(listing.eventDate, locale);
    final typeLabel = listing.isLost
        ? l10n.listingTypeLost
        : l10n.listingTypeFound;

    final double? distanceKm = widget.userLocation != null
        ? listing.roundedDistanceKmFrom(widget.userLocation!)
        : null;

    final semanticLabel = l10n.listingCardSemantics(
      typeLabel,
      listing.title,
      listing.locationName,
      dateStr,
    );

    return Semantics(
      button: true,
      label: semanticLabel,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Container(
          decoration: BoxDecoration(
            color: colors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            boxShadow: _isHovered
                ? AppShadows.floating(brightness)
                : AppShadows.card(brightness),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 16:10 Photo Cover
                AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      listing.imageUrls.isNotEmpty
                          ? AppImage(
                              imageUrl: listing.imageUrls.first,
                              fit: BoxFit.cover,
                              placeholder: (_, _) =>
                                  Container(color: colors.surfaceContainerLow),
                              errorWidget: (_, _, _) => _PlaceholderCover(
                                icon: listing.category.iconData,
                                isLost: listing.isLost,
                              ),
                            )
                          : _PlaceholderCover(
                              icon: listing.category.iconData,
                              isLost: listing.isLost,
                            ),

                      // Top-left type badge
                      Positioned(
                        top: AppSpacing.sm,
                        left: AppSpacing.sm,
                        child: ListingTypeBadge(
                          type: listing.type,
                          status: listing.status,
                        ),
                      ),

                      // Top-right report menu
                      if (!isOwner)
                        Positioned(
                          top: AppSpacing.xs,
                          right: AppSpacing.xs,
                          child: Material(
                            color: colors.surface.withValues(alpha: 0.85),
                            shape: const CircleBorder(),
                            child: ReportMenuButton(
                              targetType: ReportTargetType.listing,
                              targetId: listing.id,
                              targetOwnerId: listing.ownerId,
                            ),
                          ),
                        ),

                      // Bottom-left time overlay pill (AppColors.mediaOverlay)
                      Positioned(
                        bottom: AppSpacing.sm,
                        left: AppSpacing.sm,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.mediaOverlay,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusFull,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.schedule,
                                size: 13,
                                color: AppColors.mediaOverlayText,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                dateStr,
                                style:
                                    (textStyles.labelSmall ??
                                            const TextStyle(fontSize: 12))
                                        .copyWith(
                                          color: AppColors.mediaOverlayText,
                                          fontWeight: FontWeight.w500,
                                        ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content body
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title (titleMedium, max 2 lines)
                      Text(
                        listing.title,
                        style:
                            (textStyles.titleMedium ??
                                    const TextStyle(fontSize: 16))
                                .copyWith(
                                  color: colors.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xs),

                      // Location & distance
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: colors.primary,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: listing.locationName,
                                    style: textStyles.bodySmall?.copyWith(
                                      color: colors.onSurfaceVariant,
                                    ),
                                  ),
                                  if (distanceKm != null) ...[
                                    TextSpan(
                                      text: ' · ',
                                      style: textStyles.bodySmall?.copyWith(
                                        color: colors.onSurfaceVariant,
                                      ),
                                    ),
                                    TextSpan(
                                      text: l10n.distanceAwayKm(
                                        distanceKm.toStringAsFixed(1),
                                      ),
                                      style: textStyles.labelMedium?.copyWith(
                                        color: colors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      // Description (bodyMedium onSurfaceVariant, 2 lines)
                      if (listing.description.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          listing.description,
                          style: textStyles.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: AppSpacing.md),

                      // 2 Action Buttons (Equal width, >= 48 dp height)
                      Row(
                        children: [
                          // Button 1: Detayı Gör (Tonal)
                          Expanded(
                            child: FilledButton.tonal(
                              onPressed: widget.onTap,
                              style: FilledButton.styleFrom(
                                minimumSize: const Size(0, 48),
                                backgroundColor: colors.surfaceContainerLow,
                                foregroundColor: colors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusMd,
                                  ),
                                ),
                              ),
                              child: Text(
                                l10n.viewDetailsButton,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),

                          // Button 2: Mesaj At / Bu Benim! / Düzenle
                          Expanded(
                            child: isOwner
                                ? OutlinedButton(
                                    onPressed:
                                        widget.onActionTap ?? widget.onTap,
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size(0, 48),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppSpacing.radiusMd,
                                        ),
                                      ),
                                    ),
                                    child: Text(l10n.editListingButton),
                                  )
                                : listing.isLost
                                ? FilledButton(
                                    onPressed:
                                        widget.onActionTap ?? widget.onTap,
                                    style: FilledButton.styleFrom(
                                      minimumSize: const Size(0, 48),
                                      backgroundColor: colors.primaryContainer,
                                      foregroundColor: colors.onPrimary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppSpacing.radiusMd,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.chat_bubble_outline,
                                          size: 16,
                                        ),
                                        const SizedBox(width: AppSpacing.xs),
                                        Text(l10n.cardActionMessage),
                                      ],
                                    ),
                                  )
                                : FilledButton(
                                    onPressed:
                                        widget.onActionTap ?? widget.onTap,
                                    style: FilledButton.styleFrom(
                                      minimumSize: const Size(0, 48),
                                      backgroundColor: colors.tertiaryContainer,
                                      foregroundColor: colors.onTertiary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppSpacing.radiusMd,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.handshake_outlined,
                                          size: 16,
                                        ),
                                        const SizedBox(width: AppSpacing.xs),
                                        Text(l10n.cardActionMine),
                                      ],
                                    ),
                                  ),
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
    final bgColor = isLost ? colors.secondaryFixed : colors.surfaceContainer;
    final iconColor = isLost ? colors.onSecondaryFixed : colors.primary;

    return ExcludeSemantics(
      child: Container(
        color: bgColor,
        alignment: Alignment.center,
        child: Icon(icon, size: 40, color: iconColor),
      ),
    );
  }
}
