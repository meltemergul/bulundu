import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bulundu/app/router/routes.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/listings/models/listing.dart';
import 'package:bulundu/features/listings/presentation/widgets/category_chip_bar.dart';
import 'package:bulundu/features/listings/presentation/widgets/listing_card.dart';
import 'package:bulundu/features/listings/presentation/widgets/listing_filter_sheet.dart';
import 'package:bulundu/features/listings/providers/listing_filter_provider.dart';
import 'package:bulundu/features/listings/providers/listing_providers.dart';
import 'package:bulundu/features/map/providers/location_providers.dart';
import 'package:bulundu/features/profile/providers/profile_providers.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/utils/breakpoints.dart';
import 'package:bulundu/shared/widgets/empty_state.dart';
import 'package:bulundu/shared/widgets/error_view.dart';
import 'package:bulundu/shared/widgets/loading_view.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final filter = ref.watch(listingFilterProvider);
    final listingsAsync = ref.watch(filteredListingsProvider);
    final userLocation = ref.watch(userLocationProvider).value;
    final profile = ref.watch(currentUserProfileProvider).value;

    final locationLabel = filter.maxDistanceKm != null
        ? l10n.filterDistanceKm(filter.maxDistanceKm!.toStringAsFixed(0))
        : l10n.locationAllAreas;
    final avatarInitial = (profile?.displayName.isNotEmpty ?? false)
        ? profile!.displayName.characters.first.toUpperCase()
        : 'B';

    return Scaffold(
      appBar: AppBar(
        titleSpacing: AppSpacing.md,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(
                Icons.location_on,
                size: AppSpacing.md,
                color: colors.onPrimary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(l10n.appTitle, style: context.textStyles.titleLarge),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: InkWell(
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                onTap: () => ListingFilterSheet.show(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    border: Border.all(color: colors.outlineVariant),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.near_me_outlined,
                        size: AppSpacing.md,
                        color: colors.primary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Flexible(
                        child: Text(
                          locationLabel,
                          style: context.textStyles.labelSmall?.copyWith(
                            color: colors.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: AppSpacing.md,
                        color: colors.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: l10n.filterTitle,
            onPressed: () => ListingFilterSheet.show(context),
            icon: Badge(
              isLabelVisible: filter.hasActiveFilters,
              backgroundColor: colors.secondary,
              child: Icon(
                filter.hasActiveFilters
                    ? Icons.tune
                    : Icons.notifications_none_outlined,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => context.go(AppRoutes.profile),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: AppSpacing.md,
                    backgroundColor: colors.primaryContainer,
                    foregroundColor: colors.onPrimaryContainer,
                    child: Text(
                      avatarInitial,
                      style: context.textStyles.labelLarge?.copyWith(
                        color: colors.onPrimaryContainer,
                      ),
                    ),
                  ),
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: colors.tertiary,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.surface, width: 1.5),
                      ),
                      child: Icon(
                        Icons.check,
                        size: AppSpacing.sm,
                        color: colors.onTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border(bottom: BorderSide(color: colors.outlineVariant)),
            ),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: Breakpoints.maxContent,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<ListingType?>(
                        segments: [
                          ButtonSegment(
                            value: null,
                            label: Text(l10n.filterAll),
                          ),
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
                        onSelectionChanged: (sel) {
                          ref
                              .read(listingFilterProvider.notifier)
                              .setType(sel.first);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                CategoryChipBar(
                  selectedCategory: filter.category,
                  onSelected: (cat) {
                    ref.read(listingFilterProvider.notifier).setCategory(cat);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: listingsAsync.when(
              loading: () => const LoadingView(),
              error: (_, _) => ErrorView(
                message: l10n.errorGeneric,
                onRetry: () =>
                    ref.invalidate(latestListingsProvider(filter.type)),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return EmptyState(
                    icon: Icons.radar_outlined,
                    title: l10n.exploreEmptyTitle,
                    message: l10n.exploreEmptyMessage,
                    action: Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      alignment: WrapAlignment.center,
                      children: [
                        if (filter.hasActiveFilters)
                          OutlinedButton.icon(
                            onPressed: () {
                              ref.read(listingFilterProvider.notifier).clear();
                            },
                            icon: const Icon(Icons.explore_outlined),
                            label: Text(l10n.expandRadiusButton),
                          ),
                        FilledButton.icon(
                          onPressed: () => context.push(AppRoutes.listingNew),
                          icon: const Icon(Icons.add),
                          label: Text(l10n.fabPostListing),
                        ),
                      ],
                    ),
                  );
                }

                if (context.isCompact) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(latestListingsProvider(filter.type));
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      itemCount: items.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ListingCard(
                          listing: item,
                          userLocation: userLocation,
                          onTap: () =>
                              context.push(AppRoutes.listingDetail(item.id)),
                        );
                      },
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(latestListingsProvider(filter.type));
                  },
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: Breakpoints.maxContent,
                      ),
                      child: GridView.builder(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: Breakpoints.maxCardGridExtent,
                              mainAxisSpacing: AppSpacing.md,
                              crossAxisSpacing: AppSpacing.md,
                              childAspectRatio: 0.85,
                            ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return ListingCard(
                            listing: item,
                            userLocation: userLocation,
                            onTap: () =>
                                context.push(AppRoutes.listingDetail(item.id)),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
