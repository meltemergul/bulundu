import 'package:flutter/material.dart';
import 'package:bulundu/app/theme/app_shadows.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/profile/models/user_profile.dart';
import 'package:bulundu/shared/extensions/context_x.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.profile, this.email});

  final UserProfile? profile;
  final String? email;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final textStyles = context.textStyles;
    final brightness = Theme.of(context).brightness;

    final displayName = (profile?.displayName.isNotEmpty ?? false)
        ? profile!.displayName
        : (email ?? l10n.profileTitle);
    final initial = displayName.isNotEmpty
        ? displayName.characters.first.toUpperCase()
        : '?';

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: AppShadows.card(brightness),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        children: [
          // 96 dp Avatar with gradient ring (primary -> secondaryContainer)
          Container(
            width: 96,
            height: 96,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [colors.primary, colors.secondaryContainer],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primaryFixed,
              ),
              child: ClipOval(
                child:
                    profile?.photoUrl != null && profile!.photoUrl!.isNotEmpty
                    ? Image.network(
                        profile!.photoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Center(
                          child: Text(
                            initial,
                            style:
                                (textStyles.headlineMedium ??
                                        const TextStyle(fontSize: 24))
                                    .copyWith(
                                      color: colors.onPrimaryFixed,
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          initial,
                          style:
                              (textStyles.headlineMedium ??
                                      const TextStyle(fontSize: 24))
                                  .copyWith(
                                    color: colors.onPrimaryFixed,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Display Name
          Text(
            displayName,
            style: (textStyles.headlineSmall ?? const TextStyle(fontSize: 20))
                .copyWith(color: colors.onSurface, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),

          // Email
          if (email != null && email!.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              email!,
              style: (textStyles.bodySmall ?? const TextStyle(fontSize: 12))
                  .copyWith(color: colors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
