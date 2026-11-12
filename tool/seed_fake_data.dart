import 'dart:convert';
import 'dart:io';

const apiKey = 'AIzaSyATtsvzKyU3pzkExQZ6y8U2bstY_uUMK8M';
const projectId = 'bulundu-app';

class MockUserSpec {
  const MockUserSpec({
    required this.email,
    required this.password,
    required this.displayName,
    required this.listingId,
    required this.type,
    required this.category,
    required this.title,
    required this.description,
    required this.locationName,
    required this.lat,
    required this.lng,
    required this.daysAgo,
  });

  final String email;
  final String password;
  final String displayName;
  final String listingId;
  final String type; // 'lost' | 'found'
  final String category;
  final String title;
  final String description;
  final String locationName;
  final double lat;
  final double lng;
  final int daysAgo;
}

final mockUsers = [
  const MockUserSpec(
    email: 'demo_ayse@bulundu.app',
    password: 'Bulundu1234!',
    displayName: 'Ayşe Yılmaz',
    listingId: 'seed_ayse_cuzdan',
    type: 'lost',
    category: 'wallet',
    title: 'Siyah Deri Cüzdan ve İstanbulkart',
    description: 'Kadıköy Rıhtım civarında siyah deri cüzdanımı kaybettim. İçinde kimliğim ve İstanbulkart vardı. Bulan kişi lütfen mesaj atsın.',
    locationName: 'Kadıköy Rıhtım, İstanbul',
    lat: 40.9904,
    lng: 29.0253,
    daysAgo: 2,
  ),
  const MockUserSpec(
    email: 'demo_mehmet@bulundu.app',
    password: 'Bulundu1234!',
    displayName: 'Mehmet Kaya',
    listingId: 'seed_mehmet_anahtar',
    type: 'found',
    category: 'keys',
    title: 'Mavi Kordonlu Ev Anahtarlığı Bulundu',
    description: 'Beşiktaş vapur iskelesi banklarında üzerinde 3 adet anahtar ve mavi kordon olan anahtarlık buldum. Sahibine teslim etmek istiyorum.',
    locationName: 'Beşiktaş İskelesi, İstanbul',
    lat: 41.0422,
    lng: 29.0067,
    daysAgo: 1,
  ),
  const MockUserSpec(
    email: 'demo_zeynep@bulundu.app',
    password: 'Bulundu1234!',
    displayName: 'Zeynep Çelik',
    listingId: 'seed_zeynep_airpods',
    type: 'lost',
    category: 'electronics',
    title: 'Beyaz AirPods Pro 2 Şarj Kutusu',
    description: 'Metroda Taksim - Mecidiyeköy arasında kulaklığımın şarj kutusunu düşürdüm. Gören veya bulan varsa çok sevinirim.',
    locationName: 'Mecidiyeköy Metro Durağı, İstanbul',
    lat: 41.0664,
    lng: 28.9942,
    daysAgo: 3,
  ),
  const MockUserSpec(
    email: 'demo_can@bulundu.app',
    password: 'Bulundu1234!',
    displayName: 'Can Demir',
    listingId: 'seed_can_canta',
    type: 'found',
    category: 'bag',
    title: 'Gri Sırt Çantası (İçinde Defterler Var)',
    description: 'Kadıköy Moda Parkı bankında unutulmuş gri bir sırt çantası buldum. Sahibi eşyaların detayını belirterek mesaj atabilir.',
    locationName: 'Moda Sahil Parkı, Kadıköy',
    lat: 40.9822,
    lng: 29.0278,
    daysAgo: 0,
  ),
];

Future<Map<String, String>> authenticateUser(
  HttpClient client,
  String email,
  String password,
) async {
  // 1. Try signInWithPassword
  final signInUri = Uri.parse(
    'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey',
  );
  var req = await client.postUrl(signInUri);
  req.headers.contentType = ContentType.json;
  req.write(
    jsonEncode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    }),
  );
  var resp = await req.close();
  var body = await resp.transform(utf8.decoder).join();

  if (resp.statusCode == 200) {
    final data = jsonDecode(body) as Map<String, dynamic>;
    return {
      'idToken': data['idToken'] as String,
      'localId': data['localId'] as String,
    };
  }

  // 2. Fall back to signUp
  final signUpUri = Uri.parse(
    'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey',
  );
  req = await client.postUrl(signUpUri);
  req.headers.contentType = ContentType.json;
  req.write(
    jsonEncode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    }),
  );
  resp = await req.close();
  body = await resp.transform(utf8.decoder).join();

  if (resp.statusCode == 200) {
    final data = jsonDecode(body) as Map<String, dynamic>;
    return {
      'idToken': data['idToken'] as String,
      'localId': data['localId'] as String,
    };
  }

  throw Exception('Auth failed for $email: $body');
}

