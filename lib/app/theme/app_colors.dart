import 'package:flutter/material.dart';

abstract final class AppColors {
  /// Fotoğraf üstü zaman hapı (tema bağımsız): zemin #263A36 %80, metin #FFFFFF
  static const mediaOverlay = Color(0xCC263A36);
  static const mediaOverlayText = Color(0xFFFFFFFF);

  /// Açık tema — Deep Teal + Warm Cream + Soft Coral (DESIGN.md §2.2)
  static const lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF245C59), // Ana marka rengi (Deep Teal)
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFDCEBE6), // Açık teal dolgu
    onPrimaryContainer: Color(0xFF173F3C),
    primaryFixed: Color(0xFFDCEBE6),
    primaryFixedDim: Color(0xFFB8D3CA),
    onPrimaryFixed: Color(0xFF102F2D),
    onPrimaryFixedVariant: Color(0xFF245C59),
    secondary: Color(0xFFA94F35), // Soft Coral
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFF7D8CB), // Kayıp rozeti / pin dolgusu
    onSecondaryContainer: Color(0xFF58372D),
    secondaryFixed: Color(0xFFF7D8CB),
    secondaryFixedDim: Color(0xFFEFBBA7),
    onSecondaryFixed: Color(0xFF58372D),
    onSecondaryFixedVariant: Color(0xFF754633),
    tertiary: Color(0xFF356F62), // Sage tabanlı olumlu durum (Teslim Edildi)
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFD7E9E2), // Teslim Edildi rozeti
    onTertiaryContainer: Color(0xFF214B42),
    tertiaryFixed: Color(0xFFD7E9E2),
    tertiaryFixedDim: Color(0xFFB8D5C9),
    onTertiaryFixed: Color(0xFF173B34),
    onTertiaryFixedVariant: Color(0xFF356F62),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF93000A),
    surface: Color(0xFFF4EBDD), // Warm Cream sayfa zemini
    onSurface: Color(0xFF343D3B), // Charcoal ana metin
    onSurfaceVariant: Color(0xFF59635F), // İkincil metin ve placeholder
    surfaceDim: Color(0xFFE8DECF),
    surfaceBright: Color(0xFFFFFCF7),
    surfaceContainerLowest: Color(0xFFFFFCF7), // Kart ve form yüzeyi
    surfaceContainerLow: Color(0xFFF8F2E9),
    surfaceContainer: Color(0xFFF0E7DA),
    surfaceContainerHigh: Color(0xFFE9DFD1),
    surfaceContainerHighest: Color(0xFFE1D7C9),
    outline: Color(0xFF737D77),
    outlineVariant: Color(0xFFD0C8BC),
    inverseSurface: Color(0xFF263A36),
    onInverseSurface: Color(0xFFF8F2E9),
    inversePrimary: Color(0xFFA9CEC2),
    surfaceTint: Color(0xFF245C59),
  );

  /// Koyu tema (DESIGN.md §2.3)
  static const darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFA9CEC2),
    onPrimary: Color(0xFF173F3C),
    primaryContainer: Color(0xFF245C59),
    onPrimaryContainer: Color(0xFFFFFFFF),
    primaryFixed: Color(0xFFDCEBE6),
    primaryFixedDim: Color(0xFFB8D3CA),
    onPrimaryFixed: Color(0xFF102F2D),
    onPrimaryFixedVariant: Color(0xFF245C59),
    secondary: Color(0xFFF2B49D),
    onSecondary: Color(0xFF58372D),
    secondaryContainer: Color(0xFF754633),
    onSecondaryContainer: Color(0xFFFFE8DF),
    secondaryFixed: Color(0xFFF7D8CB),
    secondaryFixedDim: Color(0xFFEFBBA7),
    onSecondaryFixed: Color(0xFF58372D),
    onSecondaryFixedVariant: Color(0xFF754633),
    tertiary: Color(0xFFA8D0C1),
    onTertiary: Color(0xFF173B34),
    tertiaryContainer: Color(0xFF356F62),
    onTertiaryContainer: Color(0xFFFFFFFF),
    tertiaryFixed: Color(0xFFD7E9E2),
    tertiaryFixedDim: Color(0xFFB8D5C9),
    onTertiaryFixed: Color(0xFF173B34),
    onTertiaryFixedVariant: Color(0xFF356F62),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF17211F), // Koyu yeşil-gri zemin
    onSurface: Color(0xFFF4F1E9), // Net açık metin
    onSurfaceVariant: Color(0xFFC2CDC6),
    surfaceDim: Color(0xFF121A18),
    surfaceBright: Color(0xFF394C46),
    surfaceContainerLowest: Color(0xFF202D2A), // Koyu kart zemini
    surfaceContainerLow: Color(0xFF24332F),
    surfaceContainer: Color(0xFF293A35),
    surfaceContainerHigh: Color(0xFF30433D),
    surfaceContainerHighest: Color(0xFF394C46),
    outline: Color(0xFF899890),
    outlineVariant: Color(0xFF46564F),
    inverseSurface: Color(0xFFF4F1E9),
    onInverseSurface: Color(0xFF263A36),
    inversePrimary: Color(0xFF245C59),
    surfaceTint: Color(0xFFA9CEC2),
  );
}
