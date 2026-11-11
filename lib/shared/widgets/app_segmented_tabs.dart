import 'package:flutter/material.dart';
import 'package:bulundu/app/theme/app_shadows.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/shared/extensions/context_x.dart';

class AppSegmentedTabs extends StatelessWidget {
  const AppSegmentedTabs({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    required this.labels,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    final brightness = Theme.of(context).brightness;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        children: [
          for (int i = 0; i < labels.length; i++)
            Expanded(
              child: Semantics(
                selected: selectedIndex == i,
                button: true,
                child: InkWell(
                  onTap: () => onChanged(i),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selectedIndex == i
                          ? colors.surfaceContainerLowest
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      boxShadow: selectedIndex == i
                          ? AppShadows.soft(brightness)
                          : null,
                    ),
                    child: Text(
                      labels[i],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          (textStyles.labelLarge ??
                                  const TextStyle(fontSize: 14))
                              .copyWith(
                                color: selectedIndex == i
                                    ? colors.primary
                                    : colors.onSurfaceVariant,
                                fontWeight: selectedIndex == i
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                              ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
