# PROJECT.md — Bulundu (Kayıp Eşya Bulma ve Paylaşma)

> **Ad:** Bulundu · **Dart paketi:** `bulundu` · **Uygulama kimliği (Android/iOS/macOS):** `com.bulundu.app`
> **Hedef platformlar:** Android · iOS · macOS · Web (Chrome ve diğer modern tarayıcılar)
> **Amaç:** Flutter + Firebase öğrenmek, ama **mağazaya gönderilebilir kalitede**. Plan haftalık değildir: belgeler bir AI asistana verilip proje **hemen** kurulur (bkz. §9 Yapım sırası).

## 0. Belgeler ve öncelik sırası

| Dosya | Cevapladığı soru | Çelişki olursa |
|---|---|---|
| `PROJECT.md` (bu dosya) | Ne yapıyoruz? Platformlar, veri, rota, kapsam, mağaza hazırlığı | Kapsam, veri modeli, platform ve mağaza kuralları için bu geçerli |
| `DESIGN.md` | Nasıl görünmeli? Renk, bileşen, duyarlı düzen, erişilebilirlik | Görünüm için bu geçerli |
| `SKILL.md` | Kod nasıl yazılmalı? (AI asistan kuralları) | Kod stili için bu geçerli |

Belirsiz bir durumda tahmin etme: **kullanıcıya sor** (bkz. SKILL.md §9).

---

## 1. Karar kaydı

| Konu | Karar |
|---|---|
| Platformlar | **Android, iOS, macOS, Web** (Windows/Linux yok) |
| Uygulama kimliği | `com.bulundu.app` (Android `applicationId`, iOS ve macOS `PRODUCT_BUNDLE_IDENTIFIER`). **Firebase'e kaydetmeden önce** ayarlanır, sonradan değişmez |
| Flutter / Dart | Flutter stable **3.27+**, Dart 3.x, Material 3 |
| State yönetimi | **Riverpod** (kod üretimi yok: `Provider`, `StreamProvider`, `AsyncNotifier`) |
| Yönlendirme | `go_router` (`StatefulShellRoute`), web'de **path URL stratejisi** |
| Backend | Firebase: **Auth + Firestore + Storage** (+ Hosting, web için) |
| Giriş yöntemleri | **E-posta/şifre + Google + Apple** (App Store kuralı: Google sunuluyorsa Apple da sunulur) |
| Fotoğraf | Firebase Storage. Boyutlandırma `image_picker` parametreleriyle, yükleme **bayt (`putData`)** ile (web/macOS uyumu) |
| Harita | `flutter_map` + OpenStreetMap (anahtar yok) |
| Dil | **TR + EN** (ARB dosyaları) |
| Tema | **Açık + koyu** (kullanıcı seçer, sistem varsayılan) |
| Tasarım dili | Mavi ana renk, turuncu vurgu (bkz. DESIGN.md) |
| Yapı | **Feature-first**: `auth`, `listings`, `map`, `chat`, `moderation`, `profile`, `legal` |
| Billing | **Blaze (kullandıkça öde)** varsayılır; hemen bütçe uyarısı konur (bkz. §2) |
| iPad | Uygulama iPad'de de çalışır (duyarlı düzen); mağaza için iPad ekran görüntüsü de gerekir |

## 2. Kapsam

### Yapılacaklar
- Kayıt / giriş / çıkış: e-posta, Google, Apple
- Kayıtta ve ilk sosyal girişte **Kullanım Şartları + Gizlilik** onayı
- İlan ekleme, düzenleme, silme, "çözüldü" işaretleme (`Kayıp` ve `Buldum`)
- İlan listesi (Keşfet) + kategori / tip / mesafe filtresi
- Harita görünümü + haritadan konum seçme
- İlan detayı + "Bu benim" / "Bunu buldum" ile sohbet başlatma
- Gerçek zamanlı birebir mesajlaşma
- **Şikayet et** (ilan, kullanıcı, mesaj) ve **kullanıcıyı engelle**, engellenenler listesi
- **Hesabı sil** (uygulama içinde; kullanıcının ilanları, fotoğrafları, mesajları ve profili silinir)
- Gizlilik Politikası ve Kullanım Şartları ekranları + herkese açık web sayfaları
- Profil, "ilanlarım", dil ve tema ayarı
- Duyarlı düzen: telefon, tablet, macOS penceresi, geniş tarayıcı
- "Benzer ilanlar" (istemci tarafında, bonus)

### Yapılmayacaklar (bilinçli)
Push bildirim, Cloud Functions, ML/görsel eşleştirme, QR etiket, ödeme/ödül, yönetici paneli, Windows/Linux desteği.

### Blaze notu
Yeni Firebase projelerinde Storage için Blaze plan istenir ve mağaza sürümü için zaten gerekli kabul edilir.
**Hemen bütçe uyarısı koy (örn. 5 USD)**. Cloud Functions yine kullanılmaz.

