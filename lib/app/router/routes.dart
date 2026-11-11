abstract final class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const acceptTerms = '/accept-terms';

  static const explore = '/explore';
  static const map = '/map';
  static const chats = '/chats';
  static const profile = '/profile';

  static const settings = '/profile/settings';
  static const myListings = '/profile/my-listings';
  static const blockedUsers = '/profile/blocked';
  static const deleteAccount = '/profile/delete-account';

  static const listingNew = '/listings/new';
  static const listingPickLocation = '/listings/pick-location';
  static String listingDetail(String id) => '/listings/$id';
  static String listingEdit(String id) => '/listings/$id/edit';

  static String chatDetail(String chatId) => '/chats/$chatId';

  static const legalTerms = '/legal/terms';
  static const legalPrivacy = '/legal/privacy';
}
