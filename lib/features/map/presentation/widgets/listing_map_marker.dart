import 'package:flutter/material.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/listings/models/listing.dart';
import 'package:bulundu/shared/extensions/context_x.dart';

class ListingMapMarker extends StatelessWidget {
  const ListingMapMarker({
    super.key,
    required this.listing,
    required this.isSelected,
    required this.onTap,
  });

  final Listing listing;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isLost = listing.isLost;
    final bgColor = isLost ? colors.secondary : colors.tertiary;
    final fgColor = isLost ? colors.onSecondary : colors.onTertiary;
    final icon = listing.category.icon;
    final size = isSelected
        ? AppSpacing.minTouchTarget
        : AppSpacing.minTouchTarget - AppSpacing.sm;

    return Semantics(
      button: true,
      label: listing.title,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: AppSpacing.minTouchTarget,
          height: AppSpacing.minTouchTarget,
          child: Center(
            child: AnimatedContainer(
              duration: context.reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.surface,
                  width: isSelected ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow,
                    blurRadius: AppSpacing.sm,
                    offset: const Offset(0, AppSpacing.xs),
                  ),
                ],
              ),
              child: Icon(icon, color: fgColor, size: AppSpacing.md),
            ),
          ),
        ),
      ),
    );
  }
}