---

## 3. Paketler

`flutter pub add` ile **güncel sürüm** eklenir; sürüm numarasını elle yazma. Platform desteğini paketin güncel belgesinden doğrula.

| Amaç | Paket |
|---|---|
| Firebase | `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage` |
| Giriş | `google_sign_in`, `sign_in_with_apple`, `crypto` (Apple nonce) |
| State | `flutter_riverpod` |
| Yönlendirme | `go_router` |
| Harita / konum | `flutter_map`, `latlong2`, `geolocator` |
| Görsel | `image_picker`, `cached_network_image` |
| Yerelleştirme | `flutter_localizations` (sdk: flutter), `intl` |
| Yerel ayar | `shared_preferences` (tema, dil) |
| Bağlantı / sürüm | `url_launcher` (yasal sayfalar, destek e-postası), `package_info_plus` |
| Mağaza varlıkları (dev) | `flutter_launcher_icons`, `flutter_native_splash` |
| Test | `flutter_test`, `mocktail`, `fake_cloud_firestore`, `firebase_auth_mocks` |

Kullanılmayanlar: `flutter_image_compress` (web/macOS uyumu için `image_picker` boyutlandırması yeterli), `google_fonts`, `dart:io` tabanlı çözümler.
Başka paket eklemeden önce kullanıcıya sor.

---

## 4. Klasör yapısı (feature-first)

```
bulundu/
├─ PROJECT.md · SKILL.md · DESIGN.md · README.md
├─ firebase.json · firestore.rules · firestore.indexes.json · storage.rules · cors.json
├─ l10n.yaml · flutter_launcher_icons.yaml
├─ assets/
│  ├─ fonts/              (Inter: Regular, Medium, SemiBold)
│  ├─ branding/           (icon_1024.png, icon_foreground.png, splash.png)
│  └─ legal/              (terms_tr.txt, terms_en.txt, privacy_tr.txt, privacy_en.txt)
├─ web/
│  ├─ index.html · manifest.json · icons/
│  └─ legal/              (privacy-tr.html, privacy-en.html, terms-*.html, delete-account.html)
├─ android/ · ios/ · macos/   (flutter create ile oluşur)
├─ test/                  (lib/ yapısını yansıtır)
└─ lib/
   ├─ main.dart           (Firebase.initializeApp, usePathUrlStrategy, ProviderScope)
   ├─ firebase_options.dart
   ├─ app/
   │  ├─ app.dart         (MaterialApp.router, tema, l10n)
   │  ├─ router/          (app_router.dart, routes.dart)
   │  ├─ shell/           (adaptive_shell.dart: alt çubuk / navigation rail)
   │  └─ theme/           (app_colors, app_typography, app_spacing, app_theme)
   ├─ l10n/               (app_tr.arb [şablon], app_en.arb, gen/)
   ├─ shared/
   │  ├─ widgets/         (app_button, app_text_field, empty_state, error_view, loading_view, max_width_body)
   │  ├─ providers/       (firebase_providers.dart)
   │  ├─ extensions/      (context_x.dart → context.l10n, context.colors, context.isWide)
   │  └─ utils/           (validators, date_format, app_exception, platform_info, breakpoints)
   └─ features/
      ├─ auth/
      │  ├─ data/         (auth_repository.dart: platform farklarını burada soyutlar)
      │  ├─ providers/    (auth_providers.dart)
      │  └─ presentation/
      │     ├─ screens/   (login_screen, register_screen, accept_terms_screen)
      │     └─ widgets/   (social_sign_in_buttons.dart, terms_checkbox.dart)
      ├─ listings/
      │  ├─ models/       (listing, listing_draft, listing_category, listing_filter, listing_matcher)
      │  ├─ data/         (listing_repository.dart, listing_image_storage.dart)
      │  ├─ providers/    (listing_providers, listing_filter_provider, listing_form_controller)
      │  └─ presentation/
      │     ├─ screens/   (explore_screen, listing_detail_screen, listing_form_screen, my_listings_screen)
      │     └─ widgets/   (listing_card, listing_type_badge, category_chip_bar, listing_filter_sheet, image_picker_field)
      ├─ map/
      │  ├─ data/         (location_service.dart)
      │  ├─ providers/    (location_providers, map_providers)
      │  └─ presentation/
      │     ├─ screens/   (map_screen, location_picker_screen)
      │     └─ widgets/   (listing_map_marker, listing_preview_sheet)
      ├─ chat/
      │  ├─ models/       (chat, message)
      │  ├─ data/         (chat_repository.dart)
      │  ├─ providers/    (chat_providers.dart)
      │  └─ presentation/
      │     ├─ screens/   (chat_list_screen, chat_screen)
      │     └─ widgets/   (chat_tile, message_bubble, message_input)
      ├─ moderation/
      │  ├─ models/       (report.dart, report_reason.dart)
      │  ├─ data/         (moderation_repository.dart)
      │  ├─ providers/    (moderation_providers.dart: blockedUidsProvider dahil)
      │  └─ presentation/
      │     ├─ screens/   (blocked_users_screen.dart)
      │     └─ widgets/   (report_sheet.dart, block_confirm_dialog.dart, report_menu_button.dart)
      ├─ legal/
      │  └─ presentation/
      │     └─ screens/   (terms_screen.dart, privacy_screen.dart)
      └─ profile/
         ├─ models/       (user_profile.dart)
         ├─ data/         (profile_repository.dart)
         ├─ providers/    (profile_providers, settings_providers, delete_account_controller)
         └─ presentation/
            ├─ screens/   (profile_screen, settings_screen, delete_account_screen)
            └─ widgets/   (profile_header.dart)
```

