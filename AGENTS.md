# Antigravity için 5 Prompt — Bulundu


## PROMPT 1 — İskelet + Kimlik (Aşama A ve B)

```
Önce proje kökündeki PROJECT.md, DESIGN.md ve SKILL.md dosyalarını TAMAMEN oku. Bu üç dosya projenin tek doğruluk kaynağıdır; bunlara uy. Çelişki, belirsizlik veya eksik bilgi olursa tahmin yürütme, bana tek ve net bir soru sor.

GÖREV: PROJECT.md §9'daki Aşama A (İskelet) ve Aşama B (Kimlik). Sonraki aşamalara GEÇME.

Ortak kurallar:
- Uydurma yapma: paket sürümü, API adı veya yapılandırma değeri hakkında emin değilsen güncel resmi belgeye bak veya bana sor.
- Gizli anahtar uydurma, sahte Firebase değeri yazma. Elle yapmam gereken adımda DUR ve ne yapmam gerektiğini adım adım yaz.
- Yeni paket ekleme (PROJECT.md §3 listesi dışında) ve kapsam dışı özellik yapma.
- Hiçbir şeyi doğrulamadan "çalışıyor" deme. Çalıştırdığın her komutun gerçek sonucunu raporla; çalıştıramadığın şeyi açıkça "doğrulanmadı" diye yaz.

Yapılacaklar:
1. `flutter --version` ve `flutter doctor` çalıştır; eksik varsa bana bildir.
2. PROJECT.md §12'deki kurulumu uygula: `flutter create --platforms=android,ios,macos,web --org com.bulundu --project-name bulundu .` Sonra uygulama kimliğini TÜM platformlarda `com.bulundu.app` yap (Android applicationId + namespace, iOS ve macOS PRODUCT_BUNDLE_IDENTIFIER) ve bunu dosyalardan doğrula (grep ile). Kimlik Firebase'e kaydedilmeden ÖNCE doğru olmalı.
3. Bağımlılıkları `flutter pub add` ile ekle (PROJECT.md §3'teki "Firebase", "Giriş", "State", "Yönlendirme", "Yerelleştirme", "Yerel ayar", "Bağlantı/sürüm" grupları; harita/görsel/dev araçları sonraki prompt'larda). Sürüm numarasını elle yazma.
4. Klasör yapısını PROJECT.md §4'e göre kur (feature-first; yalnızca bu aşamada gereken dosyaları doldur, diğerlerini boş bırakma ama uydurma içerik de yazma).
5. ÖNCE DESIGN.md §0'ı (mockup → uygulama eşlemesi) oku ve uygula: §0.3'teki öğeleri (ödül, favori, sahte sayaçlar, "uçtan uca şifreli" vb.) ASLA ekleme. DESIGN.md §12'deki tema dosyalarını (app_colors, app_typography, app_spacing, app_shadows, app_theme) birebir yaz. Plus Jakarta Sans yazı tipi dosyalarını (Regular, SemiBold, Bold, ExtraBold + OFL lisansı) `assets/fonts/` altına koyman gerekiyor: indiremiyorsan DUR ve benden iste (uydurma/yer tutucu font dosyası koyma); pubspec'te DESIGN.md §12'deki gibi tanımla. **Uygulama simgesini** (`assets/branding/app_icon.png`) benden iste (DESIGN.md §11; sol üstteki başlık simgesi ve mağaza simgesi aynı dosya); gelene kadar geçici simge kullan ve `// TODO(app_icon)` ile işaretle. Köşe yarıçapları, gölge seviyeleri ve kırılma noktaları (768/1024) için DESIGN.md §4 ve §10'a uy. Giriş ekranını DESIGN.md §5'teki "Giriş / Kayıt" tarifine göre yap (e-posta, şifre göster/gizle, Şifremi unuttum, segmentli geçiş, sosyal giriş düğmesi YOK); şifre sıfırlama e-postasını `sendPasswordResetEmail` ile uygula.
6. l10n kur (`l10n.yaml`, `app_tr.arb` şablon, `app_en.arb`); bu aşamadaki TÜM metinleri iki dilde yaz.
7. Router: PROJECT.md §5'teki rotaların bu aşamada gerekenleri (/login, /register, /accept-terms, /explore, /map, /chats, /profile ve /profile/settings) + auth/şart yönlendirmesi + `usePathUrlStrategy()`. Uyarlanabilir kabuk: dar ekranda NavigationBar, ≥840 dp'de NavigationRail (DESIGN.md §10). Sekme ekranları şimdilik anlamlı "boş durum" gösterir.
8. Firebase: Firebase projesini ve `flutterfire configure` adımını BEN yapacağım. Bu noktada DUR ve bana tam komutları ve konsolda açmam gerekenleri (Auth: yalnız E-posta/Parola; Firestore; Storage) yaz. Ben "tamam" deyince devam et.
9. Kimlik: YALNIZ e-posta/şifre ile kayıt ol ve giriş yap (`features/auth/data/auth_repository.dart`; SKILL.md'deki kimlik doğrulama şablonu). Google ve Apple ile giriş YAPMA: `google_sign_in`/`sign_in_with_apple`/`crypto` paketlerini ekleme, Apple capability ekleme, sosyal düğme veya "veya" ayırıcısı çizme. Kayıtta Şart onayı (`/accept-terms`, `users/{uid}` belgesi: acceptedTermsAt, termsVersion). Giriş ekranı DESIGN.md §5'e uyar (yalnız e-posta/şifre).
10. Ayarlar: tema (sistem/açık/koyu) ve dil (sistem/TR/EN) seçimi, `shared_preferences` ile kalıcı; çıkış yap.
11. PROJECT.md §7'deki `firestore.rules`, `storage.rules`, §8'deki `firestore.indexes.json` ve `firebase.json` dosyalarını yaz. Deploy komutunu bana ver, ben çalıştıracağım (veya izin verirsem sen çalıştır).

Doğrulama (hepsini yap ve sonucu raporla):
- `dart format .`, `flutter analyze` (sıfır uyarı), `flutter test` (en az: auth yönlendirme mantığı ve ayar sağlayıcıları için birkaç test).
- `flutter build web` başarılı; `flutter run -d chrome` ile giriş ekranı açılıyor.
- Android için `flutter build apk --debug` (araç zinciri varsa). iOS/macOS derlemesini yapamıyorsan bunu açıkça yaz ve bana hangi komutları çalıştırmam gerektiğini ver.
- SKILL.md §8 kontrol listesini maddeleri tek tek işaretleyerek raporla.

Bitti sayılır: PROJECT.md §9 tablosundaki A ve B satırlarının "Bitti sayılır" ölçütleri. Teslimde şunları yaz: ne yaptın, hangi komutları çalıştırıp ne gördün, neyi DOĞRULAYAMADIN, benim yapmam gereken elle işler, ve varsa sorular.
```

---

## PROMPT 2 — İlanlar + Fotoğraf (Aşama C ve D)

```
PROJECT.md, DESIGN.md ve SKILL.md'yi yeniden oku (önceki prompt'lardan hatırladığına güvenme). Belirsizlikte tahmin yürütme, tek net soru sor. Uydurma paket/API kullanma; doğrulayamadığını "doğrulanmadı" diye yaz.

