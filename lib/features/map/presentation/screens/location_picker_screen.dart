import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/map/data/location_service.dart';
import 'package:bulundu/features/map/providers/location_providers.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/widgets/app_button.dart';

class LocationPickerScreen extends ConsumerStatefulWidget {
  const LocationPickerScreen({super.key, this.initialPoint});

  final LatLng? initialPoint;

  @override
  ConsumerState<LocationPickerScreen> createState() =>
      _LocationPickerScreenState();
}

class _LocationPickerScreenState extends ConsumerState<LocationPickerScreen> {
  final _mapController = MapController();
  late LatLng _selectedPoint;

  @override
  void initState() {
    super.initState();
    _selectedPoint = widget.initialPoint ?? LocationService.defaultCenter;
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
    setState(() => _selectedPoint = loc);
    _mapController.move(loc, 15);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pickLocationTitle),
        actions: [
          IconButton(
            tooltip: l10n.myLocationTooltip,
            onPressed: _goToMyLocation,
            icon: const Icon(Icons.my_location),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedPoint,
              initialZoom: 14,
              onTap: (_, point) {
                setState(() => _selectedPoint = point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.bulundu.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _selectedPoint,
                    width: AppSpacing.minTouchTarget,
                    height: AppSpacing.minTouchTarget,
                    child: Icon(
                      Icons.location_on,
                      size: AppSpacing.xl,
                      color: colors.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: AppSpacing.md,
            left: AppSpacing.md,
            right: AppSpacing.md,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Text(
                  l10n.pickLocationHint,
                  style: context.textStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.sm,
            bottom: AppSpacing.xxl + AppSpacing.xl,
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
          Positioned(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.md,
            child: SafeArea(
              child: AppButton(
                label: l10n.confirmLocationButton,
                onPressed: () => context.pop(_selectedPoint),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
