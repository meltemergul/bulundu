import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:bulundu/app/router/routes.dart';
import 'package:bulundu/app/shell/adaptive_shell.dart';
import 'package:bulundu/features/auth/presentation/screens/accept_terms_screen.dart';
import 'package:bulundu/features/auth/presentation/screens/login_screen.dart';
import 'package:bulundu/features/auth/presentation/screens/register_screen.dart';
import 'package:bulundu/features/auth/providers/auth_providers.dart';
import 'package:bulundu/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:bulundu/features/chat/presentation/screens/chat_screen.dart';
import 'package:bulundu/features/legal/presentation/screens/privacy_screen.dart';
import 'package:bulundu/features/legal/presentation/screens/terms_screen.dart';
import 'package:bulundu/features/listings/presentation/screens/explore_screen.dart';
import 'package:bulundu/features/listings/presentation/screens/listing_detail_screen.dart';
import 'package:bulundu/features/listings/presentation/screens/listing_form_screen.dart';
import 'package:bulundu/features/listings/presentation/screens/my_listings_screen.dart';
import 'package:bulundu/features/map/presentation/screens/location_picker_screen.dart';
import 'package:bulundu/features/map/presentation/screens/map_screen.dart';
import 'package:bulundu/features/moderation/presentation/screens/blocked_users_screen.dart';
import 'package:bulundu/features/profile/presentation/screens/delete_account_screen.dart';
import 'package:bulundu/features/profile/presentation/screens/profile_screen.dart';
import 'package:bulundu/features/profile/presentation/screens/settings_screen.dart';
import 'package:bulundu/features/profile/providers/profile_providers.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(authStateChangesProvider, (_, _) => notifyListeners());
    ref.listen(currentUserProfileProvider, (_, _) => notifyListeners());
    ref.listen(authControllerProvider, (_, _) => notifyListeners());
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.explore,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final path = state.matchedLocation;
      final isLegalRoute =
          path == AppRoutes.legalTerms || path == AppRoutes.legalPrivacy;
      if (isLegalRoute) return null;

      if (ref.read(authControllerProvider).isLoading) {
        return null;
      }

      final authAsync = ref.read(authStateChangesProvider);
      if (authAsync.isLoading && !authAsync.hasValue) {
        return null;
      }

      final user = authAsync.value;
      final isAuthRoute = path == AppRoutes.login || path == AppRoutes.register;
      final isAcceptTermsRoute = path == AppRoutes.acceptTerms;
      final fromParam = state.uri.queryParameters['from'];

      if (user == null) {
        if (isAuthRoute) return null;
        final targetFrom = state.uri.toString();
        if (targetFrom != AppRoutes.explore &&
            !targetFrom.startsWith(AppRoutes.login) &&
            !targetFrom.startsWith(AppRoutes.register) &&
            !targetFrom.startsWith(AppRoutes.acceptTerms)) {
          return '${AppRoutes.login}?from=${Uri.encodeComponent(targetFrom)}';
        }
        return AppRoutes.login;
      }

      final profileAsync = ref.read(currentUserProfileProvider);
      if (profileAsync.isLoading && !profileAsync.hasValue) {
        return null;
      }

      final profile = profileAsync.value;
      final hasAcceptedTerms =
          profile != null && profile.hasAcceptedCurrentTerms;

      if (!hasAcceptedTerms) {
        if (isAcceptTermsRoute) return null;
        if (fromParam != null && fromParam.isNotEmpty) {
          return '${AppRoutes.acceptTerms}?from=${Uri.encodeComponent(fromParam)}';
        }
        return AppRoutes.acceptTerms;
      }

      if (isAuthRoute || isAcceptTermsRoute) {
        if (fromParam != null &&
            fromParam.startsWith('/') &&
            !fromParam.startsWith('//')) {
          return fromParam;
        }
        return AppRoutes.explore;
      }

      return null;
    },
    routes: [
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.login,
        builder: (context, state) =>
            LoginScreen(redirectFrom: state.uri.queryParameters['from']),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.register,
        builder: (context, state) =>
            RegisterScreen(redirectFrom: state.uri.queryParameters['from']),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.acceptTerms,
        builder: (context, state) => const AcceptTermsScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AdaptiveShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.explore,
                builder: (context, state) => const ExploreScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.map,
                builder: (context, state) => const MapScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.chats,
                builder: (context, state) => const ChatListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.myListings,
        builder: (context, state) => const MyListingsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.blockedUsers,
        builder: (context, state) => const BlockedUsersScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.deleteAccount,
        builder: (context, state) => const DeleteAccountScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.listingNew,
        builder: (context, state) => const ListingFormScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.listingPickLocation,
        builder: (context, state) {
          final extra = state.extra;
          return LocationPickerScreen(
            initialPoint: extra is LatLng ? extra : null,
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/listings/:id',
        builder: (context, state) =>
            ListingDetailScreen(listingId: state.pathParameters['id']!),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/listings/:id/edit',
        builder: (context, state) =>
            ListingFormScreen(listingId: state.pathParameters['id']),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/chats/:chatId',
        builder: (context, state) =>
            ChatScreen(chatId: state.pathParameters['chatId']!),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.legalTerms,
        builder: (context, state) => const TermsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.legalPrivacy,
        builder: (context, state) => const PrivacyScreen(),
      ),
    ],
  );
});
