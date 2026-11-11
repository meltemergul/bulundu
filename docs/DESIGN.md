# Bulduk Design System — DESIGN.md

**Bulduk**, kayıp eşyaların topluluk gücü, güvenli doğrulama ve harita tabanlı arama ile sahiplerine kavuşmasını sağlayan modern bir kentsel dayanışma mobil uygulamasıdır. Bu doküman, uygulamanın görsel dili, tasarım prensipleri, renk paleti, tipografisi, bileşen kütüphanesi ve etkileşim standartlarını belirler.

---

## 1. Tasarım Felsefesi ve İlkeleri

1. **Güven ve Şeffaflık (Trust & Verification):**  
   Kayıp ve buluntu süreçleri hassastır. Arayüz; güven skorları, doğrulanmış kullanıcı rozetleri ve güvenli teslimat uyarıları ile kullanıcıya emniyet hissi aşılamalıdır.
2. **Kentsel Canlılık ve Dayanışma (Civic Warmth):**  
   Resmi/bürokratik bir kayıp eşya bürosu yerine; samimi, yardımsever ve mahalle ruhunu yaşatan dinamik bir tasarım dili.
3. **Anında Taranabilirlik ve Hızlı Eylem (High Scannability):**  
   Harita ve akış ekranlarında kritik bilgiler (mesafe, durum, ödül, süre) ilk bakışta filtrelenebilir renkli etiketlerle ayrışır.
4. **Hafif ve Ferah Katmanlaşma (Soft Surface Elevation):**  
   Yoğun gölgeler yerine yumuşak kenar yuvarlamaları (`rounded-2xl`, `rounded-3xl`), ince bordürler ve ferah yüzey tonları kullanılır.

---

## 2. Renk Paleti (Color Tokens)

### 2.1. Temel Marka Renkleri (Primary & Secondary)
- **Primary / Brand Blue:** `#2563eb` (Tailwind `blue-600`) — Güven, teknoloji ve kurumsal sağlamlık.
- **Primary Light / Active Tint:** `#eff6ff` (Tailwind `blue-50`) — Aktif tab arka planları, hafif vurgular.
- **Brand Navy / Dark:** `#1e293b` (Tailwind `slate-800` / `slate-900`) — Temel başlıklar ve birincil butonlar.

### 2.2. Semantik ve Durum Renkleri (Semantic Colors)
- **Kayıp Durumu (Lost / Amber Warning):**
  - Arka Plan / Çip: `#fef3c7` (Tailwind `amber-100`)
  - Metin / İkon: `#d97706` (Tailwind `amber-600`)
  - Dot Gösterge: `#f59e0b`
- **Bulundu Durumu (Found / Success Green):**
  - Arka Plan / Çip: `#dcfce7` (Tailwind `emerald-100` / `green-100`)
  - Metin / İkon: `#059669` (Tailwind `emerald-600`)
  - Dot Gösterge: `#10b981`
- **Ödül Rozeti (Reward Gold):** `#fef9c3` zemin, `#a16207` metin, altın yıldız ikonu.
- **Güven Puanı & Yapay Zeka (AI / Trust Indigo):** `#e0e7ff` zemin, `#4338ca` metin ve ışıltı ikonu.

### 2.3. Nötr ve Yüzey Renkleri (Surfaces & Neutrals)
- **Background (Ana Tuval):** `#f8f9ff` veya `#f8fafc` — Temiz, soğuk nötr zemin.
- **Surface Lowest (Kartlar ve Modallar):** `#ffffff` — Beyaz kart yüzeyleri.
- **Surface Container Low / Input Background:** `#f1f5f9` — Giriş alanları ve arama çubukları.
- **Borders & Dividers:** `#e2e8f0` (Tailwind `slate-200`) — İnce 1px sınır çizgileri.
- **Metin Hiyerarşisi:**
  - Başlıklar / Title: `#0f172a` (Slate 900)
  - Gövde Metni / Body: `#334155` (Slate 700)
  - İkincil / Açıklama: `#64748b` (Slate 500)
  - Placeholder / Devre Dışı: `#94a3b8` (Slate 400)

---

## 3. Tipografi Hiyerarşisi (Typography)

**Font Ailesi:** `Plus Jakarta Sans`, alternatif `Inter`, sans-serif.

