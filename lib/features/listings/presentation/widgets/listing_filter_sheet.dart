import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/listings/models/listing.dart';
import 'package:bulundu/features/listings/models/listing_category.dart';
import 'package:bulundu/features/listings/presentation/widgets/category_chip_bar.dart';
import 'package:bulundu/features/listings/providers/listing_filter_provider.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/utils/breakpoints.dart';
import 'package:bulundu/shared/widgets/app_button.dart';

class ListingFilterSheet extends ConsumerWidget {
  const ListingFilterSheet({super.key});

  static const _distanceOptions = <double?>[null, 1, 3, 5, 10, 25];

  static Future<void> show(BuildContext context) {
    if (context.isWide) {
      return showDialog<void>(
        context: context,
        builder: (_) => Dialog(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.maxFormWidth,
            ),
            child: const ListingFilterSheet(),
          ),
        ),
      );
    }
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const ListingFilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final filter = ref.watch(listingFilterProvider);
    final notifier = ref.read(listingFilterProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.filterTitle, style: context.textStyles.titleLarge),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.listingTypeLabel, style: context.textStyles.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          SegmentedButton<ListingType?>(
            segments: [
              ButtonSegment(value: null, label: Text(l10n.filterAll)),
              ButtonSegment(
                value: ListingType.lost,
                label: Text(l10n.listingTypeLost),
                icon: const Icon(Icons.search),
              ),
              ButtonSegment(
                value: ListingType.found,
                label: Text(l10n.listingTypeFound),
                icon: const Icon(Icons.inventory_2_outlined),
              ),
            ],
            selected: {filter.type},
            onSelectionChanged: (s) => notifier.setType(s.first),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.listingCategoryLabel,
            style: context.textStyles.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              FilterChip(
                selected: filter.category == null,
                label: Text(l10n.filterAll),
                onSelected: (_) => notifier.setCategory(null),
              ),
              ...ListingCategory.values.map((cat) {
                return FilterChip(
                  selected: filter.category == cat,
                  label: Text(cat.localizedLabel(context)),
                  onSelected: (sel) => notifier.setCategory(sel ? cat : null),
                );
              }),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.filterDistanceLabel, style: context.textStyles.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: _distanceOptions.map((km) {
              final label = km == null
                  ? l10n.filterDistanceAny
                  : l10n.filterDistanceKm(km.toInt().toString());
              return FilterChip(
                selected: filter.maxDistanceKm == km,
                label: Text(label),
                onSelected: (_) => notifier.setMaxDistanceKm(km),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: l10n.filterClearButton,
                  variant: AppButtonVariant.secondary,
                  onPressed: () {
                    notifier.clear();
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton(
                  label: l10n.filterApplyButton,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
