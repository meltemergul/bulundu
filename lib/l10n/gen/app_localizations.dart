import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appName.
  ///
  /// In tr, this message translates to:
  /// **'Bulundu'**
  String get appName;

  /// No description provided for @appTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bulundu'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In tr, this message translates to:
  /// **'Kayıplar bulunur, komşuluk güçlenir. Şehrindeki kayıp ve bulunan eşyaları anında keşfet.'**
  String get appTagline;

  /// No description provided for @slogan.
  ///
  /// In tr, this message translates to:
  /// **'Kayıplar bulunur, komşuluk güçlenir. Şehrindeki kayıp ve bulunan eşyaları anında keşfet.'**
  String get slogan;

  /// No description provided for @sloganShort.
  ///
  /// In tr, this message translates to:
  /// **'Kayıplar bulunur, komşuluk güçlenir.'**
  String get sloganShort;

  /// No description provided for @communitySearchBadge.
  ///
  /// In tr, this message translates to:
  /// **'✓ Topluluk destekli arama'**
  String get communitySearchBadge;

  /// No description provided for @navExplore.
  ///
  /// In tr, this message translates to:
  /// **'Keşfet'**
  String get navExplore;

  /// No description provided for @navMap.
  ///
  /// In tr, this message translates to:
  /// **'Harita'**
  String get navMap;

  /// No description provided for @navChats.
  ///
  /// In tr, this message translates to:
  /// **'Mesajlar'**
  String get navChats;

  /// No description provided for @navProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @fabPostListing.
  ///
  /// In tr, this message translates to:
  /// **'Hemen İlan Ver'**
  String get fabPostListing;

  /// No description provided for @exploreTitle.
  ///
  /// In tr, this message translates to:
  /// **'Keşfet'**
  String get exploreTitle;

  /// No description provided for @exploreEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz ilan yok'**
  String get exploreEmptyTitle;

  /// No description provided for @exploreEmptyMessage.
  ///
  /// In tr, this message translates to:
  /// **'İlk ilanı sen ver.'**
  String get exploreEmptyMessage;

  /// No description provided for @mapTitle.
  ///
  /// In tr, this message translates to:
  /// **'Harita'**
  String get mapTitle;

  /// No description provided for @chatsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Mesajlar'**
  String get chatsTitle;

  /// No description provided for @chatsEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz mesaj yok'**
  String get chatsEmptyTitle;

  /// No description provided for @chatsEmptyMessage.
  ///
  /// In tr, this message translates to:
  /// **'Bir ilanla ilgili sohbet başlattığında burada görünür.'**
  String get chatsEmptyMessage;

  /// No description provided for @profileTitle.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settingsTitle;

  /// No description provided for @myListingsTitle.
  ///
  /// In tr, this message translates to:
  /// **'İlanlarım'**
  String get myListingsTitle;

  /// No description provided for @blockedUsersTitle.
  ///
  /// In tr, this message translates to:
  /// **'Engellenenler'**
  String get blockedUsersTitle;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hesabı sil'**
  String get deleteAccountTitle;

  /// No description provided for @languageLabel.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get languageLabel;

  /// No description provided for @languageSystem.
  ///
  /// In tr, this message translates to:
  /// **'Sistem varsayılanı'**
  String get languageSystem;

  /// No description provided for @languageTurkish.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get languageTurkish;

  /// No description provided for @languageEnglish.
  ///
  /// In tr, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @themeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Tema'**
  String get themeLabel;

  /// No description provided for @themeSystem.
  ///
  /// In tr, this message translates to:
  /// **'Sistem varsayılanı'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In tr, this message translates to:
  /// **'Koyu'**
  String get themeDark;

  /// No description provided for @termsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kullanım Şartları'**
  String get termsTitle;

  /// No description provided for @privacyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik Politikası'**
  String get privacyTitle;

  /// No description provided for @versionLabel.
  ///
  /// In tr, this message translates to:
  /// **'Sürüm'**
  String get versionLabel;

  /// No description provided for @signOutButton.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış yap'**
  String get signOutButton;

  /// No description provided for @retryButton.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar dene'**
  String get retryButton;

  /// No description provided for @cancelButton.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get cancelButton;

  /// No description provided for @saveButton.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get saveButton;

  /// No description provided for @continueButton.
  ///
  /// In tr, this message translates to:
  /// **'Devam et'**
  String get continueButton;

  /// No description provided for @errorGeneric.
  ///
  /// In tr, this message translates to:
  /// **'Bir şeyler ters gitti. Tekrar dener misin?'**
  String get errorGeneric;

  /// No description provided for @loadingLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor...'**
  String get loadingLabel;

  /// No description provided for @listingLiveMessage.
  ///
  /// In tr, this message translates to:
  /// **'İlanın yayında. Eşleşme olursa mesaj alırsın.'**
  String get listingLiveMessage;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In tr, this message translates to:
  /// **'Konumunu kullanamıyoruz. Haritadan elle seçebilirsin.'**
  String get locationPermissionDenied;

  /// No description provided for @deleteListingConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Bu ilan ve fotoğrafları silinecek. Emin misin?'**
  String get deleteListingConfirm;

  /// No description provided for @reportReceivedMessage.
  ///
  /// In tr, this message translates to:
  /// **'Şikayetin alındı. İnceleyeceğiz.'**
  String get reportReceivedMessage;

  /// No description provided for @blockUserConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Bu kişiyi engellersen ilanlarını ve mesajlarını görmezsin.'**
  String get blockUserConfirm;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In tr, this message translates to:
  /// **'Hesabın, ilanların, fotoğrafların ve mesajların kalıcı olarak silinecek. Bu işlem geri alınamaz.'**
  String get deleteAccountWarning;

  /// No description provided for @acceptTermsCheckbox.
  ///
  /// In tr, this message translates to:
  /// **'Kullanım Şartları\'nı ve Gizlilik Politikası\'nı okudum, kabul ediyorum.'**
  String get acceptTermsCheckbox;

  /// No description provided for @filterAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get filterAll;

  /// No description provided for @listingTypeLost.
  ///
  /// In tr, this message translates to:
  /// **'Kayıp'**
  String get listingTypeLost;

  /// No description provided for @listingTypeFound.
  ///
  /// In tr, this message translates to:
  /// **'Bulundu'**
  String get listingTypeFound;

  /// No description provided for @listingTypeFoundVerb.
  ///
  /// In tr, this message translates to:
  /// **'Buldum'**
  String get listingTypeFoundVerb;

  /// No description provided for @listingStatusResolved.
  ///
  /// In tr, this message translates to:
  /// **'Teslim Edildi'**
  String get listingStatusResolved;

  /// No description provided for @deletedUser.
  ///
  /// In tr, this message translates to:
  /// **'Silinmiş kullanıcı'**
  String get deletedUser;

  /// No description provided for @loginTitle.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap'**
  String get loginTitle;

  /// No description provided for @registerTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt Ol'**
  String get registerTitle;

  /// No description provided for @acceptTermsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Şartlar ve Gizlilik'**
  String get acceptTermsTitle;

  /// No description provided for @acceptTermsDescription.
  ///
  /// In tr, this message translates to:
  /// **'Bulundu\'yu kullanmaya devam etmek için görünen adını kontrol et ve Kullanım Şartları ile Gizlilik Politikası\'nı onayla.'**
  String get acceptTermsDescription;

  /// No description provided for @emailLabel.
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get passwordLabel;

  /// No description provided for @passwordHelper.
  ///
  /// In tr, this message translates to:
  /// **'En az 8 karakter'**
  String get passwordHelper;

  /// No description provided for @displayNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ad Soyad'**
  String get displayNameLabel;

  /// No description provided for @displayNameHelper.
  ///
  /// In tr, this message translates to:
  /// **'İlanlarında ve mesajlarında görünecek ad (1–40 karakter).'**
  String get displayNameHelper;

  /// No description provided for @showPasswordTooltip.
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi göster'**
  String get showPasswordTooltip;

  /// No description provided for @hidePasswordTooltip.
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi gizle'**
  String get hidePasswordTooltip;

  /// No description provided for @loginButton.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap →'**
  String get loginButton;

  /// No description provided for @registerButton.
  ///
  /// In tr, this message translates to:
  /// **'Hesap Oluştur'**
  String get registerButton;

  /// No description provided for @forgotPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifremi unuttum?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In tr, this message translates to:
  /// **'Şifremi Sıfırla'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordDescription.
  ///
  /// In tr, this message translates to:
  /// **'E-posta adresini gir, şifre sıfırlama bağlantısını e-postana gönderelim.'**
  String get forgotPasswordDescription;

  /// No description provided for @sendResetLink.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantı gönder'**
  String get sendResetLink;

  /// No description provided for @passwordResetSent.
  ///
  /// In tr, this message translates to:
  /// **'Şifre sıfırlama bağlantısını e-postana gönderdik.'**
  String get passwordResetSent;

  /// No description provided for @noAccountPrompt.
  ///
  /// In tr, this message translates to:
  /// **'Henüz hesabın yok mu? Kayıt Ol'**
  String get noAccountPrompt;

  /// No description provided for @haveAccountPrompt.
  ///
  /// In tr, this message translates to:
  /// **'Zaten hesabın var mı? Giriş Yap'**
  String get haveAccountPrompt;

  /// No description provided for @termsNotice.
  ///
  /// In tr, this message translates to:
  /// **'Devam ederek Kullanım Şartları ve Gizlilik Politikası\'nı kabul etmiş olursun.'**
  String get termsNotice;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli bir e-posta adresi gir.'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordShort.
  ///
  /// In tr, this message translates to:
  /// **'Şifre en az 8 karakter olmalı.'**
  String get validationPasswordShort;

  /// No description provided for @validationDisplayNameInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Ad Soyad 1 ile 40 karakter arasında olmalı.'**
  String get validationDisplayNameInvalid;

  /// No description provided for @validationTermsRequired.
  ///
  /// In tr, this message translates to:
  /// **'Devam etmek için şartları ve gizlilik politikasını onaylamalısın.'**
  String get validationTermsRequired;

  /// No description provided for @authErrorInvalidCredentials.
  ///
  /// In tr, this message translates to:
  /// **'E-posta veya şifre hatalı.'**
  String get authErrorInvalidCredentials;

  /// No description provided for @authErrorEmailInUse.
  ///
  /// In tr, this message translates to:
  /// **'Bu e-posta ile zaten bir hesap var. Giriş yapmayı dene.'**
  String get authErrorEmailInUse;

  /// No description provided for @authErrorWeakPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifre en az 8 karakter olmalı.'**
  String get authErrorWeakPassword;

  /// No description provided for @authErrorNetwork.
  ///
  /// In tr, this message translates to:
  /// **'İnternet bağlantını kontrol edip tekrar dener misin?'**
  String get authErrorNetwork;

  /// No description provided for @authErrorCancelled.
  ///
  /// In tr, this message translates to:
  /// **'İşlem iptal edildi.'**
  String get authErrorCancelled;

  /// No description provided for @categoryWallet.
  ///
  /// In tr, this message translates to:
  /// **'Cüzdan & Kimlik'**
  String get categoryWallet;

  /// No description provided for @categoryPhone.
  ///
  /// In tr, this message translates to:
  /// **'Telefon'**
  String get categoryPhone;

  /// No description provided for @categoryKeys.
  ///
  /// In tr, this message translates to:
  /// **'Anahtarlık'**
  String get categoryKeys;

  /// No description provided for @categoryBag.
  ///
  /// In tr, this message translates to:
  /// **'Çanta'**
  String get categoryBag;

  /// No description provided for @categoryDocuments.
  ///
  /// In tr, this message translates to:
  /// **'Kimlik & Belge'**
  String get categoryDocuments;

  /// No description provided for @categoryElectronics.
  ///
  /// In tr, this message translates to:
  /// **'Elektronik'**
  String get categoryElectronics;

  /// No description provided for @categoryAccessories.
  ///
  /// In tr, this message translates to:
  /// **'Aksesuar'**
  String get categoryAccessories;

  /// No description provided for @categoryClothing.
  ///
  /// In tr, this message translates to:
  /// **'Giyim'**
  String get categoryClothing;

  /// No description provided for @categoryPet.
  ///
  /// In tr, this message translates to:
  /// **'Evcil Hayvan'**
  String get categoryPet;

  /// No description provided for @categoryOther.
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get categoryOther;

  /// No description provided for @filterTitle.
  ///
  /// In tr, this message translates to:
  /// **'Filtrele'**
  String get filterTitle;

  /// No description provided for @filterClearButton.
  ///
  /// In tr, this message translates to:
  /// **'Temizle'**
  String get filterClearButton;

  /// No description provided for @filterApplyButton.
  ///
  /// In tr, this message translates to:
  /// **'Uygula'**
  String get filterApplyButton;

  /// No description provided for @filterDistanceLabel.
  ///
  /// In tr, this message translates to:
  /// **'Maksimum mesafe'**
  String get filterDistanceLabel;

  /// No description provided for @filterDistanceAny.
  ///
  /// In tr, this message translates to:
  /// **'Mesafe sınırı yok'**
  String get filterDistanceAny;

  /// No description provided for @filterDistanceKm.
  ///
  /// In tr, this message translates to:
  /// **'{km} km içinde'**
  String filterDistanceKm(String km);

  /// No description provided for @distanceAwayKm.
  ///
  /// In tr, this message translates to:
  /// **'{km} km'**
  String distanceAwayKm(String km);

  /// No description provided for @listingFormNewTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hemen İlan Ver'**
  String get listingFormNewTitle;

  /// No description provided for @listingFormEditTitle.
  ///
  /// In tr, this message translates to:
  /// **'İlanı Düzenle'**
  String get listingFormEditTitle;

  /// No description provided for @listingTypeLabel.
  ///
  /// In tr, this message translates to:
  /// **'İlan türü'**
  String get listingTypeLabel;

  /// No description provided for @listingTitleLabel.
  ///
  /// In tr, this message translates to:
  /// **'Başlık'**
  String get listingTitleLabel;

  /// No description provided for @listingTitleHelper.
  ///
  /// In tr, this message translates to:
  /// **'Örn: Siyah deri cüzdan (1–80 karakter)'**
  String get listingTitleHelper;

  /// No description provided for @listingCategoryLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kategori'**
  String get listingCategoryLabel;

  /// No description provided for @listingDescriptionLabel.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama'**
  String get listingDescriptionLabel;

  /// No description provided for @listingDescriptionHelper.
  ///
  /// In tr, this message translates to:
  /// **'Ayırt edici özellikler veya ek bilgi (en çok 500 karakter)'**
  String get listingDescriptionHelper;

  /// No description provided for @listingPhotosLabel.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraflar (en çok 3)'**
  String get listingPhotosLabel;

  /// No description provided for @addPhotoGallery.
  ///
  /// In tr, this message translates to:
  /// **'Galeriden seç'**
  String get addPhotoGallery;

  /// No description provided for @addPhotoCamera.
  ///
  /// In tr, this message translates to:
  /// **'Kamera ile çek'**
  String get addPhotoCamera;

  /// No description provided for @removePhotoTooltip.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğrafı kaldır'**
  String get removePhotoTooltip;

  /// No description provided for @listingLocationLabel.
  ///
  /// In tr, this message translates to:
  /// **'Konum'**
  String get listingLocationLabel;

  /// No description provided for @listingLocationNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Konum açıklaması / semt'**
  String get listingLocationNameLabel;

  /// No description provided for @listingLocationNameHelper.
  ///
  /// In tr, this message translates to:
  /// **'Örn: Kadıköy Moda Parkı'**
  String get listingLocationNameHelper;

  /// No description provided for @pickLocationButton.
  ///
  /// In tr, this message translates to:
  /// **'Haritadan konum seç'**
  String get pickLocationButton;

  /// No description provided for @pickLocationTitle.
  ///
  /// In tr, this message translates to:
  /// **'Konum seç'**
  String get pickLocationTitle;

  /// No description provided for @pickLocationHint.
  ///
  /// In tr, this message translates to:
  /// **'Haritaya dokunarak konumu belirle ve onayla.'**
  String get pickLocationHint;

  /// No description provided for @confirmLocationButton.
  ///
  /// In tr, this message translates to:
  /// **'Bu konumu seç'**
  String get confirmLocationButton;

  /// No description provided for @myLocationTooltip.
  ///
  /// In tr, this message translates to:
  /// **'Konumuma git'**
  String get myLocationTooltip;

  /// No description provided for @listingEventDateLabel.
  ///
  /// In tr, this message translates to:
  /// **'Olay tarihi'**
  String get listingEventDateLabel;

  /// No description provided for @selectDateButton.
  ///
  /// In tr, this message translates to:
  /// **'Tarih seç'**
  String get selectDateButton;

  /// No description provided for @validationTitleInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Başlık 1 ile 80 karakter arasında olmalı.'**
  String get validationTitleInvalid;

  /// No description provided for @validationLocationRequired.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen haritadan bir konum seç ve konum adını gir.'**
  String get validationLocationRequired;

  /// No description provided for @listingDetailTitle.
  ///
  /// In tr, this message translates to:
  /// **'İlan detayı'**
  String get listingDetailTitle;

  /// No description provided for @foundThisButton.
  ///
  /// In tr, this message translates to:
  /// **'Bunu buldum'**
  String get foundThisButton;

  /// No description provided for @thisIsMineButton.
  ///
  /// In tr, this message translates to:
  /// **'Bu benim'**
  String get thisIsMineButton;

  /// No description provided for @editListingButton.
  ///
  /// In tr, this message translates to:
  /// **'Düzenle'**
  String get editListingButton;

  /// No description provided for @markResolvedButton.
  ///
  /// In tr, this message translates to:
  /// **'Teslim edildi olarak işaretle'**
  String get markResolvedButton;

  /// No description provided for @deleteListingButton.
  ///
  /// In tr, this message translates to:
  /// **'İlanı sil'**
  String get deleteListingButton;

  /// No description provided for @foundPrivacyNotice.
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik için bulunan eşyanın yaklaşık alanı (250 m daire) gösterilir.'**
  String get foundPrivacyNotice;

  /// No description provided for @similarListingsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Benzer ilanlar'**
  String get similarListingsTitle;

  /// No description provided for @viewDetailsButton.
  ///
  /// In tr, this message translates to:
  /// **'Detayı Gör'**
  String get viewDetailsButton;

  /// No description provided for @postedByLabel.
  ///
  /// In tr, this message translates to:
  /// **'İlan sahibi: {name}'**
  String postedByLabel(String name);

  /// No description provided for @eventDateDisplay.
  ///
  /// In tr, this message translates to:
  /// **'Tarih: {date}'**
  String eventDateDisplay(String date);

  /// No description provided for @photoSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{title} fotoğrafı {index}'**
  String photoSemantics(String title, int index);

  /// No description provided for @listingCardSemantics.
  ///
  /// In tr, this message translates to:
  /// **'{type}: {title}, {location}, {date}'**
  String listingCardSemantics(
    String type,
    String title,
    String location,
    String date,
  );

  /// No description provided for @osmAttribution.
  ///
  /// In tr, this message translates to:
  /// **'© OpenStreetMap'**
  String get osmAttribution;

  /// No description provided for @messageInputLabel.
  ///
  /// In tr, this message translates to:
  /// **'Mesajın'**
  String get messageInputLabel;

  /// No description provided for @sendMessageTooltip.
  ///
  /// In tr, this message translates to:
  /// **'Gönder'**
  String get sendMessageTooltip;

  /// No description provided for @chatOwnListingError.
  ///
  /// In tr, this message translates to:
  /// **'Kendi ilanına mesaj gönderemezsin.'**
  String get chatOwnListingError;

  /// No description provided for @moreActionsTooltip.
  ///
  /// In tr, this message translates to:
  /// **'Diğer işlemler'**
  String get moreActionsTooltip;

  /// No description provided for @reportAction.
  ///
  /// In tr, this message translates to:
  /// **'Şikayet et'**
  String get reportAction;

  /// No description provided for @blockUserAction.
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcıyı engelle'**
  String get blockUserAction;

  /// No description provided for @unblockUserButton.
  ///
  /// In tr, this message translates to:
  /// **'Engeli kaldır'**
  String get unblockUserButton;

  /// No description provided for @blockedUsersEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Engellenen kullanıcı yok'**
  String get blockedUsersEmptyTitle;

  /// No description provided for @blockedUsersEmptyMessage.
  ///
  /// In tr, this message translates to:
  /// **'Engellediğin kişiler burada listelenir.'**
  String get blockedUsersEmptyMessage;

  /// No description provided for @reportSheetTitle.
  ///
  /// In tr, this message translates to:
  /// **'Şikayet et'**
  String get reportSheetTitle;

  /// No description provided for @reportReasonSpam.
  ///
  /// In tr, this message translates to:
  /// **'Spam'**
  String get reportReasonSpam;

  /// No description provided for @reportReasonInappropriate.
  ///
  /// In tr, this message translates to:
  /// **'Uygunsuz içerik'**
  String get reportReasonInappropriate;

  /// No description provided for @reportReasonScam.
  ///
  /// In tr, this message translates to:
  /// **'Dolandırıcılık'**
  String get reportReasonScam;

  /// No description provided for @reportReasonHarassment.
  ///
  /// In tr, this message translates to:
  /// **'Taciz'**
  String get reportReasonHarassment;

  /// No description provided for @reportReasonOther.
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get reportReasonOther;

  /// No description provided for @reportNoteLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ek not (isteğe bağlı)'**
  String get reportNoteLabel;

  /// No description provided for @reportSubmitButton.
  ///
  /// In tr, this message translates to:
  /// **'Gönder'**
  String get reportSubmitButton;

  /// No description provided for @blockConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcıyı engelle'**
  String get blockConfirmTitle;

  /// No description provided for @blockConfirmButton.
  ///
  /// In tr, this message translates to:
  /// **'Engelle'**
  String get blockConfirmButton;

  /// No description provided for @deleteAccountConfirmButton.
  ///
  /// In tr, this message translates to:
  /// **'Hesabımı kalıcı olarak sil'**
  String get deleteAccountConfirmButton;

  /// No description provided for @deleteAccountReauthPasswordHelper.
  ///
  /// In tr, this message translates to:
  /// **'Güvenliğin için şifreni tekrar gir.'**
  String get deleteAccountReauthPasswordHelper;

  /// No description provided for @deleteAccountItemsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Silinecek veriler:'**
  String get deleteAccountItemsTitle;

  /// No description provided for @deleteAccountItemListings.
  ///
  /// In tr, this message translates to:
  /// **'• Yayınladığın tüm kayıp ve bulundu ilanları'**
  String get deleteAccountItemListings;

  /// No description provided for @deleteAccountItemPhotos.
  ///
  /// In tr, this message translates to:
  /// **'• Yüklediğin tüm ilan fotoğrafları'**
  String get deleteAccountItemPhotos;

  /// No description provided for @deleteAccountItemMessages.
  ///
  /// In tr, this message translates to:
  /// **'• Gönderdiğin tüm mesajlar'**
  String get deleteAccountItemMessages;

  /// No description provided for @deleteAccountItemProfile.
  ///
  /// In tr, this message translates to:
  /// **'• Profil bilgilerin ve engelleme listen'**
  String get deleteAccountItemProfile;

  /// No description provided for @deleteAccountSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Hesabın ve verilerin silindi.'**
  String get deleteAccountSuccess;

  /// No description provided for @cardActionMessage.
  ///
  /// In tr, this message translates to:
  /// **'Mesaj At'**
  String get cardActionMessage;

  /// No description provided for @cardActionMine.
  ///
  /// In tr, this message translates to:
  /// **'Bu Benim!'**
  String get cardActionMine;

  /// No description provided for @safetyTipBanner.
  ///
  /// In tr, this message translates to:
  /// **'Önemli: Eşya tesliminde kalabalık, kamusal alanları tercih edin.'**
  String get safetyTipBanner;

  /// No description provided for @chatSecurityNotice.
  ///
  /// In tr, this message translates to:
  /// **'Kişisel ve finansal bilgilerini sohbette paylaşma.'**
  String get chatSecurityNotice;

  /// No description provided for @activeListingsCount.
  ///
  /// In tr, this message translates to:
  /// **'Aktif İlan'**
  String get activeListingsCount;

  /// No description provided for @deliveredListingsCount.
  ///
  /// In tr, this message translates to:
  /// **'Teslim Edilen'**
  String get deliveredListingsCount;

  /// No description provided for @badgeResolved.
  ///
  /// In tr, this message translates to:
  /// **'✓ TESLİM EDİLDİ'**
  String get badgeResolved;

  /// No description provided for @locationPermissionSetting.
  ///
  /// In tr, this message translates to:
  /// **'Konum izni'**
  String get locationPermissionSetting;

  /// No description provided for @supportEmail.
  ///
  /// In tr, this message translates to:
  /// **'Destek'**
  String get supportEmail;

  /// No description provided for @feedTitleNearby.
  ///
  /// In tr, this message translates to:
  /// **'Yakınındaki İlanlar'**
  String get feedTitleNearby;

  /// No description provided for @feedTitleRecent.
  ///
  /// In tr, this message translates to:
  /// **'Son İlanlar'**
  String get feedTitleRecent;

  /// No description provided for @sortNewest.
  ///
  /// In tr, this message translates to:
  /// **'En Yeniler'**
  String get sortNewest;

  /// No description provided for @sortNearest.
  ///
  /// In tr, this message translates to:
  /// **'En Yakınlar'**
  String get sortNearest;

  /// No description provided for @radiusInKm.
  ///
  /// In tr, this message translates to:
  /// **'{radius} km içi'**
  String radiusInKm(String radius);

  /// No description provided for @searchHint.
  ///
  /// In tr, this message translates to:
  /// **'Eşya adı, anahtar kelime, marka ara...'**
  String get searchHint;

  /// No description provided for @searchMessagesHint.
  ///
  /// In tr, this message translates to:
  /// **'Mesajlarda ve ilanlarda ara...'**
  String get searchMessagesHint;

  /// No description provided for @filtersActiveTooltip.
  ///
  /// In tr, this message translates to:
  /// **'Filtreler etkin'**
  String get filtersActiveTooltip;

  /// No description provided for @editProfileTitle.
  ///
  /// In tr, this message translates to:
  /// **'Profili Düzenle'**
  String get editProfileTitle;

  /// No description provided for @editProfileSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'İsim ve profil fotoğrafını güncelle'**
  String get editProfileSubtitle;

  /// No description provided for @changePhoto.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğrafı Değiştir'**
  String get changePhoto;

  /// No description provided for @takePhoto.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf Çek'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In tr, this message translates to:
  /// **'Galeriden Seç'**
  String get chooseFromGallery;

  /// No description provided for @removePhoto.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğrafı Kaldır'**
  String get removePhoto;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Profilin başarıyla güncellendi.'**
  String get profileUpdatedSuccess;

  /// No description provided for @accountAndProfileSection.
  ///
  /// In tr, this message translates to:
  /// **'Hesap & Profil'**
  String get accountAndProfileSection;

  /// No description provided for @sendMessageToOwner.
  ///
  /// In tr, this message translates to:
  /// **'İlan Sahibine Mesaj Gönder'**
  String get sendMessageToOwner;

  /// No description provided for @contactSectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Mesaj & İletişim'**
  String get contactSectionTitle;

  /// No description provided for @contactSectionSubtitleLost.
  ///
  /// In tr, this message translates to:
  /// **'Bu eşyayı bulduysanız veya bilgi vermek istiyorsanız ilan sahibine mesaj atın.'**
  String get contactSectionSubtitleLost;

  /// No description provided for @contactSectionSubtitleFound.
  ///
  /// In tr, this message translates to:
  /// **'Bu eşya size aitse ilan sahibine mesaj atarak teslim alabilirsiniz.'**
  String get contactSectionSubtitleFound;

  /// No description provided for @quickMessagePlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'İlan sahibine bir mesaj yazın...'**
  String get quickMessagePlaceholder;

  /// No description provided for @sendDirectMessage.
  ///
  /// In tr, this message translates to:
  /// **'Mesajı Gönder'**
  String get sendDirectMessage;

  /// No description provided for @ownListingNotice.
  ///
  /// In tr, this message translates to:
  /// **'Bu sizin ilanınız. Kendi ilanınıza mesaj gönderemezsiniz.'**
  String get ownListingNotice;

  /// No description provided for @viewListingMessages.
  ///
  /// In tr, this message translates to:
  /// **'İlana Gelen Mesajları Gör'**
  String get viewListingMessages;

  /// No description provided for @cannotMessageOwnListing.
  ///
  /// In tr, this message translates to:
  /// **'Kendi ilanınıza mesaj gönderemezsiniz.'**
  String get cannotMessageOwnListing;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
