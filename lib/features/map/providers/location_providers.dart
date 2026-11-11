import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:bulundu/features/map/data/location_service.dart';

final locationServiceProvider = Provider<LocationService>(
  (_) => LocationService(),
);

final userLocationProvider = FutureProvider<LatLng?>((ref) async {
  return ref.watch(locationServiceProvider).getCurrentLocation();
});