### Katman kuralları (her feature için)
`presentation` → `providers` → `data` → `models`. Okun tersi yönde import **yasak**.
Widget Firebase'e doğrudan dokunmaz; sadece provider izler.

### Feature'lar arası bağımlılık
- Bir feature başka feature'ın yalnızca `models/` ve `providers/` klasörüne bağımlı olabilir.
- Başka feature'ın `data/` ve `presentation/` klasörü import edilmez.
- `shared/` hiçbir feature'ı import etmez. `app/` hepsini import edebilir.
- Örnek: `profile/delete_account_controller` ilanları silmek için `listings/providers/listingRepositoryProvider`'ı kullanır; `listings/data` import etmez.
- Örnek: `listings/presentation` engellenenleri gizlemek için `moderation/providers/blockedUidsProvider`'ı izler.

---

## 5. Rotalar (go_router)

| Yol | Ekran | Not |
|---|---|---|
| `/login` | LoginScreen | Oturum yoksa her yol buraya yönlenir (hedef yol `from` ile saklanır) |
| `/register` | RegisterScreen | Şart onay kutusu zorunlu |
| `/accept-terms` | AcceptTermsScreen | Oturum var ama profil/şart onayı yoksa (ilk sosyal giriş, şart sürümü değişimi) |
| `/explore` | ExploreScreen | Sekme 1 (varsayılan) |
| `/map` | MapScreen | Sekme 2 |
| `/chats` | ChatListScreen | Sekme 3 |
| `/profile` | ProfileScreen | Sekme 4 |
| `/profile/settings` | SettingsScreen | Dil, tema, yasal bağlantılar, sürüm, çıkış |
| `/profile/my-listings` | MyListingsScreen | |
| `/profile/blocked` | BlockedUsersScreen | Engeli kaldırma |
| `/profile/delete-account` | DeleteAccountScreen | Yeniden doğrulama + onay |
| `/listings/new` | ListingFormScreen | Sekmelerin dışında |
| `/listings/:id` | ListingDetailScreen | **Web'de paylaşılabilir bağlantı** |
| `/listings/:id/edit` | ListingFormScreen | Sadece sahibi |
| `/listings/pick-location` | LocationPickerScreen | Sonucu `pop` ile döner |
| `/chats/:chatId` | ChatScreen | |
| `/legal/terms` | TermsScreen | Oturum gerekmez |
| `/legal/privacy` | PrivacyScreen | Oturum gerekmez |

- Gezinme: dar ekranda `NavigationBar` (alt), geniş ekranda `NavigationRail` (bkz. DESIGN.md §10). `StatefulShellRoute.indexedStack`.
- Keşfet ve Harita'da turuncu **"İlan ver"** `FloatingActionButton.extended`.
- Auth/şart durumu değişince `GoRouter.refreshListenable` ile yönlendirme yenilenir.
- Web'de `usePathUrlStrategy()`; Hosting `**` → `/index.html` yeniden yazması gerekir (bkz. §10).

---

## 6. Veri modeli (Firestore)

### `users/{uid}`
| Alan | Tip | Not |
|---|---|---|
| `displayName` | string | 1–40 karakter |
| `photoUrl` | string? | |
| `acceptedTermsAt` | timestamp | Şart onay zamanı |
| `termsVersion` | number | Kabul edilen şart sürümü (`AppConfig.termsVersion`) |
| `createdAt` | timestamp | `serverTimestamp` |

E-posta, telefon, konum geçmişi `users` belgesinde **tutulmaz**.

### `users/{uid}/blocks/{blockedUid}`
| Alan | Tip |
|---|---|
| `createdAt` | timestamp |

Yalnızca sahibi okur/yazar. Engellenen kişinin ilanları engelleyene gösterilmez, sohbet/mesaj gönderemez.

