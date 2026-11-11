import 'package:flutter/material.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/shared/extensions/context_x.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 32,
    this.borderRadius = AppSpacing.radiusMd,
  });

  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.appName,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.asset(
          'assets/branding/app_icon.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
