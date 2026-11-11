import 'package:flutter/material.dart';
import 'package:bulundu/app/theme/app_shadows.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/listings/models/listing.dart';
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

  IconData get iconData => switch (this) {
    ListingCategory.wallet => Icons.account_balance_wallet_outlined,
    ListingCategory.phone => Icons.phone_android_outlined,
    ListingCategory.keys => Icons.key_outlined,
    ListingCategory.bag => Icons.backpack_outlined,
    ListingCategory.documents => Icons.description_outlined,
    ListingCategory.electronics => Icons.devices_outlined,
    ListingCategory.accessories => Icons.watch_outlined,
    ListingCategory.clothing => Icons.checkroom_outlined,
    ListingCategory.pet => Icons.pets_outlined,
    ListingCategory.other => Icons.category_outlined,
  };
}

class CategoryChipBar extends StatelessWidget {
  const CategoryChipBar({
    super.key,
    required this.selectedType,
    required this.selectedCategory,
    required this.onTypeSelected,
    required this.onCategorySelected,
  });

  final ListingType? selectedType;
  final ListingCategory? selectedCategory;
  final ValueChanged<ListingType?> onTypeSelected;
  final ValueChanged<ListingCategory?> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final brightness = Theme.of(context).brightness;

    final isAll = selectedType == null && selectedCategory == null;

    final quickChips = [
      _ChipItem(
        label: l10n.filterAll,
        icon: Icons.apps,
        isSelected: isAll,
        iconColor: colors.primary,
        onTap: () {
          onTypeSelected(null);
          onCategorySelected(null);
        },
      ),
      _ChipItem(
        label: l10n.listingTypeLost,
        icon: Icons.crisis_alert,
        isSelected: selectedType == ListingType.lost,
        iconColor: colors.secondary,
        onTap: () {
          onCategorySelected(null);
          onTypeSelected(
            selectedType == ListingType.lost ? null : ListingType.lost,
          );
        },
      ),
      _ChipItem(
        label: l10n.listingTypeFound,
        icon: Icons.inventory_2_outlined,
        isSelected: selectedType == ListingType.found,
        iconColor: colors.primary,
        onTap: () {
          onCategorySelected(null);
          onTypeSelected(
            selectedType == ListingType.found ? null : ListingType.found,
          );
        },
      ),
      _ChipItem(
        label: l10n.categoryPet,
        icon: Icons.pets_outlined,
        isSelected: selectedCategory == ListingCategory.pet,
        iconColor: colors.primary,
        onTap: () {
          onTypeSelected(null);
          onCategorySelected(
            selectedCategory == ListingCategory.pet
                ? null
                : ListingCategory.pet,
          );
        },
      ),
      _ChipItem(
        label: l10n.categoryElectronics,
        icon: Icons.devices_outlined,
        isSelected: selectedCategory == ListingCategory.electronics,
        iconColor: colors.primary,
        onTap: () {
          onTypeSelected(null);
          onCategorySelected(
            selectedCategory == ListingCategory.electronics
                ? null
                : ListingCategory.electronics,
          );
        },
      ),
      _ChipItem(
        label: l10n.categoryWallet,
        icon: Icons.account_balance_wallet_outlined,
        isSelected: selectedCategory == ListingCategory.wallet,
        iconColor: colors.primary,
        onTap: () {
          onTypeSelected(null);
          onCategorySelected(
            selectedCategory == ListingCategory.wallet
                ? null
                : ListingCategory.wallet,
          );
        },
      ),
      _ChipItem(
        label: l10n.categoryKeys,
        icon: Icons.key_outlined,
        isSelected: selectedCategory == ListingCategory.keys,
        iconColor: colors.primary,
        onTap: () {
          onTypeSelected(null);
          onCategorySelected(
            selectedCategory == ListingCategory.keys
                ? null
                : ListingCategory.keys,
          );
        },
      ),
    ];

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: quickChips.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (_, i) {
          final item = quickChips[i];
          return Center(
            child: Semantics(
              selected: item.isSelected,
              button: true,
              label: item.label,
              child: InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  constraints: const BoxConstraints(minHeight: 36),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: item.isSelected
                        ? colors.primary
                        : colors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    boxShadow: item.isSelected
                        ? null
                        : AppShadows.soft(brightness),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        size: 16,
                        color: item.isSelected
                            ? colors.onPrimary
                            : item.iconColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.label,
                        style:
                            (context.textStyles.labelMedium ??
                                    const TextStyle(fontSize: 12))
                                .copyWith(
                                  color: item.isSelected
                                      ? colors.onPrimary
                                      : colors.onSurfaceVariant,
                                  fontWeight: item.isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ChipItem {
  const _ChipItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.iconColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final Color iconColor;
  final VoidCallback onTap;
}
