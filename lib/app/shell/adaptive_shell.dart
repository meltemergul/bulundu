import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bulundu/app/router/routes.dart';
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
    final isWide = context.isWide;
    final currentIndex = navigationShell.currentIndex;

    if (isWide) {
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
                    top: AppSpacing.xs,
                    bottom: AppSpacing.md,
                  ),
                  child: FloatingActionButton.extended(
                    onPressed: () => context.push(AppRoutes.listingNew),
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    icon: const Icon(Icons.add),
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

    final navBarIndex = currentIndex >= 2 ? currentIndex + 1 : currentIndex;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(top: BorderSide(color: colors.outlineVariant)),
          boxShadow: [
            BoxShadow(
              color: colors.shadow,
              blurRadius: AppSpacing.md,
              offset: const Offset(0, -AppSpacing.xs),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: navBarIndex,
          onDestinationSelected: (idx) {
            if (idx == 2) {
              context.push(AppRoutes.listingNew);
              return;
            }
            final branchIdx = idx > 2 ? idx - 1 : idx;
            _onBranchSelected(branchIdx);
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore, color: colors.primary),
              label: l10n.navExplore,
            ),
            NavigationDestination(
              icon: const Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map, color: colors.primary),
              label: l10n.navMap,
            ),
            NavigationDestination(
              icon: Container(
                width: AppSpacing.xl + AppSpacing.sm,
                height: AppSpacing.xl + AppSpacing.sm,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.35),
                      blurRadius: AppSpacing.sm,
                      offset: const Offset(0, AppSpacing.xs),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add,
                  color: colors.onPrimary,
                  size: AppSpacing.lg,
                ),
              ),
              label: l10n.fabPostListing,
            ),
            NavigationDestination(
              icon: const Icon(Icons.chat_bubble_outline),
              selectedIcon: Icon(Icons.chat_bubble, color: colors.primary),
              label: l10n.navChats,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: colors.primary),
              label: l10n.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}
