import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bulundu/app/app.dart';
import 'package:bulundu/features/profile/models/user_profile.dart';
import 'package:bulundu/shared/providers/firebase_providers.dart';
import 'package:bulundu/shared/utils/validators.dart';

void main() {
  group('Aşama A & B - Auth Redirect, Terms Gate, Tabs & Settings', () {
    testWidgets('unauthenticated user is redirected to LoginScreen', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({'settings.locale': 'tr'});
      final prefs = await SharedPreferences.getInstance();
      final mockAuth = MockFirebaseAuth(signedIn: false);
      final fakeFirestore = FakeFirebaseFirestore();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            firebaseAuthProvider.overrideWithValue(mockAuth),
            firestoreProvider.overrideWithValue(fakeFirestore),
          ],
          child: const BulunduApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Giriş Yap'), findsWidgets);
      // Strictly email/password: no social login buttons (PROJECT.md §1, DESIGN.md §0.3)
      expect(find.text('Apple ile devam et'), findsNothing);
      expect(find.text('Google ile devam et'), findsNothing);
    });

    testWidgets(
      'signed-in user without terms is gated at AcceptTermsScreen until accepted',
      (tester) async {
        SharedPreferences.setMockInitialValues({'settings.locale': 'tr'});
        final prefs = await SharedPreferences.getInstance();
        final mockUser = MockUser(
          isAnonymous: false,
          uid: 'uid_1',
          email: 'ayse@example.com',
          displayName: 'Ayşe Yılmaz',
        );
        final mockAuth = MockFirebaseAuth(signedIn: true, mockUser: mockUser);
        final fakeFirestore = FakeFirebaseFirestore();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sharedPreferencesProvider.overrideWithValue(prefs),
              firebaseAuthProvider.overrideWithValue(mockAuth),
              firestoreProvider.overrideWithValue(fakeFirestore),
            ],
            child: const BulunduApp(),
          ),
        );
        await tester.pumpAndSettle();

        // Should be on AcceptTermsScreen
        expect(find.text('Şartlar ve Gizlilik'), findsOneWidget);
        expect(find.text('Devam et'), findsOneWidget);

        // Check the terms checkbox and tap Continue
        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Devam et'));
        await tester.pumpAndSettle();

        // Now redirected to ExploreScreen with 4 tabs
        expect(find.text('Keşfet'), findsWidgets);
        expect(find.text('Harita'), findsOneWidget);
        expect(find.text('Mesajlar'), findsOneWidget);
        expect(find.text('Profil'), findsOneWidget);
      },
    );

    testWidgets('renders 4 tabs and switches TR/EN and Light/Dark theme', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({'settings.locale': 'tr'});
      final prefs = await SharedPreferences.getInstance();
      final mockUser = MockUser(
        isAnonymous: false,
        uid: 'uid_2',
        email: 'ali@example.com',
        displayName: 'Ali Demir',
      );
      final mockAuth = MockFirebaseAuth(signedIn: true, mockUser: mockUser);
      final fakeFirestore = FakeFirebaseFirestore();
      await fakeFirestore.collection('users').doc('uid_2').set({
        'displayName': 'Ali Demir',
        'acceptedTermsAt': Timestamp.now(),
        'termsVersion': UserProfile.currentTermsVersion,
        'createdAt': Timestamp.now(),
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            firebaseAuthProvider.overrideWithValue(mockAuth),
            firestoreProvider.overrideWithValue(fakeFirestore),
          ],
          child: const BulunduApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to Profile tab
      await tester.tap(find.text('Profil'));
      await tester.pumpAndSettle();
      expect(find.text('Ali Demir'), findsOneWidget);

      // Open Settings screen
      await tester.tap(find.text('Ayarlar'));
      await tester.pumpAndSettle();

      // Switch theme to Dark
      await tester.tap(find.text('Koyu'));
      await tester.pumpAndSettle();
      expect(prefs.getString('settings.themeMode'), 'dark');

      // Switch language to English
      await tester.ensureVisible(find.text('English'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();
      expect(prefs.getString('settings.locale'), 'en');
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
    });

    testWidgets('uses NavigationRail on wide screens (>= 840 dp)', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final mockUser = MockUser(
        isAnonymous: false,
        uid: 'uid_3',
        email: 'can@example.com',
        displayName: 'Can',
      );
      final mockAuth = MockFirebaseAuth(signedIn: true, mockUser: mockUser);
      final fakeFirestore = FakeFirebaseFirestore();
      await fakeFirestore.collection('users').doc('uid_3').set({
        'displayName': 'Can',
        'acceptedTermsAt': Timestamp.now(),
        'termsVersion': UserProfile.currentTermsVersion,
        'createdAt': Timestamp.now(),
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            firebaseAuthProvider.overrideWithValue(mockAuth),
            firestoreProvider.overrideWithValue(fakeFirestore),
          ],
          child: const BulunduApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
    });
  });

  group('Validators', () {
    test('validates email addresses', () {
      expect(Validators.isValidEmail('user@example.com'), isTrue);
      expect(Validators.isValidEmail('invalid-email'), isFalse);
      expect(Validators.isValidEmail(''), isFalse);
    });

    test('validates password length', () {
      expect(Validators.isValidPassword('123456'), isTrue);
      expect(Validators.isValidPassword('12345'), isFalse);
    });
  });
}
