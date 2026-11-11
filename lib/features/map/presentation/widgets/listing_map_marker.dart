import 'package:flutter/material.dart';
import 'package:bulundu/app/theme/app_shadows.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/listings/models/listing.dart';
import 'package:bulundu/features/listings/presentation/widgets/category_chip_bar.dart';
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
    final brightness = Theme.of(context).brightness;
    final isLost = listing.isLost;

    final bgColor = isLost
        ? colors.secondaryContainer
        : colors.primaryContainer;
    final fgColor =
        isLost ? colors.onSecondaryContainer : colors.onPrimaryContainer;
    final icon = listing.category.iconData;

    final bodySize = isSelected ? 44.0 : 36.0;

    return Semantics(
      button: true,
      label: listing.title,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: isSelected ? 120 : 48,
          height: isSelected ? 72 : 48,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSelected)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Text(
                    listing.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: fgColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              Center(
                child: Container(
                  width: bodySize,
                  height: bodySize,
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: isLost ? BoxShape.circle : BoxShape.rectangle,
                    borderRadius: isLost ? null : BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: AppShadows.floating(brightness),
                  ),
                  child: Icon(icon, color: fgColor, size: isSelected ? 22 : 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
