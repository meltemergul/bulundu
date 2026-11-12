
# DESIGN.md — Bulundu Tasarım Rehberi

**Hedef his:** güven veren, modern, sıcak ve erişilebilir. Kaybı yaşayan biri stresli olabilir; arayüz onu yormamalı, net yönlendirmeli.

**Taban:** Material 3 · **Ana renk:** derin teal (güven ve topluluk) · **Yardımcı renk:** sage (olumlu durumlar) · **Vurgu:** coral (kayıp ilanı ve dikkat) · **Zemin:** sıcak cream · **Yazı tipi:** Plus Jakarta Sans · **Temalar:** açık + koyu · **Diller:** TR + EN.

**Duyarlılık:** tasarım **her boyutta** çalışır: 320 dp küçük telefondan 1920 dp tarayıcıya, dikey ve yatay (ayrıntı §10). **Giriş:** yalnız e-posta ve şifre; Google/Apple/sosyal giriş yoktur.

**Kaynak:** Kullanıcının Stitch paketi (`stitch_kay_p_e_ya_takip_portal.zip`): **Civic Beacon** tasarım sistemi (`civic_beacon/DESIGN.md`) + 5 ekran (`ke_fet`, `harita`, `mesajlar`, `profil`, `giri_kay_t_ol`; her birinde `code.html` ve `screen.png`). Bu belge o tasarımın Flutter karşılığını ve **PROJECT.md kapsamına uyarlanmış** halini tarif eder. Marka: **empatik, son derece verimli, topluluk odaklı** — "Modern Utility + Human-Centric Warmth".

## 0. Mockup → uygulama eşlemesi (önce bunu oku)

Mockup bir görsel taslaktır; her öğesi uygulanamaz ya da yayınlanamaz. Aşağıdaki karar **bağlayıcıdır**. Tabloda "uygulanır" yazmayan öğe **ekrana konmaz** (çalışmayan düğme, sahte sayı, kendini doğrulayamayan iddia mağaza reddi ve kullanıcı güveni riskidir).

### 0.1 Uygulanır

Üst başlık (**uygulama simgesi** + ad + profil avatarı) · arama alanı + filtre düğmesi · kategori hapları · ilan akışı kartları (Kayıp/Bulundu rozeti, zaman, mesafe, açıklama, **Detayı Gör**, **Mesaj At / Bu Benim!**) · "Hemen İlan Ver" genişletilmiş FAB (yalnız Keşfet) · merkezdeki yükseltilmiş **+** düğmeli alt gezinme · harita (pinler, filtre hapları, yarıçap hapı, konumuma git, yakınlaştır/uzaklaştır, alttaki kaydırmalı kart şeridi) · Mesajlar listesi + arama + güvenlik ipucu bandı · Profil kartı + sayaç şeridi + sekmeler (İlanlarım, Ayarlar) · giriş/kayıt (segmentli geçiş, e-posta, şifre, şifremi unuttum, şart onayı).

### 0.2 Uyarlanır (mockup'tan bilinçli farklar)

| Mockup | Uygulamada | Neden |

|---|---|---|

| Kayıp = coral, Bulundu = teal (kartlarda) ama haritada Bulundu = **yeşil** | **Bulundu her yerde teal**, sage yalnız **Teslim Edildi** ve olumlu eylem ("Bu Benim!") | Mockup kendi içinde tutarsız; yeşil iki farklı anlam taşıyamaz |

| Harita pini: iki tip de daire | Kayıp = **daire**, Bulundu = **yuvarlatılmış kare** pin | Renk körlüğünde şekille ayırt edilsin (DESIGN §9) |

| `label-sm` 10 px | **12 sp** (en küçük metin) | Okunabilirlik ve erişilebilirlik |

| Küçük hap/butonlar (~30 dp) | Görsel ≥ 36 dp, **dokunma alanı ≥ 48 dp** | Dokunma hedefi kuralı |

| Placeholder rengi `outline` (kontrast 4.28:1) | Placeholder = `onSurfaceVariant` | AA kontrast (≥ 4.5:1) |

| "E-posta veya Telefon" alanı | Yalnız **E-posta** | Telefon girişi kapsam dışı (PROJECT.md §2) |

| Kayıt onayı: "bildirim almayı… kabul ediyorum" | Kullanım Şartları + Gizlilik onayı (bağlantılı), §8 metni | Mağaza ve KVKK gereği; bildirim yok |

| Giriş: ayrı ekranda geri oku | Yok | Giriş kök ekrandır |

| Hızlı kategori hapları tip ve kategoriyi aynı satırda karıştırıyor | Tek satır, tek seçim: Tümü, Kayıp, Bulundu, Evcil Hayvan, Elektronik, Cüzdan & Kimlik, Anahtarlık; **kalanı ve birleşik filtre** filtre sayfasında (§5) | Mockup davranışı korunur, tüm kategoriler erişilebilir kalır |

| Alt gezinmede merkez **+** bir sekme gibi duruyor | Merkez **+** bir **eylem**dir (sekme değildir); 4 gerçek sekme: Keşfet, Harita, Mesajlar, Profil | `StatefulShellRoute` 4 dal (PROJECT.md §5) |

| Uygulama adı "Bulduk" (başlık, giriş ekranı, sürüm metni, logo görseli) | **"Bulundu"** (her yerde; l10n `appName`) | Kullanıcı kararı. Simge görselinde "Bulduk" yazısı varsa o görsel kullanılmaz: simgede **yazı olmamalı** (§11) |

| Koyu tema yok | Mockup renklerinden **türetilmiş** koyu tema (§2) | PROJECT.md kararı |

| Form alanı: açık slate kenarlık `#E2E8F0` (ekranda kenarlıksız dolgu) | Dolgu `surfaceContainerLow` + **1 dp `outline` kenarlık** | `#E2E8F0`/beyaz = 1.23:1, alan sınırı algılanamaz (≥ 3:1 gerekir) |

| Çözülen ilan: "Sahibi Bulundu" ve "Teslim Edildi" ayrı yazılmış | Tek durum adı: **Teslim Edildi** (rozet, eylem, sayaç) | Tasarım sistemi bu adı kullanır; tek ad = karışıklık yok |

| Sohbet satırı: çevrimiçi yeşil nokta, ✓✓, okunmamış sayı | Yok (v2); **avatar, ad, ilan tip/başlık hapı, son mesaj, zaman, ilan küçük resmi var** | Çevrimiçi/okundu takibi veri modelinde yok; geri kalanı uygulanabilir |

| Haritada Bulundu = yeşil pin (kart rozetinde mavi) | Bulundu = **teal** (her yerde) | Tasarım kendi içinde tutarsız; yeşil yalnız Teslim Edildi |

### 0.3 Kapsam dışı (ekrana **konmaz**, v2 olabilir)

| Mockup öğesi | Durum |

|---|---|

| "Google ile Devam Et" / "Apple ile Devam Et" düğmeleri, "veya şununla devam et" ayırıcısı | **Hayır** (kullanıcı kararı: giriş yalnız e-posta ve şifre) |

| Ödül ("5.000 TL Ödül"), ödül rozeti | v2 (PROJECT.md: ödeme/ödül yok) |

| Favori (kalp) düğmesi | v2 (veri modeli yok) |

| "24 Paylaşım", "410 Görüntülenme" sayaçları, paylaş düğmesi | v2 (sayaç yazımı ve paylaşım/deep link yok) |

| Sesli arama (mic) | v2 |

| Kayıtlı Aramalar sekmesi, "Arama Alarmı", anlık bildirim, bildirim zili | v2 (push yok) |

| "Yapay zeka 3 eşleşme önerisi bulundu!" şeridi | v2 (ML yok; yalnız bonus "Benzer ilanlar") |

| Doğrulama Talepleri sekmesi, "Onayla ve Mesajlaş", Sistem mesajları | v2 |

| Okunmamış sayısı rozetleri (sohbet satırı ve alt gezinme), okundu işaretleri (✓✓) | v2 (okundu takibi yok) |

| Başlıkta konum seçici ("Kadıköy, İstanbul"), "TR" hapı | Kaldırıldı (ters coğrafi kodlama yok, anlamsız) |

| "Bu alanda ara", katman değiştirici, "Gördüm! Bildir" | v2 |

| "Yol Tarifi" | **Hayır:** bulunan eşyanın kesin koordinatını sızdırır (konum gizliliği) |

| "Sahibi Ara" (telefon) | **Hayır:** telefon numarası tutulmaz; iletişim uygulama içi sohbettir |

| Kullanıcı adı (@selin.korkmaz), "Doğrulanmış Üye/Mahalle Gönüllüsü", güven puanı 98/100, "%99" güven rozeti, rozet koleksiyonu, "Teşekkür" sayacı | v2 (doğrulama/puan sistemi yok) |

| "e-Devlet onaylı", "Gizlilik & Kimlik Doğrulama" (e-Devlet) | **Hayır:** olmayan bir doğrulamayı iddia etmek yanıltıcıdır |

| "256-bit **uçtan uca şifreli** iletişim" | **Hayır, kesinlikle:** Firestore sohbeti uçtan uca şifreli **değildir**. Bu ifade kullanılmaz (yanıltıcı, mağaza ve KVKK riski) |

| "Bu hafta 142 eşya kavuştu!" bandı, "Bugün 18 eşya sahibine kavuştu" şeridi | **Hayır:** toplu sayılar Cloud Functions/veri olmadan uydurma olur |

| "Topluluk **Güvenceli** Arama" | "Topluluk destekli arama" olarak yumuşatılır ("garanti/güvence" vaadi yok) |

| "Beni Hatırla" | Kaldırıldı (oturum zaten kalıcı) |

| Mockup'taki gerçek kişi fotoğrafları ve isimler | Uygulamada kullanılmaz; mağaza görselleri **uydurma örnek veri** ile hazırlanır |

### 0.4 PROJECT.md'ye eklenen küçük şeyler

**Şifre sıfırlama** (e-posta ile, giriş ekranından diyalog) kapsama alındı. Ayarlar'da **Konum izni** satırı (sistem ayarlarını açar), **Destek** satırı (`mailto:`), sürüm bilgisi. Sohbet satırı için `chats` belgesine **`listingType`** ve **`listingImageUrl`** kopya alanları eklendi (PROJECT.md §6); karşı tarafın adı/avatarı `users/{uid}` belgesinden okunur.

### 0.5 Kaynak çatışmaları ve çözümü

Bu sürümde eski mavi/amber/yeşil renk eşlemesi kaldırılmış; uygulama genelinde Teal + Cream + Coral paleti ve §2.5 durum eşlemesi esas alınmıştır.

