---
name: bulundu-flutter-firebase
description: Bulundu (kayıp eşya) Flutter + Firebase projesinde kod yazarken, dosya eklerken veya değiştirirken kullan. Android, iOS, macOS ve web'de çalışan, mağazaya hazır uygulama için feature-first yapı, Riverpod, Firestore/Storage, çoklu platform, UGC güvenceleri, l10n, tema ve erişilebilirlik kurallarını içerir.
---

# SKILL.md — Bulundu için AI asistan kodlama kuralları

Bu dosya, projede kod yazan AI asistanın (ve senin) uyacağı kurallardır.
Önce **PROJECT.md** (kapsam, veri modeli, yollar) ve **DESIGN.md** (görünüm) okunur, sonra bu dosya uygulanır.

## 1. Çalışma sırası

1. İsteği PROJECT.md'deki kapsam ve **yapım sırasına (§9, aşama A–H)** göre değerlendir. Aşamaları sırayla ilerlet; "Bitti sayılır" maddeleri bitmeden sonraki aşamaya geçme. Kapsam dışıysa **yapma, sor**.
2. Küçük, çalışır adımlarla ilerle. Her adım sonunda uygulama **dört platformda** (Android, iOS, macOS, Chrome) derlenmeli ve açılmalı.
3. Yeni dosyayı **§2 tablosundaki** yere koy. Yeri tabloda yoksa sor.
4. Bitirmeden önce **§8 kontrol listesini** uygula.

## 2. Ne nereye gider

| Ekleyeceğin şey | Konum |
|---|---|
| Ekran | `features/<f>/presentation/screens/<ad>_screen.dart` |
| Feature'a özel widget | `features/<f>/presentation/widgets/<ad>.dart` |
| Birden çok feature'ın kullandığı genel widget | `shared/widgets/` |
| Firestore / Storage / Auth erişimi | `features/<f>/data/<ad>_repository.dart` |
| Riverpod provider | `features/<f>/providers/<ad>_providers.dart` |
| Veri sınıfı, enum, saf Dart mantığı | `features/<f>/models/` |
| Renk, tipografi, boşluk, tema | `app/theme/` |
| Rota tanımı | `app/router/` |
| Uyarlanabilir kabuk (alt çubuk / rail) | `app/shell/adaptive_shell.dart` |
| Platform farkı (`kIsWeb`, `defaultTargetPlatform`) | İlgili `data/` dosyasında veya `shared/utils/platform_info.dart`; **widget içinde dağınık yok** |
| Şikayet / engelleme | `features/moderation/` |
| Gizlilik / Şartlar ekranları | `features/legal/presentation/screens/` |
| Herkese açık yasal sayfalar (HTML) | `web/legal/` |
| Metin | `lib/l10n/app_tr.arb` **ve** `app_en.arb` |
| Test | `test/` altında `lib/` yolunu yansıtarak |

## 3. Katman ve import kuralları

- Yön: `presentation → providers → data → models`. Ters yönde import **yasak**.
- Widget içinde `FirebaseFirestore`, `FirebaseAuth`, `FirebaseStorage` **kullanılmaz**; sadece `ref.watch/read` ile provider.
- Feature'lar arası: başka feature'ın **sadece `models/` ve `providers/`** klasörü import edilir. `data/` ve `presentation/` edilmez.
- `shared/` hiçbir feature'ı import etmez.
- Import'lar `package:bulundu/...` biçiminde mutlak olur (göreli `../../..` yok).
- Barrel (`export`) dosyası oluşturma.

## 4. Adlandırma

| Tür | Kural | Örnek |
|---|---|---|
| Dosya | `snake_case.dart` | `listing_card.dart` |
| Sınıf / enum | `UpperCamelCase` | `ListingRepository` |
| Provider | `camelCaseProvider` | `latestListingsProvider` |
| Ekran | `...Screen` | `ExploreScreen` |
| Repository | `...Repository` | `ChatRepository` |
| Private | `_` önekli | `_buildHeader` |