### `reports/{reportId}`
| Alan | Tip | Not |
|---|---|---|
| `reporterId` | string | `request.auth.uid` |
| `targetType` | string | `listing` \| `user` \| `message` |
| `targetId` | string | İlan/kullanıcı/mesaj id (mesaj için `chatId/messageId`) |
| `targetOwnerId` | string | İçeriğin sahibi |
| `reason` | string | `spam, inappropriate, scam, harassment, other` |
| `note` | string | 0–300 karakter |
| `createdAt` | timestamp | |

İstemci sadece **oluşturur**; okuma/güncelleme/silme kapalı. Şikayetler Firebase konsolundan elle incelenir (bkz. §11, 24 saat taahhüdü).

### `listings/{listingId}`
| Alan | Tip | Not |
|---|---|---|
| `type` | string | `lost` \| `found` |
| `status` | string | `open` \| `resolved` |
| `title` | string | 1–80 karakter |
| `description` | string | 0–500 karakter |
| `category` | string | `wallet, phone, keys, bag, documents, electronics, accessories, clothing, pet, other` |
| `imageUrls` | list<string> | 0–3 adet |
| `lat`, `lng` | number | |
| `locationName` | string | |
| `eventDate` | timestamp | |
| `ownerId` | string | `request.auth.uid` ile aynı |
| `ownerName` | string | Kopya alan |
| `createdAt`, `updatedAt` | timestamp | `serverTimestamp` |

**Konum gizliliği:** `found` ilanlar haritada kesin pin yerine **250 m'lik daire** olarak gösterilir. Dairenin merkezi, gerçek noktadan ilan kimliğinden türetilen **deterministik bir sapmayla (≤ 120 m)** kaydırılarak çizilir (gerçek nokta daire içinde kalır, merkezden okunamaz). Kartlardaki mesafe 0,5 km'ye yuvarlanır. Koordinat belgede kesin saklanır; bu bir demo sınırlamasıdır ve Gizlilik Politikası'nda belirtilir.

### `chats/{chatId}` — `chatId = "{listingId}_{requesterUid}"`
| Alan | Tip | Not |
|---|---|---|
| `listingId` | string | |
| `listingTitle` | string | Kopya alan |
| `participants` | list<string> | `[ownerId, requesterUid]` |
| `lastMessage` | string | |
| `updatedAt` | timestamp | |

Kişi kendi ilanına sohbet başlatamaz. Aynı ilan için ikinci sohbet açılamaz.

### `chats/{chatId}/messages/{messageId}`
| Alan | Tip | Not |
|---|---|---|
| `senderId` | string | |
| `text` | string | 1–1000 karakter |
| `createdAt` | timestamp | |

Mesaj + `chats.lastMessage/updatedAt` **tek `WriteBatch`** ile yazılır.

### Storage yolu
`listings/{uid}/{listingId}/{index}.jpg` · `image_picker(maxWidth: 1280, maxHeight: 1280, imageQuality: 80)`, hedef **< 1 MB**, `putData` + `contentType: image/jpeg`.

### Hesap silme akışı (istemci tarafı, Cloud Functions yok)
1. Yeniden doğrulama (şifre / Google / Apple)
2. Kullanıcının ilanlarının fotoğrafları (Storage) ve ilanlar silinir
3. Kullanıcının gönderdiği mesajlar silinir; sohbet belgeleri kalır (karşı tarafın geçmişi, "Silinmiş kullanıcı" etiketiyle)
4. `users/{uid}/blocks/*` ve `users/{uid}` silinir
5. En son `FirebaseAuth.currentUser.delete()` (yetki gerektiren adımlar auth varken yapılsın diye)
Gönderilmiş **şikayet kayıtları** meşru çıkar gereği saklanır; Gizlilik Politikası'nda yazılır.

### Sorgu stratejisi
- Sunucu: `status == open`, isteğe bağlı `type`, `orderBy createdAt desc`, `limit 50`.
- **İstemci:** kategori, mesafe ve **engellenen kullanıcıların gizlenmesi**.
- Bileşik indeksler §8'dedir.

---

## 7. Güvenlik kuralları

Test modu **yok**. Rules ilk gün projede olur ve her aşamada güncellenir.