`civic_beacon/DESIGN.md` içinde YAML belirteçleri ile açıklama metni birbirini tutmuyor. **Çözüm: YAML belirteçleri + ekran görüntüleri esas alındı** (ekranlar onlarla çizilmiş).

| Açıklama metni | YAML belirteci (kullanılan) | Neden |

|---|---|---|

| Secondary `#F59E0B` | `#855300` / container `#FEA619` | Beyaz/`#F59E0B` = 2.15:1 (yetersiz) |

| Tertiary `#10B981` | `#006242` / container `#007D55` | Beyaz/`#10B981` = 2.54:1 (yetersiz) |

| Tuval `#F8FAFC`, nötr `#64748B`, sarı rozet `#FEF3C7`/`#B45309` (4.51, sınırda) | `surface #F8F9FF`, `onSurfaceVariant #434655`, `secondaryFixed #FFDDB8` | Ekranlarla birebir; kontrast daha yüksek |

| "Bulundu" = tertiary (yeşil) ve rozet = indigo (aynı belgede) | Bulundu = **teal**, Teslim Edildi = **yeşil** | Tek anlam – tek renk |

| Köşe: kontroller `0.5rem` ama `md = 0.75rem` | Kontrol 8, orta 12, kart 16, sheet 24 dp (§4) | Belirteçler esas |

| Gölge: FAB `rgba(37,99,235,.18)` (HTML ekranlarda `.45`) | `.18` + ikinci katman (§4) | Tasarım sistemi esas, daha yumuşak |

| Resim oranı 4:3 veya 1:1 | **16:10** | Ekran görüntülerinin tamamı 16:10 |

---

## 1. İlkeler

1. **Net ve sıcak:** Bir ekranda tek ana aksiyon. Yumuşak gölgeler, bol boşluk, yuvarlak köşeler.

2. **Güven:** Teal ağırlıklı, tutarlı bileşenler, dürüst metin (sahte sayı ve iddia yok).

3. **Renkler anlam taşır:** Coral = **Kayıp**, teal = **Bulundu** ve ana eylem, sage = **Teslim Edildi / olumlu sonuç**, kırmızı = hata. Cream yüzeyleri sakin bir zemin sağlar. Renk anlamı dışında süs için kullanılmaz.

4. **Erişilebilirlik sonradan eklenmez:** Kontrast, 48 dp hedef, metin ölçeği, ekran okuyucu baştan düşünülür.

5. **Renk tek başına bilgi taşımaz:** Her durum **metin** (ve mümkünse şekil/ikon) ile de ayırt edilir.

6. **Dürüst arayüz:** Çalışmayan ya da sahte veri gösteren öğe yok (bkz. §0.3).

7. **Katmanlı derinlik, sert çizgi yok:** Ayrım kenarlıkla değil ton ve yumuşak gölgeyle yapılır (form alanı kenarlığı erişilebilirlik için istisna).

8. **Durum anlaşılır:** Kayıp (coral), Bulundu (teal) ve Teslim Edildi (sage) durumları renk, metin ve ikon/şekil ile birlikte ayırt edilir.

---

## 2. Renk paleti

Renkler Material 3 ColorScheme rollerine bağlıdır. Uygulama kimliği Teal + Cream + Coral kombinasyonudur. Koda ham renk yazılmaz; Theme.of(context).colorScheme kullanılır (tema bağımsız medya kaplamaları ve marka varlıkları için AppColors istisnası).

2.1 Marka renkleri
Renk	Hex	Kullanım
Trust Electric Indigo	#2563EB / #004AC6	Ana marka rengi; birincil butonlar (CTA), aktif sekmeler, bağlantılar, harita ve odak vurgusu
Energetic Warm Amber	#FEA619 / #855300	Kayıp ilanı rozeti, kayıp pinleri ve dikkat/acil arama vurgusu
Safety Emerald Teal	#007D55 / #006242	Bulundu ve Teslim Edildi durumları, olumlu sonuçlar ve başarı etiketleri
Clean Canvas	#F8F9FF	Açık tema sayfa zemini ve geniş yüzeyler
Deep Navy Charcoal	#0B1C30	Ana metin ve başlıklar
Surface White	#FFFFFF	Kartlar, arama alanları ve form yüzeyleri

2.2 Açık tema — Material 3 rolleri
Rol	Hex	Kullanım
primary	#004AC6	Ana marka rengi, bağlantı, aktif sekme
onPrimary	#FFFFFF	Birincil buton metni ve ikonu
primaryContainer	#2563EB	Birincil eylem (CTA) butonu, odak ve marka vurgusu
onPrimaryContainer	#EEEFFF	Açık indigo dolgu üzerindeki metin/ikon
primaryFixed / primaryFixedDim	#DBE1FF / #B4C5FF	Bulundu rozeti ve sabit açık indigo yüzeyler
onPrimaryFixed / onPrimaryFixedVariant	#00174B / #003EA8	Sabit indigo yüzeylerde metin/ikon
secondary	#855300	Kayıp durumu koyu metin/ikon tonu (Energetic Warm Amber)
onSecondary	#FFFFFF	Secondary eylem üzerindeki metin
secondaryContainer	#FEA619	Kayıp rozeti dot, Kayıp pin dolgusu ve aktif Kayıp filtresi
onSecondaryContainer	#684000	Kayıp rozeti ve amber dolgu üzerindeki metin/ikon
secondaryFixed / secondaryFixedDim	#FFDDB8 / #FFB95F	Kayıp rozeti için açık amber yüzey
onSecondaryFixed / onSecondaryFixedVariant	#2A1700 / #653E00	Kayıp rozeti metni/ikonu
tertiary	#006242	Teslim Edildi ve Bulundu olumlu durum metni/ikonu (Safety Emerald Teal)
onTertiary	#FFFFFF	Olumlu eylem metni
tertiaryContainer	#007D55	Teslim Edildi rozeti ve olumlu eylem dolgusu
onTertiaryContainer	#BDFFDB	Zümrüt dolgu üzerindeki metin/ikon
tertiaryFixed / tertiaryFixedDim	#6FFBBE / #4EDEA3	Teslim Edildi rozeti için nane yüzey
onTertiaryFixed / onTertiaryFixedVariant	#002113 / #005236	Teslim Edildi rozeti metni/ikonu
error / onError	#BA1A1A / #FFFFFF	Hata, silme ve başarısız işlem
errorContainer / onErrorContainer	#FFDAD6 / #93000A	Hata bandı ve hata açıklaması
surface	#F8F9FF	Sayfa zemini
surfaceContainerLowest	#FFFFFF	Kart, arama alanı ve form yüzeyi
surfaceContainerLow	#EFF4FF	Secondary CTA ve hafif yüzey dolgusu
surfaceContainer	#E5EEFF	Pasif hap, tonal buton ve görsel yer tutucu
surfaceContainerHigh	#DCE9FF	Seçili olmayan kart vurgusu ve nötr rozet yüzeyi
surfaceContainerHighest / surfaceVariant	#D3E4FE	Gelen mesaj balonu ve yükseltilmiş nötr yüzey
surfaceDim / surfaceBright	#CBDBF5 / #F8F9FF	Dim ve parlak yüzeyler
onSurface	#0B1C30	Ana metin ve başlıklar (Deep Navy)
onSurfaceVariant	#434655	İkincil metin ve placeholder
outline	#737686	Form alanı kenarlığı ve odak dışı sınırlar
outlineVariant	#C3C6D7	Yalnız dekoratif ayırıcılar
inverseSurface / onInverseSurface	#213145 / #EAF1FF	Snackbar ve ters yüzey
inversePrimary	#B4C5FF	Ters yüzey üzerindeki marka vurgusu
surfaceTint	#0053DB	Material 3 yüzey tonu
Fotoğraf üstü zaman hapı: zemin #0B1C30 %80, metin #FFFFFF → AppColors.mediaOverlay / mediaOverlayText.

2.3 Koyu tema
Rol	Hex
primary / onPrimary	#B4C5FF / #002A78
primaryContainer / onPrimaryContainer	#004AC6 / #DBE1FF
secondary / onSecondary	#FFB95F / #472A00
secondaryContainer / onSecondaryContainer	#653E00 / #FFDDB8
tertiary / onTertiary	#4EDEA3 / #003824
tertiaryContainer / onTertiaryContainer	#005236 / #6FFBBE
error / onError	#FFB4AB / #690005
errorContainer / onErrorContainer	#93000A / #FFDAD6
surface	#0F141C
surfaceContainerLowest	#141A23
surfaceContainerLow	#1A212C
surfaceContainer	#202733
surfaceContainerHigh	#30433D
surfaceContainerHighest	#394C46
surfaceDim / surfaceBright	#121A18 / #394C46
onSurface / onSurfaceVariant	#F4F1E9 / #C2CDC6
outline / outlineVariant	#899890 / #46564F
inverseSurface / onInverseSurface	#F4F1E9 / #263A36
inversePrimary	#245C59
primaryFixed, secondaryFixed ve tertiaryFixed rolleri açık temadaki değerlerini korur.

2.4 Kontrast ve erişilebilirlik
Metin kontrastı WCAG AA için normal metinde en az 4.5:1, büyük metinde ve anlam taşıyan grafik öğelerinde en az 3:1 olmalıdır. Önemli eşleşmeler:

