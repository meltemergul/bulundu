import 'package:flutter/material.dart';
import 'package:bulundu/l10n/gen/app_localizations.dart';
import 'package:bulundu/shared/utils/breakpoints.dart';

extension ContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textStyles => Theme.of(this).textTheme;

  double get screenWidth => MediaQuery.sizeOf(this).width;
  bool get isCompact => screenWidth < Breakpoints.compact;
  bool get isMedium =>
      screenWidth >= Breakpoints.compact && screenWidth < Breakpoints.medium;
  bool get isWide => screenWidth >= Breakpoints.medium;
  bool get reduceMotion => MediaQuery.disableAnimationsOf(this);
}
