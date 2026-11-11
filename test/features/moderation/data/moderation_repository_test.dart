import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bulundu/features/moderation/data/moderation_repository.dart';
import 'package:bulundu/features/moderation/models/report.dart';
import 'package:bulundu/features/moderation/models/report_reason.dart';

void main() {
  group('ModerationRepository', () {
    late FakeFirebaseFirestore fakeFirestore;
    late ModerationRepository repository;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      repository = ModerationRepository(fakeFirestore);
    });

    test('submitReport writes report document to Firestore', () async {
      await repository.submitReport(
        const ModerationReport(
          reporterId: 'user_a',
          targetType: ReportTargetType.listing,
          targetId: 'listing_123',
          targetOwnerId: 'user_b',
          reason: ReportReason.spam,
          note: 'Test note',
        ),
      );

      final snapshot = await fakeFirestore.collection('reports').get();
      expect(snapshot.docs.length, 1);
      final data = snapshot.docs.first.data();
      expect(data['reporterId'], 'user_a');
      expect(data['targetType'], 'listing');
      expect(data['targetId'], 'listing_123');
      expect(data['reason'], 'spam');
      expect(data['note'], 'Test note');
    });

    test(
      'blockUser prevents self-block and manages blocks subcollection',
      () async {
        await repository.blockUser(uid: 'user_a', blockedUid: 'user_a');
        final blockedSelf = await repository.watchBlockedUids('user_a').first;
        expect(blockedSelf, isEmpty);

        await repository.blockUser(uid: 'user_a', blockedUid: 'user_b');
        final blockedAfterAdd = await repository
            .watchBlockedUids('user_a')
            .first;
        expect(blockedAfterAdd, contains('user_b'));

        await repository.unblockUser(uid: 'user_a', blockedUid: 'user_b');
        final blockedAfterRemove = await repository
            .watchBlockedUids('user_a')
            .first;
        expect(blockedAfterRemove, isNot(contains('user_b')));
      },
    );
  });
}
