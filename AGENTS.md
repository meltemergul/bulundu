# Bulundu — Ajan Talimatları

Flutter + Firebase uygulaması (Android, iOS, macOS, Web). Mağazaya gönderilebilir kalite hedeflenir.

## Her görevde önce oku
1. `PROJECT.md` — kapsam, platformlar, veri modeli, rotalar, güvenlik kuralları, yapım sırası, mağaza hazırlığı
2. `DESIGN.md` — tasarım dili, bileşenler, duyarlı düzen, erişilebilirlik
3. `bulundu-flutter-firebase` skill'i (`.agents/skills/bulundu-flutter-firebase/SKILL.md`) — kod kuralları ve şablonlar

Çelişki olursa: kapsam, veri ve platform için `PROJECT.md`; görünüm için `DESIGN.md`; kod stili için skill geçerlidir.
Belgelerdeki "SKILL.md" ifadesi bu skill'i anlatır.

## Değişmez kurallar
- Feature-first yapı ve katman yönü: `presentation → providers → data → models` (PROJECT.md §4).
- Belirsiz, çelişkili veya belgede olmayan bir şey varsa **tahmin etme**; tek ve net bir soru sor.
- Paketleri PROJECT.md §3 dışında sormadan ekleme. Uygulama kimliği `com.bulundu.app` değişmez.
- `dart:io` ve `dart:html` kullanma; platform farkı tek yerde soyutlanır (SKILL.md §7A).
- Kodda sabit renk, yazı boyutu veya kullanıcı metni yok; metinler ARB'de (TR + EN).
- Komut çıktısını oku. Doğrulamadığın şeyi "çalışıyor" diye raporlama; `// ignore` ile uyarı bastırma.
- Commit yapma (commit'i kullanıcı yapar). Gizli anahtar, servis hesabı, keystore yazma veya commit etme.
