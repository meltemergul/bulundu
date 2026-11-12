import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bulundu/app/theme/app_shadows.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/chat/models/chat.dart';
import 'package:bulundu/features/profile/providers/profile_providers.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/utils/date_format.dart';

class ChatTile extends ConsumerWidget {
  const ChatTile({
    super.key,
    required this.chat,
    required this.currentUid,
    required this.onTap,
    this.isSelected = false,
  });

  final Chat chat;
  final String currentUid;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final textStyles = context.textStyles;
    final brightness = Theme.of(context).brightness;

    final otherUid = chat.otherParticipantUid(currentUid);
    final otherProfile = ref.watch(userProfileByIdProvider(otherUid)).value;
    final otherName = otherProfile?.displayName.isNotEmpty == true
        ? otherProfile!.displayName
        : l10n.deletedUser;

    final locale = Localizations.localeOf(context).toString();
    final timeStr = AppDateFormat.formatTime(chat.updatedAt, locale);

    // Listing badge style in chat tile (Civic Beacon status pill)
    final isFound = chat.listingType == 'found';
    final badgeBg = isFound ? colors.primaryFixed : colors.secondaryFixed;
    final badgeFg = isFound ? colors.primary : colors.secondary;
    final badgeIcon = isFound ? Icons.inventory_2_outlined : Icons.crisis_alert;
    final badgePrefix = isFound ? l10n.listingTypeFound : l10n.listingTypeLost;

    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? colors.surfaceContainerLow
            : colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: AppShadows.card(brightness),
        border: isSelected ? Border.all(color: colors.primary, width: 2) : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. User Avatar (44 dp)
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primaryFixed,
                ),
                child: ClipOval(
                  child:
                      otherProfile?.photoUrl != null &&
                          otherProfile!.photoUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: otherProfile.photoUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) => Center(
                            child: Text(
                              otherName.isNotEmpty
                                  ? otherName.substring(0, 1).toUpperCase()
                                  : '?',
                              style: TextStyle(
                                color: colors.onPrimaryFixed,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            otherName.isNotEmpty
                                ? otherName.substring(0, 1).toUpperCase()
                                : '?',
                            style: TextStyle(
                              color: colors.onPrimaryFixed,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),

              // 2. Center info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and time row
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            otherName,
                            style:
                                (textStyles.titleMedium ??
                                        const TextStyle(fontSize: 16))
                                    .copyWith(
                                      color: colors.onSurface,
                                      fontWeight: FontWeight.w700,
                                    ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          timeStr,
                          style:
                              (textStyles.labelMedium ??
                                      const TextStyle(fontSize: 12))
                                  .copyWith(
                                    color: colors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),

                    // Listing pill ("Bulundu: AirPods Pro")
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusSm,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(badgeIcon, size: 12, color: badgeFg),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              '$badgePrefix: ${chat.listingTitle}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  (textStyles.labelSmall ??
                                          const TextStyle(fontSize: 11))
                                      .copyWith(
                                        color: badgeFg,
                                        fontWeight: FontWeight.w600,
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 3),

                    // Last message
                    Text(
                      chat.lastMessage.isNotEmpty ? chat.lastMessage : '...',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          (textStyles.bodyMedium ??
                                  const TextStyle(fontSize: 14))
                              .copyWith(color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),

              // 3. Right listing thumbnail (56 dp, radius 8)
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                child: Container(
                  width: 56,
                  height: 56,
                  color: colors.surfaceContainer,
                  child:
                      chat.listingImageUrl != null &&
                          chat.listingImageUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: chat.listingImageUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) => Icon(
                            Icons.inventory_2_outlined,
                            size: 24,
                            color: colors.primary,
                          ),
                        )
                      : Icon(
                          Icons.inventory_2_outlined,
                          size: 24,
                          color: colors.primary,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
