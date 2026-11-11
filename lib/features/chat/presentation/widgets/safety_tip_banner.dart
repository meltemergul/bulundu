import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/shared/extensions/context_x.dart';

class SafetyTipBanner extends StatefulWidget {
  const SafetyTipBanner({super.key});

  @override
  State<SafetyTipBanner> createState() => _SafetyTipBannerState();
}

class _SafetyTipBannerState extends State<SafetyTipBanner> {
  static const _prefKey = 'dismissed_safety_tip_banner';
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _checkDismissed();
  }

  Future<void> _checkDismissed() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_prefKey) == true) {
      if (mounted) setState(() => _isVisible = false);
    }
  }

  Future<void> _dismiss() async {
    setState(() => _isVisible = false);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    final colors = context.colors;
    final textStyles = context.textStyles;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: colors.primaryFixed.withValues(alpha: 0.40),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.shield_outlined, color: colors.primary, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              context.l10n.safetyTipBanner,
              style: (textStyles.bodySmall ?? const TextStyle(fontSize: 12))
                  .copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            tooltip: context.l10n.cancelButton,
            onPressed: _dismiss,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }
}
