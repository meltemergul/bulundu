import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bulundu/app/router/routes.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/listings/models/listing.dart';
import 'package:bulundu/features/listings/presentation/widgets/listing_filter_sheet.dart';
import 'package:bulundu/features/listings/providers/listing_filter_provider.dart';
import 'package:bulundu/features/listings/providers/listing_providers.dart';
import 'package:bulundu/features/map/data/location_service.dart';
import 'package:bulundu/features/map/presentation/widgets/listing_map_marker.dart';
import 'package:bulundu/features/map/presentation/widgets/listing_preview_sheet.dart';
import 'package:bulundu/features/map/providers/location_providers.dart';
import 'package:bulundu/features/map/providers/map_providers.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/utils/breakpoints.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final _mapController = MapController();
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _goToMyLocation() async {
    final loc = await ref.read(locationServiceProvider).getCurrentLocation();
    if (!mounted) return;
    if (loc == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.locationPermissionDenied)),
      );
      return;
    }
    _mapController.move(loc, 14);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isWide = context.isWide;
    final filter = ref.watch(listingFilterProvider);
    final listingsAsync = ref.watch(filteredListingsProvider);
    final selectedListing = ref.watch(selectedMapListingProvider);
    final userLocation = ref.watch(userLocationProvider).value;

    final allListings = listingsAsync.value ?? const <Listing>[];
    final query = _searchQuery.trim().toLowerCase();
    final listings = query.isEmpty
        ? allListings
        : allListings.where((l) {
            return l.title.toLowerCase().contains(query) ||
                l.locationName.toLowerCase().contains(query) ||
                l.description.toLowerCase().contains(query);
          }).toList();
    final foundListings = listings.where((l) => l.isFound).toList();

    final previewPanel = selectedListing != null
        ? ListingPreviewSheet(
            listing: selectedListing,
            onClose: () =>
                ref.read(selectedMapListingProvider.notifier).select(null),
            onViewDetails: () =>
                context.push(AppRoutes.listingDetail(selectedListing.id)),
          )
        : null;

    final mapStack = Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: userLocation ?? LocationService.defaultCenter,
            initialZoom: 13,
            onTap: (_, _) {
              ref.read(selectedMapListingProvider.notifier).select(null);
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.bulundu.app',
            ),
            CircleLayer(
              circles: foundListings.map((item) {
                return CircleMarker(
                  point: item.displayPoint,
                  radius: Listing.foundPrivacyRadiusMeters,
                  useRadiusInMeter: true,
                  color: colors.tertiary.withValues(alpha: 0.18),
                  borderColor: colors.tertiary,
                  borderStrokeWidth: 2,
                );
              }).toList(),
            ),
            if (userLocation != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: userLocation,
                    width: AppSpacing.xxl,
                    height: AppSpacing.xxl,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.primary.withValues(alpha: 0.2),
                      ),
                      child: Container(
                        width: AppSpacing.md,
                        height: AppSpacing.md,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.primary,
                          border: Border.all(color: colors.surface, width: 2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            MarkerLayer(
              markers: listings.map((item) {
                final isSelected = selectedListing?.id == item.id;
                return Marker(
                  point: item.displayPoint,
                  width: AppSpacing.minTouchTarget,
                  height: AppSpacing.minTouchTarget,
                  child: ListingMapMarker(
                    listing: item,
                    isSelected: isSelected,
                    onTap: () {
                      ref
                          .read(selectedMapListingProvider.notifier)
                          .select(item);
                    },
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        Positioned(
          top: AppSpacing.sm,
          left: AppSpacing.md,
          right: AppSpacing.md,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: colors.surface.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  border: Border.all(color: colors.outlineVariant),
                  boxShadow: [
                    BoxShadow(
                      color: colors.shadow,
                      blurRadius: AppSpacing.md,
                      offset: const Offset(0, AppSpacing.xs),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: l10n.mapSearchHint,
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: colors.primary),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm + AppSpacing.xs,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      selected: filter.type == null,
                      showCheckmark: false,
                      label: Text(
                        l10n.filterAll,
                        style: context.textStyles.labelLarge?.copyWith(
                          color: filter.type == null
                              ? colors.onPrimary
                              : colors.onSurface,
                        ),
                      ),
                      onSelected: (_) => ref
                          .read(listingFilterProvider.notifier)
                          .setType(null),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    FilterChip(
                      selected: filter.type == ListingType.lost,
                      showCheckmark: false,
                      selectedColor: colors.secondary,
                      label: Text(
                        l10n.listingTypeLost,
                        style: context.textStyles.labelLarge?.copyWith(
                          color: filter.type == ListingType.lost
                              ? colors.onSecondary
                              : colors.onSurface,
                        ),
                      ),
                      onSelected: (_) => ref
                          .read(listingFilterProvider.notifier)
                          .setType(ListingType.lost),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    FilterChip(
                      selected: filter.type == ListingType.found,
                      showCheckmark: false,
                      selectedColor: colors.tertiary,
                      label: Text(
                        l10n.listingTypeFound,
                        style: context.textStyles.labelLarge?.copyWith(
                          color: filter.type == ListingType.found
                              ? colors.onTertiary
                              : colors.onSurface,
                        ),
                      ),
                      onSelected: (_) => ref
                          .read(listingFilterProvider.notifier)
                          .setType(ListingType.found),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: AppSpacing.sm,
          bottom: AppSpacing.sm,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Text(
              l10n.osmAttribution,
              style: context.textStyles.labelSmall,
            ),
          ),
        ),
        if (!isWide && previewPanel != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: AppSpacing.lg,
            child: previewPanel,
          ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mapTitle),
        actions: [
          IconButton(
            tooltip: l10n.myLocationTooltip,
            onPressed: _goToMyLocation,
            icon: const Icon(Icons.my_location),
          ),
          IconButton(
            tooltip: l10n.filterTitle,
            onPressed: () => ListingFilterSheet.show(context),
            icon: Icon(
              filter.hasActiveFilters
                  ? Icons.filter_alt
                  : Icons.filter_alt_outlined,
            ),
          ),
        ],
      ),
      body: isWide
          ? Row(
              children: [
                Expanded(child: mapStack),
                if (previewPanel != null)
                  SizedBox(
                    width: Breakpoints.maxCardGridExtent,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: previewPanel,
                    ),
                  ),
              ],
            )
          : mapStack,
    );
  }
}
