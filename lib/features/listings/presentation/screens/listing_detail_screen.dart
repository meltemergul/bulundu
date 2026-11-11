import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bulundu/app/router/routes.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/auth/providers/auth_providers.dart';
import 'package:bulundu/features/chat/providers/chat_providers.dart';
import 'package:bulundu/features/listings/models/listing.dart';
import 'package:bulundu/features/listings/presentation/widgets/category_chip_bar.dart';
import 'package:bulundu/features/listings/presentation/widgets/listing_card.dart';
import 'package:bulundu/features/listings/presentation/widgets/listing_type_badge.dart';
import 'package:bulundu/features/listings/providers/listing_form_controller.dart';
import 'package:bulundu/features/listings/providers/listing_providers.dart';
import 'package:bulundu/features/moderation/models/report_reason.dart';
import 'package:bulundu/features/moderation/presentation/widgets/report_menu_button.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/utils/date_format.dart';
import 'package:bulundu/shared/widgets/app_button.dart';
import 'package:bulundu/shared/widgets/app_image.dart';
import 'package:bulundu/shared/widgets/error_view.dart';
import 'package:bulundu/shared/widgets/loading_view.dart';
import 'package:bulundu/shared/widgets/max_width_body.dart';

class ListingDetailScreen extends ConsumerWidget {
  const ListingDetailScreen({super.key, required this.listingId});

  final String listingId;