### `firestore.rules`
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    function signedIn() { return request.auth != null; }
    function isUser(uid) { return signedIn() && request.auth.uid == uid; }

    function chatData(chatId) {
      return get(/databases/$(database)/documents/chats/$(chatId)).data;
    }
    function isParticipant(chatId) {
      return signedIn() && request.auth.uid in chatData(chatId).participants;
    }
    function otherUid(chatId) {
      return chatData(chatId).participants[0] == request.auth.uid
        ? chatData(chatId).participants[1]
        : chatData(chatId).participants[0];
    }
    function blockedBy(uid) {
      return exists(/databases/$(database)/documents/users/$(uid)/blocks/$(request.auth.uid));
    }

    match /users/{uid} {
      allow read: if signedIn();
      allow create, update: if isUser(uid)
        && request.resource.data.acceptedTermsAt is timestamp
        && request.resource.data.termsVersion is number;
      allow delete: if isUser(uid);

      match /blocks/{blockedUid} {
        allow read, write: if isUser(uid);
      }
    }

    match /reports/{reportId} {
      allow create: if signedIn()
        && request.resource.data.reporterId == request.auth.uid
        && request.resource.data.targetType in ['listing', 'user', 'message']
        && request.resource.data.reason in ['spam', 'inappropriate', 'scam', 'harassment', 'other']
        && request.resource.data.note.size() <= 300;
      allow read, update, delete: if false;
    }

    match /listings/{listingId} {
      allow read: if signedIn();
      allow create: if signedIn()
        && request.resource.data.ownerId == request.auth.uid
        && request.resource.data.type in ['lost', 'found']
        && request.resource.data.status == 'open'
        && request.resource.data.title is string
        && request.resource.data.title.size() > 0
        && request.resource.data.title.size() <= 80;
      allow update: if isUser(resource.data.ownerId)
        && request.resource.data.ownerId == resource.data.ownerId;
      allow delete: if isUser(resource.data.ownerId);
    }

    match /chats/{chatId} {
      // get: sohbet henüz yoksa (resource == null) "yok" cevabı dönsün diye izinli;
      // böylece istemci önce var mı diye bakıp sonra oluşturabilir.
      allow get: if signedIn()
        && (resource == null || request.auth.uid in resource.data.participants);
      allow list: if signedIn() && request.auth.uid in resource.data.participants;
      allow create: if signedIn()
        && request.resource.data.participants.size() == 2
        && request.auth.uid in request.resource.data.participants
        && chatId == request.resource.data.listingId + '_' + request.auth.uid
        && get(/databases/$(database)/documents/listings/$(request.resource.data.listingId))
             .data.ownerId == request.resource.data.participants[0]
        && !blockedBy(request.resource.data.participants[0]);
      allow update: if signedIn() && request.auth.uid in resource.data.participants;
      allow delete: if false;

      match /messages/{messageId} {
        allow read: if isParticipant(chatId);
        allow create: if isParticipant(chatId)
          && request.resource.data.senderId == request.auth.uid
          && request.resource.data.text is string
          && request.resource.data.text.size() > 0
          && request.resource.data.text.size() <= 1000
          && !blockedBy(otherUid(chatId));
        allow update: if false;
        allow delete: if signedIn() && resource.data.senderId == request.auth.uid;
      }
    }
  }
}
```

### `storage.rules`
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /listings/{uid}/{allPaths=**} {
      allow read: if request.auth != null;
      allow create, update: if request.auth != null
        && request.auth.uid == uid
        && request.resource.size < 1 * 1024 * 1024
        && request.resource.contentType.matches('image/.*');
      allow delete: if request.auth != null && request.auth.uid == uid;
    }
  }
}
```

### `cors.json` (web'de Storage görselleri için)
```json
[{ "origin": ["https://<PROJE_ID>.web.app", "https://<PROJE_ID>.firebaseapp.com", "http://localhost:*"],
   "method": ["GET"], "maxAgeSeconds": 3600 }]
```
Uygulama: `gsutil cors set cors.json gs://<BUCKET>`. Özel alan adı eklenirse origin listesine eklenir.

## 8. `firestore.indexes.json`

```json
{
  "indexes": [
    { "collectionGroup": "listings", "queryScope": "COLLECTION", "fields": [
      { "fieldPath": "status", "order": "ASCENDING" },
      { "fieldPath": "createdAt", "order": "DESCENDING" } ] },
    { "collectionGroup": "listings", "queryScope": "COLLECTION", "fields": [
      { "fieldPath": "status", "order": "ASCENDING" },
      { "fieldPath": "type", "order": "ASCENDING" },
      { "fieldPath": "createdAt", "order": "DESCENDING" } ] },
    { "collectionGroup": "listings", "queryScope": "COLLECTION", "fields": [
      { "fieldPath": "ownerId", "order": "ASCENDING" },
      { "fieldPath": "createdAt", "order": "DESCENDING" } ] },
    { "collectionGroup": "chats", "queryScope": "COLLECTION", "fields": [
      { "fieldPath": "participants", "arrayConfig": "CONTAINS" },
      { "fieldPath": "updatedAt", "order": "DESCENDING" } ] }
  ],
  "fieldOverrides": []
}
```
Not: hesap silmede kullanıcının mesajlarını bulmak için `collectionGroup('messages').where('senderId', ...)` kullanılırsa **collection group indeksi** ve rules'ta `match /{path=**}/messages/{id}` kuralı gerekir. Bunun yerine kullanıcının sohbetleri (`participants arrayContains`) gezilip her sohbette `messages.where('senderId' == uid)` sorgulanır (ek indeks gerekmez).

---

## 9. Yapım sırası (AI için; süre yok, sıra var)

