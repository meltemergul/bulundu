# Bulundu (`com.bulundu.app`)

Kayıp eşya bulma ve paylaşma uygulaması (Flutter + Firebase).
Desteklenen platformlar: **Android · iOS · macOS · Web**.

## Mimari ve Teknoloji Yığını
- **Flutter 3.27+ / Dart 3.x / Material 3**
- **Mimari:** Feature-first (`auth`, `listings`, `map`, `chat`, `moderation`, `profile`, `legal`)
- **Katman Kuralı:** `presentation → providers → data → models`
- **State Yönetimi:** `flutter_riverpod` (kod üretimi yok: `Provider`, `StreamProvider`, `Notifier`, `AsyncNotifier`)
- **Yönlendirme:** `go_router` (`StatefulShellRoute.indexedStack`, web'de `usePathUrlStrategy()`)
- **Backend:** Firebase Auth (E-posta/Şifre, Google, Apple), Cloud Firestore, Firebase Storage, Firebase Hosting
- **Harita:** `flutter_map` + OpenStreetMap
- **Yerelleştirme & Tema:** TR + EN (`lib/l10n/app_tr.arb`, `app_en.arb`), Açık + Koyu tema

## Kurulum ve Çalıştırma
```bash
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
```

### Platformlarda Çalıştırma
- **Web (Chrome):** `flutter run -d chrome`
- **macOS:** `flutter run -d macos`
- **iOS:** `flutter run -d ios`
- **Android:** `flutter run -d android`

### Firebase Kuralları ve İndeksler
```bash
firebase deploy --only firestore:rules,firestore:indexes,storage
gsutil cors set cors.json gs://bulundu-app.firebasestorage.app
```

## Bilinen Sınırlamalar (Demo ve Mimari Notlar)
- **Konum Gizliliği:** `found` (Bulundu) ilanları haritada ilan kimliğinden türetilen deterministik sapmalı (≤ 120 m) 250 m yarıçaplı daire olarak gösterilir; ancak koordinatlar Firestore belgesinde kesin olarak saklanır.
- **İstemci Tarafı Filtreleme:** Kategori, mesafe ve engellenen kullanıcı filtreleri istemci tarafında uygulanır (`limit(50)`).
- **Bildirim:** Push bildirim yoktur; yeni mesajlar uygulama açıkken gerçek zamanlı görünür.
- **Moderasyon:** Şikayetler (`reports`) Firebase konsolundan 24 saat içinde elle incelenir.
- **Hesap Silme:** Cloud Functions kullanılmadığından hesap silme adımları (Storage fotoğrafları → ilanlar → gönderilen mesajlar → bloklar ve profil → Firebase Auth) istemci tarafından sırayla yürütülür.
- **Yasal Metin Yer Tutucusu:** `assets/legal/*.txt` ve `web/legal/*.html` içindeki `[DESTEK_E_POSTASI]` yer tutucusu mağaza yayını öncesinde gerçek destek e-posta adresiyle değiştirilmelidir.
