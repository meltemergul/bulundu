import 'package:flutter/material.dart';
import 'package:bulundu/app/theme/app_colors.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/app/theme/app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(AppColors.lightScheme);
  static ThemeData get dark => _build(AppColors.darkScheme);

  static ThemeData _build(ColorScheme s) {
    final text = AppTypography.textTheme.apply(
      bodyColor: s.onSurface,
      displayColor: s.onSurface,
    );
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
    );
    const minSize = Size(AppSpacing.minTouchTarget, AppSpacing.minTouchTarget);

    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      borderSide: BorderSide(color: c, width: w),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: s,
      scaffoldBackgroundColor: s.surface,
      textTheme: text,
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarTheme(
        backgroundColor: s.surface,
        foregroundColor: s.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge?.copyWith(
          color: s.onSurface,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: s.onSurface),
      ),
      // Ana buton: primaryContainer + beyaz metin, basılı/hover: primary.
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(minSize),
          shape: WidgetStatePropertyAll(buttonShape),
          textStyle: WidgetStatePropertyAll(text.labelLarge),
          foregroundColor: WidgetStatePropertyAll(s.onPrimary),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return s.onSurface.withValues(alpha: 0.12);
            }
            if (states.contains(WidgetState.pressed) ||
                states.contains(WidgetState.hovered)) {
              return s.primary;
            }
            return s.primary;
          }),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: minSize,
          shape: buttonShape,
          textStyle: text.labelLarge,
          foregroundColor: s.primary,
          side: BorderSide(color: s.outline),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: minSize,
          textStyle: text.labelLarge,
          foregroundColor: s.primary,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: s.primary,
        foregroundColor: s.onPrimary,
        elevation: 0,
        extendedTextStyle: text.labelLarge,
        shape: const StadiumBorder(),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
          ),
          side: WidgetStatePropertyAll(
            BorderSide(color: s.outlineVariant),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return s.primaryContainer;
            }
            return s.surfaceContainerLowest;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return s.onPrimaryContainer;
            }
            return s.onSurface;
          }),
          textStyle: WidgetStatePropertyAll(text.labelMedium),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: s.surfaceContainerLowest,
        labelStyle: text.bodyMedium?.copyWith(color: s.onSurfaceVariant),
        floatingLabelStyle: text.bodyMedium?.copyWith(
          color: s.primary,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: text.bodyMedium?.copyWith(
          color: s.onSurfaceVariant.withValues(alpha: 0.6),
        ),
        border: border(s.outlineVariant),
        enabledBorder: border(s.outlineVariant),
        focusedBorder: border(s.primary, 2),
        errorBorder: border(s.error, 2),
        focusedErrorBorder: border(s.error, 2),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: s.surfaceContainerLowest,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        side: BorderSide(color: s.outlineVariant, width: 1),
        backgroundColor: s.surfaceContainerLowest,
        selectedColor: s.primaryContainer,
        labelStyle: text.labelMedium?.copyWith(color: s.onSurface),
        secondaryLabelStyle:
            text.labelMedium?.copyWith(color: s.onPrimaryContainer),
        checkmarkColor: s.onPrimaryContainer,
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        side: BorderSide(color: s.outline, width: 2),
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? s.primary : null,
        ),
        checkColor: WidgetStatePropertyAll(s.onPrimary),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? s.primary : s.outline,
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: s.surface,
        indicatorColor: s.primaryFixed,
        labelType: NavigationRailLabelType.all,
        selectedIconTheme: IconThemeData(color: s.onPrimaryFixed),
        unselectedIconTheme: IconThemeData(color: s.onSurfaceVariant),
        selectedLabelTextStyle: text.labelSmall?.copyWith(color: s.primary),
        unselectedLabelTextStyle: text.labelSmall?.copyWith(
          color: s.onSurfaceVariant,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: s.surfaceContainerLowest,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusSheet),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(color: s.outlineVariant, space: 1),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: s.inverseSurface,
        contentTextStyle: text.bodyMedium?.copyWith(color: s.onInverseSurface),
      ),
    );
  }
}
