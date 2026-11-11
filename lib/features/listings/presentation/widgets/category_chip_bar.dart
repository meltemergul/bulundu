import 'package:flutter/material.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/listings/models/listing_category.dart';
import 'package:bulundu/shared/extensions/context_x.dart';

extension ListingCategoryL10n on ListingCategory {
  String localizedLabel(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      ListingCategory.wallet => l10n.categoryWallet,
      ListingCategory.phone => l10n.categoryPhone,
      ListingCategory.keys => l10n.categoryKeys,
      ListingCategory.bag => l10n.categoryBag,
      ListingCategory.documents => l10n.categoryDocuments,
      ListingCategory.electronics => l10n.categoryElectronics,
      ListingCategory.accessories => l10n.categoryAccessories,
      ListingCategory.clothing => l10n.categoryClothing,
      ListingCategory.pet => l10n.categoryPet,
      ListingCategory.other => l10n.categoryOther,
    };
  }
}

class CategoryChipBar extends StatelessWidget {
  const CategoryChipBar({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  final ListingCategory? selectedCategory;
  final ValueChanged<ListingCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return SizedBox(
      height: AppSpacing.minTouchTarget,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: _CategoryPill(
              selected: selectedCategory == null,
              label: l10n.filterAll,
              onTap: () => onSelected(null),
              colors: colors,
            ),
          ),
          ...ListingCategory.values.map((cat) {
            final isSelected = selectedCategory == cat;
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: _CategoryPill(
                selected: isSelected,
                icon: cat.icon,
                label: cat.localizedLabel(context),
                onTap: () => onSelected(isSelected ? null : cat),
                colors: colors,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({
    required this.selected,
    required this.label,
    required this.onTap,
    required this.colors,
    this.icon,
  });

  final bool selected;
  final String label;
  final VoidCallback onTap;
  final ColorScheme colors;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? colors.primary : colors.surface;
    final fg = selected ? colors.onPrimary : colors.onSurface;
    final borderColor = selected ? colors.primary : colors.outlineVariant;

    return Material(
      color: bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        side: BorderSide(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: AppSpacing.md, color: fg),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(
                label,
                style: context.textStyles.labelLarge?.copyWith(color: fg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
