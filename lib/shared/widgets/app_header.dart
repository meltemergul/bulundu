import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bulundu/app/theme/app_shadows.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/profile/providers/profile_providers.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/widgets/app_image.dart';
import 'package:bulundu/shared/widgets/app_logo.dart';

class AppHeader extends ConsumerWidget implements PreferredSizeWidget {
  const AppHeader({super.key, this.trailing});

  final Widget? trailing;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    final brightness = Theme.of(context).brightness;
    final userAsync = ref.watch(currentUserProfileProvider);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 64 + MediaQuery.paddingOf(context).top,
          padding: EdgeInsets.only(
            top: MediaQuery.paddingOf(context).top,
            left: AppSpacing.md,
            right: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: 0.80),
            boxShadow: AppShadows.header(brightness),
          ),
          child: Row(
            children: [
              const AppLogo(size: 32),
              const SizedBox(width: AppSpacing.sm),
              Text(
                context.l10n.appName,
                style: (textStyles.titleMedium ?? const TextStyle(fontSize: 16))
                    .copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const Spacer(),
              if (trailing != null)
                trailing!
              else
                userAsync.maybeWhen(
                  data: (user) => Semantics(
                    button: true,
                    label: context.l10n.navProfile,
                    child: InkWell(
                      onTap: () => context.go('/profile'),
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusFull,
                      ),
                      child: Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colors.primary.withValues(alpha: 0.20),
                              width: 2,
                            ),
                            color: colors.primaryFixed,
                          ),
                          child: ClipOval(
                            child:
                                user?.photoUrl != null &&
                                    user!.photoUrl!.isNotEmpty
                                ? AppImage(
                                    imageUrl: user.photoUrl!,
                                    fit: BoxFit.cover,
                                    errorWidget: (_, _, _) =>
                                        _FallbackAvatar(name: user.displayName),
                                  )
                                : _FallbackAvatar(name: user?.displayName),
                          ),
                        ),
                      ),
                    ),
                  ),
                  orElse: () => const SizedBox(width: 48, height: 48),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FallbackAvatar extends StatelessWidget {
  const _FallbackAvatar({this.name});
  final String? name;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final initial = (name != null && name!.trim().isNotEmpty)
        ? name!.trim().substring(0, 1).toUpperCase()
        : '?';

    return Center(
      child: Text(
        initial,
        style: TextStyle(
          color: colors.onPrimaryFixed,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
