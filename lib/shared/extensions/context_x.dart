import 'package:flutter/material.dart';
import 'package:bulundu/l10n/gen/app_localizations.dart';
import 'package:bulundu/shared/utils/breakpoints.dart';

extension ContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textStyles => Theme.of(this).textTheme;

  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  bool get isWide => screenWidth >= Breakpoints.medium;
  bool get isExpanded => screenWidth >= Breakpoints.expanded;
  bool get useRail => isWide && screenHeight >= Breakpoints.minRailHeight;
  bool get reduceMotion => MediaQuery.disableAnimationsOf(this);
}
