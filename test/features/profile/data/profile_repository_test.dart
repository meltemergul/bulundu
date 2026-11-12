import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bulundu/features/profile/data/profile_repository.dart';
import 'package:bulundu/features/profile/models/user_profile.dart';

void main() {
  group('ProfileRepository', () {
    late FakeFirebaseFirestore db;
    late ProfileRepository repo;

    setUp(() {
      db = FakeFirebaseFirestore();
      repo = ProfileRepository(db);
    });

    test('saveTermsAndProfile creates and updates profile document', () async {
      await repo.saveTermsAndProfile(
        uid: 'user_1',
        displayName: 'Meltem Ergül',
        photoUrl: 'data:image/png;base64,abc123',
      );

      final profile = await repo.getProfile('user_1');
      expect(profile, isNotNull);
      expect(profile!.displayName, 'Meltem Ergül');
      expect(profile.photoUrl, 'data:image/png;base64,abc123');
      expect(profile.termsVersion, UserProfile.currentTermsVersion);
    });

    test(
      'updateProfile updates name and photoUrl keeping terms data',
      () async {
        await repo.saveTermsAndProfile(uid: 'user_2', displayName: 'İlk Ad');

        await repo.updateProfile(
          uid: 'user_2',
          displayName: 'Güncel Ad',
          photoUrl: 'data:image/jpeg;base64,xyz789',
        );

        final profile = await repo.getProfile('user_2');
        expect(profile, isNotNull);
        expect(profile!.displayName, 'Güncel Ad');
        expect(profile.photoUrl, 'data:image/jpeg;base64,xyz789');
      },
    );

    test('updateProfile removes photo when removePhoto is true', () async {
      await repo.saveTermsAndProfile(
        uid: 'user_3',
        displayName: 'Kullanıcı',
        photoUrl: 'data:image/png;base64,initialPhoto',
      );

      await repo.updateProfile(uid: 'user_3', removePhoto: true);

      final profile = await repo.getProfile('user_3');
      expect(profile, isNotNull);
      expect(profile!.photoUrl, isNull);
      expect(profile.displayName, 'Kullanıcı');
    });
  });
}
