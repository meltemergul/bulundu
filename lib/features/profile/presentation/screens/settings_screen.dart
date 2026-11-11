import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bulundu/app/router/routes.dart';
import 'package:bulundu/app/theme/app_shadows.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/auth/providers/auth_providers.dart';
import 'package:bulundu/features/profile/providers/settings_providers.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/utils/breakpoints.dart';
import 'package:bulundu/shared/widgets/max_width_body.dart';

final appVersionProvider = FutureProvider<String>((_) async {
  try {
    final info = await PackageInfo.fromPlatform();
    return info.version.isNotEmpty ? info.version : '1.0.0';
  } catch (_) {
    return '1.0.0';
  }
});

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: const MaxWidthBody(
        maxWidth: Breakpoints.maxContent,
        child: SettingsView(),
      ),
    );
  }
}

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key, this.shrinkWrap = false, this.physics});

  final bool shrinkWrap;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final textStyles = context.textStyles;
    final brightness = Theme.of(context).brightness;
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final versionAsync = ref.watch(appVersionProvider);

    return ListView(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        // Theme selection
        Text(
          l10n.themeLabel,
          style: (textStyles.titleMedium ?? const TextStyle(fontSize: 16))
              .copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.sm),
        SegmentedButton<ThemeMode>(
          segments: [
            ButtonSegment(
              value: ThemeMode.system,
              label: Text(l10n.themeSystem),
              icon: const Icon(Icons.brightness_auto_outlined),
            ),
            ButtonSegment(
              value: ThemeMode.light,
              label: Text(l10n.themeLight),
              icon: const Icon(Icons.light_mode_outlined),
            ),
            ButtonSegment(
              value: ThemeMode.dark,
              label: Text(l10n.themeDark),
              icon: const Icon(Icons.dark_mode_outlined),
            ),
          ],
          selected: {themeMode},
          onSelectionChanged: (selection) {
            ref.read(themeModeProvider.notifier).setThemeMode(selection.first);
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        // Language selection
        Text(
          l10n.languageLabel,
          style: (textStyles.titleMedium ?? const TextStyle(fontSize: 16))
              .copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.sm),
        SegmentedButton<String>(
          segments: [
            ButtonSegment(
              value: 'system',
              label: Text(l10n.languageSystem),
              icon: const Icon(Icons.language_outlined),
            ),
            const ButtonSegment(value: 'tr', label: Text('Türkçe')),
            const ButtonSegment(value: 'en', label: Text('English')),
          ],
          selected: {locale?.languageCode ?? 'system'},
          onSelectionChanged: (selection) {
            final code = selection.first;
            ref
                .read(localeProvider.notifier)
                .setLocale(code == 'system' ? null : Locale(code));
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        // Navigation items card
        Container(
          decoration: BoxDecoration(
            color: colors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            boxShadow: AppShadows.card(brightness),
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.location_on_outlined,
                  title: l10n.locationPermissionSetting,
                  onTap: () => Geolocator.openAppSettings(),
                ),
                const Divider(height: 1),
                _SettingsTile(
                  icon: Icons.block_outlined,
                  title: l10n.blockedUsersTitle,
                  onTap: () => context.push(AppRoutes.blockedUsers),
                ),
                const Divider(height: 1),
                _SettingsTile(
                  icon: Icons.description_outlined,
                  title: l10n.termsTitle,
                  onTap: () => context.push(AppRoutes.legalTerms),
                ),
                const Divider(height: 1),
                _SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: l10n.privacyTitle,
                  onTap: () => context.push(AppRoutes.legalPrivacy),
                ),
                const Divider(height: 1),
                _SettingsTile(
                  icon: Icons.mail_outline,
                  title: l10n.supportEmail,
                  onTap: () async {
                    final uri = Uri.parse('mailto:destek@bulundu.app');
                    if (await canLaunchUrl(uri)) await launchUrl(uri);
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Auth Actions Card
        Container(
          decoration: BoxDecoration(
            color: colors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            boxShadow: AppShadows.card(brightness),
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.logout_outlined,
                  title: l10n.signOutButton,
                  onTap: () =>
                      ref.read(authControllerProvider.notifier).signOut(),
                ),
                const Divider(height: 1),
                _SettingsTile(
                  icon: Icons.delete_forever_outlined,
                  title: l10n.deleteAccountTitle,
                  iconColor: colors.error,
                  textColor: colors.error,
                  onTap: () => context.push(AppRoutes.deleteAccount),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Version text (DESIGN.md §5: "Bulundu v{sürüm}")
        Center(
          child: Text(
            versionAsync.when(
              data: (v) => '${l10n.appName} v$v',
              loading: () => '${l10n.appName} v...',
              error: (_, _) => '${l10n.appName} v1.0.0',
            ),
            style: textStyles.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ListTile(
      minLeadingWidth: 0,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 2,
      ),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 20, color: iconColor ?? colors.primary),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? colors.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}