  Future<void> _confirmAndDelete(
    BuildContext context,
    WidgetRef ref,
    Listing listing,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showAdaptiveDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog.adaptive(
        title: Text(l10n.deleteListingButton),
        content: Text(l10n.deleteListingConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: context.colors.error,
              foregroundColor: context.colors.onError,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.deleteListingButton),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final ok = await ref
        .read(listingFormControllerProvider.notifier)
        .deleteListing(listing.id);
    if (!context.mounted) return;
    if (ok) {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(AppRoutes.explore);
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
    }
  }

  Future<void> _startChat(
    BuildContext context,
    WidgetRef ref,
    Listing listing,
  ) async {
    final chatId = await ref
        .read(chatControllerProvider.notifier)
        .startOrOpenChat(listing);
    if (!context.mounted) return;
    if (chatId != null) {
      context.push(AppRoutes.chatDetail(chatId));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.errorGeneric)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final currentUid = ref.watch(authStateChangesProvider).value?.uid;
    final listingAsync = ref.watch(listingDetailProvider(listingId));
    final formState = ref.watch(listingFormControllerProvider);
    final chatState = ref.watch(chatControllerProvider);

    Widget buildBackButton() {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(AppRoutes.explore);
          }
        },
      );
    }

    return listingAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(
          title: Text(l10n.listingDetailTitle),
          leading: buildBackButton(),
        ),
        body: const LoadingView(),
      ),
      error: (_, _) => Scaffold(
        appBar: AppBar(
          title: Text(l10n.listingDetailTitle),
          leading: buildBackButton(),
        ),
        body: ErrorView(
          message: l10n.errorGeneric,
          onRetry: () => ref.invalidate(listingDetailProvider(listingId)),
        ),
      ),
      data: (listing) {
        if (listing == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.listingDetailTitle),
              leading: buildBackButton(),
            ),
            body: ErrorView(message: l10n.errorGeneric),
          );
        }

        final isOwner = currentUid != null && currentUid == listing.ownerId;
        final locale = Localizations.localeOf(context).toString();
        final dateStr = AppDateFormat.formatShortDate(
          listing.eventDate,
          locale,
        );
        final similar = ref.watch(similarListingsProvider(listing));

        return Title(
          title: '${listing.title} — ${l10n.appTitle}',
          color: colors.primary,
          child: Scaffold(
            appBar: AppBar(
              title: Text(l10n.listingDetailTitle),
              leading: buildBackButton(),
              actions: [
                if (!isOwner)
                  ReportMenuButton(
                    targetType: ReportTargetType.listing,
                    targetId: listing.id,
                    targetOwnerId: listing.ownerId,
                    onBlocked: () {
                      if (context.canPop()) context.pop();
                    },
                  ),
              ],
            ),
            body: SingleChildScrollView(
              child: MaxWidthBody(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (listing.imageUrls.isNotEmpty) ...[
                      SizedBox(
                        height: AppSpacing.xxl * 5,
                        child: PageView.builder(
                          itemCount: listing.imageUrls.length,
                          itemBuilder: (context, index) {
                            return Semantics(
                              label: l10n.photoSemantics(
                                listing.title,
                                index + 1,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusLg,
                                ),
                                child: AppImage(
                                  imageUrl: listing.imageUrls[index],
                                  fit: BoxFit.cover,
                                  placeholder: (context, _) => Container(
                                    color: colors.surfaceContainerLow,
                                  ),
                                  errorWidget: (context, _, _) => Container(
                                    color: colors.surfaceContainerLow,
                                    child: const Icon(
                                      Icons.broken_image_outlined,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: AppSpacing.sm,
                              runSpacing: AppSpacing.xs,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                ListingTypeBadge(
                                  type: listing.type,
                                  status: listing.status,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.sm,
                                    vertical: AppSpacing.xs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.surfaceContainerLow,
                                    borderRadius: BorderRadius.circular(
                                      AppSpacing.radiusFull,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        listing.category.icon,
                                        size: AppSpacing.md,
                                        color: colors.primary,
                                      ),
                                      const SizedBox(width: AppSpacing.xs),
                                      Text(
                                        listing.category.localizedLabel(
                                          context,
                                        ),
                                        style: context.textStyles.labelSmall
                                            ?.copyWith(color: colors.onSurface),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            SelectionArea(
                              child: Text(
                                listing.title,
                                style: context.textStyles.headlineSmall,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Row(
                              children: [
                                Icon(
                                  Icons.place_outlined,
                                  size: AppSpacing.md,
                                  color: colors.primary,
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                Expanded(
                                  child: Text(
                                    listing.locationName,
                                    style: context.textStyles.bodyMedium
                                        ?.copyWith(
                                          color: colors.onSurfaceVariant,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              '${l10n.eventDateDisplay(dateStr)} · ${l10n.postedByLabel(listing.ownerName.isNotEmpty ? listing.ownerName : l10n.deletedUser)}',
                              style: context.textStyles.bodyMedium?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                            if (listing.description.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.md),
                              const Divider(),
                              const SizedBox(height: AppSpacing.md),
                              SelectionArea(
                                child: Text(
                                  listing.description,
                                  style: context.textStyles.bodyLarge,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: colors.primaryFixed.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusXl,
                        ),
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            color: colors.onPrimaryFixed,
                            size: AppSpacing.lg,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.safetyTipBanner,
                                  style: context.textStyles.labelLarge
                                      ?.copyWith(
                                        color: colors.onPrimaryFixed,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      child: SizedBox(
                        height: AppSpacing.xxl * 4,
                        child: Stack(
                          children: [
                            FlutterMap(
                              options: MapOptions(
                                initialCenter: listing.displayPoint,
                                initialZoom: 14,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.bulundu.app',
                                ),
                                if (listing.isFound)
                                  CircleLayer(
                                    circles: [
                                      CircleMarker(
                                        point: listing.displayPoint,
                                        radius:
                                            Listing.foundPrivacyRadiusMeters,
                                        useRadiusInMeter: true,
                                        color: colors.primary.withValues(
                                          alpha: 0.15,
                                        ),
                                        borderColor: colors.primary,
                                        borderStrokeWidth: 1.5,
                                      ),
                                    ],
                                  )
                                else
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: listing.exactPoint,
                                        width: AppSpacing.minTouchTarget,
                                        height: AppSpacing.minTouchTarget,
                                        child: Icon(
                                          Icons.location_on,
                                          size: AppSpacing.xl,
                                          color: colors.secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            Positioned(
                              left: AppSpacing.xs,
                              bottom: AppSpacing.xs,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.xs,
                                  vertical: 2,
                                ),
                                color: colors.surface.withValues(alpha: 0.85),
                                child: Text(
                                  l10n.osmAttribution,
                                  style: context.textStyles.labelSmall,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (listing.isFound) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l10n.foundPrivacyNotice,
                        style: context.textStyles.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    if (isOwner) ...[
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          if (!listing.isResolved)
                            AppButton(
                              label: l10n.markResolvedButton,
                              icon: Icons.check_circle_outline,
                              isLoading: formState.isLoading,
                              onPressed: () {
                                ref
                                    .read(
                                      listingFormControllerProvider.notifier,
                                    )
                                    .markResolved(listing.id);
                              },
                            ),
                          AppButton(
                            label: l10n.editListingButton,
                            variant: AppButtonVariant.secondary,
                            icon: Icons.edit_outlined,
                            onPressed: () =>
                                context.push(AppRoutes.listingEdit(listing.id)),
                          ),
                          AppButton(
                            label: l10n.deleteListingButton,
                            variant: AppButtonVariant.danger,
                            icon: Icons.delete_outline,
                            isLoading: formState.isLoading,
                            onPressed: () =>
                                _confirmAndDelete(context, ref, listing),
                          ),
                        ],
                      ),
                    ] else if (!listing.isResolved) ...[
                      listing.isLost
                          ? FilledButton.icon(
                              style: FilledButton.styleFrom(
                                minimumSize: const Size.fromHeight(48),
                                backgroundColor: colors.primaryContainer,
                                foregroundColor: colors.onPrimary,
                              ),
                              icon: const Icon(Icons.chat_bubble_outline),
                              label: Text(l10n.foundThisButton),
                              onPressed: chatState.isLoading
                                  ? null
                                  : () => _startChat(context, ref, listing),
                            )
                          : FilledButton.icon(
                              style: FilledButton.styleFrom(
                                minimumSize: const Size.fromHeight(48),
                                backgroundColor: colors.tertiaryContainer,
                                foregroundColor: colors.onTertiary,
                              ),
                              icon: const Icon(Icons.handshake_outlined),
                              label: Text(l10n.thisIsMineButton),
                              onPressed: chatState.isLoading
                                  ? null
                                  : () => _startChat(context, ref, listing),
                            ),
                    ],
                    if (similar.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        l10n.similarListingsTitle,
                        style: context.textStyles.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ...similar.map(
                        (sim) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: ListingCard(
                            listing: sim,
                            onTap: () =>
                                context.push(AppRoutes.listingDetail(sim.id)),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
