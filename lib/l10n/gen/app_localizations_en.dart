// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Bulduk';

  @override
  String get appTagline => 'Reuniting lost items through community power.';

  @override
  String get navExplore => 'Explore';

  @override
  String get navMap => 'Map';

  @override
  String get navChats => 'Messages';

  @override
  String get navProfile => 'Profile';

  @override
  String get fabPostListing => 'Post listing';

  @override
  String get exploreTitle => 'Explore';

  @override
  String get exploreEmptyTitle => 'No lost listings nearby yet';

  @override
  String get exploreEmptyMessage =>
      'Try expanding the search radius or be the first to post.';

  @override
  String get mapTitle => 'Map';

  @override
  String get chatsTitle => 'Messages';

  @override
  String get chatsEmptyTitle => 'No messages yet';

  @override
  String get chatsEmptyMessage =>
      'When you start a conversation about a listing, it will appear here.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get myListingsTitle => 'My listings';

  @override
  String get blockedUsersTitle => 'Blocked users';

  @override
  String get deleteAccountTitle => 'Delete account';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageEnglish => 'English';

  @override
  String get themeLabel => 'Theme';

  @override
  String get themeSystem => 'System default';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get termsTitle => 'Terms of Use';

  @override
  String get privacyTitle => 'Privacy Policy';

  @override
  String get versionLabel => 'Version';

  @override
  String get signOutButton => 'Sign out';

  @override
  String get retryButton => 'Try again';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get saveButton => 'Save';

  @override
  String get continueButton => 'Continue';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get loadingLabel => 'Loading...';

  @override
  String get listingLiveMessage =>
      'Your listing is live. You\'ll get a message if someone responds.';

  @override
  String get locationPermissionDenied =>
      'We can\'t use your location. You can pick a spot on the map.';

  @override
  String get deleteListingConfirm =>
      'This listing and its photos will be deleted. Are you sure?';

  @override
  String get reportReceivedMessage =>
      'Thanks, we received your report. We\'ll review it.';

  @override
  String get blockUserConfirm =>
      'If you block this person, you won\'t see their listings or messages.';

  @override
  String get deleteAccountWarning =>
      'Your account, listings, photos and messages will be permanently deleted. This can\'t be undone.';

  @override
  String get acceptTermsCheckbox =>
      'I have read and accept the Terms of Use and Privacy Policy.';

  @override
  String get filterAll => 'All';

  @override
  String get listingTypeLost => 'Lost';

  @override
  String get listingTypeFound => 'Found';

  @override
  String get listingTypeFoundVerb => 'I found';

  @override
  String get listingStatusResolved => 'Resolved';

  @override
  String get deletedUser => 'Deleted user';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get registerTitle => 'Create account';

  @override
  String get acceptTermsTitle => 'Terms & Privacy';

  @override
  String get acceptTermsDescription =>
      'Check your display name and accept the Terms of Use and Privacy Policy to continue using Bulduk.';

  @override
  String get emailLabel => 'Email address';

  @override
  String get passwordLabel => 'Password';

  @override
  String get displayNameLabel => 'Display name';

  @override
  String get displayNameHelper =>
      'Name shown on your listings and messages (1–40 characters).';

  @override
  String get showPasswordTooltip => 'Show password';

  @override
  String get hidePasswordTooltip => 'Hide password';

  @override
  String get loginButton => 'Sign in';

  @override
  String get registerButton => 'Create account';

  @override
  String get orDivider => 'or';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get noAccountPrompt => 'Don\'t have an account? Create one';

  @override
  String get haveAccountPrompt => 'Already have an account? Sign in';

  @override
  String get validationEmailInvalid => 'Please enter a valid email address.';

  @override
  String get validationPasswordShort =>
      'Password must be at least 6 characters.';

  @override
  String get validationDisplayNameInvalid =>
      'Display name must be between 1 and 40 characters.';

  @override
  String get validationTermsRequired =>
      'You must accept the terms and privacy policy to continue.';

  @override
  String get authErrorInvalidCredentials =>
      'Incorrect email or password. Please check and try again.';

  @override
  String get authErrorEmailInUse =>
      'An account already exists with this email. Try signing in.';

  @override
  String get authErrorWeakPassword =>
      'Please choose a stronger password (at least 6 characters).';

  @override
  String get authErrorNetwork =>
      'Please check your internet connection and try again.';

  @override
  String get authErrorCancelled => 'Sign-in was cancelled.';

  @override
  String get categoryWallet => 'Wallet';

  @override
  String get categoryPhone => 'Phone';

  @override
  String get categoryKeys => 'Keys';

  @override
  String get categoryBag => 'Bag';

  @override
  String get categoryDocuments => 'ID / Documents';

  @override
  String get categoryElectronics => 'Electronics';

  @override
  String get categoryAccessories => 'Accessories';

  @override
  String get categoryClothing => 'Clothing';

  @override
  String get categoryPet => 'Pet';

  @override
  String get categoryOther => 'Other';

  @override
  String get filterTitle => 'Filter';

  @override
  String get filterClearButton => 'Clear filters';

  @override
  String get filterApplyButton => 'Apply';

  @override
  String get filterDistanceLabel => 'Maximum distance';

  @override
  String get filterDistanceAny => 'Any distance';

  @override
  String filterDistanceKm(String km) {
    return 'Within $km km';
  }

  @override
  String distanceAwayKm(String km) {
    return '$km km';
  }

  @override
  String get listingFormNewTitle => 'Post listing';

  @override
  String get listingFormEditTitle => 'Edit listing';

  @override
  String get listingTypeLabel => 'Listing type';

  @override
  String get listingTitleLabel => 'Title';

  @override
  String get listingTitleHelper =>
      'e.g. Black leather wallet (1–80 characters)';

  @override
  String get listingCategoryLabel => 'Category';

  @override
  String get listingDescriptionLabel => 'Description';

  @override
  String get listingDescriptionHelper =>
      'Distinguishing details or notes (up to 500 characters)';

  @override
  String get listingPhotosLabel => 'Photos (up to 3)';

  @override
  String get addPhotoGallery => 'Choose from gallery';

  @override
  String get addPhotoCamera => 'Take photo';

  @override
  String get removePhotoTooltip => 'Remove photo';

  @override
  String get listingLocationLabel => 'Location';

  @override
  String get listingLocationNameLabel => 'Location name / area';

  @override
  String get listingLocationNameHelper => 'e.g. Kadikoy Pier';

  @override
  String get pickLocationButton => 'Pick location on map';

  @override
  String get pickLocationTitle => 'Pick location';

  @override
  String get pickLocationHint => 'Tap on the map to set the spot and confirm.';

  @override
  String get confirmLocationButton => 'Select this spot';

  @override
  String get myLocationTooltip => 'Go to my location';

  @override
  String get listingEventDateLabel => 'Event date';

  @override
  String get selectDateButton => 'Select date';

  @override
  String get validationTitleInvalid =>
      'Title must be between 1 and 80 characters.';

  @override
  String get validationLocationRequired =>
      'Please pick a spot on the map and enter a location name.';

  @override
  String get listingDetailTitle => 'Listing details';

  @override
  String get foundThisButton => 'I found this';

  @override
  String get thisIsMineButton => 'This is mine';

  @override
  String get editListingButton => 'Edit';

  @override
  String get markResolvedButton => 'Mark as resolved';

  @override
  String get deleteListingButton => 'Delete listing';

  @override
  String get foundPrivacyNotice =>
      'For safety, an approximate area (250 m circle) is shown for found items.';

  @override
  String get similarListingsTitle => 'Similar listings';

  @override
  String get viewDetailsButton => 'Details';

  @override
  String postedByLabel(String name) {
    return 'Posted by: $name';
  }

  @override
  String eventDateDisplay(String date) {
    return 'Date: $date';
  }

  @override
  String photoSemantics(String title, int index) {
    return '$title photo $index';
  }

  @override
  String listingCardSemantics(
    String type,
    String title,
    String location,
    String date,
  ) {
    return '$type: $title, $location, $date';
  }

  @override
  String get osmAttribution => '© OpenStreetMap contributors';

  @override
  String get messageInputLabel => 'Your message';

  @override
  String get sendMessageTooltip => 'Send';

  @override
  String get chatOwnListingError =>
      'You can\'t start a chat on your own listing.';

  @override
  String get moreActionsTooltip => 'More actions';

  @override
  String get reportAction => 'Report';

  @override
  String get blockUserAction => 'Block user';

  @override
  String get unblockUserButton => 'Unblock';

  @override
  String get blockedUsersEmptyTitle => 'No blocked users';

  @override
  String get blockedUsersEmptyMessage => 'People you block will appear here.';

  @override
  String get reportSheetTitle => 'Report';

  @override
  String get reportReasonSpam => 'Spam';

  @override
  String get reportReasonInappropriate => 'Inappropriate content';

  @override
  String get reportReasonScam => 'Scam';

  @override
  String get reportReasonHarassment => 'Harassment';

  @override
  String get reportReasonOther => 'Other';

  @override
  String get reportNoteLabel => 'Additional note (optional)';

  @override
  String get reportSubmitButton => 'Submit';

  @override
  String get blockConfirmTitle => 'Block user';

  @override
  String get blockConfirmButton => 'Block';

  @override
  String get deleteAccountConfirmButton => 'Permanently delete my account';

  @override
  String get deleteAccountReauthPasswordHelper =>
      'Enter your password again to confirm.';

  @override
  String get deleteAccountItemsTitle => 'Data to be deleted:';

  @override
  String get deleteAccountItemListings =>
      '• All lost and found listings you posted';

  @override
  String get deleteAccountItemPhotos => '• All listing photos you uploaded';

  @override
  String get deleteAccountItemMessages => '• All messages you sent';

  @override
  String get deleteAccountItemProfile =>
      '• Your profile and blocked users list';

  @override
  String get deleteAccountSuccess => 'Your account and data have been deleted.';

  @override
  String get locationAllAreas => 'All Areas';

  @override
  String get expandRadiusButton => 'Expand search radius';

  @override
  String get cardActionMessage => 'Message';

  @override
  String get cardActionMine => 'This is Mine!';

  @override
  String get favoriteTooltip => 'Add to favorites';

  @override
  String get verifiedBadgeLabel => 'Verified';

  @override
  String get trustScoreTitle => 'Trust & Community Profile';

  @override
  String get trustScoreBadge => '98/100 ★ Super Trust';

  @override
  String get trustScoreSubtitle => 'Verified community member · Safe handover';

  @override
  String get badgeFastHelper => 'Fast Helper';

  @override
  String get badgeItemDetective => 'Item Detective';

  @override
  String get badgeVerifiedVolunteer => 'Verified Neighborhood Volunteer';

  @override
  String get safetyBannerTitle => 'Safe Handover Reminder';

  @override
  String get safetyBannerMessage =>
      'Always meet in public places for handovers and verify distinguishing item details.';

  @override
  String get mapSearchHint => 'Search listings or area on map...';

  @override
  String get nearbyListingsTitle => 'Nearby Listings';
}
