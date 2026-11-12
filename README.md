# Bulundu (`com.bulundu.app`)

[![Flutter](https://img.shields.io/badge/Flutter-3.27+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore%20%7C%20Hosting-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-Proprietary-blue.svg)](#)

> *"Kayıplar bulunur, komşuluk güçlenir. Şehrindeki kayıp ve bulunan eşyaları anında keşfet."*

Bulundu, yerel toplulukların kayıp ve bulunan eşyaları güvenle paylaşmasını, harita üzerinde keşfetmesini ve eşya sahipleriyle anlık mesajlaşmasını sağlayan modern, çok platformlu bir Flutter uygulamasıdır.

Desteklenen Platformlar: **Android · iOS · macOS · Web (PWA)**

---

## 📱 Temel Özellikler

- **Modern Civic Beacon Tasarım Sistemi:** Material 3 tabanlı, yüksek kontrastlı ve erişilebilir renk paleti (`#004AC6` Primary, `#FEA619` Secondary, `#006242` Tertiary), Plus Jakarta Sans tipografisi, 48 dp dokunma hedefleri ve akıcı gölgeler.
- **Kayıp & Bulundu İlan Akışı:** Fotoğraflı ilan oluşturma, 10 farklı kategori (Cüzdan, Anahtarlık, Telefon, Çanta, Belge, vb.), metin araması, tipe göre segment geçişi (Tümü / Kayıp / Bulundu).
- **Mesafe ve Konum Filtreleme:** Kullanıcının mevcut konumuna göre gerçek zamanlı mesafe hesaplama ve yakınlığa göre sıralama (0.5 km – 50 km).
- **İnteraktif OpenStreetMap Haritası:** 
  - Kayıp ilanlar için amber daire pin (`#FEA619`).
  - Bulundu ilanlar için mavi yuvarlatılmış kare pin (`#004AC6`) ve **250 metre yarıçaplı gizlilik dairesi** (kesin konum gizlenir).
- **Gerçek Zamanlı Sohbet & Mesajlaşma:**
  - İlan detayında ve kartlarda tek tıkla mesajlaşma başlatma.
  - Hızlı mesaj öneri çipleri (*"Eşyanızı buldum!"*, *"Bu eşya bana ait!"*).
  - İlan sahibine özel bilgilendirme ve gelen mesajları görüntüleme kısayolu.
- **0 TL / Ücretsiz Firestore Base64 Fotoğraf Mimarisi:** Firebase Storage ücretli Blaze planı / depozito gerektirmeden, görselleri otomatik optimize edip (<60 KB) Firestore inline data URI (`data:image/jpeg;base64,...`) olarak saklayan %100 ücretsiz fotoğraf çözümü.
- **Kullanıcı Profili ve Ayarları:**
  - Profil fotoğrafı ekleme, kameradan/galeriden değiştirme veya kaldırma.
  - İsim/soyisim güncelleme.
  - Dinamik tema seçimi (Sistem / Açık / Koyu) ve yerelleştirme (Sistem / Türkçe / English).
- **Güvenlik, Moderasyon ve Yasal Uyum:**
  - İlan veya kullanıcı şikayet etme (Spam, Dolandırıcılık, Uygunsuz İçerik, Taciz).
  - Kullanıcı engelleme (engellenen kullanıcının ilanları ve mesajları arayüzde ve kurallarda gizlenir).
  - KVKK ve GDPR uyumlu Kullanım Şartları ve Gizlilik Politikası sayfaları.
  - Ayarlar ekranından 3 adımda güvenli hesap ve veri silme akışı.

---

## 🏗️ Mimari ve Proje Yapısı

Uygulama, **Feature-First (Özellik Tabanlı)** ve **Katmanlı Mimari** prensiplerine sıkı sıkıya bağlıdır:

```
lib/
├── app/                  # Uygulama çekirdeği: Router, Tema, Renkler
│   ├── router/           # GoRouter yapılandırması & route sabitleri
│   └── theme/            # AppColors, AppTypography, AppSpacing, AppTheme
├── features/             # Özellik modülleri
│   ├── auth/             # Kimlik doğrulama (E-posta/Şifre)
│   ├── listings/         # İlan modelleri, repository, form ve kart bileşenleri
│   ├── map/              # Harita servisi, markerlar, konum filtreleri
│   ├── chat/             # Sohbet modeli, repository, mesajlaşma ekranı
│   ├── profile/          # Profil düzenleme, kullanıcı ayarları, profil başlığı
│   ├── moderation/       # Şikayet ve engelleme sistemi
│   └── legal/            # Kullanım şartları ve gizlilik ekranları
├── l10n/                 # Çoklu dil ARB dosyaları (TR + EN) ve üretilen kodlar
└── shared/               # Paylaşılan bileşenler, yardımcı araçlar, AppImage, AppButton
```

### Teknoloji Yığını
- **State Yönetimi:** `flutter_riverpod` (kod üretimi olmadan saf `Provider`, `StreamProvider`, `Notifier`, `AsyncNotifier`).
- **Yönlendirme:** `go_router` (`StatefulShellRoute.indexedStack`, web için `usePathUrlStrategy()`).
- **Harita:** `flutter_map` + `latlong2` + `geolocator` (OpenStreetMap karoları ve atfı).
- **Veritabanı & Kimlik:** `cloud_firestore` (tip güvenli `withConverter`, `WriteBatch`), `firebase_auth`.
- **Görsel İşleme:** `image_picker` + `dart:ui` tabanlı sıkıştırma ve `AppImage` универсал görsel gösterici.

---

## 🚀 Kurulum ve Çalıştırma

### 1. Gereksinimler
- Flutter SDK (3.27 veya üzeri)
- Dart SDK (3.6 veya üzeri)
- Firebase CLI (Firestore kuralları ve hosting dağıtımı için)

### 2. Bağımlılıkları Yükleme ve Kod Üretimi
```bash
flutter pub get
flutter gen-l10n
```

### 3. Statik Analiz ve Testler
```bash
flutter analyze
flutter test
```

### 4. Platformlarda Çalıştırma
```bash
# Web (Chrome)
flutter run -d chrome

# macOS Masaüstü
flutter run -d macos

# iOS Simülatör / Cihaz
flutter run -d ios

# Android Emülatör / Cihaz
flutter run -d android
```

---

## 🧪 Test Verisi ve Demo Hesaplar

Uygulamayı sıfırdan denerken diğer kullanıcıların ilanlarını görmek ve karşılıklı mesajlaşmayı test edebilmek için veritabanına otomatik 4 adet örnek ilan yükleyen bir script mevcuttur:

```bash
dart run tool/seed_fake_data.dart
```

### Karşılıklı Mesajlaşmayı Test Etmek İçin Hazır Kullanıcılar:

| E-posta | Şifre | Sahip Olduğu İlan |
| :--- | :--- | :--- |
| `demo_ayse@bulundu.app` | `Bulundu1234!` | *Siyah Deri Cüzdan ve İstanbulkart* (Kayıp) |
| `demo_mehmet@bulundu.app` | `Bulundu1234!` | *Mavi Kordonlu Ev Anahtarlığı Bulundu* (Bulundu) |
| `demo_zeynep@bulundu.app` | `Bulundu1234!` | *Beyaz AirPods Pro 2 Şarj Kutusu* (Kayıp) |
| `demo_can@bulundu.app` | `Bulundu1234!` | *Gri Sırt Çantası* (Bulundu) |

> **İpucu:** Kendi hesabınızla giriş yapıp Ayşe Yılmaz'ın cüzdan ilanına mesaj atabilir, ardından gizli sekmede `demo_ayse@bulundu.app` ile giriş yaparak mesajı yanıtlayabilirsiniz.

---

## 🔒 Güvenlik Kuralları ve Dağıtım

Proje kökündeki `firestore.rules` ve `firestore.indexes.json` dosyaları Firebase konsoluna şu komutla dağıtılır:

```bash
# Firestore kuralları ve indeksleri dağıtma
firebase deploy --only firestore:rules,firestore:indexes

# Web sürümünü Firebase Hosting'e dağıtma
flutter build web --release
firebase deploy --only hosting
```

---

## ⚠️ Bilinen Sınırlamalar ve Mimari Notlar

1. **Yalnızca E-posta / Şifre Kimlik Doğrulaması:** Sosyal giriş (Google, Apple) kapsam dışıdır. App Store Guideline 4.8 gereğince Google Sign-In eklendiğinde Apple Sign-In de zorunlu hale geleceği için sade e-posta/şifre akışı tercih edilmiştir.
2. **Fotoğraf Depolama (0 TL Maliyet):** Firebase Storage Blaze planı depozitosuna takılmamak adına fotoğraflar Firestore belgelerine inline Base64 data URI olarak kaydedilir (< 60 KB).
3. **Konum Gizliliği:** `found` (Bulundu) ilanları haritada deterministik sapmalı (≤ 120 m) 250 m yarıçaplı daire olarak gösterilir. Koordinatlar belgede kesin olarak saklanır, gizlilik istemci görsel katmanında sağlanır.
4. **İstemci Tarafı Filtreleme:** Kategori, mesafe ve engellenen kullanıcı filtreleri Firestore sorgu limitleri (`limit(50)`) nedeniyle istemci tarafında uygulanır.
5. **Anlık Bildirimler (Push Notifications):** Push bildirim altyapısı bulunmamaktadır; yeni mesajlar uygulama açıkken gerçek zamanlı Firestore stream'i üzerinden güncellenir.
6. **Moderasyon:** Şikayet kayıtları (`reports` koleksiyonu) istemciden yalnızca oluşturulabilir; inceleme Firebase Konsolu üzerinden manuel olarak yürütülür.
7. **Hesap Silme Akışı:** Cloud Functions kullanılmadığından hesap silme adımları (ilanlar → mesajlar → blok kayıtları → profil belgesi → Firebase Auth kullanıcısı) istemci tarafından sırasıyla gerçekleştirilir.
8. **Yasal Metinler:** `assets/legal/*.txt` ve `web/legal/*.html` dosyaları içindeki `[DESTEK_E_POSTASI]` yer tutucusu resmi mağaza yayını öncesinde geçerli bir e-posta adresiyle güncellenmelidir.
