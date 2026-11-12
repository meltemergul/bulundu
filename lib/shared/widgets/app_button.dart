import 'package:flutter/material.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/shared/extensions/context_x.dart';

enum AppButtonVariant { primary, secondary, danger, tertiary }

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final AppButtonVariant variant;
  final bool expand;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    Color bg;
    Color fg;
    List<BoxShadow>? shadows;
    Border? border;

    switch (widget.variant) {
      case AppButtonVariant.primary:
        // Solid primary indigo fill (#2563EB / #004AC6) + white text + modern depth shadow
        bg = isEnabled
            ? (_isPressed ? colors.primary : colors.primaryContainer)
            : colors.onSurface.withValues(alpha: 0.12);
        fg = isEnabled ? colors.onPrimary : colors.onSurfaceVariant;
        shadows = isEnabled && !_isPressed
            ? [
                BoxShadow(
                  color: colors.primaryContainer.withValues(
                    alpha: _isHovered ? 0.32 : 0.22,
                  ),
                  blurRadius: _isHovered ? 18 : 12,
                  offset: Offset(0, _isHovered ? 6 : 4),
                  spreadRadius: -2,
                ),
              ]
            : null;
        break;

      case AppButtonVariant.secondary:
        // Subtle slate surface (#EFF4FF) with slate/navy text (#0B1C30)
        bg = isEnabled
            ? (_isPressed || _isHovered
                  ? colors.surfaceContainer
                  : colors.surfaceContainerLow)
            : colors.surfaceContainerLowest;
        fg = isEnabled ? colors.onSurface : colors.onSurfaceVariant;
        border = Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.6),
          width: 1,
        );
        break;

      case AppButtonVariant.danger:
        // Muted error container (#FFDAD6) with dark red text (#93000A)
        bg = isEnabled
            ? (_isPressed || _isHovered ? colors.error : colors.errorContainer)
            : colors.onSurface.withValues(alpha: 0.08);
        fg = isEnabled
            ? (_isPressed || _isHovered
                  ? colors.onError
                  : colors.onErrorContainer)
            : colors.onSurfaceVariant;
        break;

      case AppButtonVariant.tertiary:
        // Transparent borderless
        bg = Colors.transparent;
        fg = isEnabled ? colors.primary : colors.onSurfaceVariant;
        break;
    }

    final Widget content = widget.isLoading
        ? SizedBox(
            width: AppSpacing.md,
            height: AppSpacing.md,
            child: CircularProgressIndicator(strokeWidth: 2.2, color: fg),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 18, color: fg),
                const SizedBox(width: AppSpacing.xs + 2),
              ],
              Flexible(
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      (textStyles.labelLarge ?? const TextStyle(fontSize: 14))
                          .copyWith(
                            color: fg,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.1,
                          ),
                ),
              ),
            ],
          );

    final Widget buttonContainer = AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      height: 48, // 48px touch target per spec
      constraints: const BoxConstraints(minHeight: 48),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusMd,
        ), // 0.5rem (8dp)
        boxShadow: shadows,
        border: border,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          onTap: isEnabled ? widget.onPressed : null,
          onHighlightChanged: (val) => setState(() => _isPressed = val),
          onHover: (val) => setState(() => _isHovered = val),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Center(child: content),
          ),
        ),
      ),
    );

    if (!widget.expand) return buttonContainer;
    return SizedBox(width: double.infinity, child: buttonContainer);
  }
}
