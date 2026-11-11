import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bulundu/features/auth/providers/auth_providers.dart';
import 'package:bulundu/features/moderation/data/moderation_repository.dart';
import 'package:bulundu/features/moderation/models/report.dart';
import 'package:bulundu/features/moderation/models/report_reason.dart';
import 'package:bulundu/shared/providers/firebase_providers.dart';

final moderationRepositoryProvider = Provider<ModerationRepository>(
  (ref) => ModerationRepository(ref.watch(firestoreProvider)),
);

final blockedUidsProvider = StreamProvider<Set<String>>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) {
    return Stream.value(const <String>{});
  }
  return ref.watch(moderationRepositoryProvider).watchBlockedUids(user.uid);
});

class ModerationController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> submitReport({
    required ReportTargetType targetType,
    required String targetId,
    required String targetOwnerId,
    required ReportReason reason,
    required String note,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return false;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(moderationRepositoryProvider)
          .submitReport(
            ModerationReport(
              reporterId: user.uid,
              targetType: targetType,
              targetId: targetId,
              targetOwnerId: targetOwnerId,
              reason: reason,
              note: note,
            ),
          );
    });
    return !state.hasError;
  }

  Future<bool> blockUser(String blockedUid) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return false;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(moderationRepositoryProvider)
          .blockUser(uid: user.uid, blockedUid: blockedUid);
    });
    return !state.hasError;
  }

  Future<bool> unblockUser(String blockedUid) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return false;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(moderationRepositoryProvider)
          .unblockUser(uid: user.uid, blockedUid: blockedUid);
    });
    return !state.hasError;
  }
}

final moderationControllerProvider =
    AsyncNotifierProvider<ModerationController, void>(ModerationController.new);
