import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bulundu/app/theme/app_spacing.dart';
import 'package:bulundu/features/moderation/providers/moderation_providers.dart';
import 'package:bulundu/features/profile/providers/profile_providers.dart';
import 'package:bulundu/shared/extensions/context_x.dart';
import 'package:bulundu/shared/widgets/empty_state.dart';
import 'package:bulundu/shared/widgets/error_view.dart';
import 'package:bulundu/shared/widgets/loading_view.dart';
import 'package:bulundu/shared/widgets/max_width_body.dart';

class BlockedUsersScreen extends ConsumerWidget {
  const BlockedUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final blockedAsync = ref.watch(blockedUidsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.blockedUsersTitle)),
      body: blockedAsync.when(
        loading: () => const LoadingView(),
        error: (_, _) => ErrorView(
          message: l10n.errorGeneric,
          onRetry: () => ref.invalidate(blockedUidsProvider),
        ),
        data: (uids) {
          final list = uids.toList();
          if (list.isEmpty) {
            return MaxWidthBody(
              child: EmptyState(
                icon: Icons.block_outlined,
                title: l10n.blockedUsersEmptyTitle,
                message: l10n.blockedUsersEmptyMessage,
              ),
            );
          }
          return MaxWidthBody(
            child: ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final blockedUid = list[index];
                final profileAsync = ref.watch(
                  userProfileByIdProvider(blockedUid),
                );
                final name = profileAsync.value?.displayName.isNotEmpty == true
                    ? profileAsync.value!.displayName
                    : l10n.deletedUser;

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.person_off_outlined),
                    title: Text(name),
                    trailing: OutlinedButton(
                      onPressed: () {
                        ref
                            .read(moderationControllerProvider.notifier)
                            .unblockUser(blockedUid);
                      },
                      child: Text(l10n.unblockUserButton),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
