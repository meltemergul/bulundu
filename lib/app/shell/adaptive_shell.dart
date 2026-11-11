import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bulundu/app/router/routes.dart';
import 'package:bulundu/app/theme/app_shadows.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/shared/extensions/context_x.dart';

class AdaptiveShell extends StatelessWidget {
  const AdaptiveShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onBranchSelected(int branchIndex) {
    navigationShell.goBranch(
      branchIndex,
      initialLocation: branchIndex == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final brightness = Theme.of(context).brightness;
    final currentIndex = navigationShell.currentIndex;
    final useRail = context.useRail;

    if (useRail) {
      return Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              NavigationRail(
                selectedIndex: currentIndex,
                onDestinationSelected: _onBranchSelected,
                labelType: NavigationRailLabelType.all,
                leading: Padding(
                  padding: const EdgeInsets.only(
                    top: AppSpacing.sm,
                    bottom: AppSpacing.lg,
                  ),
                  child: FloatingActionButton.extended(
                    heroTag: null,
                    onPressed: () => context.push(AppRoutes.listingNew),
                    backgroundColor: colors.primaryContainer,
                    foregroundColor: colors.onPrimary,
                    elevation: 0,
                    icon: const Icon(Icons.add_circle_outline),
                    label: Text(l10n.fabPostListing),
                  ),
                ),
                destinations: [
                  NavigationRailDestination(
                    icon: const Icon(Icons.explore_outlined),
                    selectedIcon: const Icon(Icons.explore),
                    label: Text(l10n.navExplore),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.map_outlined),
                    selectedIcon: const Icon(Icons.map),
                    label: Text(l10n.navMap),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.chat_bubble_outline),
                    selectedIcon: const Icon(Icons.chat_bubble),
                    label: Text(l10n.navChats),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.person_outline),
                    selectedIcon: const Icon(Icons.person),
                    label: Text(l10n.navProfile),
                  ),
                ],
              ),
              const VerticalDivider(width: 1, thickness: 1),
              Expanded(child: navigationShell),
            ],
          ),
        ),
      );
    }

    // Compact bottom bar with floating elevated center [+]
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Glass backdrop bar
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 64 + MediaQuery.paddingOf(context).bottom,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom,
                ),
                decoration: BoxDecoration(
                  color: colors.surface.withValues(alpha: 0.85),
                  boxShadow: AppShadows.floating(brightness),
                ),
                child: Row(
                  children: [
                    _NavItem(
                      icon: Icons.explore_outlined,
                      selectedIcon: Icons.explore,
                      label: l10n.navExplore,
                      isSelected: currentIndex == 0,
                      onTap: () => _onBranchSelected(0),
                    ),
                    _NavItem(
                      icon: Icons.map_outlined,
                      selectedIcon: Icons.map,
                      label: l10n.navMap,
                      isSelected: currentIndex == 1,
                      onTap: () => _onBranchSelected(1),
                    ),
                    // Placeholder space for center + button
                    const Expanded(child: SizedBox(height: 48)),
                    _NavItem(
                      icon: Icons.chat_bubble_outline,
                      selectedIcon: Icons.chat_bubble,
                      label: l10n.navChats,
                      isSelected: currentIndex == 2,
                      onTap: () => _onBranchSelected(2),
                    ),
                    _NavItem(
                      icon: Icons.person_outline,
                      selectedIcon: Icons.person,
                      label: l10n.navProfile,
                      isSelected: currentIndex == 3,
                      onTap: () => _onBranchSelected(3),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Center floating [+] action button
          Positioned(
            top: -20,
            child: Semantics(
              button: true,
              label: l10n.fabPostListing,
              child: Tooltip(
                message: l10n.fabPostListing,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    shape: BoxShape.circle,
                    boxShadow: AppShadows.floating(brightness),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => context.push(AppRoutes.listingNew),
                      child: Icon(Icons.add, size: 28, color: colors.onPrimary),
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

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Expanded(
      child: Semantics(
        selected: isSelected,
        button: true,
        label: label,
        child: InkResponse(
          onTap: onTap,
          radius: 28,
          child: SizedBox(
            height: 64,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSelected ? selectedIcon : icon,
                  size: 24,
                  color: isSelected ? colors.primary : colors.onSurfaceVariant,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      (textStyles.labelSmall ?? const TextStyle(fontSize: 12))
                          .copyWith(
                            color: isSelected
                                ? colors.primary
                                : colors.onSurfaceVariant,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