Her aşama sonunda uygulama **dört platformda da** (Android, iOS veya simülatör, macOS, Chrome) açılıp aşamanın ana akışı denenir. Bir aşamanın "Bitti sayılır" maddeleri tamamlanmadan sonrakine geçilmez.

| Aşama | İş | Bitti sayılır |
|---|---|---|
| **A. İskelet** | `flutter create --platforms=android,ios,macos,web --org com.bulundu --project-name bulundu .`; kimlikleri `com.bulundu.app` yap; Firebase projesi + `flutterfire configure` (tüm platformlar, aynı kimlik); tema (DESIGN.md), l10n, router, uyarlanabilir kabuk (alt çubuk / rail), platform izinleri (§10) | Boş sekmelerle uygulama 4 platformda açılır; TR/EN ve açık/koyu geçişi çalışır |
| **B. Kimlik** | E-posta, Google, Apple girişi (`auth_repository` içinde platform farkları soyut); kayıt + şart onayı; `/accept-terms`; `users` belgesi; auth'a bağlı yönlendirme; Rules + indexes ilk sürüm deploy | 4 platformda üç yöntemle giriş/çıkış çalışır; şart onayı olmadan içeri girilmez |
| **C. İlanlar** | `Listing` modeli, repository, ilan formu (**konum seçici dahil**, fotoğrafsız), Keşfet listesi canlı, detay, düzenleme, silme, çözüldü | İlan eklenir, canlı görünür; başkasının ilanı düzenlenemez (rules testi) |
| **D. Fotoğraf** | `image_picker` (kamera yoksa gizle), boyutlandırma, `putData` yükleme, galeri, silmede fotoları temizleme, `cors.json` | Foto 4 platformda yüklenir ve **web'de de görünür** |
| **E. Harita** | Harita ekranı, mesafe filtresi, konum izni akışı (reddedilirse el ile seçim), OSM atfı (konum seçici C aşamasında yapıldı) | Pin/daireler görünür; izin reddedilince uygulama çalışır |
| **F. Sohbet** | Sohbet listesi/ekranı, gerçek zamanlı mesajlar, `WriteBatch`, kendi ilanına sohbet engeli | İki hesapla karşılıklı mesajlaşılır; başkasının sohbeti rules ile engellenir |
| **G. Güvenlik ve yasal** | Şikayet et (ilan/kullanıcı/mesaj), engelle + liste, engelleneni gizleme, hesap silme akışı, Gizlilik/Şartlar ekranları + `web/legal/*.html`, rules güncel (bkz. §7) | Her UGC ekranında şikayet/engelle var; hesap silince veriler gerçekten gider (emulator/konsolda doğrula) |
| **H. Yayına hazırlık** | Duyarlı düzen cilası, erişilebilirlik geçişi, testler, ikon/açılış ekranı, sürüm numaraları, imzalama, derlemeler, mağaza formları (§11), README | §12 "Yayın öncesi" listesi tamam |

### Bonus (aşama H'den sonra)
1. **Benzer ilanlar:** aynı kategori + zıt tip + 2 km + ±7 gün (`listing_matcher.dart`, saf Dart, birim testli)
2. Firebase Emulator Suite ile yerel geliştirme ve rules testleri
3. Firebase App Check (Play Integrity, App Attest, reCAPTCHA) — kötüye kullanımı azaltır
4. Push bildirim (bu sürüm kapsamı dışı)

---

## 10. Platform matrisi ve platforma özgü kurulum

### Özellik desteği
| Özellik | Android | iOS | macOS | Web |
|---|---|---|---|---|
| E-posta girişi | ✓ | ✓ | ✓ | ✓ |
| Google girişi | ✓ | ✓ | ✓ | ✓ (popup/yönlendirme) |
| Apple girişi | ✓ | ✓ | ✓ | ✓ |
| Konum | ✓ | ✓ | ✓ | ✓ (yalnızca HTTPS) |
| Kamera ile foto | ✓ | ✓ | ✗ (dosya seçici) | ✗ (dosya seçici) |
| Galeriden / dosyadan foto | ✓ | ✓ | ✓ | ✓ |
| Harita (OSM) | ✓ | ✓ | ✓ | ✓ |

Giriş akışları platforma göre **farklıdır** (yerel SDK, `signInWithProvider`, web popup). Bu fark yalnızca `features/auth/data/auth_repository.dart` içinde, `kIsWeb` ve `defaultTargetPlatform` ile soyutlanır. Güncel FlutterFire belgesine bak; belge ile bu tablo çelişirse **kullanıcıya sor**.
Kamera seçeneği `ImagePicker().supportsImageSource(ImageSource.camera)` ile gösterilir/gizlenir.

### Minimum sürümler
Firebase paketlerinin güncel belgesindeki en düşük sürümü kullan (Android `minSdk`, iOS ve macOS dağıtım hedefi). Uygulama bunun altını desteklemez.

