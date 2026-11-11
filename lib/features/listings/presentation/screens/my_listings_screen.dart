import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bulundu/app/router/routes.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/listings/presentation/widgets/listing_card.dart';
import 'package:bulundu/features/listings/providers/listing_providers.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/widgets/empty_state.dart';
import 'package:bulundu/shared/widgets/error_view.dart';
import 'package:bulundu/shared/widgets/loading_view.dart';
import 'package:bulundu/shared/widgets/max_width_body.dart';

class MyListingsScreen extends ConsumerWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final listingsAsync = ref.watch(myListingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myListingsTitle)),
      body: listingsAsync.when(
        loading: () => const LoadingView(),
        error: (_, _) => ErrorView(
          message: l10n.errorGeneric,
          onRetry: () => ref.invalidate(myListingsProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return MaxWidthBody(
              child: EmptyState(
                icon: Icons.list_alt_outlined,
                title: l10n.myListingsTitle,
                message: l10n.exploreEmptyMessage,
              ),
            );
          }
          return MaxWidthBody(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final item = items[index];
                return ListingCard(
                  listing: item,
                  onTap: () => context.push(AppRoutes.listingDetail(item.id)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
