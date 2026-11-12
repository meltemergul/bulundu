import 'package:flutter/material.dart';

abstract final class AppColors {
  /// Fotoğraf üstü zaman hapı: zemin #0B1C30 %80, metin #FFFFFF
  static const mediaOverlay = Color(0xCC0B1C30);
  static const mediaOverlayText = Color(0xFFFFFFFF);

  /// Açık tema — Civic Beacon (Modern Electric Indigo + Energetic Warm Amber + Safety Emerald Teal)
  static const lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF004AC6),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(
      0xFF2563EB,
    ), // Electric Indigo (Primary CTA, radius indicators)
    onPrimaryContainer: Color(0xFFEEEFFF),
    primaryFixed: Color(0xFFDBE1FF), // Soft sky pill
    primaryFixedDim: Color(0xFFB4C5FF),
    onPrimaryFixed: Color(0xFF00174B),
    onPrimaryFixedVariant: Color(0xFF003EA8),
    secondary: Color(0xFF855300), // Energetic Warm Amber
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFFEA619), // Kayıp rozeti & dot
    onSecondaryContainer: Color(0xFF684000),
    secondaryFixed: Color(0xFFFFDDB8), // Light warm amber pill
    secondaryFixedDim: Color(0xFFFFB95F),
    onSecondaryFixed: Color(0xFF2A1700),
    onSecondaryFixedVariant: Color(0xFF653E00),
    tertiary: Color(0xFF006242), // Safety Emerald Teal
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFF007D55),
    onTertiaryContainer: Color(0xFFBDFFDB),
    tertiaryFixed: Color(0xFF6FFBBE), // Tender mint/emerald pill
    tertiaryFixedDim: Color(0xFF4EDEA3),
    onTertiaryFixed: Color(0xFF002113),
    onTertiaryFixedVariant: Color(0xFF005236),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF93000A),
    surface: Color(0xFFF8F9FF), // Ice-clean canvas
    onSurface: Color(0xFF0B1C30), // Deep Navy / Charcoal
    onSurfaceVariant: Color(0xFF434655), // Neutral slate captions
    surfaceDim: Color(0xFFCBDBF5),
    surfaceBright: Color(0xFFF8F9FF),
    surfaceContainerLowest: Color(0xFFFFFFFF), // Pure white cards & inputs
    surfaceContainerLow: Color(0xFFEFF4FF), // Secondary CTA subtle surface
    surfaceContainer: Color(0xFFE5EEFF),
    surfaceContainerHigh: Color(0xFFDCE9FF),
    surfaceContainerHighest: Color(0xFFD3E4FE),
    outline: Color(0xFF737686),
    outlineVariant: Color(0xFFC3C6D7),
    inverseSurface: Color(0xFF213145),
    onInverseSurface: Color(0xFFEAF1FF),
    inversePrimary: Color(0xFFB4C5FF),
    surfaceTint: Color(0xFF0053DB),
  );

  /// Koyu tema
  static const darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFB4C5FF),
    onPrimary: Color(0xFF002A78),
    primaryContainer: Color(0xFF004AC6),
    onPrimaryContainer: Color(0xFFDBE1FF),
    primaryFixed: Color(0xFFDBE1FF),
    primaryFixedDim: Color(0xFFB4C5FF),
    onPrimaryFixed: Color(0xFF00174B),
    onPrimaryFixedVariant: Color(0xFF003EA8),
    secondary: Color(0xFFFFB95F),
    onSecondary: Color(0xFF472A00),
    secondaryContainer: Color(0xFF653E00),
    onSecondaryContainer: Color(0xFFFFDDB8),
    secondaryFixed: Color(0xFFFFDDB8),
    secondaryFixedDim: Color(0xFFFFB95F),
    onSecondaryFixed: Color(0xFF2A1700),
    onSecondaryFixedVariant: Color(0xFF653E00),
    tertiary: Color(0xFF4EDEA3),
    onTertiary: Color(0xFF003824),
    tertiaryContainer: Color(0xFF005236),
    onTertiaryContainer: Color(0xFF6FFBBE),
    tertiaryFixed: Color(0xFF6FFBBE),
    tertiaryFixedDim: Color(0xFF4EDEA3),
    onTertiaryFixed: Color(0xFF002113),
    onTertiaryFixedVariant: Color(0xFF005236),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF0F141C),
    onSurface: Color(0xFFE2E7F4),
    onSurfaceVariant: Color(0xFFC3C6D7),
    surfaceDim: Color(0xFF0A0F16),
    surfaceBright: Color(0xFF333A48),
    surfaceContainerLowest: Color(0xFF141A23),
    surfaceContainerLow: Color(0xFF1A212C),
    surfaceContainer: Color(0xFF202733),
    surfaceContainerHigh: Color(0xFF262E3B),
    surfaceContainerHighest: Color(0xFF2C3543),
    outline: Color(0xFF8D91A0),
    outlineVariant: Color(0xFF434655),
    inverseSurface: Color(0xFFE2E7F4),
    onInverseSurface: Color(0xFF213145),
    inversePrimary: Color(0xFF004AC6),
    surfaceTint: Color(0xFFB4C5FF),
  );
}
