import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const _family = 'PlusJakartaSans';

  static const textTheme = TextTheme(
    headlineLarge: TextStyle(
      fontFamily: _family,
      fontSize: 28,
      height: 36 / 28,
      fontWeight: FontWeight.w800,
    ),
    headlineMedium: TextStyle(
      fontFamily: _family,
      fontSize: 22,
      height: 30 / 22,
      fontWeight: FontWeight.w700,
    ),
    headlineSmall: TextStyle(
      fontFamily: _family,
      fontSize: 20,
      height: 28 / 20,
      fontWeight: FontWeight.w700,
    ),
    titleLarge: TextStyle(
      fontFamily: _family,
      fontSize: 20,
      height: 28 / 20,
      fontWeight: FontWeight.w700,
    ),
    titleMedium: TextStyle(
      fontFamily: _family,
      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w700,
    ),
    bodyLarge: TextStyle(
      fontFamily: _family,
      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      fontFamily: _family,
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      fontFamily: _family,
      fontSize: 12,
      height: 16 / 12,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: TextStyle(
      fontFamily: _family,
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w600,
    ),
    labelMedium: TextStyle(
      fontFamily: _family,
      fontSize: 12,
      height: 16 / 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.24,
    ),
    labelSmall: TextStyle(
      fontFamily: _family,
      fontSize: 12,
      height: 16 / 12,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.24,
    ),
  );

  /// Geniş ekranda (≥ 1024 dp) yalnız ekran başlıkları için.
  static const wideHeadlineLarge = TextStyle(
    fontFamily: _family,
    fontSize: 36,
    height: 44 / 36,
    fontWeight: FontWeight.w800,
  );
  static const wideHeadlineMedium = TextStyle(
    fontFamily: _family,
    fontSize: 28,
    height: 36 / 28,
    fontWeight: FontWeight.w700,
  );
}
