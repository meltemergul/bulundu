import 'package:flutter/material.dart';

/// Koyu temada gölge yok: derinlik surfaceContainer* tonlarıyla verilir.
abstract final class AppShadows {
  static List<BoxShadow> _light(bool dark, List<BoxShadow> s) =>
      dark ? const [] : s;

  /// Seviye 1: besleme kartları, filtreler.
  static List<BoxShadow> card(Brightness b) =>
      _light(b == Brightness.dark, const [
        BoxShadow(
          color: Color(0x0D0F172A),
          blurRadius: 16,
          spreadRadius: -2,
          offset: Offset(0, 4),
        ),
        BoxShadow(
          color: Color(0x080F172A),
          blurRadius: 4,
          spreadRadius: -1,
          offset: Offset(0, 2),
        ),
      ]);

  static List<BoxShadow> soft(Brightness b) => _light(
    b == Brightness.dark,
    const [
      BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
    ],
  );

  /// Seviye 2: FAB, harita pinleri, merkez +, yüzen alt çubuk.
  static List<BoxShadow> floating(Brightness b) =>
      _light(b == Brightness.dark, const [
        BoxShadow(
          color: Color(0x2E2563EB),
          blurRadius: 28,
          spreadRadius: -4,
          offset: Offset(0, 12),
        ),
        BoxShadow(
          color: Color(0x0A0F172A),
          blurRadius: 10,
          spreadRadius: -2,
          offset: Offset(0, 4),
        ),
      ]);

  /// Modal / bottom sheet.
  static List<BoxShadow> sheet(Brightness b) =>
      _light(b == Brightness.dark, const [
        BoxShadow(
          color: Color(0x140F172A),
          blurRadius: 32,
          offset: Offset(0, -8),
        ),
      ]);

  static List<BoxShadow> header(Brightness b) => _light(
    b == Brightness.dark,
    const [
      BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 1)),
    ],
  );
}