Çift	Kontrast	Kullanım
#FFFFFF / #245C59	7.64:1	Ana buton metni
#343D3B / #F4EBDD	9.47:1	Ana metin / sayfa zemini
#58372D / #E99A7B	4.69:1	Coral vurgu üzerindeki metin
#245C59 / #F4EBDD	6.46:1	Teal metin / cream zemin
Coral rengin açık tonu (#E99A7B) beyaz metinle kullanılmaz. Coral yüzeylerde #58372D gibi koyu metin tercih edilir. Mustard yalnızca dekoratif vurgu veya koyu metinli rozet zemini olarak kullanılır. Her ekran ve tema için kontrast ayrıca doğrulanır.

2.5 İlan durumlarının renk eşlemesi
Durum	Zemin	Metin / ikon	Pin şekli	Etiket
Kayıp	secondaryContainer	onSecondaryContainer	Coral daire	"KAYIP"
Bulundu	primaryContainer	onPrimaryContainer	Teal yuvarlatılmış kare	"BULUNDU"
Teslim Edildi	tertiaryContainer	onTertiaryContainer	—	"TESLİM EDİLDİ"
Hata	errorContainer	onErrorContainer	—	Açıklayıcı metin
Renk tek başına bilgi taşımaz; rozetlerde durum metni ve ikon daima görünür. Kayıp/Bulundu ayrımı haritada pin şekliyle de desteklenir.

## 3. Tipografi

- Yazı tipi: **Plus Jakarta Sans** (Regular 400, SemiBold 600, Bold 700, ExtraBold 800). Latin Extended'ı destekler; Türkçe karakterler (ğ, ş, ı, İ) doğrulanır.

- Dosyalar `assets/fonts/` altında **paketlenir** (ağdan indirme yok, `google_fonts` paketi **kullanılmaz**). Dosya adları: `PlusJakartaSans-Regular.ttf`, `-SemiBold.ttf`, `-Bold.ttf`, `-ExtraBold.ttf`. Lisans (SIL OFL) dosyası `assets/fonts/OFL.txt` olarak eklenir. Dosyaları ben indiremiyorsam kullanıcıdan istenir (uydurma yok).

- Boyutlar `sp`'tir ve sistem metin ölçeğine uyar. **Metni elle küçültme/sabitleme yok.**

| Flutter stili | Mockup adı | Boyut / Satır | Ağırlık | Kullanım |

|---|---|---|---|---|

| `headlineLarge` | headline-xl-mobile | 28 / 36 | 800 | Giriş ekranı uygulama adı, boş durum başlığı (geniş ekran: 36 / 44) |

| `headlineMedium` | headline-lg-mobile | 22 / 30 | 700 | Ekran/bölüm başlığı (geniş ekran: 28 / 36) |

| `headlineSmall`, `titleLarge` | headline-md | 20 / 28 | 700 | Profil adı, AppBar başlığı |

| `titleMedium` | headline-sm | 16 / 24 | 700 | **Kart başlığı**, bölüm başlığı |

| `bodyLarge` | body-lg | 16 / 24 | 400 | Ana metin |

| `bodyMedium` | body-md | 14 / 20 | 400 | Açıklama, mesaj |

| `bodySmall` | body-sm | 12 / 16 | 400 | Yardımcı metin, konum satırı |

| `labelLarge` | label-lg | 14 / 20 | 600 | Buton, segment |

| `labelMedium` | label-md | 12 / 16 | 600 | Hap, mesafe, zaman |

| `labelSmall` | label-sm | **12 / 16** (mockup 10) | 700 | Rozet (KAYIP/BULUNDU), sayaç |

12 sp'den küçük yazı yok. Gövde metni 14–16 sp, satır yüksekliği 1.4–1.5. **Durum ve güven etiketleri** (`labelSmall`, `labelMedium`) harf aralığı **+0.02 em** (12 sp için `letterSpacing: 0.24`) — dış mekân parlak ışıkta okunabilirlik için. Rozet metni büyük harf (TR'de `İ/ı` dönüşümüne dikkat: `toUpperCase` yerine ARB'de hazır büyük harf yaz).

---

## 4. Boşluk, şekil, gölge

**4 dp ızgara.** Sabitler `AppSpacing`:

| Ad | dp | Mockup | Kullanım |

|---|---|---|---|

| `xs` | 4 | space-xs | İkon-metin arası |

| `sm` | 8 | space-sm | Küçük boşluk, hap arası |

| `md` | 16 | space-md, margin, gutter | **Ekran kenar boşluğu**, kart iç boşluğu, kartlar arası |

| `lg` | 24 | space-lg, gutter-desktop | Bölümler arası |

| `xl` | 32 | space-xl, margin-desktop | Büyük ayrım, masaüstü kenar boşluğu |

| `xxl` | 48 | — | Boş durum üst boşluğu |

**Köşe yarıçapı** (Civic Beacon: sm 4, DEFAULT 8, md 12, lg 16, xl 24, full):

| Ad | dp | Kullanım |

|---|---|---|

| `radiusSm` | 4 | Onay kutusu, küçük etiket |

| `radiusMd` | 8 | **Butonlar, hap-olmayan kontroller**, 80 dp küçük resim |

| `radiusLg` | 12 | **Arama alanı, form alanı, segment kabı**, ilan görseli iç köşesi |

| `radiusXl` | 16 | **Kart, harita kaplamaları, uyarı kartı** |

| `radiusSheet` | 24 | **Bottom sheet üst köşeleri**, büyük modal |

| `radiusFull` | 9999 | **Hap, rozet**, FAB, avatar, merkez **+** |

**Gölge** (tonal katman + yumuşak renkli gölge; sert kenarlık yok; `AppShadows`):

| Ad | Değer | Nerede |

|---|---|---|

| `card` (Seviye 1) | `0 4 16 -2 rgba(15,23,42,.05)` + `0 2 4 -1 rgba(15,23,42,.03)` | İlan/sohbet/profil kartı, filtreler |

| `soft` | `0 1 2 rgba(0,0,0,.05)` | Hap, arama alanı |

| `floating` (Seviye 2) | `0 12 28 -4 rgba(37,99,235,.18)` + `0 4 10 -2 rgba(15,23,42,.04)` | **FAB, harita pinleri, merkez +, yüzen alt çubuk** |

| `sheet` (Modal) | `0 -8 32 0 rgba(15,23,42,.08)` + arkada yumuşak blur | **Şikayet, ilan sahiplenme, filtre sheet'i** |

| `header` | `0 1 8 rgba(0,0,0,.04)` | Üst başlık |

**Koyu temada gölge kullanılmaz;** derinlik `surfaceContainer*` tonlarıyla verilir (`AppShadows` koyu temada boş liste döner).

**Cam etkisi:** üst başlık %80, alt gezinme %85 `surface` + `BackdropFilter(blur 20)`; web'de performans düşerse yarı saydam düz renge düşer.

---

## 5. Bileşenler

### Butonlar (minimum yükseklik **48 dp**, köşe `radiusMd` 8)

| Tür | Stil | Nerede |

|---|---|---|

| Ana | `FilledButton`: zemin `primaryContainer`, metin `onPrimary`, basılı/hover `primary` | Giriş Yap, Hesap Oluştur, Kaydet, **Mesaj At**, Gönder |

| Olumlu | `FilledButton`: zemin `tertiaryContainer`, metin `onTertiary`, ikon `handshake` | Bulundu ilanında **Bu Benim!** |

| Tonal | `FilledButton.tonal`: zemin `surfaceContainer`, metin `primary` | **Detayı Gör**, Detay |

| İkincil | `OutlinedButton` | İptal, Filtreyi temizle |

| Düşük vurgu | `TextButton` | Bağlantı benzeri eylemler |

| Tehlikeli | `FilledButton` + `error`/`onError` | İlanı sil, Hesabı sil (onay ile) |

| FAB | `FloatingActionButton.extended`, hap, `primaryContainer`/`onPrimary`, ikon `add_circle`, "Hemen İlan Ver", `floating` gölgesi | **Yalnız Keşfet** |

Bir ekranda **tek** ana buton. Yükleme sırasında buton devre dışı + içinde ilerleme göstergesi. Basınca `scale 0.95` (150 ms; hareketi azalt açıksa yok).

### Hap (kategori/filtre) — `CategoryChipBar`

- Yatay kaydırmalı, hap şekli, görsel yükseklik ≥ 36 dp, **dokunma alanı 48 dp**, ikon 15–16 dp + `labelMedium`.

- Pasif: zemin `surfaceContainerLowest`, metin `onSurfaceVariant`, `soft` gölge, ikon renkli (Kayıp: `secondary`, Bulundu: `primary`, diğerleri `primary`). Aktif: zemin `primary`, metin `onPrimary`, onay ikonu **gerekmez** (zemin + metin farkı yeterli; ayrıca `Semantics(selected: true)`).

- Satır içeriği: **Tümü** (`apps`), **Kayıp** (`crisis_alert`), **Bulundu** (`inventory_2`), **Evcil Hayvan** (`pets` → `pet`), **Elektronik** (`devices` → `electronics`+`phone`), **Cüzdan & Kimlik** (`account_balance_wallet` → `wallet`+`documents`), **Anahtarlık** (`key` → `keys`). Tek seçim.

- Harita üstü hapları farklıdır: aktif "Tümü" = `onSurface` zemin / `surface` metin; aktif "Kayıp" = `secondaryContainer`/`onSecondaryContainer`; aktif "Bulundu" = **`primary`/`onPrimary`** (mockup yeşili değiştirildi); sayı parantez içinde dinamik.

### Arama alanı ve filtre düğmesi

- Arama: zemin `surfaceContainerLowest`, köşe `radiusLg` 12, `soft` gölge, sol `search` ikonu, placeholder `onSurfaceVariant` ("Eşya adı, anahtar kelime, marka ara..."), kenarlıksız (ikon + placeholder alanı tanımlar), yükseklik 48. Arama **istemci tarafıdır** (yüklenen ilanların başlık/açıklama/yer adı).

- Filtre düğmesi (`tune`): 48×48, zemin `surfaceContainer`, ikon `primary`; filtre etkinse sağ üstte 8 dp `primary` nokta **ve** `Semantics` "Filtreler etkin".

- **Filtre sayfası** (`ListingFilterSheet`): tip (Tümü/Kayıp/Bulundu), kategori çoklu seçim (PROJECT.md kategorilerinin tümü), mesafe (1/3/5/10 km veya sınırsız; konum yoksa devre dışı + açıklama), tarih aralığı, "Uygula" ve "Temizle".

### İlan kartı (`ListingCard`)

```

┌───────────────────────────────────────┐

│ [foto 16:10, köşe 16 üstte] │

│ [● KAYIP] │ ← üst sol rozet

│ [🕒 2 saat önce] │ ← alt sol, fotoğraf üstü hap

├───────────────────────────────────────┤

│ Golden Retriever Tasmalı Köpek - Max │ ← titleMedium, en çok 2 satır

│ 📍 Kadıköy Moda Parkı · 450 m │ ← bodySmall + mesafe labelMedium primary

│ Kırmızı boyun tasması var… │ ← bodyMedium onSurfaceVariant, 2 satır

│ [ Detayı Gör ] [ 💬 Mesaj At ] │ ← 2 buton, ≥ 48 dp, eşit genişlik

└───────────────────────────────────────┘

```

- Zemin `surfaceContainerLowest`, köşe `radiusXl` 16, `card` gölgesi (Seviye 1), **kenarlık yok**. Fotoğraf `cached_network_image`, üzerine gelince (web/macOS) 1.05 yakınlaşma (300 ms; hareketi azalt açıksa yok).

- Kayıp ilanda CTA **Mesaj At** (`chat`, `primaryContainer`); Bulundu ilanında **Bu Benim!** (`handshake`, `tertiaryContainer`). Kendi ilanında ikisi yerine **Düzenle**.

- Kartın gövdesi tek dokunma hedefi (detaya gider); iç butonlar ayrıca odaklanır. `Semantics(label: "Kayıp: Siyah deri cüzdan, Mecidiyeköy metro çıkışı, 2,8 kilometre, dün akşam")`.

- Foto yoksa kategori ikonlu `surfaceContainer` zemin. Yükleme: düz gri blok iskelet (shimmer yok).

- Mesafe konum izni yoksa **gösterilmez**.

### Tip rozeti (`ListingTypeBadge`)

Hap, `labelSmall`, yükseklik ≥ 24, **metin her zaman görünür**: "● KAYIP" / "● BULUNDU" / "✓ TESLİM EDİLDİ". Renkler §2.4; harf aralığı +0.02 em. "Kayıp" noktası canlı hissi için nabız atar (yalnız hareketi azalt kapalıysa).

### Alt gezinme (dar ekran) — `AdaptiveShell`

- Sabit, yükseklik 64 dp + güvenli alan, `surface` %85 + blur, `floating` gölgesi (yüzen çubuk), kenarlık yok.

- 5 yuva: **Keşfet** (`explore`), **Harita** (`map`), **merkez +**, **Mesajlar** (`chat_bubble`), **Profil** (`person`). Etiket her zaman görünür (`labelSmall`). Aktif öğe: `primary` + kalın; pasif `onSurfaceVariant`. Her sekme ≥ 48 dp.

- **Merkez +:** 56 dp daire, `primaryContainer`, `onPrimary` `add` (28), çubuğun 20 dp üstüne taşar, `floating` gölgesi, `Semantics(label: "İlan ver")` + tooltip. Bu bir **eylemdir**: `/listings/new` açar; sekme dalı değildir.

- Okunmamış rozeti **yok** (v2).

### Gezinme (orta ve geniş ekran: `useRail`, §10.1)

`NavigationRail`, `labelType: all`, 4 hedef; `leading` olarak genişletilmiş **"İlan ver"** düğmesi (`primaryContainer`). Seçili gösterge `primaryFixed`.

### Üst başlık (`AppHeader`) ve uygulama simgesi (`AppLogo`)

Sabit, 64 dp, `surface` %80 + blur, `header` gölgesi. **Sol üstteki simge, uygulamanın simgesidir** (mağaza/ana ekran simgesiyle **aynı görsel**): `assets/branding/app_icon.png`, `AppLogo` widget'ı ile 32 dp yükseklikte, köşe `radiusMd` kırpmalı, `Semantics(label: uygulama adı)`. Yanında uygulama adı (`titleMedium`, bold). Sağda 48×48 dokunma alanlı profil avatarı (32 dp, `primary` %20 halka; fotoğraf yoksa baş harfler). Konum seçici, zil ve "TR" hapı **yok** (§0.3).

`AppLogo` tek yerde tanımlanır; başlık, giriş ekranı (72 dp) ve açılış ekranı aynı dosyayı kullanır. Kullanıcı kendi simgesini verene kadar geçici simge (§11) kullanılır ve kodda `// TODO(app_icon)` ile işaretlenir.

### Segmentli sekmeler (`AppSegmentedTabs`, `shared/widgets`)

Kap: `surfaceContainerLow`, köşe `radiusLg` 12, iç boşluk 4. Öğeler eşit genişlik, yükseklik 48, köşe `radiusMd` 8, `labelLarge`/`labelMedium`. Seçili: zemin `surfaceContainerLowest`, metin `primary`, `soft` gölge. Seçili değil: metin `onSurfaceVariant`. `Semantics(selected)`. Giriş/Kayıt, Profil (İlanlarım · Ayarlar) ve gerektiğinde başka yerlerde kullanılır.

### Form alanları

- 48 dp yükseklik, köşe `radiusMd` 8, zemin `surfaceContainerLow`, **1 dp `outline` kenarlık** (açık slate `#E2E8F0` yerine: ≥ 3:1 için), odakta 2 dp `primary` kenarlık (+ `primary` %20 dış halka), **görünür etiket** (üstte `labelLarge`; placeholder etiket yerine geçmez), başta ikon (`badge`, `alternate_email`, `lock`), şifrede sonda "göster/gizle" düğmesi (`tooltip`).

- Hata: `error` kenarlık + ikon + **metin** (renk tek başına yetmez). Yardım metni altta.

- `autofillHints` ve doğru `keyboardType`.

- **Onay kutusu:** `radiusSm` 4 köşeli kare, seçilince zemin `primaryContainer` + beyaz tik; **radyo:** daire, seçilince `primaryContainer` + iç beyaz nokta. Dokunma alanı 48 dp.

### Harita (`MapScreen`)

- Tam ekran OSM. Üstte yüzen: arama alanı + filtre düğmesi, altında hap sırası (**Tümü (n) · Kayıp (n) · Bulundu (n) · ◎ 3 km çap**). Yarıçap hapı filtre sayfasını açar.

- **Pinler** (ekranda damla biçiminde, altta kuyruklu): Kayıp = 36 dp **daire gövde** `secondaryContainer`, ikon `onSecondaryContainer`; Bulundu = 36 dp **yuvarlatılmış kare gövde** `primaryContainer`, ikon beyaz. Altta küçük döndürülmüş kare "kuyruk"; `floating` gölgesi. Seçili olmayan pinlerin üstünde de kısa ad hapı olabilir (kalabalıkta yalnız seçili pinde). İkon kategoriden (`pets`, `headphones`/`devices`, `account_balance_wallet`, `key`, `backpack`…). Seçili pin 44 dp, üstünde ad hapı (zemin pin rengi). Dokunma alanı ≥ 48 dp. **Bulundu ilanlarda pin, 250 m'lik yarı saydam `primary` daire içinde gösterilir** (PROJECT.md §6 konum gizliliği); "Yol tarifi" yoktur.

- **Kullanıcı konumu ve yarıçap:** 14 dp `primary` nokta + beyaz halka + "Sen" hapı (`primary` zemin, beyaz metin). Seçili **arama yarıçapı** konum merkezli iç içe yumuşak daireler olarak çizilir (`primary` %6–%12 dolgu, en dıştaki 1 dp `primary` %30 kenar); halkalar nabız atar (hareketi azalt açıksa yok). Yarıçap hapı ("3 km çap") bu daireyi yönetir.

- **Sağ araçlar:** `my_location` (konuma git), `add` / `remove` (zoom) — 48×48, zemin `surfaceContainerLowest`, `soft` gölge, `Semantics` etiketli.

- **Alt kart şeridi:** yatay, yakalamalı kaydırma (`PageView`/`ListView` + snap), kart genişliği 320 dp, pin seçimi ile eşlenir. Kart: foto veya kategori ikonu, rozet, mesafe, başlık, yer + zaman, kart köşe 16, `card` gölgesi, 80×80 küçük resim solda; **Detay** (tonal) + **İletişim** (Kayıp) / **Bu Benim!** (Bulundu). Ekrandaki "Yol Tarifi" düğmesi **yoktur** (§0.3). Geniş ekranda şerit yerine sağ panel (§10.2).

- Haritanın köşesinde **© OpenStreetMap** atfı her zaman görünür.

### Mesajlar

- Üstte arama ("Mesajlarda ve ilanlarda ara..."; istemci tarafı), altında **güvenlik ipucu bandı**: zemin `primaryFixed` %40, `shield` ikonu, "Önemli: Eşya tesliminde kalabalık, kamusal alanları tercih edin." + kapat (`close`, kapatma durumu `shared_preferences`'ta).

- Sohbet satırı (`ChatTile`): kart (`surfaceContainerLowest`, köşe 16, `card`), solda 44 dp **karşı tarafın avatarı** (`users/{uid}.photoUrl`, yoksa baş harfler), ortada **karşı tarafın adı** (`titleMedium`) + sağda zaman (`labelMedium`, `primary`), altında **ilan hapı** ("Bulundu: AirPods Pro" teal / "Kayıp: Golden Köpek Max" coral / "Teslim Edildi: Siyah Cüzdan" sage; metin + ikon) ve **son mesaj** (`bodyMedium`, 1 satır); sağda 56 dp **ilan küçük resmi** (`chats.listingImageUrl`, köşe 8; yoksa kategori ikonu). Okunmamış sayısı, çevrimiçi noktası ve ✓✓ yok (v2). Sekme yok (Aktif/Doğrulama yok); tek liste, `updatedAt` azalan. Ek veri: `chats.listingType`, `chats.listingImageUrl` (PROJECT.md §6).

- Alt not: "Kişisel ve finansal bilgilerini sohbette paylaşma." (**şifreleme iddiası yok**).

### Sohbet ekranı

- Gelen balon: `surfaceContainerHighest`, solda; giden: `primaryContainer` + `onPrimary`, sağda. En çok ekranın %80'i. Zaman `labelSmall`. Gönderme alanı klavyenin üstünde; "Gönder" ikon düğmesinde `tooltip`. Başlıkta ilan başlığı + üç nokta (Şikayet/Engelle).

### Profil

- **Profil kartı:** `surfaceContainerLowest`, köşe 16, `card`; ortalı avatar 96 dp (gradyan halka `primary → secondaryContainer`, 4 dp), ad (`headlineSmall`). Arka plana iki yumuşak bulanık daire (`primaryFixed` %40 ve `secondaryFixed` %50, dekoratif). "Doğrulanmış" rozeti, kullanıcı adı, güven puanı **yok**.

- **Sayaç şeridi:** 2 sütun: **Aktif İlan** (`primary`), **Teslim Edilen** (`tertiary`); sayılar kullanıcının kendi ilanlarından hesaplanır.

- **Sekmeler** (`AppSegmentedTabs`): **İlanlarım (n)** · **Ayarlar**.

- **İlanlarım satırı:** kart, solda 80×80 küçük resim (köşe 8), sağda durum rozeti + zaman, başlık (tek satır), konum. Teslim edilmiş ilan: küçük resim üstünde `task_alt` bindirmesi, rozet "✓ TESLİM EDİLDİ", alt satır "Teslim Edildi • Arşivlendi" ve **Detay** düğmesi. Açık ilan: **Düzenle** ve **Teslim edildi olarak işaretle** eylemleri.

- **Ayarlar satırı:** 48+ dp, solda ikon karosu (`surfaceContainerLow`, köşe 8), başlık (`labelLarge`) + alt başlık (`bodySmall`), sağda `chevron_right`. Satırlar: **Dil**, **Tema**, **Konum izni** (sistem ayarlarını açar), **Engellenenler**, **Gizlilik Politikası**, **Kullanım Şartları**, **Destek** (`mailto:`), **Çıkış Yap**, **Hesabı Sil** (kırmızı, en altta). Altta sürüm: "Bulundu v{sürüm}" (`package_info_plus`).

### Giriş / Kayıt

Üstten alta: **uygulama simgesi** (`AppLogo`, 72 dp, `surfaceContainerHigh` daire içinde; mockup'taki amber geri oku yok) → uygulama adı (`headlineLarge`) + yanında 8 dp `primary` nokta → slogan "Kayıplar bulunur, komşuluk güçlenir. Şehrindeki kayıp ve bulunan eşyaları anında keşfet." (`bodyMedium`, ortalı) → hap "✓ Topluluk destekli arama" (`surfaceContainerHigh`/`primary`) → **segmentli geçiş** (Giriş Yap / Kayıt Ol; `/login` ↔ `/register`) → form kartı (`surfaceContainerLowest`, köşe 16, `card`):

- Giriş: **E-posta**, **Şifre** (göster/gizle), sağda **Şifremi unuttum?** (küçük diyalog: e-posta alanı + "Bağlantı gönder"; sonuç snackbar), ana buton **Giriş Yap →**.

- Kayıt: **Ad Soyad** (1–40), **E-posta**, **Şifre** (alt yardım metni "En az 8 karakter"), onay kutusu (şart/gizlilik, bağlantılı), ana buton **Hesap Oluştur**. Onay kutusu işaretlenmeden buton devre dışıdır.

- Doğrulama: alan bazlı, gönderimde ve alandan çıkınca; hata metni alanın altında (§8). Sunucu hataları (yanlış şifre, e-posta kayıtlı, ağ yok) formun üstünde `errorContainer` bandında ve `Semantics(liveRegion: true)` ile duyurulur; hata mesajı hesabın var olup olmadığını **sızdırmaz** ("E-posta veya şifre hatalı").

- Form kartı geniş ekranda 480 dp'de ortalanır; dar ekranda tam genişlik, klavye açılınca kaydırılır (§10).

- **Sosyal giriş yoktur** (Google/Apple düğmesi, "veya şununla devam et" ayırıcısı çizilmez); giriş yalnız e-posta ve şifreyle yapılır.

- Altta geçiş metni ("Henüz hesabın yok mu? **Kayıt Ol**"); en altta "Devam ederek **Kullanım Şartları** ve **Gizlilik Politikası**'nı kabul etmiş olursun." (bağlantılı; kayıtta onay kutusu zorunlu, şart sürümü değişirse `/accept-terms` yeniden onay alır).

### Geri bildirim

- Başarı/bilgi: `SnackBar` (`inverseSurface`, 4 sn, ekran okuyucuya duyurulur). Geri alınabilir işlemlerde "Geri al".

- Yıkıcı işlem: onay `AlertDialog`'u, sonuç açıkça yazılır.

### Şikayet ve engelleme (`ReportMenuButton`)

- İlan detayı, ilan kartı menüsü, sohbet başlığı ve profilde üç nokta menüsü (`tooltip`: "Diğer işlemler") → **Şikayet et**, **Kullanıcıyı engelle**. Kendi içeriğinde gösterilmez.

- **Şikayet sayfası** (bottom sheet; geniş ekranda ortalanmış dialog): neden (radyo: Spam, Uygunsuz içerik, Dolandırıcılık, Taciz, Diğer), isteğe bağlı not (≤ 300, sayaç), "Gönder". Sonuç: snackbar "Şikayetin alındı. İnceleyeceğiz."

- **Engelleme onayı:** dialog, sonucu yazar; geri alma: Profil → Ayarlar → Engellenenler.

---

## 6. Ekran düzenleri (özet)

| Ekran | Düzen |

|---|---|

| **Giriş / Kayıt** | §5 "Giriş / Kayıt". Kayıtta şart onay kutusu ana butondan önce |

| **Keşfet** | `AppHeader` → arama + filtre → hap satırı → akış başlığı ("Yakınındaki İlanlar" + yarıçap hapı "3 km içi" ya da konum yoksa "Son İlanlar") + sıralama ("En Yeniler" ↔ "En Yakınlar") → `ListingCard` listesi → "Hemen İlan Ver" FAB. Banner yok |

| **Harita** | §5 "Harita" |

| **İlan formu** | Tek sütun: tip (segment) → başlık → kategori → açıklama → foto (≤ 3) → konum (harita seçici) → tarih → Kaydet |

| **İlan detayı** | Foto galerisi (kaydırmalı) → rozet + başlık → yer/tarih → açıklama → mini harita (Bulundu'da 250 m daire) → altta sabit ana buton: kayıp ilanda **"Bunu buldum"**, bulundu ilanında **"Bu benim"**; kendi ilanında **Düzenle** + **Teslim edildi olarak işaretle**; üç nokta menüsü (Şikayet/Engelle) |

| **Mesajlar** | §5 "Mesajlar" |

| **Profil** | §5 "Profil" |

| **Hesabı sil** | Silinecekler listesi (ilanlar, fotoğraflar, mesajlar, profil), geri alınamaz uyarısı, yeniden doğrulama, kırmızı onay butonu |

| **Şart onayı** | Kısa özet + Şartlar ve Gizlilik bağlantıları + onay kutusu + "Devam et" (onaylanana kadar devre dışı) |

Not: Keşfet kartındaki CTA ("Mesaj At") ile detaydaki CTA ("Bunu buldum") aynı sohbeti açar; kart kısa etiketi, detay açık etiketi kullanır.

---

## 7. Hareket

- Süre 150–250 ms, yumuşak `easeOutCubic`; basınca ölçek 0.95. Yalnız anlamlı hareket: basma geri bildirimi, sayfa geçişi, "Kayıp" noktası nabzı, kullanıcı konumu halkası, fotoğraf üstüne gelince yakınlaşma (web/macOS).

- Geçişler Material varsayılanları.

- **Sistem "hareketi azalt" ayarına uyulur** (`MediaQuery.disableAnimationsOf(context)` doğruysa tüm süs animasyonları kapalı/anlık).

## 8. Metin tonu (mikro kopya)

Sıcak, empatik, kısa, suçlamayan; abartılı vaat ve "garanti/güvence" yok. Emir kipi yerine yönlendirme.

| Durum | TR | EN |

|---|---|---|

| Boş liste | "Henüz ilan yok. İlk ilanı sen ver." | "No listings yet. Be the first to post." |

| Genel hata | "Bir şeyler ters gitti. Tekrar dener misin?" | "Something went wrong. Please try again." |

| İlan yayında | "İlanın yayında. Eşleşme olursa mesaj alırsın." | "Your listing is live. You'll get a message if someone responds." |

| Konum izni yok | "Konumunu kullanamıyoruz. Haritadan elle seçebilirsin." | "We can't use your location. You can pick a spot on the map." |

| Silme onayı | "Bu ilan ve fotoğrafları silinecek. Emin misin?" | "This listing and its photos will be deleted. Are you sure?" |

| Şikayet alındı | "Şikayetin alındı. İnceleyeceğiz." | "Thanks, we received your report. We'll review it." |

| Engelleme onayı | "Bu kişiyi engellersen ilanlarını ve mesajlarını görmezsin." | "If you block this person, you won't see their listings or messages." |

| Hesap silme | "Hesabın, ilanların, fotoğrafların ve mesajların kalıcı olarak silinecek. Bu işlem geri alınamaz." | "Your account, listings, photos and messages will be permanently deleted. This can't be undone." |

| Şart onayı | "Kullanım Şartları'nı ve Gizlilik Politikası'nı okudum, kabul ediyorum." | "I have read and accept the Terms of Use and Privacy Policy." |

| Slogan | "Kayıplar bulunur, komşuluk güçlenir." | "Lost things get found, neighbors grow closer." |

| Güvenlik ipucu | "Eşya tesliminde kalabalık, kamusal alanları tercih et." | "Meet in busy, public places when handing over an item." |

| Sohbet notu | "Kişisel ve finansal bilgilerini sohbette paylaşma." | "Never share personal or financial details in chat." |

| Şifre sıfırlama | "Şifre sıfırlama bağlantısını e-postana gönderdik." | "We've emailed you a password reset link." |

| Şifre kısa | "Şifre en az 8 karakter olmalı." | "Password must be at least 8 characters." |

| Geçersiz e-posta | "Geçerli bir e-posta adresi gir." | "Enter a valid email address." |

| Giriş hatalı | "E-posta veya şifre hatalı." | "Incorrect email or password." |

| E-posta kayıtlı | "Bu e-posta ile zaten bir hesap var. Giriş yapmayı dene." | "An account with this email already exists. Try signing in." |

| Konum yok (mesafe) | "Yakınındaki ilanları görmek için konum iznini aç." | "Turn on location to see listings near you." |

Hata mesajı teknik ayrıntı göstermez; ne olduğunu ve ne yapılacağını söyler.

---

## 9. Erişilebilirlik kontrol listesi (her ekran için)

- [ ] Metin kontrastı ≥ 4.5:1, ikon/kenarlık ≥ 3:1 (açık **ve** koyu tema); placeholder `onSurfaceVariant`

- [ ] Tüm dokunma hedefleri ≥ 48×48 dp (hap ve küçük düğmelerin görsel boyutu küçük olsa da dokunma alanı 48), birbirine yakın hedefler arası ≥ 8 dp

- [ ] Sistem metin ölçeği **%200**'de taşma/kırpılma yok, kaydırılabilir (kart butonları dar ekranda alt alta dizilebilir)

- [ ] İkon-only her düğmede `tooltip`/`Semantics.label`; dekoratif görsel `excludeSemantics`

- [ ] Anlamlı fotoğraflarda alternatif metin (örn. "Siyah deri cüzdan fotoğrafı")

- [ ] Bilgi renk dışında **metin ve şekille** de verilir (rozet metni, pin şekli)

- [ ] Odak sırası mantıklı; form alanlarında etiket + hata ilişkisi

- [ ] Ekran okuyucu (TalkBack/VoiceOver) ile ana akış tamamlanabilir: giriş → ilan ver → detay → mesaj

- [ ] Hareket azaltma ayarı çalışır (nabız, halka, yakınlaşma, blur dışı süsler kapanır)

- [ ] Yükleniyor / hata / boş durumları tasarlanmış ve duyurulur

---

## 10. Duyarlı düzen ve platformlar (Android · iOS · macOS · Web)

**Duyarlılık zorunludur.** Tasarım, 320 dp'lik küçük telefondan 1920 dp'lik tarayıcıya kadar, dikey ve yatay, açık/koyu temada ve %200 yazı ölçeğinde bozulmadan çalışır. Mockup **yalnız telefon** (≈ 360–412 dp) içindir; diğer genişlikler Civic Beacon'ın **ızgara ilkelerinden** türetilir (mobil 4 sütun, tablet 8 sütun, masaüstü 12 sütun, içerik en çok 1280 dp).

### 10.1 Kırılma noktaları (`shared/utils/breakpoints.dart`)

Genişlik **ekran değil, mevcut alan** üzerinden okunur (`MediaQuery.sizeOf` / `LayoutBuilder`): macOS/Chrome penceresi veya iPad bölünmüş ekranı yeniden boyutlanınca düzen anında uyum sağlar.

| Genişlik | Sınıf | Gezinme | Kenar boşluğu / aralık | Keşfet / listeler | Form, detay, giriş |

|---|---|---|---|---|---|

| < 768 dp | Dar (telefon) | Alt çubuk (merkez **+**) | 16 / 16 | Tek sütun liste, kartlar tam genişlik | Tam genişlik |

| 768–1023 dp | Orta (tablet, geniş telefon yatay, dar pencere) | Sol `NavigationRail` + "İlan ver" (yükseklik ≥ 480 ise) | 16 / 16 | 2 sütun kart ızgarası (`maxCrossAxisExtent` 400) | Ortalanmış, en çok 720 dp |

| ≥ 1024 dp | Geniş (masaüstü, tarayıcı, macOS, tablet yatay) | Sol `NavigationRail` + "İlan ver" | **32 / 24**, içerik en çok **1280 dp** ortalı | 3 sütun ızgara | Ortalanmış: form 560, detay 960 dp |

- **Gezinme kuralı:** `useRail = genişlik ≥ 768 && yükseklik ≥ 480`. Telefon **yatayında** (örn. 844×390) yükseklik 480'in altında olduğu için **alt çubuk korunur**; sütun sayısı ise yine genişliğe göre belirlenir (2 sütun). Alt çubuk ve rail arasında geçişte seçili sekme ve sayfa durumu **kaybolmaz**.

- Başlık boyutu ≥ 1024 dp'de `headlineLarge` 36/44, `headlineMedium` 28/36.

- İçerik hiçbir zaman çok geniş satıra yayılmaz: metin sütunu ≤ 720 dp (`MaxWidthBody`).

- `SafeArea` (çentik, ada, home göstergesi) ve ekran yönü her yerde desteklenir. macOS pencere asgari boyutu ≈ 480×640; pencere serbestçe boyutlandırılabilir.

### 10.2 Ekran başına düzen (zorunlu)

| Ekran | Dar (< 768) | Orta (768–1023) | Geniş (≥ 1024) |

|---|---|---|---|

| Giriş / Kayıt | Tam genişlik form, klavyede kaydırılır | 480 dp ortalı kart | 480 dp ortalı kart |

| Keşfet | Arama + hap şeridi + tek sütun kartlar + FAB | Rail + 2 sütun ızgara | Rail + 3 sütun ızgara, içerik ≤ 1280 |

| İlan detayı | Foto üstte, bilgiler altta, tek sütun, altta sabit ana buton | Ortalanmış, ≤ 720 | Foto solda (≈ 55%), bilgi/eylemler sağda; toplam ≤ 960 |

| İlan formu | Tam genişlik, tek sütun | Ortalanmış, ≤ 720 | Ortalanmış, ≤ 560; konum seçici formun altında |

| Harita | Tam ekran + alt ilan şeridi | Tam alan + alt şerit | Tam alan + **sağ panel** (360 dp, seçili ilan özeti) |

| Mesajlar | Liste → sohbet ayrı sayfa | Liste → sohbet ayrı sayfa | **Yan yana:** solda liste (360), sağda sohbet; seçili sohbet yoksa boş durum. `/chats/:chatId` rotası ve derin bağlantı aynı kalır |

| Profil / Ayarlar | Tam genişlik liste | Ortalanmış, ≤ 720 | Ortalanmış, ≤ 720 |

| Yasal / metin sayfaları | Tam genişlik | ≤ 720 | ≤ 720 |

| Dialog / sheet | Alttan sheet (köşe 24) | Alttan sheet, en çok 560 dp, ortalı | Ortalanmış dialog, 480–560 dp |

**İsteğe bağlı bölünmüş görünüm** (Civic Beacon önerisi; **zorunlu değil**, yalnız kullanıcı onaylarsa): Keşfet'te solda harita paneli + sağda kart akışı; masaüstünde üç sütun (Filtreler · Akış · Detay/Harita önizleme).

### 10.3 Duyarlılık kuralları (kod)

- **Sabit genişlik/yükseklik yok** (ham `width: 320` gibi); `Expanded`/`Flexible`, `ConstrainedBox(maxWidth)`, `Wrap`, `SliverGridDelegateWithMaxCrossAxisExtent` kullan. Izgara sütun sayısı elle yazılmaz, `maxCrossAxisExtent` belirler.

- **Taşma yok:** her `Text` için `maxLines` + `overflow` ya da `Wrap`; uzun başlık, uzun ad, uzun TR/EN çeviri ve **%200 yazı ölçeği** altında `RenderFlex overflowed` hatası olmaz. Kart butonları dar alanda alt alta dizilir.

- **Kaydırma:** form ve detay ekranları klavye açılınca (`viewInsets`) kaydırılabilir kalır, odaktaki alan klavyenin altında kalmaz; içerik dikey olarak sığmazsa kaydırılır (yatay mod dahil).

- **Yön:** dikey ve yatay desteklenir; içerik `SafeArea` ile çentik/ada/home göstergesinden kaçar.

- **Görseller:** sabit en-boy oranı (`AspectRatio` **16:10**) + `BoxFit.cover`; yükleme ve hata durumu aynı boyutu korur (zıplama yok). Küçük önizlemelerde `memCacheWidth`.

- **Dokunma/fare:** hedefler ≥ 48 dp; geniş ekranda hover ve odak halkası (§10.4).

- **Durum korunur:** pencere boyutu değişince seçili sekme, kaydırma konumu ve form içeriği **kaybolmaz** (`StatefulShellRoute`, durum yukarıda tutulur).

- **Tek karar noktası:** düzen dalları `context.isWide`, `context.useRail` ve `ResponsiveLayout` gibi yardımcılarda karar verilir; ekranlar içinde dağınık `if (width > …)` yazılmaz.

### 10.4 Duyarlılık test matrisi

Her ekran en az şu boyutlarda açılıp taşma, okunabilirlik ve dokunma hedefi açısından kontrol edilir (widget testi + elle):

| Cihaz sınıfı | Boyut (dp) | Beklenen gezinme |

|---|---|---|

| Küçük telefon | 320 × 568 | Alt çubuk |

| Telefon | 390 × 844 | Alt çubuk |

| Telefon yatay | 844 × 390 | Alt çubuk, 2 sütun |

| Tablet dikey | 768 × 1024 | Rail |

| Tablet yatay / küçük pencere | 1024 × 768 | Rail, 3 sütun |

| Masaüstü / Chrome / macOS | 1440 × 900 ve 1920 × 1080 | Rail, içerik ≤ 1280 ortalı |

Her boyut için ek olarak: yazı ölçeği **1.0 ve 2.0**, açık/koyu tema, TR/EN.

### 10.5 Fare ve klavye (web, macOS; tabletlerde de)

- **Odak halkası:** tüm etkileşimli öğelerde görünür, 2 dp `primary`, ≥ 3:1. Tab sırası görsel sırayla aynı.

- **Hover:** kart gölgesi hafif artar (açık tema) ya da `surfaceContainerHigh` tonuna geçer (koyu); butonlarda Material hover katmanı; imleç `SystemMouseCursors.click`.

- **Klavye:** Enter formu gönderir, Esc dialog/sheet kapatır, Boşluk/Enter odaklı öğeyi etkinleştirir. Sohbette Enter gönderir, Shift+Enter yeni satır.

- **Kaydırma:** masaüstü/web'de görünür `Scrollbar`; fare tekerleği ve dokunmatik yüzey desteklenir. Yatay hap/kart şeritleri fare ile sürüklenebilir (`ScrollConfiguration` ile fare sürükleme izni).

- Uzun metinler (açıklama, mesaj) **seçilebilir** (`SelectionArea`).

- Sağ tık menüsüne bağımlı özellik yok. `visualDensity: standard`, hedef ≥ 48 dp her platformda geçerli.

### 10.6 Web'e özgü

- Her rota sayfa başlığını günceller (`Title`); doğrudan `/listings/:id` açılabilir.

- Sekme simgesi ve `theme-color` = `#2563EB`; ilk yüklemede boş beyaz ekran yerine açılış göstergesi (`surface` zemin).

- Geri/ileri tarayıcı düğmeleri beklendiği gibi çalışır.

### 10.7 Platform uyumu

Material 3 kimliği her yerde aynıdır. Yalnızca `showAdaptiveDialog`, `Switch.adaptive`, iOS/macOS kenardan geri kaydırma ve tarih seçici uyarlanır; renk, tipografi, şekil **değişmez**.

### 10.8 Simgeler

Mockup **Material Symbols Outlined** kullanır. Flutter'da yerleşik `Icons.*` (outlined/rounded) kullanılır; **ek simge paketi eklenmez**. Eşleme: `explore`→`Icons.explore_outlined`, `map`→`Icons.map_outlined`, `add`→`Icons.add`, `chat_bubble`→`Icons.chat_bubble_outline`, `person`→`Icons.person_outline`, `search`→`Icons.search`, `tune`→`Icons.tune`, `crisis_alert`→`Icons.crisis_alert`, `inventory_2`→`Icons.inventory_2_outlined`, `pets`→`Icons.pets`, `devices`→`Icons.devices`, `account_balance_wallet`→`Icons.account_balance_wallet_outlined`, `key`→`Icons.key`, `location_on`→`Icons.location_on_outlined`, `schedule`→`Icons.schedule`, `handshake`→`Icons.handshake_outlined`, `task_alt`→`Icons.task_alt`, `check_circle`→`Icons.check_circle`, `my_location`→`Icons.my_location`, `shield`→`Icons.shield_outlined`, `near_me`→`Icons.near_me_outlined`. Birebir karşılığı olmayan simgede en yakın `Icons.*` seçilir ve kullanıcıya bildirilir.

---

## 11. Mağaza varlıkları ve marka

| Varlık | Ölçü / kural |

|---|---|

| **Uygulama simgesi** | **Mockup'ta sol üstteki simge, uygulamanın simgesidir.** Zip'te yalnızca kırık bir bulut bağlantısı geldi, dosya yoktu; bu yüzden palet ile bir **geçici simge** hazırlandı: `branding/app_icon.svg` + `app_icon.png` (1024×1024, `#2563EB` zemin, beyaz büyüteç, içinde `#FEA619` konum işareti; yazı yok, şeffaflık yok, köşe yuvarlatma yok) ve `app_icon_foreground.png` (Android adaptive ön planı, şeffaf, %66 güvenli alan). Dosyalar `assets/branding/` altına konur ve kodda `// TODO(app_icon)` ile **geçici** işaretlenir. Kullanıcı kendi simgesini verirse aynı adlarla değiştirilir (kare, ≥ 1024×1024, yazısız, **şeffaflık yok**; mağaza kurallarına uymuyorsa düzeltilmiş sürüm istenir). Aynı dosya üst başlıkta, giriş ekranında, açılış ekranında ve mağaza/ana ekran simgesinde kullanılır |

| Uygulama simgesi (mağaza) | 1024×1024 kare, köşeleri **yuvarlatılmamış** (sistem yuvarlar), şeffaflık yok (App Store). Kaynak: `app_icon.png`; `flutter_launcher_icons` ile tüm platformlar |

| Android adaptive | Ön plan şeffaf PNG, önemli içerik merkezdeki **%66** güvenli alanda; arka plan `#2563EB` |

| Açılış ekranı | Açık: `#F8F9FF` zemin + uygulama simgesi; koyu: `#0B1C30` zemin + uygulama simgesi (`flutter_native_splash`) |

| Ekran görüntüleri | Keşfet, Harita, İlan detayı, İlan ver, Mesajlar, Koyu tema; **TR ve EN**; iPhone, iPad, Android telefon, macOS. **Uydurma örnek veri**; gerçek kişi, gerçek fotoğraf, kişisel veri yok; §0.3'teki sahte sayı/iddialar **yok** |

| Play öne çıkan görsel | 1024×500, uygulama simgesi + "Kayıplar bulunur, komşuluk güçlenir." |

| Ton | Sıcak, güven veren; abartılı vaat ve "garanti" ifadesi yok |

Simge ve görseller `flutter_launcher_icons` ile Android, iOS, macOS ve web için üretilir.

---

## 12. Flutter uygulaması

Dosyalar: `lib/app/theme/app_colors.dart`, `app_typography.dart`, `app_spacing.dart`, `app_shadows.dart`, `app_theme.dart` (**`app_shadows.dart` yeni dosyadır**, PROJECT.md §4'e eklendi).

### `pubspec.yaml` yazı tipi bölümü

```yaml

flutter:

uses-material-design: true

fonts:

- family: PlusJakartaSans

fonts:

- asset: assets/fonts/PlusJakartaSans-Regular.ttf

weight: 400

- asset: assets/fonts/PlusJakartaSans-SemiBold.ttf

weight: 600

- asset: assets/fonts/PlusJakartaSans-Bold.ttf

weight: 700

- asset: assets/fonts/PlusJakartaSans-ExtraBold.ttf

weight: 800

```

### `app_spacing.dart`

```dart

abstract final class AppSpacing {

static const double xs = 4;

static const double sm = 8;

static const double md = 16; // margin, gutter, kart içi

static const double lg = 24; // gutter-desktop

static const double xl = 32; // margin-desktop

static const double xxl = 48;

static const double radiusSm = 4;

static const double radiusMd = 8;

static const double radiusLg = 12;

static const double radiusXl = 16;

static const double radiusSheet = 24;

static const double radiusFull = 9999;

static const double minTouchTarget = 48;

}

```

### `breakpoints.dart` (`shared/utils/`)

```dart

abstract final class Breakpoints {

static const double medium = 768; // tablet: NavigationRail başlar

static const double expanded = 1024; // masaüstü: kenar boşluğu 32, 3 sütun

static const double maxContent = 1280; // içerik üst sınırı

static const double minRailHeight = 480; // bunun altında (telefon yatay) alt çubuk kalır

}

// context_x.dart içinde:

// bool get isWide => MediaQuery.sizeOf(this).width >= Breakpoints.medium;

// bool get isExpanded => MediaQuery.sizeOf(this).width >= Breakpoints.expanded;

// bool get useRail => isWide && MediaQuery.sizeOf(this).height >= Breakpoints.minRailHeight;

```

### `app_colors.dart`

```dart

import 'package:flutter/material.dart';

abstract final class AppColors {

/// Fotoğraf üstü zaman hapı (tema bağımsız).

static const mediaOverlay = Color(0xBF213145);

static const mediaOverlayText = Color(0xFFEAF1FF);

static const lightScheme = ColorScheme(

brightness: Brightness.light,

primary: Color(0xFF004AC6),

onPrimary: Color(0xFFFFFFFF),

primaryContainer: Color(0xFF2563EB),

onPrimaryContainer: Color(0xFFEEEFFF),

primaryFixed: Color(0xFFDBE1FF),

primaryFixedDim: Color(0xFFB4C5FF),

onPrimaryFixed: Color(0xFF00174B),

onPrimaryFixedVariant: Color(0xFF003EA8),

secondary: Color(0xFF855300),

onSecondary: Color(0xFFFFFFFF),

secondaryContainer: Color(0xFFFEA619),

onSecondaryContainer: Color(0xFF684000),

secondaryFixed: Color(0xFFFFDDB8),

secondaryFixedDim: Color(0xFFFFB95F),

onSecondaryFixed: Color(0xFF2A1700),

onSecondaryFixedVariant: Color(0xFF653E00),

tertiary: Color(0xFF006242),

onTertiary: Color(0xFFFFFFFF),

tertiaryContainer: Color(0xFF007D55),

onTertiaryContainer: Color(0xFFBDFFDB),

tertiaryFixed: Color(0xFF6FFBBE),

tertiaryFixedDim: Color(0xFF4EDEA3),

onTertiaryFixed: Color(0xFF002113),

onTertiaryFixedVariant: Color(0xFF005236),

error: Color(0xFFBA1A1A),

onError: Color(0xFFFFFFFF),

errorContainer: Color(0xFFFFDAD6),

onErrorContainer: Color(0xFF93000A),

surface: Color(0xFFF8F9FF),

onSurface: Color(0xFF0B1C30),

onSurfaceVariant: Color(0xFF434655),

surfaceDim: Color(0xFFCBDBF5),

surfaceBright: Color(0xFFF8F9FF),

surfaceContainerLowest: Color(0xFFFFFFFF),

surfaceContainerLow: Color(0xFFEFF4FF),

surfaceContainer: Color(0xFFE5EEFF),

surfaceContainerHigh: Color(0xFFDCE9FF),

surfaceContainerHighest: Color(0xFFD3E4FE),

outline: Color(0xFF737686),

outlineVariant: Color(0xFFC3C6D7),

inverseSurface: Color(0xFF213145),

onInverseSurface: Color(0xFFEAF1FF),

inversePrimary: Color(0xFFB4C5FF),

surfaceTint: Color(0xFF0053DB),

);

/// Koyu tema mockup'ta yoktur; açık temadan türetilmiştir (DESIGN.md §2.2).

static const darkScheme = ColorScheme(

brightness: Brightness.dark,

primary: Color(0xFFB4C5FF),

onPrimary: Color(0xFF002A78),

primaryContainer: Color(0xFF2563EB),

onPrimaryContainer: Color(0xFFFFFFFF),

primaryFixed: Color(0xFFDBE1FF),

primaryFixedDim: Color(0xFFB4C5FF),

onPrimaryFixed: Color(0xFF00174B),

onPrimaryFixedVariant: Color(0xFF003EA8),

secondary: Color(0xFFFFB95F),

onSecondary: Color(0xFF472A00),

secondaryContainer: Color(0xFFFEA619),

onSecondaryContainer: Color(0xFF684000),

secondaryFixed: Color(0xFFFFDDB8),

secondaryFixedDim: Color(0xFFFFB95F),

onSecondaryFixed: Color(0xFF2A1700),

onSecondaryFixedVariant: Color(0xFF653E00),

tertiary: Color(0xFF4EDEA3),

onTertiary: Color(0xFF003824),

tertiaryContainer: Color(0xFF007D55),

onTertiaryContainer: Color(0xFFFFFFFF),

tertiaryFixed: Color(0xFF6FFBBE),

tertiaryFixedDim: Color(0xFF4EDEA3),

onTertiaryFixed: Color(0xFF002113),

onTertiaryFixedVariant: Color(0xFF005236),

error: Color(0xFFFFB4AB),

onError: Color(0xFF690005),

errorContainer: Color(0xFF93000A),

onErrorContainer: Color(0xFFFFDAD6),

surface: Color(0xFF0B1C30),

onSurface: Color(0xFFEAF1FF),

onSurfaceVariant: Color(0xFFC3C6D7),

surfaceDim: Color(0xFF08131F),

surfaceBright: Color(0xFF2A4562),

surfaceContainerLowest: Color(0xFF14263C), // koyu temada KART rengi

surfaceContainerLow: Color(0xFF172B43),

surfaceContainer: Color(0xFF1B314B),

surfaceContainerHigh: Color(0xFF223A57),

surfaceContainerHighest: Color(0xFF2A4562),

outline: Color(0xFF8D90A0),

outlineVariant: Color(0xFF434655),

inverseSurface: Color(0xFFEAF1FF),

onInverseSurface: Color(0xFF213145),

inversePrimary: Color(0xFF004AC6),

surfaceTint: Color(0xFFB4C5FF),

);

}

```

### `app_typography.dart`

```dart

import 'package:flutter/material.dart';

abstract final class AppTypography {

static const _family = 'PlusJakartaSans';

static const textTheme = TextTheme(

headlineLarge: TextStyle(fontFamily: _family, fontSize: 28, height: 36 / 28, fontWeight: FontWeight.w800),

headlineMedium: TextStyle(fontFamily: _family, fontSize: 22, height: 30 / 22, fontWeight: FontWeight.w700),

headlineSmall: TextStyle(fontFamily: _family, fontSize: 20, height: 28 / 20, fontWeight: FontWeight.w700),

titleLarge: TextStyle(fontFamily: _family, fontSize: 20, height: 28 / 20, fontWeight: FontWeight.w700),

titleMedium: TextStyle(fontFamily: _family, fontSize: 16, height: 24 / 16, fontWeight: FontWeight.w700),

bodyLarge: TextStyle(fontFamily: _family, fontSize: 16, height: 24 / 16, fontWeight: FontWeight.w400),

bodyMedium: TextStyle(fontFamily: _family, fontSize: 14, height: 20 / 14, fontWeight: FontWeight.w400),

bodySmall: TextStyle(fontFamily: _family, fontSize: 12, height: 16 / 12, fontWeight: FontWeight.w400),

labelLarge: TextStyle(fontFamily: _family, fontSize: 14, height: 20 / 14, fontWeight: FontWeight.w600),

labelMedium: TextStyle(fontFamily: _family, fontSize: 12, height: 16 / 12, fontWeight: FontWeight.w600, letterSpacing: 0.24),

labelSmall: TextStyle(fontFamily: _family, fontSize: 12, height: 16 / 12, fontWeight: FontWeight.w700, letterSpacing: 0.24),

);

/// Geniş ekranda (≥ 1024 dp) yalnız ekran başlıkları için.

static const wideHeadlineLarge =

TextStyle(fontFamily: _family, fontSize: 36, height: 44 / 36, fontWeight: FontWeight.w800);

static const wideHeadlineMedium =

TextStyle(fontFamily: _family, fontSize: 28, height: 36 / 28, fontWeight: FontWeight.w700);

}

```

### `app_shadows.dart`

```dart

import 'package:flutter/material.dart';

/// Koyu temada gölge yok: derinlik surfaceContainer* tonlarıyla verilir.

abstract final class AppShadows {

static List<BoxShadow> _light(bool dark, List<BoxShadow> s) => dark ? const [] : s;

/// Seviye 1: besleme kartları, filtreler.

static List<BoxShadow> card(Brightness b) => _light(b == Brightness.dark, const [

BoxShadow(color: Color(0x0D0F172A), blurRadius: 16, spreadRadius: -2, offset: Offset(0, 4)),

BoxShadow(color: Color(0x080F172A), blurRadius: 4, spreadRadius: -1, offset: Offset(0, 2)),

]);

static List<BoxShadow> soft(Brightness b) => _light(b == Brightness.dark, const [

BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),

]);

/// Seviye 2: FAB, harita pinleri, merkez +, yüzen alt çubuk.

static List<BoxShadow> floating(Brightness b) => _light(b == Brightness.dark, const [

BoxShadow(color: Color(0x2E2563EB), blurRadius: 28, spreadRadius: -4, offset: Offset(0, 12)),

BoxShadow(color: Color(0x0A0F172A), blurRadius: 10, spreadRadius: -2, offset: Offset(0, 4)),

]);

/// Modal / bottom sheet.

static List<BoxShadow> sheet(Brightness b) => _light(b == Brightness.dark, const [

BoxShadow(color: Color(0x140F172A), blurRadius: 32, offset: Offset(0, -8)),

]);

static List<BoxShadow> header(Brightness b) => _light(b == Brightness.dark, const [

BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 1)),

]);

}

```

### `app_theme.dart`

```dart

import 'package:flutter/material.dart';

import 'app_colors.dart';

import 'app_spacing.dart';

import 'app_typography.dart';

abstract final class AppTheme {

static ThemeData get light => _build(AppColors.lightScheme);

static ThemeData get dark => _build(AppColors.darkScheme);

static ThemeData _build(ColorScheme s) {

final text = AppTypography.textTheme;

final buttonShape = RoundedRectangleBorder(

borderRadius: BorderRadius.circular(AppSpacing.radiusMd),

);

const minSize = Size(AppSpacing.minTouchTarget, AppSpacing.minTouchTarget);

OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(

borderRadius: BorderRadius.circular(AppSpacing.radiusMd),

borderSide: BorderSide(color: c, width: w),

);

return ThemeData(

useMaterial3: true,

colorScheme: s,

scaffoldBackgroundColor: s.surface,

textTheme: text,

visualDensity: VisualDensity.standard,

appBarTheme: AppBarTheme(

backgroundColor: s.surface,

foregroundColor: s.onSurface,

elevation: 0,

scrolledUnderElevation: 0,

centerTitle: false,

titleTextStyle: text.titleLarge?.copyWith(color: s.onSurface),

),

// Ana buton: primaryContainer + beyaz metin (5.17:1), basılı/hover: primary.

filledButtonTheme: FilledButtonThemeData(

style: ButtonStyle(

minimumSize: const WidgetStatePropertyAll(minSize),

shape: WidgetStatePropertyAll(buttonShape),

textStyle: WidgetStatePropertyAll(text.labelLarge),

foregroundColor: WidgetStatePropertyAll(s.onPrimary),

backgroundColor: WidgetStateProperty.resolveWith((states) {

if (states.contains(WidgetState.disabled)) {

return s.onSurface.withValues(alpha: 0.12);

}

if (states.contains(WidgetState.pressed) ||

states.contains(WidgetState.hovered)) {

return s.primary;

}

return s.primaryContainer;

}),

),

),

outlinedButtonTheme: OutlinedButtonThemeData(

style: OutlinedButton.styleFrom(

minimumSize: minSize,

shape: buttonShape,

textStyle: text.labelLarge,

side: BorderSide(color: s.outline),

),

),

textButtonTheme: TextButtonThemeData(

style: TextButton.styleFrom(minimumSize: minSize, textStyle: text.labelLarge),

),

floatingActionButtonTheme: FloatingActionButtonThemeData(

backgroundColor: s.primaryContainer,

foregroundColor: s.onPrimary,

elevation: 0,

extendedTextStyle: text.labelLarge,

shape: const StadiumBorder(),

),

inputDecorationTheme: InputDecorationTheme(

filled: true,

fillColor: s.surfaceContainerLow,

hintStyle: text.bodyMedium?.copyWith(color: s.onSurfaceVariant),

border: border(s.outline),

enabledBorder: border(s.outline),

focusedBorder: border(s.primary, 2),

errorBorder: border(s.error, 2),

focusedErrorBorder: border(s.error, 2),

),

cardTheme: CardThemeData(

elevation: 0,

color: s.surfaceContainerLowest,

margin: EdgeInsets.zero,

shape: RoundedRectangleBorder(

borderRadius: BorderRadius.circular(AppSpacing.radiusXl),

),

),

chipTheme: ChipThemeData(

shape: const StadiumBorder(),

side: BorderSide.none,

backgroundColor: s.surfaceContainerLowest,

selectedColor: s.primary,

labelStyle: text.labelMedium?.copyWith(color: s.onSurfaceVariant),

secondaryLabelStyle: text.labelMedium?.copyWith(color: s.onPrimary),

checkmarkColor: s.onPrimary,

),

checkboxTheme: CheckboxThemeData(

shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusSm)),

side: BorderSide(color: s.outline, width: 2),

fillColor: WidgetStateProperty.resolveWith(

(states) => states.contains(WidgetState.selected) ? s.primaryContainer : null,

),

checkColor: WidgetStatePropertyAll(s.onPrimary),

),

radioTheme: RadioThemeData(

fillColor: WidgetStateProperty.resolveWith(

(states) => states.contains(WidgetState.selected) ? s.primaryContainer : s.outline,

),

),

navigationRailTheme: NavigationRailThemeData(

backgroundColor: s.surface,

indicatorColor: s.primaryFixed,

labelType: NavigationRailLabelType.all,

selectedIconTheme: IconThemeData(color: s.onPrimaryFixed),

unselectedIconTheme: IconThemeData(color: s.onSurfaceVariant),

selectedLabelTextStyle: text.labelSmall?.copyWith(color: s.primary),

unselectedLabelTextStyle: text.labelSmall?.copyWith(color: s.onSurfaceVariant),

),

bottomSheetTheme: BottomSheetThemeData(

backgroundColor: s.surfaceContainerLowest,

shape: const RoundedRectangleBorder(

borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusSheet)),

),

),

dividerTheme: DividerThemeData(color: s.outlineVariant, space: 1),

snackBarTheme: SnackBarThemeData(

behavior: SnackBarBehavior.floating,

backgroundColor: s.inverseSurface,

contentTextStyle: text.bodyMedium?.copyWith(color: s.onInverseSurface),

),

);

}

}

```

> `ChipThemeData` seçili etiket rengi Flutter sürümüne göre değişebilir; `CategoryChipBar` seçili/seçili değil renklerini kendisi vererek bunu garanti eder.

> `CardThemeData`, `WidgetStatePropertyAll`, `withValues` ve ColorScheme "fixed/surfaceContainer*" rolleri Flutter 3.27+ içindir. Sürüm uyuşmazlığı çıkarsa kullanıcıya sor.

> Alt gezinme ve üst başlık özel widget'lardır (`AdaptiveShell`, `AppHeader`): cam etkisi ve merkez **+** için stok `NavigationBar` yetmez.

### `app.dart` içinde

```dart

MaterialApp.router(

theme: AppTheme.light,

darkTheme: AppTheme.dark,

themeMode: ref.watch(themeModeProvider), // profile/providers/settings_providers.dart

locale: ref.watch(localeProvider), // null = sistem dili

localizationsDelegates: AppLocalizations.localizationsDelegates,

supportedLocales: AppLocalizations.supportedLocales,

routerConfig: ref.watch(appRouterProvider),

)

```

---

## 13. Tasarım "Bitti" ölçütü

- [ ] Tüm ekranlar açık ve koyu temada ve TR/EN dilinde kontrol edildi

- [ ] §0.3'teki **hiçbir** kapsam dışı/yanıltıcı öğe (sahte sayı, "uçtan uca şifreli", ödül, favori, güven puanı vb.) ekranda yok

- [ ] Kayıp = coral, Bulundu = teal, Teslim Edildi = sage; pin şekilleri farklı (daire / yuvarlatılmış kare)

- [ ] §9 erişilebilirlik listesi her ekranda geçti; en küçük metin 12 sp

- [ ] §10: dar, orta ve geniş genişlikte (telefon, tablet, macOS, Chrome) düzen doğru; telefon yatayında alt çubuk korunuyor; odak halkası ve hover çalışıyor

- [ ] Klavye ile ana akış tamamlanabiliyor (giriş → ilan ver → mesaj)

- [ ] Google/Apple girişi ve "veya şununla devam et" ayırıcısı hiçbir yerde yok; şikayet/engelle her UGC ekranında var

- [ ] §10.4 test matrisindeki **tüm boyutlarda** (320 dp'den 1920 dp'ye, dikey/yatay, yazı ölçeği 1.0 ve 2.0) taşma, kırpılma ve kapalı kalan alan yok; pencere boyutu değişince durum korunuyor

- [ ] Koda ham renk, ham yazı boyutu, ham boşluk yazılmadı (yalnızca tema, `AppSpacing`, `AppShadows`, `AppColors.mediaOverlay*`)

- [ ] Plus Jakarta Sans paketlenmiş, Türkçe karakterler doğru görünüyor

- [ ] §11 mağaza varlıkları hazır; **uygulama simgesi** (`app_icon.png`) kullanıcıdan alındı (veya "geçici" olarak işaretli) ve başlıkta, girişte, açılışta, mağaza simgesinde aynı dosya kullanılıyor

- [ ] Köşe yarıçapları (8 / 12 / 16 / 24) ve gölge seviyeleri (card / floating / sheet) Civic Beacon değerleriyle eşleşiyor