| Seviye | Boyut / Satır Yüksekliği | Ağırlık | Kullanım Alanı |
|---|---|---|---|
| **Display / Hero** | 24px / 32px | Bold (700) | Giriş karşılama başlıkları, modal tepe başlıkları |
| **Heading 1 (H1)** | 20px / 28px | Bold (700) | Profil adı, ekran ana başlıkları |
| **Heading 2 (H2)** | 16px / 24px | SemiBold (600) | İlan kart başlıkları, bölüm başlıkları (Yakındaki İlanlar) |
| **Subhead / Pill** | 13px / 18px | Medium (500) / SemiBold | Kategori filtreleri, çip etiketleri |
| **Body (Gövde)** | 14px / 20px | Regular (400) | İlan açıklamaları, mesaj metinleri, form etiketleri |
| **Caption / Meta** | 12px / 16px | Medium (500) | Mesafe, zaman damgası, sayaç rozetleri, alt navigasyon etiketleri |

---

## 4. Spacing ve Yuvarlaklık (Spacing & Shape)

- **Grid & Safe Area:** 16px (Mobile X padding: `px-4`), dikey ritim 12px / 16px.
- **Köşe Yuvarlaklıkları (Corner Radius):**
  - **Inputs & Küçük Butonlar:** `rounded-xl` (12px)
  - **İlan Kartları & Konteynerlar:** `rounded-2xl` (16px)
  - **Öne Çıkan Modallar & Bannerlar:** `rounded-3xl` (24px)
  - **Etiketler & Rozetler (Pills):** `rounded-full` (9999px)
  - **FAB (Hızlı İlan Butonu):** `rounded-full` (w-14 h-14)
- **Gölgelendirme (Elevation):**
  - `shadow-sm`: Standart ilan kartları ve inputlar için hafif sınır hissi.
  - `shadow-lg`: Harita üzeri hareketli kartlar, bottom navigation ve yüzen aksiyon butonu (FAB).

---

## 5. UI Bileşen Standartları (UI Components)

### 5.1. Navigasyon ve Üst Çubuk (App Shell)
- **Top App Bar:**
  - Sol: Marka Logo Wordmark (`Bulduk`) + Konum Seçici Dropdown (`Kadıköy, İstanbul ▾`).
  - Sağ: Bildirim Çanı (sayı rozetiyle) + Doğrulanmış Profil Avatarı.
- **Bottom Tab Bar (Alt Bar):**
  - 5 duraklı yapı: *Keşfet*, *Harita*, **[+] Hızlı İlan Ekle FAB**, *Mesajlar* (okunmamış rozetli), *Profil*.
  - Orta buton belirgin mavi daire ve beyaz artı simgesiyle yükseltilmiş (elevated).

### 5.2. İlan Kartları (Listing Card)
- **Görsel Alanı:** 16:9 oranında fotoğraf, sol üstte durum çipi (`• Kayıp` / `• Bulundu`), sağ üstte favori ikonu, sol altta geçen süre etiketi (`2 saat önce`).
- **İçerik Alanı:**
  - İlan başlığı + Güvenilirlik oranı (`%99 Eşleşme`).
  - Konum pin ikonu ve mahalle/cadde bilgisi + yürüyüş/sürüş mesafesi.
  - Kısa özet metni (maksimum 2 satır, truncate).
- **Aksiyon Barı:**
  - Paylaşım ve görüntülenme sayaçları.
  - Hızlı CTA: Kayıp ilanı için *"Mesaj At"*, Buluntu ilanı için *"Bu Benim!"*.

### 5.3. Harita Pinleri ve Radar (Map Elements)
- **Kullanıcı Konumu:** Yanıp sönen mavi dalgalı radar halkası (`animate-ping`).
- **Kayıp Pini:** Turuncu zemin, beyaz pati/cüzdan/anahtar piktogramı + isim etiketi.
- **Bulundu Pini:** Zümrüt yeşili zemin, beyaz kilit/kulaklık simgesi.
- **Arama Çubuğu:** Harita üzerinde yüzen yarı saydam arama inputu ve katman filtreleri.

### 5.4. Doğrulama ve Güvenilirlik Öğeleri (Trust Elements)
- **Güven Skoru Kartı:** `98/100 ★ Süper Güven` göstergesi ve başarıyla çözülen vaka sayısı.
- **Rozetler:** *Hızlı Yardımsever*, *Eşya Dedektifi*, *Doğrulanmış Mahalle Gönüllüsü*.
- **Güvenlik Uyarısı Banner'ı:** Halka açık alan teslimatı ve kişisel kod doğrulaması hatırlatıcıları.

---

## 6. Mikro-Etkileşimler ve Durumlar

- **Boş Durumlar (Empty States):** "Yakınınızda henüz kayıp ilanı yok" mesajı yanında çevre yarıçapını genişletme önerisi.
- **Bildirim Rozetleri:** Canlı kırmızı / turuncu sayaçlar (`bg-red-500 text-white text-xs font-bold rounded-full`).
- **Arama ve Filtre:** Anında sonuç getiren kategori hapları (Seçildiğinde `bg-blue-600 text-white`, varsayılan `bg-white text-slate-700 border`).