GÖREV: PROJECT.md §9'daki Aşama C (İlanlar) ve Aşama D (Fotoğraf). Önceki aşamalar tamam olmalı; değilse DUR ve söyle. Harita, sohbet, şikayet/engelleme ve hesap silme bu prompt'ta YOK.

Ortak kurallar: yeni paket ekleme (yalnızca PROJECT.md §3'te listelenen `image_picker` ve `cached_network_image` bu aşamada eklenebilir); `dart:io` ve `dart:html` KULLANMA; widget içinde Firebase'e dokunma; tüm metinler ARB'de (TR+EN); renk/boşluk/yazı tipi yalnızca tema ve AppSpacing üzerinden.

Yapılacaklar:
1. `Listing`, `ListingDraft`, `ListingCategory`, `ListingFilter` modelleri (SKILL.md §10 şablonu ve PROJECT.md §6 alanları; `category` alanı ve kategoriler PROJECT.md'deki gibi). `withConverter` kullan.
2. `ListingRepository`: canlı akış (status==open, isteğe bağlı type, createdAt desc, limit 50), tekil okuma, oluşturma, güncelleme (kısmi update), silme, "çözüldü" işaretleme. Gerekli indeksler `firestore.indexes.json`'da zaten var; yeni sorgu başka indeks gerektiriyorsa dosyayı güncelle.
3. Provider'lar (Riverpod, kod üretimi YOK), `ListingFormController` (AsyncNotifier). Sürüm farkı nedeniyle sınıf adı belirsizse kurulu Riverpod sürümünün belgesine bak.
4. Ekranlar: ExploreScreen (tip segmenti Tümü/Kayıp/Bulundu, kategori chip satırı, ListingCard; geniş ekranda ızgara DESIGN.md §10), ListingDetailScreen (galeri, rozet, bilgiler; "Bunu buldum" / "Bu benim" butonları sohbet gerektirdiği için sonraki prompt'ta eklenecek; bu aşamada bu butonlar GÖRÜNMESİN), ListingFormScreen (oluştur + düzenle), MyListingsScreen. Konum seçici sonraki prompt'ta gelecek; bu aşamada formda yalnızca `locationName` metin alanı olsun, lat/lng için geçici sabit değer (İstanbul merkezi) kullan ve bunu koda `// TODO(prompt-3): konum seçici` ile işaretle.
5. Tüm AsyncValue'larda yükleniyor / hata (yeniden dene) / boş durumları (DESIGN.md §8 metinleri).
6. Fotoğraf: `image_picker` (maxWidth 1280, maxHeight 1280, imageQuality 80), en çok 3 foto, `XFile.readAsBytes()` + `putData(contentType: image/jpeg)` ile `listings/{uid}/{listingId}/{index}.jpg` yoluna yükleme (SKILL.md §10 şablonu), kamera seçeneği `supportsImageSource` ile koşullu, `cached_network_image` ile gösterim, ilan silinince Storage'daki fotoğrafları da silme, anlamlı alternatif metin.
7. Web için `cors.json` dosyasını yaz; `gsutil` komutunu bana ver (proje/bucket adını benden iste, uydurma).
8. Yerel izin açıklamaları: iOS Info.plist (kamera, foto kütüphanesi; TR+EN), macOS entitlement'ları (PROJECT.md §10), Android gerekiyorsa. Dosyaları doğrula (grep).
9. Birim/widget testleri: Listing model dönüşümü (fake_cloud_firestore), repository, ListingCard/Badge widget testi.

Doğrulama: dart format, flutter analyze (sıfır uyarı), flutter test hepsi geçsin; `flutter build web` ve (mümkünse) `flutter build apk --debug`; Chrome'da elle akış: ilan oluştur → listede canlı görün → düzenle → çözüldü → sil. Rules'ı doğrula: başka kullanıcının ilanını düzenleme/silme REDDEDİLMELİ (emulator veya yazdığın bir rules testiyle; yapamadıysan "doğrulanmadı" yaz ve bana elle test adımlarını ver). SKILL.md §8 listesini işaretleyerek raporla.

Bitti sayılır: PROJECT.md §9 C ve D satırları. Teslimde: yapılanlar, çalıştırılan komutlar ve gerçek sonuçları, DOĞRULANAMAYANLAR, benim yapacağım elle işler, sorular.
```

---

## PROMPT 3 — Harita + Sohbet (Aşama E ve F)

```
PROJECT.md, DESIGN.md ve SKILL.md'yi yeniden oku. DESIGN.md §0.3'teki kapsam dışı/yanıltıcı mockup öğelerini (ödül, favori, sahte sayaç, "uçtan uca şifreli" vb.) EKLEME; ekranları DESIGN.md §5–§6 tarifine göre yap. Belirsizlikte tek net soru sor; uydurma yapma; doğrulayamadığını açıkça yaz.

GÖREV: PROJECT.md §9'daki Aşama E (Harita) ve Aşama F (Sohbet). Önceki aşamalar tamam olmalı; değilse DUR. Şikayet/engelleme ve hesap silme bu prompt'ta YOK (sonraki prompt), ama sohbet ve harita kodunu "engellenen kullanıcıyı gizleme" eklenebilecek şekilde temiz yaz.

Ortak kurallar: `dart:io`/`dart:html` yok; platform farkı tek yerde; widget'ta Firebase yok; metinler ARB'de TR+EN; renk/boşluk yalnızca temadan. Paket ekleme: yalnızca `flutter_map`, `latlong2`, `geolocator` (PROJECT.md §3), sürümleri `flutter pub add` ile.

Yapılacaklar — Harita:
1. `LocationService` (`features/map/data`): izin kontrolü/isteği, konumu alma, reddedilme ve kapalı konum servisi durumları. Web'de yalnızca HTTPS'de çalıştığını göz önünde tut. İzin reddedilirse uygulama tamamen kullanılabilir kalır (elle seçim).
2. MapScreen: OpenStreetMap karoları, kayıp ilanlar için amber DAİRE pin (`secondaryContainer`), bulundu ilanlar için mavi YUVARLATILMIŞ KARE pin (`primaryContainer`) ve kesin konum yerine 250 m yarıçaplı yarı saydam daire (DESIGN.md §5 "Harita"; "Yol tarifi" ve "Sahibi Ara" YOK; dokunma hedefi ≥ 48 dp), "konumuma git", üstte tip/kategori filtre chip'leri, seçilen ilan için alt sheet (geniş ekranda sağ panel, DESIGN.md §10), "İlan ver" FAB, **© OpenStreetMap atfı her zaman görünür**. `flutter_map` için gerekli `userAgentPackageName` değerini `com.bulundu.app` olarak ver.
3. LocationPickerScreen (`/listings/pick-location`, sonucu `pop` ile döner) ve ListingFormScreen'e bağla: önceki prompt'taki `TODO(prompt-3)` geçici koordinatını KALDIR, gerçek seçici kullanılsın.
4. Keşfet'e mesafe filtresi (istemci tarafı; kullanıcının konumu yoksa filtre devre dışı ve bunu söyle). Mesafe hesabını saf Dart fonksiyonu olarak `listings/models` içinde yaz ve birim testle.
5. Platform izinleri: AndroidManifest (COARSE/FINE konum), iOS Info.plist konum açıklaması (TR+EN), macOS entitlement'ı + Info.plist açıklaması. grep ile doğrula.

Yapılacaklar — Sohbet:
6. Modeller `Chat`, `Message`; `ChatRepository` (PROJECT.md §6: chatId = "{listingId}_{requesterUid}", participants [ownerId, requesterUid]; kişi kendi ilanına sohbet başlatamaz; mesaj + lastMessage/updatedAt tek WriteBatch).
7. İlan detayında "Bunu buldum" (kayıp ilanda) ve "Bu benim" (bulundu ilanında) butonları sohbeti başlatır/açar; kendi ilanında "Düzenle" + "Çözüldü olarak işaretle" (DESIGN.md §6).
8. ChatListScreen, ChatScreen (gerçek zamanlı, mesaj baloncukları DESIGN.md §5, Enter gönderir, Shift+Enter yeni satır, uzun mesaj/metin seçilebilir), okunabilirlik ve ekran okuyucu etiketleri.
9. Firestore rules'ın sohbet kısmının PROJECT.md §7 ile BİREBİR aynı olduğunu doğrula.

Testler: mesafe hesabı, Chat/Message dönüşümü, ChatRepository (fake_cloud_firestore: ikinci sohbet açılamaz, kendi ilanına sohbet yok), harita işaretleyici widget testi.

Doğrulama: dart format, flutter analyze (sıfır uyarı), flutter test geçsin; flutter build web (+ mümkünse apk debug); Chrome'da elle akış: iki farklı hesapla (iki tarayıcı profili) ilan → sohbet → karşılıklı mesaj; konum izni reddedildiğinde uygulama çalışıyor; rules: üçüncü kullanıcı sohbeti OKUYAMAMALI (emulator/rules testi; yapamadıysan "doğrulanmadı" ve elle test adımları). SKILL.md §8'i işaretleyerek raporla.

Bitti sayılır: PROJECT.md §9 E ve F satırları. Teslimde: yapılanlar, komutlar ve gerçek sonuçlar, DOĞRULANAMAYANLAR, benim elle işlerim, sorular.
```

---

## PROMPT 4 — Güvenlik, Yasal, Hesap Silme (Aşama G)

```
PROJECT.md, DESIGN.md ve SKILL.md'yi yeniden oku. DESIGN.md §0.3'teki kapsam dışı/yanıltıcı mockup öğelerini (ödül, favori, sahte sayaç, "uçtan uca şifreli" vb.) EKLEME; ekranları DESIGN.md §5–§6 tarifine göre yap. Belirsizlikte tek net soru sor; uydurma yapma; doğrulayamadığını açıkça yaz.

GÖREV: PROJECT.md §9'daki Aşama G (Güvenlik ve yasal). Bu aşama App Store ve Google Play kabulü için ZORUNLUDUR; eksik bırakma. Önceki aşamalar tamam olmalı; değilse DUR.

Ortak kurallar: widget'ta Firebase yok; `dart:io` yok; metinler ARB'de TR+EN; yeni paket yok (`url_launcher`, `package_info_plus` zaten PROJECT.md §3'te).

Yapılacaklar:
1. `features/moderation`: `Report`, `ReportReason` modelleri; `ModerationRepository` (şikayet oluştur, engelle, engeli kaldır, engellenenleri akış olarak oku); `blockedUidsProvider`; `ReportMenuButton`, `ReportSheet` (geniş ekranda dialog), `BlockConfirmDialog`, `BlockedUsersScreen` (`/profile/blocked`). Metinler DESIGN.md §8.
2. Şikayet/engelle erişimi: ilan detayı, ilan kartı menüsü, sohbet başlığı, mesaj (uzun basma/menü) ve kullanıcı profili. Kendi içeriğinde GÖSTERME.
3. Engellenen kullanıcıların ilanları Keşfet, Harita ve sohbet listesinde GİZLENİR (istemci tarafı, `blockedUidsProvider`); engellediğin kişiye sohbet/mesaj başlatma arayüzde de engellenir. Rules zaten engelleyene mesajı reddeder (PROJECT.md §7); bunu doğrula.
4. `features/legal`: TermsScreen ve PrivacyScreen (`/legal/terms`, `/legal/privacy`; oturum gerekmez), metinler `assets/legal/*.txt` (TR+EN). Ayrıca `web/legal/privacy-tr.html`, `privacy-en.html`, `terms-tr.html`, `terms-en.html`, `delete-account.html` (herkese açık, giriş gerektirmez). İÇERİK: PROJECT.md §11'de sayılan her şeyi kapsa (toplanan veriler: ad, e-posta, fotoğraf, konum, mesajlar; amaç; saklama; silme yolu; şikayet kayıtlarının saklanması; KVKK hakları; konum koordinatlarının kesin saklandığı; iletişim). Destek e-postası için `[DESTEK_E_POSTASI]` yer tutucusu bırak ve bunu teslimde BANA açıkça bildir; sahte adres, şirket adı, adres veya vergi no YAZMA. Metinlerin hukuki tavsiye olmadığını ve yayından önce benim gözden geçirmem gerektiğini teslimde belirt.
5. Hesap silme (`/profile/delete-account`, Ayarlar'dan ≤ 3 dokunuş): PROJECT.md §6 "Hesap silme akışı" sırasıyla — yeniden doğrulama (şifre ile), kullanıcının ilanları ve Storage fotoğrafları, gönderdiği mesajlar (kullanıcının sohbetlerini `participants arrayContains` ile gez, her sohbette `messages.where(senderId == uid)`; collection group KULLANMA), blocks alt koleksiyonu, `users/{uid}`, EN SON `currentUser.delete()`. Yarıda kesilirse yeniden denenebilir olsun; ilerleme ve hata durumları kullanıcıya gösterilsin. Sohbet belgeleri kalır, karşı tarafta "Silinmiş kullanıcı" görünsün (profil okunamıyorsa bu etiket).
6. Ayarlar'a Gizlilik, Şartlar, sürüm (`package_info_plus`), "Engellenenler" ve "Hesabı sil" bağlantılarını ekle (DESIGN.md §6).
7. Rules: PROJECT.md §7 ile birebir eşitle; şikayet koleksiyonu istemciden SADECE oluşturulabilir olmalı.
8. Testler: ModerationRepository, blockedUids filtreleme mantığı (saf fonksiyon), hesap silme akışı (fake_cloud_firestore ile veri gerçekten siliniyor), şart sürümü artınca `/accept-terms` yönlendirmesi.

Doğrulama: dart format, flutter analyze (sıfır uyarı), flutter test geçsin; flutter build web (+ mümkünse apk debug). Chrome'da elle: şikayet gönder (Firestore `reports` belgesi oluştu mu), engelle (ilanlar kayboldu mu), engeli kaldır, hesabı sil (ilanlar, fotoğraflar, mesajlar, user belgesi gitti mi — Firebase konsolunda/emulator'de kontrol et; yapamadıysan "doğrulanmadı" ve elle kontrol adımlarını ver). Rules: reports okunamıyor/güncellenemiyor. SKILL.md §8'i ve §7B'yi işaretleyerek raporla.

Bitti sayılır: PROJECT.md §9 G satırı ve §11 "Ortak" listesinin kod ile ilgili maddeleri. Teslimde: yapılanlar, komutlar ve gerçek sonuçlar, DOĞRULANAMAYANLAR, benim elle işlerim (özellikle yer tutucular), sorular.
```

---

## PROMPT 5 — Yayın Hazırlığı (Aşama H)

```
PROJECT.md, DESIGN.md ve SKILL.md'yi yeniden oku. DESIGN.md §0.3'teki kapsam dışı/yanıltıcı mockup öğelerini (ödül, favori, sahte sayaç, "uçtan uca şifreli" vb.) EKLEME; ekranları DESIGN.md §5–§6 tarifine göre yap. Belirsizlikte tek net soru sor; uydurma yapma; doğrulayamadığını açıkça yaz.

GÖREV: PROJECT.md §9'daki Aşama H (Yayına hazırlık). Önceki tüm aşamalar tamam olmalı; değilse DUR ve hangi madde eksik söyle. Yeni özellik EKLEME; yalnızca cila, doğrulama, imzalama hazırlığı ve belgeler.

Yapılacaklar:
1. **Tam denetim:** SKILL.md §8, §7A, §7B, DESIGN.md §9 ve §13, PROJECT.md §12 "Yayın öncesi" listelerini madde madde, kanıtla (komut çıktısı veya dosya yolu) işaretle. Geçmeyen madde varsa düzelt.
2. **Kod temizliği:** `flutter analyze` sıfır uyarı; `dart format`; `print`/debug log, `debugShowCheckedModeBanner`, kullanılmayan import/dosya, kodda sabit metin (ARB dışı) ve sabit renk/boyut taraması (grep). `dart:io` ve `dart:html` kullanımı taraması.
3. **Duyarlı düzen ve erişilebilirlik:** DESIGN.md §10.2 "Ekran başına düzen" tablosunun, §10.4 "Duyarlılık test matrisi"nin ve `useRail` kuralının (telefon yatayında alt çubuk) (320 dp → 1920 dp, dikey/yatay) tüm ekranlarda sağlandığını, metin ölçeği %200'de taşma olmadığını, ikon-only düğmelerde tooltip/Semantics olduğunu, odak/hover/klavye akışını kontrol et ve eksikleri düzelt (widget testleriyle metin ölçeği ve genişlik testleri ekle).
4. **Marka varlıkları:** DESIGN.md §11'e göre `assets/branding/` için simge ve açılış görseli kaynaklarını ÜRET (basit, yazısız, benim vereceğim simgeyi (`assets/branding/app_icon.png`) kaynak olarak kullan (şeffaflık/yazı/yuvarlatılmış köşe kurallarını DESIGN.md §11'e göre doğrula); henüz yoksa DESIGN.md §11'deki geçici simgeyi üret (zemin #2563EB, beyaz büyüteç içinde konum işareti, amber nokta) ve bunu GEÇİCİ diye işaretle; SVG'den PNG üretebilirsin; ticari bir marka/karakter/logoya benzetme). `flutter_launcher_icons` ve `flutter_native_splash` yapılandırmasını yaz, çalıştır, Android/iOS/macOS/web simgelerinin oluştuğunu dosyalardan doğrula. Web manifest ve index.html (başlık, açıklama, theme-color).
5. **Sürüm ve imza hazırlığı:** pubspec sürüm/derleme numarası (1.0.0+1); Android release imzası için `key.properties` desteği (anahtar dosyası ve şifreleri ASLA oluşturma/commit etme, `.gitignore`'a ekle; keystore'u nasıl üreteceğimi adım adım yaz); iOS/macOS imzalama ve capability'leri (konum, ağ; Sign in with Apple EKLEME) için Xcode'da benim yapmam gereken adımları yaz; `ITSAppUsesNonExemptEncryption`. Dağıtım hedef sürümleri Firebase paketlerinin güncel gereksinimleriyle uyumlu mu kontrol et.
6. **Güvenlik denetimi:** `.gitignore` (key.properties, *.jks, servis hesabı JSON'ları vb.), repoda gizli bilgi taraması, Firestore/Storage rules'ın PROJECT.md §7 ile birebir olduğu, Hosting `firebase.json` (rewrites ** → /index.html; `/legal/*.html` etkilenmemeli), CORS. Google Cloud'da API anahtarı kısıtlarını benim yapmam gerektiğini adım adım yaz.
7. **Derlemeler:** `flutter build apk --release`, `flutter build appbundle --release` (imza yoksa debug imzayla derlendiğini belirt), `flutter build web --release`; macOS/iOS derlemelerini yapabiliyorsan yap (`flutter build macos`, `flutter build ipa --no-codesign`), yapamıyorsan bunu AÇIKÇA yaz ve komutları ver. Her birinin gerçek sonucunu raporla.
8. **Duman testi senaryosu:** PROJECT.md §12'deki akışı (kayıt → ilan ver foto+konum → ikinci hesapla mesajlaş → şikayet/engelle → hesabı sil) Chrome'da çalıştır ve sonucu yaz; diğer platformlar için bana elle test kontrol listesi ver.
9. **README.md:** kurulum, `flutterfire configure`, platform notları, rules/indexes/CORS deploy, derleme komutları, sürüm yönetimi, bilinen sınırlamalar (PROJECT.md §13).
10. **Mağaza kılavuzu (`STORE_CHECKLIST.md`):** PROJECT.md §11'i, benim doldurmam gereken her alanla (App Privacy / Data safety yanıtları: hangi veri türü toplanıyor, neden, kullanıcıya bağlı mı; yaş derecelendirme anketi için UGC yanıtları; ekran görüntüsü listesi ve boyutları; açıklama ve anahtar kelime taslakları TR+EN) somut bir kontrol listesine çevir. Güncel mağaza gereksinimlerini (ekran görüntüsü boyutları, hedef API seviyesi, Play kişisel hesap test koşulu) resmi belgelerden DOĞRULA; doğrulayamadığın sayıyı uydurma, "kontrol et" yaz.

Doğrulama: yukarıdaki her adımın çıktısını raporda göster. "Hepsi tamam" deme; her maddeyi ✅ (kanıtla doğrulandı), ⚠️ (kısmen/sınırlı) veya ❌ (yapılamadı, nedeni) ile işaretle.

Bitti sayılır: PROJECT.md §12 "Yayın öncesi" listesi ve §11 maddeleri; ❌ ve ⚠️ olanlar benim yapacağım iş olarak net listelenmiş olmalı. Teslimde: özet tablo, DOĞRULANAMAYANLAR, benim elle işlerim (sırayla), yer tutucuların listesi, sorular.
```

---

## Her prompt'tan sonra sen kontrol et
- `flutter analyze` ve `flutter test` kendi bilgisayarında temiz mi?
- `flutter run -d chrome` ile ana akışı elle dene.
- Ajanın raporundaki **DOĞRULANAMAYANLAR** bölümünü oku; orası senin işin.
- Bir sorun çıkarsa aynı konuşmada şunu yaz: *"Hata: [hata metni]. Önce nedenini PROJECT.md/SKILL.md'ye bakarak teşhis et, sonra düzelt, sonra aynı doğrulamayı tekrar çalıştır ve gerçek çıktıyı göster."*