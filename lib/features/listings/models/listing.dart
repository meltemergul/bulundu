import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:bulundu/features/listings/models/listing_category.dart';

enum ListingType { lost, found }

enum ListingStatus { open, resolved }

class Listing {
  const Listing({
    required this.id,
    required this.type,
    required this.status,
    required this.title,
    required this.category,
    required this.description,
    required this.ownerId,
    required this.ownerName,
    required this.lat,
    required this.lng,
    required this.locationName,
    required this.eventDate,
    required this.createdAt,
    this.updatedAt,
    this.imageUrls = const [],
  });

  static const double foundPrivacyRadiusMeters = 250;
  static const double foundMaxOffsetMeters = 120;

  final String id;
  final ListingType type;
  final ListingStatus status;
  final String title;
  final ListingCategory category;
  final String description;
  final String ownerId;
  final String ownerName;
  final double lat;
  final double lng;
  final String locationName;
  final DateTime eventDate;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String> imageUrls;

  bool get isLost => type == ListingType.lost;
  bool get isFound => type == ListingType.found;
  bool get isResolved => status == ListingStatus.resolved;

  LatLng get exactPoint => LatLng(lat, lng);

  /// For `found` listings, returns a deterministic offset point (<= 120 m)
  /// derived from the listing `id` so the exact point remains inside the
  /// 250 m circle without being at its center.
  LatLng get displayPoint {
    if (type == ListingType.lost) {
      return exactPoint;
    }
    // Deterministic hash without external crypto dependency
    var h = 0x811c9dc5;
    for (final cu in id.codeUnits) {
      h = ((h ^ cu) * 0x01000193) & 0xFFFFFFFF;
    }
    final normDist = (h & 0xFFFF) / 65535.0;
    final normBearing = ((h >> 16) & 0xFFFF) / 65535.0;
    // Distance between 30 m and 120 m
    final distanceMeters = 30.0 + (normDist * (foundMaxOffsetMeters - 30.0));
    final bearingRad = normBearing * 2 * pi;

    const earthRadius = 6378137.0;
    final latRad = lat * pi / 180.0;
    final dLat = (distanceMeters * cos(bearingRad)) / earthRadius;
    final cosLat = cos(latRad).abs() < 1e-6 ? 1e-6 : cos(latRad);
    final dLng = (distanceMeters * sin(bearingRad)) / (earthRadius * cosLat);

    return LatLng(lat + (dLat * 180.0 / pi), lng + (dLng * 180.0 / pi));
  }

  /// Distance in kilometers from [userPoint], rounded to 0.5 km for cards.
  double roundedDistanceKmFrom(LatLng userPoint) {
    const distance = Distance();
    final km = distance.as(LengthUnit.Kilometer, userPoint, exactPoint);
    final rounded = (km * 2).round() / 2.0;
    return rounded < 0.5 ? 0.5 : rounded;
  }

  factory Listing.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snap,
    SnapshotOptions? _,
  ) {
    final d = snap.data()!;
    return Listing(
      id: snap.id,
      type: ListingType.values.byName(d['type'] as String),
      status: ListingStatus.values.byName(d['status'] as String),
      title: d['title'] as String,
      category: ListingCategory.values.byName(d['category'] as String),
      description: (d['description'] as String?) ?? '',
      ownerId: d['ownerId'] as String,
      ownerName: (d['ownerName'] as String?) ?? '',
      lat: (d['lat'] as num).toDouble(),
      lng: (d['lng'] as num).toDouble(),
      locationName: (d['locationName'] as String?) ?? '',
      eventDate: (d['eventDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (d['updatedAt'] as Timestamp?)?.toDate(),
      imageUrls: List<String>.from(d['imageUrls'] as List? ?? const []),
    );
  }

  Map<String, dynamic> toCreateMap() => {
    'type': type.name,
    'status': status.name,
    'title': title,
    'category': category.name,
    'description': description,
    'ownerId': ownerId,
    'ownerName': ownerName,
    'lat': lat,
    'lng': lng,
    'locationName': locationName,
    'eventDate': Timestamp.fromDate(eventDate),
    'imageUrls': imageUrls,
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  };
}