Future<void> main() async {
  stdout.writeln('========================================');
  stdout.writeln('Bulundu Fake Data Seeder Başlatılıyor...');
  stdout.writeln('========================================');

  final client = HttpClient();

  try {
    for (final spec in mockUsers) {
      stdout.writeln('\n[+] İşleniyor: ${spec.displayName} (${spec.email})');

      final authData = await authenticateUser(
        client,
        spec.email,
        spec.password,
      );
      final idToken = authData['idToken']!;
      final uid = authData['localId']!;

      stdout.writeln('    -> Giriş yapıldı. UID: $uid');

      // 1. Write users/{uid} document
      final userUri = Uri.parse(
        'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/users/$uid',
      );
      final nowIso = DateTime.now().toUtc().toIso8601String();

      var req = await client.patchUrl(userUri);
      req.headers.set('Authorization', 'Bearer $idToken');
      req.headers.contentType = ContentType.json;
      req.write(
        jsonEncode({
          'fields': {
            'displayName': {'stringValue': spec.displayName},
            'termsVersion': {'integerValue': '1'},
            'acceptedTermsAt': {'timestampValue': nowIso},
            'createdAt': {'timestampValue': nowIso},
          },
        }),
      );
      var resp = await req.close();
      if (resp.statusCode != 200) {
        final err = await resp.transform(utf8.decoder).join();
        stdout.writeln('    [!] Profil güncellenemedi: $err');
      } else {
        await resp.drain();
        stdout.writeln('    -> Profil kaydedildi.');
      }

      // 2. Write listings/{listingId} document
      final eventIso = DateTime.now()
          .subtract(Duration(days: spec.daysAgo))
          .toUtc()
          .toIso8601String();

      final listingUri = Uri.parse(
        'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/listings/${spec.listingId}',
      );
      req = await client.patchUrl(listingUri);
      req.headers.set('Authorization', 'Bearer $idToken');
      req.headers.contentType = ContentType.json;
      req.write(
        jsonEncode({
          'fields': {
            'type': {'stringValue': spec.type},
            'status': {'stringValue': 'open'},
            'title': {'stringValue': spec.title},
            'category': {'stringValue': spec.category},
            'description': {'stringValue': spec.description},
            'ownerId': {'stringValue': uid},
            'ownerName': {'stringValue': spec.displayName},
            'lat': {'doubleValue': spec.lat},
            'lng': {'doubleValue': spec.lng},
            'locationName': {'stringValue': spec.locationName},
            'eventDate': {'timestampValue': eventIso},
            'imageUrls': {
              'arrayValue': {'values': []},
            },
            'createdAt': {'timestampValue': eventIso},
            'updatedAt': {'timestampValue': eventIso},
          },
        }),
      );
      resp = await req.close();
      if (resp.statusCode != 200) {
        final err = await resp.transform(utf8.decoder).join();
        stdout.writeln('    [!] İlan eklenemedi: $err');
      } else {
        await resp.drain();
        stdout.writeln(
          '    -> İlan başarıyla eklendi: "${spec.title}" [${spec.type}]',
        );
      }
    }

    stdout.writeln('\n========================================');
    stdout.writeln('BAŞARILI! 4 adet örnek ilan Firestore\'a yüklendi.');
    stdout.writeln('========================================');
    stdout.writeln(
      'Oluşturulan Demo Kullanıcılar (Giriş yapıp mesaj yanıtlamak için):',
    );
    stdout.writeln('1. demo_ayse@bulundu.app   | Şifre: Bulundu1234!');
    stdout.writeln('2. demo_mehmet@bulundu.app | Şifre: Bulundu1234!');
    stdout.writeln('3. demo_zeynep@bulundu.app | Şifre: Bulundu1234!');
    stdout.writeln('4. demo_can@bulundu.app    | Şifre: Bulundu1234!');
    stdout.writeln('========================================');
  } finally {
    client.close();
  }
}