### Android
- `applicationId` ve `namespace`: `com.bulundu.app`
- İzinler (`AndroidManifest.xml`): `ACCESS_COARSE_LOCATION`, `ACCESS_FINE_LOCATION` (internet izni release'te de manifestte olmalı)
- Google girişi: SHA-1 ve SHA-256 parmak izleri Firebase'e eklenir (debug **ve** release/Play imza anahtarı)
- Release imza: keystore + `key.properties` (**commit edilmez**); Play App Signing kullan

### iOS
- Bundle id `com.bulundu.app`; Xcode'da **Sign in with Apple** capability
- `Info.plist`: `NSLocationWhenInUseUsageDescription`, `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription` (TR + EN, `InfoPlist.strings` ile yerelleştirilir; metinler **neden** istendiğini söyler)
- Google girişi için `REVERSED_CLIENT_ID` URL şeması; `ITSAppUsesNonExemptEncryption = false`

### macOS
- Bundle id `com.bulundu.app`; **App Sandbox** açık
- Entitlement'lar (`DebugProfile.entitlements` ve `Release.entitlements`):
  `com.apple.security.network.client`, `com.apple.security.files.user-selected.read-only`, `com.apple.security.personal-information.location`, `keychain-access-groups` (firebase_auth için), `com.apple.developer.applesignin` (Apple girişi)
- `Info.plist`: konum kullanım açıklaması
- Pencere asgari boyutu belirlenir (örn. 480×640)

### Web
- `usePathUrlStrategy()`; `web/index.html` başlık, açıklama, tema rengi, `manifest.json` (ad, simgeler, `theme_color`)
- Firebase Auth → **Authorized domains**: Hosting alan adları + özel alan adı
- Hosting (`firebase.json`): `public: build/web`, `rewrites: ** → /index.html` (`/legal/*.html` gerçek dosya olduğu için etkilenmez); `main.dart.js` ve varlıklar için önbellek başlıkları
- Storage görselleri için `cors.json` (§7)
- Konum yalnızca HTTPS'de çalışır; izin reddi arayüzde açıkça işlenir
- Tarayıcı tabanlı kısıtlar: `dart:io` yok, dosya yolu yok (yalnız `XFile` + bayt)

### Mouse/klavye (web ve macOS)
Odak halkası görünür, Tab sırası mantıklı, Enter ile form gönderme, Esc ile sheet/dialog kapatma, hover durumları, fare tekerleği ile kaydırma, metinler seçilebilir (`SelectionArea`). Ayrıntı DESIGN.md §10.

---

## 11. Mağaza hazırlığı

### Ortak
- [ ] **Gizlilik Politikası** ve **Kullanım Şartları** (TR + EN) yazıldı; uygulamada **ve** herkese açık URL'de (`/legal/privacy-*.html`) var
- [ ] Politika şunları açıkça söyler: toplanan veriler (ad, e-posta, fotoğraf, yaklaşık/kesin konum, mesajlar), amaç, saklama, silme yolu, şikayet kayıtlarının saklanması, iletişim e-postası, KVKK haklar
- [ ] **Destek e-postası** belirlendi (belgelerde `[DESTEK_E_POSTASI]` yer tutucusu **gerçek adresle** değiştirilir)
- [ ] Şartlar: uygunsuz içerik yasak, ihlalde içerik/hesap kaldırılır
- [ ] **Hesabı uygulama içinden silme** çalışıyor (Apple ve Google zorunlu kılar) + web'de silme talebi sayfası (`web/legal/delete-account.html`; Google Play için URL)
- [ ] **Kullanıcı içeriği (UGC) güvenceleri:** şart onayı, şikayet, engelleme, şikayetleri **24 saat içinde** inceleme taahhüdü (konsoldan elle; bunu gerçekten yapabilmen gerekir)
- [ ] Demo/inceleme hesabı (Apple App Review notuna yazılır)
- [ ] Rules ve indexes **production** projesinde; test modu yok; bütçe uyarısı var
- [ ] Google Cloud'da **API anahtarı kısıtları**: web anahtarı HTTP referrer ile, Android SHA/paket ile, iOS bundle id ile
- [ ] Hata ayıklama kodu/log yok (`kDebugMode` dışında), debug banner kapalı, kodda gizli anahtar yok

### Apple (iOS + macOS)
- [ ] Apple Developer Program üyeliği; App ID `com.bulundu.app` (Sign in with Apple etkin)
- [ ] App Store Connect: ad, alt başlık, açıklama (TR + EN), anahtar kelimeler, destek URL'i, gizlilik politikası URL'i
- [ ] **App Privacy** (veri türleri: kullanıcı kimliği, e-posta, fotoğraflar, konum, kullanıcı içeriği/mesajlar)
- [ ] Yaş derecelendirmesi (UGC var → "kullanıcı tarafından üretilen içerik" soruları dürüst yanıtlanır)
- [ ] Ekran görüntüleri: iPhone (güncel zorunlu boyutlar) + iPad + macOS
- [ ] Arşiv: `flutter build ipa`, macOS için Xcode Archive; TestFlight ile test
- [ ] Guideline 4.8 (Apple girişi), 5.1.1(v) (hesap silme), 1.2 (UGC) maddeleri karşılandı

### Google Play
- [ ] Play Console hesabı; uygulama `com.bulundu.app`; **AAB** (`flutter build appbundle`), Play App Signing
- [ ] **Data safety** formu, içerik derecelendirme anketi, hedef kitle, gizlilik politikası URL'i, hesap silme URL'i
- [ ] Ekran görüntüleri (telefon; tablet önerilir), 512×512 simge, 1024×500 öne çıkan görsel
- [ ] Yeni kişisel geliştirici hesapları için **kapalı test koşulu** (test kullanıcısı sayısı ve süresi) güncel haliyle Play Console'dan kontrol edilir
- [ ] Hedef API seviyesi güncel gereksinimi karşılıyor

### Web
- [ ] `flutter build web --release` → `firebase deploy --only hosting`
- [ ] Hosting alan adında giriş (Google/Apple) çalışıyor, görseller görünüyor (CORS), `/listings/:id` doğrudan açılıyor

### Marka varlıkları
`flutter_launcher_icons` (Android adaptive + iOS + macOS + web) ve `flutter_native_splash` ile üretilir; kaynak: `assets/branding/`. Marka renkleri DESIGN.md'den.

---

## 12. Kurulum özeti ve "Yayın öncesi" listesi

### Kurulum
1. `flutter create --platforms=android,ios,macos,web --org com.bulundu --project-name bulundu .`
2. Kimlikleri `com.bulundu.app` yap (Android `build.gradle`: `applicationId`/`namespace`; Xcode: iOS ve macOS `PRODUCT_BUNDLE_IDENTIFIER`)
3. Firebase projesi aç; **Auth** (E-posta, Google, Apple), **Firestore**, **Storage**, **Hosting**; Blaze + bütçe uyarısı
4. `dart pub global activate flutterfire_cli`
   `flutterfire configure --platforms=android,ios,macos,web --android-package-name=com.bulundu.app --ios-bundle-id=com.bulundu.app --macos-bundle-id=com.bulundu.app`
5. Android SHA-1/SHA-256, Apple Services ID/anahtarı ve Google OAuth istemcilerini Firebase'e tanımla
6. `firebase deploy --only firestore:rules,firestore:indexes,storage`; `gsutil cors set cors.json gs://<BUCKET>`
7. `l10n.yaml` ekle, `flutter gen-l10n`

`l10n.yaml`:
```yaml
arb-dir: lib/l10n
template-arb-file: app_tr.arb
output-localization-file: app_localizations.dart
output-dir: lib/l10n/gen
synthetic-package: false
nullable-getter: false
```

### Yayın öncesi (hepsi işaretlenmeden gönderme)
- [ ] `flutter analyze` temiz, `dart format` uygulanmış, `flutter test` yeşil
- [ ] 4 platformda derleme: `flutter build apk`/`appbundle`, `flutter build ipa`, `flutter build macos`, `flutter build web --release`
- [ ] 4 platformda duman testi: kayıt → ilan ver (foto + konum) → ikinci hesapla mesajlaş → şikayet/engelle → hesabı sil
- [ ] Tüm metinler ARB'de (TR + EN), kodda sabit metin yok
- [ ] DESIGN.md §9 erişilebilirlik listesi ve §13 tasarım ölçütü (duyarlı düzen dahil) geçti
- [ ] §11 mağaza hazırlığı maddeleri tamam
- [ ] Rules testleri (emulator veya elle) başarılı: yabancı ilan düzenleme, yabancı sohbet okuma, engelleyene mesaj yasak
- [ ] README: kurulum, platform notları, demo sınırlamaları, sürüm/versiyon yönetimi

---

## 13. Bilinen sınırlamalar (README ve Gizlilik Politikası'na yazılır)
- Koordinatlar kesin saklanır; gizlilik yalnızca arayüzde (daire) sağlanır
- Mesafe, kategori ve engelleme filtresi istemci tarafındadır (büyük ölçek için uygun değil)
- Bildirim yok: yeni mesaj için uygulamanın açık olması gerekir
- Moderasyon elle yapılır (Firebase konsolu); otomatik içerik filtresi yoktur
- OSM karoları düşük/orta trafik içindir; yoğun kullanımda kendi karo sağlayıcın gerekir (harita üstünde "© OpenStreetMap" atfı **zorunlu**)
- Cloud Functions olmadığından hesap silme istemciden yapılır; yarıda kesilirse artık veri kalabilir (yeniden denenebilir olacak şekilde tasarlanır)
