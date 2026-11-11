import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bulundu/app/router/routes.dart';
import 'package:bulundu/app/theme/app_shadows.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/listings/presentation/widgets/category_chip_bar.dart';
import 'package:bulundu/features/listings/presentation/widgets/listing_card.dart';
import 'package:bulundu/features/listings/presentation/widgets/listing_filter_sheet.dart';
import 'package:bulundu/features/listings/providers/listing_filter_provider.dart';
import 'package:bulundu/features/listings/providers/listing_providers.dart';
import 'package:bulundu/features/map/providers/location_providers.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/utils/breakpoints.dart';
import 'package:bulundu/shared/widgets/app_header.dart';
import 'package:bulundu/shared/widgets/empty_state.dart';
import 'package:bulundu/shared/widgets/error_view.dart';
import 'package:bulundu/shared/widgets/loading_view.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final textStyles = context.textStyles;
    final brightness = Theme.of(context).brightness;

    final filter = ref.watch(listingFilterProvider);
    final listingsAsync = ref.watch(filteredListingsProvider);
    final userLocation = ref.watch(userLocationProvider).value;

    return Scaffold(
      appBar: const AppHeader(),
      body: Column(
        children: [
          // Search Bar + Filter Button
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.xs,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      boxShadow: AppShadows.soft(brightness),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(
                        color: colors.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      cursorColor: colors.primary,
                      onChanged: (val) => setState(
                        () => _searchQuery = val.trim().toLowerCase(),
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.searchHint,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Semantics(
                  button: true,
                  label: filter.hasActiveFilters
                      ? l10n.filtersActiveTooltip
                      : l10n.filterTitle,
                  child: InkWell(
                    onTap: () => ListingFilterSheet.show(context),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: colors.surfaceContainer,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusLg,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(Icons.tune, color: colors.primary),
                          if (filter.hasActiveFilters)
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: colors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Category & Type Chip Bar
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: CategoryChipBar(
              selectedType: filter.type,
              selectedCategory: filter.category,
              onTypeSelected: (type) {
                ref.read(listingFilterProvider.notifier).setType(type);
              },
              onCategorySelected: (cat) {
                ref.read(listingFilterProvider.notifier).setCategory(cat);
              },
            ),
          ),

          // Feed Header: "Yakınındaki İlanlar" / "Son İlanlar" + radius pill
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.xs,
            ),
            child: Row(
              children: [
                Text(
                  userLocation != null
                      ? l10n.feedTitleNearby
                      : l10n.feedTitleRecent,
                  style:
                      (textStyles.titleMedium ?? const TextStyle(fontSize: 16))
                          .copyWith(
                            color: colors.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                ),
                const SizedBox(width: AppSpacing.sm),
                if (filter.maxDistanceKm != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusFull,
                      ),
                    ),
                    child: Text(
                      l10n.radiusInKm(filter.maxDistanceKm!.toStringAsFixed(0)),
                      style:
                          (textStyles.labelSmall ??
                                  const TextStyle(fontSize: 12))
                              .copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                  ),
                const Spacer(),
                Text(
                  l10n.sortNewest,
                  style:
                      (textStyles.labelSmall ?? const TextStyle(fontSize: 12))
                          .copyWith(color: colors.onSurfaceVariant),
                ),
              ],
            ),
          ),

          // Listings Stream List / Grid
          Expanded(
            child: listingsAsync.when(
              loading: () => const LoadingView(),
              error: (_, _) => ErrorView(
                message: l10n.errorGeneric,
                onRetry: () =>
                    ref.invalidate(latestListingsProvider(filter.type)),
              ),
              data: (items) {
                final filtered = _searchQuery.isEmpty
                    ? items
                    : items.where((i) {
                        return i.title.toLowerCase().contains(_searchQuery) ||
                            i.description.toLowerCase().contains(
                              _searchQuery,
                            ) ||
                            i.locationName.toLowerCase().contains(_searchQuery);
                      }).toList();

                if (filtered.isEmpty) {
                  return EmptyState(
                    icon: Icons.radar_outlined,
                    title: l10n.exploreEmptyTitle,
                    message: l10n.exploreEmptyMessage,
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
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final isGrid = width >= Breakpoints.medium;

                          if (!isGrid) {
                            return ListView.separated(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              itemCount: filtered.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: AppSpacing.md),
                              itemBuilder: (context, index) {
                                final item = filtered[index];
                                return ListingCard(
                                  listing: item,
                                  userLocation: userLocation,
                                  onTap: () => context.push(
                                    AppRoutes.listingDetail(item.id),
                                  ),
                                );
                              },
                            );
                          }

                          return GridView.builder(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent:
                                      Breakpoints.maxCardGridExtent,
                                  mainAxisSpacing: AppSpacing.md,
                                  crossAxisSpacing: AppSpacing.md,
                                  childAspectRatio: 0.78,
                                ),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final item = filtered[index];
                              return ListingCard(
                                listing: item,
                                userLocation: userLocation,
                                onTap: () => context.push(
                                  AppRoutes.listingDetail(item.id),
                                ),
                              );
                            },
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