Kod, değişken ve yorum adları **İngilizce**; kullanıcıya görünen metinler **ARB'de**.

## 5. Riverpod kuralları

- Kod üretimi (`@riverpod`, `build_runner`) **kullanılmaz**. `Provider`, `StreamProvider`, `FutureProvider`, `NotifierProvider`, `AsyncNotifierProvider` kullan.
- Firebase örnekleri `shared/providers/firebase_providers.dart` içindeki provider'lardan gelir (test için taklit edilebilsin).
- Canlı veri: `StreamProvider`. Tek seferlik işlem (kaydet, sil, gönder): `AsyncNotifier` içinde, durum `AsyncValue` olarak ekrana yansır.
- Widget'ta `ref.watch` (build içinde), olay işleyicide `ref.read`.
- Her `AsyncValue` için **üç durum da** gösterilir: yükleniyor, hata (yeniden dene ile), boş.
- `BuildContext`'i `await`'ten sonra kullanmadan önce `if (!context.mounted) return;`.

## 6. Firebase kuralları

- Firestore'da `withConverter` kullan; ham `Map` widget'a sızmaz.
- Zaman damgaları `FieldValue.serverTimestamp()` ile yazılır. Okurken `null` olabilir (yazma beklemede): `?? DateTime.now()`.
- Çoklu yazma gereken yerde `WriteBatch` (örn. mesaj + `lastMessage`).
- Listeler **limitli** okunur (`limit(50)`); sınırsız sorgu yok.
- Bir sorgu yeni bileşik indeks gerektiriyorsa `firestore.indexes.json` güncellenir.
- Rules değişikliği gerektiren her iş, `firestore.rules` / `storage.rules` dosyasını da günceller.
- Foto: `ImagePicker.pickImage(maxWidth: 1280, maxHeight: 1280, imageQuality: 80)` ile boyutlandır, `XFile.readAsBytes()` ve `putData(..., contentType: image/jpeg)` ile yükle (**`File`/`dart:io` yok**, web ve macOS'ta çalışsın). Storage yolu `listings/{uid}/{listingId}/{index}.jpg`. İlan silinince fotoları da silinir.
- Engellenenler (`users/{uid}/blocks`) `moderation/providers/blockedUidsProvider` ile okunur; ilan listesi, harita ve sohbet listesi bu kümeye göre filtrelenir.
- Hesap silme sırası PROJECT.md §6'daki gibidir; auth hesabı **en son** silinir, yeniden doğrulama önce yapılır.
- Kullanıcıya ait veri eklersen (yeni alan/koleksiyon) hesap silme akışına ve Gizlilik Politikası'na da ekle.
- **Asla commit etme:** servis hesabı JSON'u, özel anahtarlar. (`firebase_options.dart` ve `google-services.json` istemci yapılandırmasıdır, güvenlik Rules ile sağlanır.)

## 7. Arayüz, l10n ve erişilebilirlik kuralları

- Renk, yazı tipi, boşluk **sadece** `Theme.of(context)` ve `AppSpacing` üzerinden. Koda `Color(0x...)`, `fontSize: 17` gibi sabit değer yazılmaz.
- Metin yalnızca `context.l10n.xxx`. Kodda sabit Türkçe/İngilizce metin yok. Yeni metin → iki ARB dosyasına birden.
- Dokunma hedefi en az **48×48 dp**. İkon-only butonlarda `tooltip` / `Semantics(label: ...)` zorunlu.
- Bilgi yalnızca renkle verilmez: tip rozeti **ikon + metin + renk** taşır (bkz. DESIGN.md).
- Metin ölçeği %200'de taşma/kırpılma olmamalı; sabit yükseklikli metin kutusu yok.
- Form alanlarında görünür etiket ve hata metni; `autofillHints` ve doğru `keyboardType`.
- Ayrıntılar ve kontrol listesi: **DESIGN.md §9**.

## 7A. Çoklu platform kuralları (Android · iOS · macOS · Web)

- **`dart:io` ve `dart:html` import edilmez.** Platform sorusu için `kIsWeb` ve `defaultTargetPlatform` kullanılır. Dosya yolu yok; yalnız `XFile` + bayt (`Uint8List`).
- Platforma özgü davranış (giriş akışları, kamera desteği, konum izni) **tek yerde** soyutlanır (`auth_repository`, `location_service`, `platform_info`). Widget'lar `if (Platform...)` içermez.
- Kamera seçeneği `ImagePicker().supportsImageSource(ImageSource.camera)` ile koşullu gösterilir.
- Yerel izin açıklamaları (Info.plist, entitlements, manifest) PROJECT.md §10'a göre eklenir; **yeni bir izin/özellik eklersen** ilgili platform dosyalarını da güncelle.
- **Duyarlı düzen:** sabit genişlik yok. Geniş ekranda içerik `MaxWidthBody` ile ortalanır; ≥ 840 dp'de `NavigationRail`. Eşikler `shared/utils/breakpoints.dart` içindedir (DESIGN.md §10).
- **Fare ve klavye:** her tıklanabilir öğe odaklanabilir ve hover durumu gösterir; formlar Enter ile gönderilir; dialog/sheet Esc ile kapanır; uzun metinler `SelectionArea` ile seçilebilir.
- Web: `usePathUrlStrategy()`, doğrudan `/listings/:id` açılabilmeli; Storage görselleri için CORS (PROJECT.md §7); HTTPS dışında konum çalışmaz, hatayı arayüzde işle.
- Paket platform desteğinden emin değilsen güncel belgesine bak; destek yoksa **kullanıcıya sor** (sessizce platformu kapatma).

## 7B. Mağaza ve kullanıcı içeriği (UGC) kuralları

- Kullanıcı içeriği gösteren **her ekranda** (ilan detayı, ilan kartı menüsü, sohbet, profil) **Şikayet et** ve **Engelle** erişilebilir olmalı (`report_menu_button`).
- Kayıt ve ilk sosyal girişte şart onayı alınmadan `users` belgesi yazılmaz; şart sürümü artarsa `/accept-terms` yeniden gösterilir.
- Hesabı silme her zaman Ayarlar'dan ≤ 3 dokunuşla bulunur ve **gerçekten** veriyi siler.
- Giriş ekranında Google ile Apple düğmesi **eşit görünürlükte** (DESIGN.md §5).
- İzin istemeden önce neden gerektiğini açıkla; reddedilirse uygulama kullanılabilir kalır.
- Release kodunda `print`/debug log, test hesabı, gizli anahtar, `debugShowCheckedModeBanner: true` olmaz.
- Yasal metin ve mağaza formu alanlarında **yer tutucu** (`[DESTEK_E_POSTASI]` gibi) bırakılırsa bunu açıkça kullanıcıya bildir.

## 8. Bitirmeden önce kontrol listesi

- [ ] `dart format .` uygulandı
- [ ] `flutter analyze` sıfır uyarı
- [ ] Yeni metinler `app_tr.arb` ve `app_en.arb` içinde; `flutter gen-l10n` çalıştı
- [ ] Yükleniyor / hata / boş durumları var
- [ ] Katman ve feature import kuralları ihlal edilmedi
- [ ] Rules/indexes gerekiyorsa güncellendi
- [ ] Yeni mantık için test yazıldı (model dönüşümü, saf fonksiyon veya widget)
- [ ] Açık ve koyu temada, TR ve EN dilinde göz ile kontrol edildi
- [ ] Dört platformda açıldı: Android, iOS (veya simülatör), macOS, Chrome (`flutter run -d chrome`)
- [ ] Dar (telefon) ve geniş (tablet/masaüstü/tarayıcı) genişlikte düzen bozulmuyor
- [ ] `dart:io`/`dart:html` kullanılmadı; platform farkı soyutlandı
- [ ] Yeni UGC alanı varsa şikayet/engelle ve hesap silme akışı güncellendi

## 9. Sormadan yapılmayacaklar (önce kullanıcıya sor)

- Yeni paket eklemek veya mevcut paketi değiştirmek
- Uygulama kimliğini (`com.bulundu.app`), platform listesini veya giriş yöntemlerini değiştirmek
- Bir platformu (web, macOS vb.) bir özellik için devre dışı bırakmak
- Mağaza metinlerini, gizlilik/şart içeriğini veya destek e-postasını kesinleştirmek
- PROJECT.md'deki kapsam dışı bir özellik (push, Cloud Functions, ML, ödeme vb.)
- Firestore veri modelini veya rota yollarını değiştirmek
- Renk paletini veya tasarım ilkelerini değiştirmek
- Klasör yapısında §2 tablosuna uymayan bir yer açmak
- Bir gereksinim iki belgede çelişiyorsa veya belirsizse: **tahmin yürütme, tek ve net bir soru sor** (mümkünse seçenekli)

## 10. Kod kalıpları (şablon olarak kullan)

### Model (`features/listings/models/listing.dart`)
```dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum ListingType { lost, found }
enum ListingStatus { open, resolved }
// ListingCategory (wallet, phone, keys, bag, documents, electronics, accessories,
// clothing, pet, other) ayrı dosyadadır: models/listing_category.dart

class Listing {
  const Listing({
    required this.id,
    required this.type,
    required this.status,
    required this.title,
    required this.category,
    required this.description,
    required this.ownerId,
    required this.ownerName,
    required this.lat,
    required this.lng,
    required this.locationName,
    required this.eventDate,
    required this.createdAt,
    this.imageUrls = const [],
  });

  final String id;
  final ListingType type;
  final ListingStatus status;
  final String title;
  final ListingCategory category;
  final String description;
  final String ownerId;
  final String ownerName;
  final double lat;
  final double lng;
  final String locationName;
  final DateTime eventDate;
  final DateTime createdAt;
  final List<String> imageUrls;

  factory Listing.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snap,
    SnapshotOptions? _,
  ) {
    final d = snap.data()!;
    return Listing(
      id: snap.id,
      type: ListingType.values.byName(d['type'] as String),
      status: ListingStatus.values.byName(d['status'] as String),
      title: d['title'] as String,
      category: ListingCategory.values.byName(d['category'] as String),
      description: (d['description'] as String?) ?? '',
      ownerId: d['ownerId'] as String,
      ownerName: (d['ownerName'] as String?) ?? '',
      lat: (d['lat'] as num).toDouble(),
      lng: (d['lng'] as num).toDouble(),
      locationName: (d['locationName'] as String?) ?? '',
      eventDate: (d['eventDate'] as Timestamp).toDate(),
      // serverTimestamp yazma beklerken null olabilir
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      imageUrls: List<String>.from(d['imageUrls'] as List? ?? const []),
    );
  }

  /// Yalnızca ilk oluşturma için. Güncellemede kısmi `update({...})` kullan.
  Map<String, dynamic> toCreateMap() => {
        'type': type.name,
        'status': status.name,
        'title': title,
        'category': category.name,
        'description': description,
        'ownerId': ownerId,
        'ownerName': ownerName,
        'lat': lat,
        'lng': lng,
        'locationName': locationName,
        'eventDate': Timestamp.fromDate(eventDate),
        'imageUrls': imageUrls,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
}
```

### Repository (`features/listings/data/listing_repository.dart`)
```dart
class ListingRepository {
  ListingRepository(this._db);
  final FirebaseFirestore _db;

  CollectionReference<Listing> get _col =>
      _db.collection('listings').withConverter<Listing>(
            fromFirestore: Listing.fromFirestore,
            toFirestore: (l, _) => l.toCreateMap(),
          );

  Stream<List<Listing>> watchLatest({ListingType? type, int limit = 50}) {
    Query<Listing> q = _col.where('status', isEqualTo: ListingStatus.open.name);
    if (type != null) q = q.where('type', isEqualTo: type.name);
    q = q.orderBy('createdAt', descending: true).limit(limit);
    return q.snapshots().map((s) => s.docs.map((d) => d.data()).toList());
  }
}
```

### Provider'lar
```dart
// shared/providers/firebase_providers.dart
final firestoreProvider = Provider<FirebaseFirestore>((_) => FirebaseFirestore.instance);

// features/listings/providers/listing_providers.dart
final listingRepositoryProvider = Provider<ListingRepository>(
  (ref) => ListingRepository(ref.watch(firestoreProvider)),
);

final latestListingsProvider =
    StreamProvider.family<List<Listing>, ListingType?>((ref, type) {
  return ref.watch(listingRepositoryProvider).watchLatest(type: type);
});
```

### Ekran iskeleti (üç durum zorunlu)
```dart
class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final listings = ref.watch(latestListingsProvider(null));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.exploreTitle)),
      body: listings.when(
        loading: () => const LoadingView(),
        error: (_, __) => ErrorView(
          message: l10n.errorGeneric,
          onRetry: () => ref.invalidate(latestListingsProvider(null)),
        ),
        data: (items) => items.isEmpty
            ? EmptyState(title: l10n.exploreEmptyTitle, message: l10n.exploreEmptyMessage)
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (_, i) => ListingCard(listing: items[i]),
              ),
      ),
    );
  }
}
```

### Tek seferlik işlem (`AsyncNotifier`)
```dart
class ListingFormController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> submit(ListingDraft draft) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(listingRepositoryProvider).create(draft),
    );
  }
}
```
> Not: Riverpod'un güncel ana sürümünde `AutoDisposeAsyncNotifier` yerine `AsyncNotifier` kullanılabilir. `flutter pub add` ile kurulan sürümün belgesine bak; sürüm farkında **kullanıcıya sor**.

### Fotoğraf yükleme (tüm platformlar, bayt ile)
```dart
// features/listings/data/listing_image_storage.dart
class ListingImageStorage {
  ListingImageStorage(this._storage);
  final FirebaseStorage _storage;

  Future<String> upload({
    required String uid,
    required String listingId,
    required int index,
    required XFile file, // image_picker; maxWidth/maxHeight 1280, imageQuality 80 ile alındı
  }) async {
    final bytes = await file.readAsBytes(); // web, macOS ve mobilde ortak
    final ref = _storage.ref('listings/$uid/$listingId/$index.jpg');
    await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
    return ref.getDownloadURL();
  }
}
```

### Platform farkını soyutlama (`auth_repository.dart` özeti)
```dart
Future<void> signInWithGoogle() async {
  if (kIsWeb) {
    await _auth.signInWithPopup(GoogleAuthProvider());
    return;
  }
  // Mobil ve macOS: güncel `google_sign_in` belgesindeki akışla kimlik bilgisi al,
  // sonra _auth.signInWithCredential(...) çağır.
}
// Apple için de aynı desen: web'de popup/provider, iOS/macOS/Android'de güncel
// sign_in_with_apple ve FlutterFire belgesindeki akış (nonce için crypto paketi).
```
Platform akışları paket sürümüne göre değişir; ayrıntıda belge ile bu şablon çelişirse **belgeyi izle ve kullanıcıya bildir**.

### Duyarlı yardımcılar
```dart
// shared/utils/breakpoints.dart
abstract final class Breakpoints {
  static const double compact = 600;   // telefon
  static const double medium = 840;    // NavigationRail başlangıcı
  static const double maxContent = 720; // tek sütun içerik üst sınırı
}
// shared/extensions/context_x.dart
extension ContextX on BuildContext {
  bool get isWide => MediaQuery.sizeOf(this).width >= Breakpoints.medium;
}
```

## 11. Commit ve dal kuralları

- Dal: `feature/<ad>`, `fix/<ad>`. Küçük ve sık commit.
- Mesaj: Conventional Commits, Türkçe ya da İngilizce tutarlı: `feat(listings): ilan formu eklendi`, `fix(chat): mesaj sırası düzeltildi`.
- Bir commit = bir mantıksal değişiklik; rules/indexes değişikliği ilgili kodla aynı commit'te.
