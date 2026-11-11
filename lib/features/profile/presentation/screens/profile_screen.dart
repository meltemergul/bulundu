import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bulundu/app/router/routes.dart';
import 'package:bulundu/app/theme/app_shadows.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/auth/providers/auth_providers.dart';
import 'package:bulundu/features/listings/models/listing.dart';
import 'package:bulundu/features/listings/providers/listing_providers.dart';
import 'package:bulundu/features/profile/presentation/screens/settings_screen.dart';
import 'package:bulundu/features/profile/presentation/widgets/profile_header.dart';
import 'package:bulundu/features/profile/providers/profile_providers.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/utils/breakpoints.dart';
import 'package:bulundu/shared/widgets/app_segmented_tabs.dart';
import 'package:bulundu/shared/widgets/max_width_body.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  int _selectedTabIndex = 0; // 0: İlanlarım, 1: Ayarlar

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final textStyles = context.textStyles;
    final brightness = Theme.of(context).brightness;

    final authUser = ref.watch(authStateChangesProvider).value;
    final profile = ref.watch(currentUserProfileProvider).value;
    final myListingsAsync = ref.watch(myListingsProvider);

    final listings = myListingsAsync.value ?? const <Listing>[];
    final activeCount = listings.where((l) => !l.isResolved).length;
    final deliveredCount = listings.where((l) => l.isResolved).length;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: MaxWidthBody(
        maxWidth: Breakpoints.maxContent,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Profile Header (96 dp avatar with gradient ring)
              ProfileHeader(profile: profile, email: authUser?.email),
              const SizedBox(height: AppSpacing.md),

              // 2. Real Counters: 2 Columns (Aktif İlan, Teslim Edilen)
              Container(
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  boxShadow: AppShadows.card(brightness),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '$activeCount',
                            style:
                                (textStyles.headlineMedium ??
                                        const TextStyle(fontSize: 22))
                                    .copyWith(
                                      color: colors.primary,
                                      fontWeight: FontWeight.w800,
                                    ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.activeListingsCount,
                            style:
                                (textStyles.labelSmall ??
                                        const TextStyle(fontSize: 12))
                                    .copyWith(color: colors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 36,
                      color: colors.outlineVariant,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '$deliveredCount',
                            style:
                                (textStyles.headlineMedium ??
                                        const TextStyle(fontSize: 22))
                                    .copyWith(
                                      color: colors.tertiary,
                                      fontWeight: FontWeight.w800,
                                    ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.deliveredListingsCount,
                            style:
                                (textStyles.labelSmall ??
                                        const TextStyle(fontSize: 12))
                                    .copyWith(color: colors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 3. Segmented Tabs: İlanlarım (n) · Ayarlar
              AppSegmentedTabs(
                selectedIndex: _selectedTabIndex,
                onChanged: (idx) => setState(() => _selectedTabIndex = idx),
                labels: [
                  '${l10n.myListingsTitle} (${listings.length})',
                  l10n.settingsTitle,
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // 4. Tab Content
              if (_selectedTabIndex == 0) ...[
                // Quick jump to My Listings Screen or inline cards
                Container(
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                    boxShadow: AppShadows.card(brightness),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Material(
                    color: Colors.transparent,
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: colors.primaryContainer,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusSm,
                          ),
                        ),
                        child: Icon(
                          Icons.list_alt_outlined,
                          color: colors.onPrimary,
                        ),
                      ),
                      title: Text(
                        l10n.myListingsTitle,
                        style:
                            (textStyles.titleMedium ??
                                    const TextStyle(fontSize: 16))
                                .copyWith(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        '${listings.length} ${l10n.exploreTitle.toLowerCase()}',
                        style: textStyles.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push(AppRoutes.myListings),
                    ),
                  ),
                ),
              ] else ...[
                // Settings embedded view (DESIGN.md §5)
                const SettingsView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
