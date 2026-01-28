import '../models/reference_content.dart';

/// Comprehensive astrology articles collection
class ArticlesContent {
  static List<AstrologyArticle> getAllArticles() {
    return [
      // BEGINNER ARTICLES (1-8)
      AstrologyArticle(
        id: '1',
        title: 'Astrolojiye Başlangıç: Temel Kavramlar',
        summary: 'Astroloji dünyasına ilk adımınızı atın. Burçlar, gezegenler ve evler hakkında temel bilgiler.',
        content: '''
Astroloji, gökyüzündeki gök cisimlerinin konumlarının dünya üzerindeki olayları ve insan davranışlarını etkilediği inancına dayanan kadim bir bilim dalıdır.

## Burçlar

Zodyak kuşağı 12 eşit parçaya bölünmüştür ve her parça bir burcu temsil eder. Her burç kendine özgü enerji ve karakteristik özellikler taşır.

## Gezegenler

Her gezegen farklı bir yaşam alanını temsil eder:
- **Güneş**: Benlik, kimlik, ego
- **Ay**: Duygular, içgüdüler, bilinçaltı
- **Merkür**: İletişim, düşünce, öğrenme
- **Venüs**: Aşk, güzellik, değerler
- **Mars**: Eylem, enerji, tutku
- **Jüpiter**: Büyüme, şans, genişleme
- **Satürn**: Yapı, disiplin, karmik dersler
- **Uranüs**: Değişim, özgünlük, devrim
- **Neptün**: Rüyalar, spiritüellik, hayal gücü
- **Pluto**: Dönüşüm, güç, yeniden doğuş

## Evler

Doğum haritası 12 eve bölünür ve her ev yaşamın farklı bir alanını temsil eder. 1. ev benlikle başlar, 12. ev bilinçaltı ile sona erer.
        ''',
        category: ArticleCategory.beginners,
        publishedAt: DateTime.now().subtract(const Duration(days: 30)),
        author: 'Venus One Team',
        readTimeMinutes: 8,
        tags: ['başlangıç', 'burçlar', 'gezegenler', 'evler'],
      ),

      AstrologyArticle(
        id: '2',
        title: 'Doğum Haritası Nasıl Okunur?',
        summary: 'Natal chart yorumlama sanatının temel adımları ve dikkat edilmesi gereken noktalar.',
        content: '''
Doğum haritası, doğduğunuz anda gökyüzünün bir fotoğrafıdır. Bu haritayı okumak, kendinizi tanımanın en derin yollarından biridir.

## Adım 1: Üç Büyüklere Bakın

**Güneş Burcunuz**: Temel kimliğiniz, eğonuz ve yaşam amacınız.

**Ay Burcunuz**: Duygusal doğanız, içgüdüleriniz ve iç dünyanız.

**Yükselen Burcunuz**: Dünyaya nasıl göründüğünüz ve ilk izleniminiz.

## Adım 2: Gezegen Konumlarını İnceleyin

Her gezegenin hangi burçta ve hangi evde olduğuna bakın. Örneğin, Venüs'ünüz 7. evdeyse ilişkiler hayatınızda merkezi bir rol oynar.

## Adım 3: Açıları Analiz Edin

Gezegenler arası açılar (kavuşum, karşıtlık, üçgen, kare, altıgen) enerjilerin nasıl etkileştiğini gösterir.

## Adım 4: Ev Yöneticilerini Bulun

Her evin yöneticisi olan gezegeni ve onun konumunu inceleyin. Bu, o yaşam alanının nasıl işlediğini gösterir.

## Adım 5: Bütünü Görün

Tek tek parçalara değil, bütüne bakın. Haritadaki tekrarlayan temalar ve baskın elementler önemlidir.
        ''',
        category: ArticleCategory.beginners,
        publishedAt: DateTime.now().subtract(const Duration(days: 28)),
        author: 'Venus One Team',
        readTimeMinutes: 10,
        tags: ['doğum haritası', 'natal chart', 'yorum'],
      ),

      AstrologyArticle(
        id: '3',
        title: 'Dört Element ve Anlamları',
        summary: 'Ateş, Toprak, Hava ve Su elementlerinin astrolojideki önemi ve karakteristikleri.',
        content: '''
Astrolojide dört element, burçları ve enerjileri anlamak için temel bir çerçeve sunar.

## Ateş Elementi (Koç, Aslan, Yay)

Ateş burçları tutkulu, enerjik ve ilham vericidir. Liderlik etmeyi, macera aramayı ve spontan olmayı severler.

**Güçlü Yanları**: Cesaret, coşku, vizyon
**Zorlukları**: Sabırsızlık, düşüncesizlik

## Toprak Elementi (Boğa, Başak, Oğlak)

Toprak burçları pratik, güvenilir ve çalışkandır. Somut sonuçlar, istikrar ve maddi güvenlik ararlar.

**Güçlü Yanları**: Güvenilirlik, sabır, pratiklik
**Zorlukları**: İnatçılık, değişime direnç

## Hava Elementi (İkizler, Terazi, Kova)

Hava burçları entelektüel, iletişimci ve sosyaldir. Fikirleri, bağlantıları ve zihinsel uyarımı önemserler.

**Güçlü Yanları**: Zeka, uyum sağlama, objektiflik
**Zorlukları**: Kararsızlık, yüzeysellik

## Su Elementi (Yengeç, Akrep, Balık)

Su burçları duygusal, sezgisel ve empatiktir. Derin bağlantılar, duygusal güvenlik ve anlam ararlar.

**Güçlü Yanları**: Empati, sezgi, derinlik
**Zorlukları**: Aşırı duygusallık, savunmacılık
        ''',
        category: ArticleCategory.beginners,
        publishedAt: DateTime.now().subtract(const Duration(days: 25)),
        author: 'Venus One Team',
        readTimeMinutes: 7,
        tags: ['elementler', 'ateş', 'toprak', 'hava', 'su'],
      ),

      AstrologyArticle(
        id: '4',
        title: 'Modaliteler: Öncü, Sabit ve Değişken Burçlar',
        summary: 'Burçların hareket tarzlarını belirleyen modalite kavramı.',
        content: '''
Modaliteler, burçların enerjiyi nasıl kullandığını ve değişimle nasıl ilişkilendiğini gösterir.

## Öncü Burçlar (Koç, Yengeç, Terazi, Oğlak)

Öncü burçlar mevsim başlangıçlarını temsil eder. Başlatıcı, girişimci ve lider enerjisi taşırlar.

- Yeni projelere heyecanla başlarlar
- İnisiyatif almakta üstündürler
- Harekete geçmekte tereddüt etmezler
- Bazen bitirmekte zorlanabilirler

## Sabit Burçlar (Boğa, Aslan, Akrep, Kova)

Sabit burçlar mevsimin ortasını temsil eder. Kararlı, istikrarlı ve dayanıklı enerjileri vardır.

- Başladıkları işi bitirirler
- Değişime direnç gösterebilirler
- Sadık ve güvenilirdirler
- Bazen inatçı olabilirler

## Değişken Burçlar (İkizler, Başak, Yay, Balık)

Değişken burçlar mevsim geçişlerini temsil eder. Esnek, uyumlu ve çok yönlü enerjileri vardır.

- Değişime kolayca adapte olurlar
- Birden fazla konuyla ilgilenebilirler
- Aracı ve uzlaştırıcıdırlar
- Bazen odaklanmakta zorlanabilirler
        ''',
        category: ArticleCategory.beginners,
        publishedAt: DateTime.now().subtract(const Duration(days: 22)),
        author: 'Venus One Team',
        readTimeMinutes: 6,
        tags: ['modalite', 'öncü', 'sabit', 'değişken'],
      ),

      AstrologyArticle(
        id: '5',
        title: 'Yükselen Burç: Dış Dünyadaki Maskeniz',
        summary: 'Ascendant burcunuzun kişiliğinizi ve ilk izleniminizi nasıl şekillendirdiği.',
        content: '''
Yükselen burcunuz (Ascendant), doğduğunuz anda doğu ufkunda yükselen burçtur ve astrolojide "üç büyük"ten biridir.

## Yükselen Neden Önemli?

- **İlk İzlenim**: İnsanların sizinle ilk tanıştıklarında gördükleri
- **Fiziksel Görünüm**: Beden yapınızı ve stilinizi etkiler
- **Yaşam Yaklaşımı**: Dünyayla nasıl etkileştiğiniz
- **1. Ev Başlangıcı**: Tüm ev sisteminin temelini oluşturur

## Güneş vs Yükselen

Güneş burcunuz içsel kimliğinizi, yükselen burcunuz ise dışsal ifadenizi temsil eder. Örneğin:
- Yengeç güneşli, Koç yükselenli biri: İçten yumuşak ama dıştan cesur görünür
- Oğlak güneşli, Balık yükselenli biri: İçten hırslı ama dıştan hayalperest görünür

## Yükseleni Hesaplamak

Yükselenizi hesaplamak için doğum saatinizi ve yerinizi bilmeniz gerekir. Saat farkı bile yükseleni değiştirebilir!
        ''',
        category: ArticleCategory.beginners,
        publishedAt: DateTime.now().subtract(const Duration(days: 20)),
        author: 'Venus One Team',
        readTimeMinutes: 8,
        tags: ['yükselen', 'ascendant', 'kişilik'],
      ),

      AstrologyArticle(
        id: '6',
        title: 'Ay Burcunuz: Duygusal DNA\'nız',
        summary: 'Ay burcunuzun iç dünyanızı, duygusal ihtiyaçlarınızı ve alışkanlıklarınızı nasıl belirlediği.',
        content: '''
Ay burcunuz, güneş burcunuz kadar önemlidir çünkü duygusal doğanızı, iç dünyanızı ve temel güvenlik ihtiyaçlarınızı temsil eder.

## Ay Ne Temsil Eder?

- **Duygusal Tepkiler**: Stres altında nasıl davranırsınız
- **İç Güvenlik**: Kendinizi güvende hissetmeniz için neye ihtiyacınız var
- **Çocukluk Kalıpları**: Aileden öğrendiğiniz duygusal alışkanlıklar
- **Sezgisel Doğa**: İçgüdüleriniz ve sezgileriniz
- **Bakım Tarzı**: Başkalarını nasıl beslediğiniz

## Ay Burçlarının Özellikleri

**Ateş Ayları (Koç, Aslan, Yay)**: Duygusal ifadede spontan ve dramatik

**Toprak Ayları (Boğa, Başak, Oğlak)**: Duygusal güvenlik için pratik ihtiyaçlar

**Hava Ayları (İkizler, Terazi, Kova)**: Duyguları rasyonalize etme eğilimi

**Su Ayları (Yengeç, Akrep, Balık)**: Derin, yoğun ve empatik duygusal deneyimler

## Ay ve Anne İlişkisi

Ay burcunuz, annenizle ilişkinizi ve ondan aldığınız duygusal mirası da gösterir.
        ''',
        category: ArticleCategory.beginners,
        publishedAt: DateTime.now().subtract(const Duration(days: 18)),
        author: 'Venus One Team',
        readTimeMinutes: 9,
        tags: ['ay burcu', 'duygular', 'bilinçaltı'],
      ),

      AstrologyArticle(
        id: '7',
        title: '12 Ev Sistemi: Yaşamın Haritası',
        summary: 'Astrolojik evlerin temsil ettiği yaşam alanları ve her evin anlamı.',
        content: '''
Doğum haritasındaki 12 ev, yaşamınızın farklı alanlarını temsil eder. Her ev, belirli konuları ve deneyimleri yönetir.

## Evler ve Anlamları

**1. Ev - Benlik**: Fiziksel görünüm, kişilik, ilk izlenim

**2. Ev - Değerler**: Para, mülkiyet, öz değer

**3. Ev - İletişim**: Kardeşler, yakın çevre, kısa yolculuklar

**4. Ev - Kökler**: Ev, aile, geçmiş, duygusal temel

**5. Ev - Yaratıcılık**: Romantizm, çocuklar, hobiler, eğlence

**6. Ev - Günlük Yaşam**: Sağlık, iş rutini, hizmet

**7. Ev - Ortaklıklar**: Evlilik, iş ortakları, açık düşmanlar

**8. Ev - Dönüşüm**: Ölüm/yeniden doğuş, paylaşılan kaynaklar, cinsellik

**9. Ev - Genişleme**: Yüksek öğrenim, felsefe, uzak yolculuklar

**10. Ev - Kariyer**: Meslek, toplumsal konum, otorite figürleri

**11. Ev - Topluluk**: Arkadaşlar, gruplar, umutlar, idealler

**12. Ev - Bilinçaltı**: Gizli düşmanlar, spiritüellik, karma
        ''',
        category: ArticleCategory.beginners,
        publishedAt: DateTime.now().subtract(const Duration(days: 15)),
        author: 'Venus One Team',
        readTimeMinutes: 10,
        tags: ['evler', 'houses', 'yaşam alanları'],
      ),

      AstrologyArticle(
        id: '8',
        title: 'Astrolojik Açılar: Gezegen Diyalogları',
        summary: 'Kavuşum, karşıtlık, üçgen, kare ve altıgen açılarının anlamları.',
        content: '''
Astrolojik açılar, gezegenler arasındaki ilişkileri ve enerji etkileşimlerini gösterir.

## Majör Açılar

**Kavuşum (0°)**: İki gezegen yan yana. Enerjiler birleşir ve yoğunlaşır. Nötr açı - gezegenin doğasına bağlı.

**Karşıtlık (180°)**: İki gezegen karşı karşıya. Gerilim, farkındalık ve denge arayışı. Zor ama büyütücü.

**Üçgen (120°)**: Uyum, akış ve doğal yetenekler. En olumlu açılardan biri. Kolay ama tembelliğe yol açabilir.

**Kare (90°)**: Sürtüşme, zorluk ve büyüme potansiyeli. Zorlu ama motive edici.

**Altıgen (60°)**: Fırsatlar ve hafif destek. Olumlu ama kavuşum veya üçgen kadar güçlü değil.

## Minör Açılar

- **Yarı Kare (45°)**: Hafif gerilim
- **Yarı Karşıtlık (150°)**: Ayarlama gerektiren enerji
- **Yarı Altıgen (30°)**: Hafif destek

## Orb (Tolerans)

Açılar tam derece olmak zorunda değildir. Birkaç derece sapma (orb) kabul edilir. Güneş ve Ay için daha geniş orb kullanılır.
        ''',
        category: ArticleCategory.beginners,
        publishedAt: DateTime.now().subtract(const Duration(days: 12)),
        author: 'Venus One Team',
        readTimeMinutes: 8,
        tags: ['açılar', 'kavuşum', 'karşıtlık', 'üçgen', 'kare'],
      ),

      // RELATIONSHIP ARTICLES (9-15)
      AstrologyArticle(
        id: '9',
        title: 'İlişkilerde Astroloji: Sinastri Rehberi',
        summary: 'Sevgilinizle uyumunuzu astrolojik açıdan nasıl değerlendirebilirsiniz?',
        content: '''
Sinastri, iki kişinin doğum haritalarını karşılaştırarak ilişki dinamiklerini anlama sanatıdır.

## Önemli Sinastri Açıları

### Güneş-Ay Bağlantıları
En temel uyum göstergesidir. Bir kişinin Güneşi diğerinin Ayı ile kavuşum veya üçgen yapıyorsa, derin bir anlayış vardır.

### Venüs-Mars Bağlantıları
Romantik ve cinsel çekim. Kavuşum veya karşıtlık güçlü çekimi gösterir.

### Merkür Bağlantıları
İletişim uyumu. Merkürler arasındaki olumlu açılar, birbirinizi anlamanızı kolaylaştırır.

## 7. Ev Analizi

Her iki kişinin 7. evi (ortaklık evi) önemlidir:
- 7. ev yöneticisinin konumu
- 7. evdeki gezegenler
- 7. ev başlangıcı üzerindeki açılar

## Kırmızı Bayraklar

- Satürn karesi: Kısıtlama ve soğukluk hissi
- Neptün karesi: Yanılsama ve hayal kırıklığı riski
- Pluto karesi: Güç mücadeleleri
        ''',
        category: ArticleCategory.relationships,
        publishedAt: DateTime.now().subtract(const Duration(days: 10)),
        author: 'Venus One Team',
        readTimeMinutes: 12,
        tags: ['sinastri', 'ilişkiler', 'uyum', 'aşk'],
      ),

      AstrologyArticle(
        id: '10',
        title: 'Venüs Burcunuz ve Aşk Diliniz',
        summary: 'Venüs burcunuzun aşk, çekim ve ilişki tarzınızı nasıl şekillendirdiği.',
        content: '''
Venüs, astrolojide aşk ve güzellik gezegenidir. Venüs burcunuz, nasıl sevdiğinizi ve neyi çekici bulduğunuzu gösterir.

## Venüs Burçlarının Aşk Tarzları

**Koç Venüsü**: Tutkulu, doğrudan, kovalamacayı seven. Heyecan ve macera arar.

**Boğa Venüsü**: Sadık, duyusal, kaliteli. Fiziksel temas ve lüks önemlidir.

**İkizler Venüsü**: Oyuncu, entelektüel, değişken. Zihinsel uyarım şarttır.

**Yengeç Venüsü**: Koruyucu, romantik, nostaljik. Duygusal güvenlik önceliklidir.

**Aslan Venüsü**: Cömert, dramatik, sadık. Takdir edilmek ve özel hissetmek ister.

**Başak Venüsü**: Mütevazı, hizmet odaklı, seçici. Pratik aşk ifadeleri.

**Terazi Venüsü**: Romantik, diplomatik, güzelliğe düşkün. Denge ve uyum arar.

**Akrep Venüsü**: Yoğun, tutkulu, dönüştürücü. Ya hep ya hiç yaklaşımı.

**Yay Venüsü**: Maceracı, özgür ruhlu, iyimser. Büyüme ve keşif önemlidir.

**Oğlak Venüsü**: Ciddi, sadık, geleneksel. Uzun vadeli taahhüt değerlidir.

**Kova Venüsü**: Özgün, arkadaş canlısı, bağımsız. Zihinsel bağlantı önceliklidir.

**Balık Venüsü**: Romantik, fedakar, empatik. Ruh eşi arayışı güçlüdür.
        ''',
        category: ArticleCategory.relationships,
        publishedAt: DateTime.now().subtract(const Duration(days: 8)),
        author: 'Venus One Team',
        readTimeMinutes: 10,
        tags: ['venüs', 'aşk', 'ilişki', 'çekim'],
      ),

      AstrologyArticle(
        id: '11',
        title: 'Mars ve İlişkide Tutku',
        summary: 'Mars burcunuzun cinsellik, tutku ve çatışma tarzınızı nasıl belirlediği.',
        content: '''
Mars, eylem ve tutku gezegenidir. İlişkilerde Mars, cinsel enerjiyi, savaş tarzını ve neyin motive ettiğini gösterir.

## Mars\'ın İlişkideki Rolü

- **Cinsel Enerji**: Tutkuyu nasıl ifade edersiniz
- **Çatışma Tarzı**: Tartışmalarda nasıl davranırsınız
- **Motivasyon**: Sizi harekete geçiren şeyler
- **Girişimcilik**: İlişkide adım atma tarzınız

## Venüs-Mars Dinamiği

Venüs çekicilik, Mars ise kovalamadır. İki partnerin Venüs ve Mars\'ı arasındaki açılar kimyayı belirler.

**Venüs kavuşum Mars**: Güçlü çekim
**Venüs karşıt Mars**: Manyetik gerilim
**Venüs kare Mars**: Tutkulu ama çatışmalı
**Venüs üçgen Mars**: Doğal uyum

## Mars Burçlarının Tutku Tarzları

Ateş Mars\'ı: Hızlı, tutkulu, spontan
Toprak Mars\'ı: Duyusal, dayanıklı, pratik
Hava Mars\'ı: Zihinsel uyarım, iletişim önemli
Su Mars\'ı: Duygusal yoğunluk, sezgisel bağlantı
        ''',
        category: ArticleCategory.relationships,
        publishedAt: DateTime.now().subtract(const Duration(days: 6)),
        author: 'Venus One Team',
        readTimeMinutes: 9,
        tags: ['mars', 'tutku', 'cinsellik', 'ilişki'],
      ),

      AstrologyArticle(
        id: '12',
        title: 'Kompozit Harita: İlişkinizin Doğum Haritası',
        summary: 'İki kişinin enerjisinin birleşiminden oluşan kompozit haritanın yorumlanması.',
        content: '''
Kompozit harita, iki kişinin haritalarının matematiksel ortalamasıdır ve ilişkinin kendisinin "doğum haritası"dır.

## Kompozit Nasıl Hesaplanır?

Her iki kişinin aynı gezegenlerinin orta noktası alınır. Örneğin, sizin Güneşiniz 10° Koç, partnerinizin Güneşi 20° İkizler ise kompozit Güneş 0° Boğa olur.

## Önemli Kompozit Faktörler

**Güneş**: İlişkinin temel amacı ve kimliği

**Ay**: Duygusal iklim ve güvenlik hissi

**Venüs**: Sevgi ifadesi ve uyum

**Mars**: Ortak eylem ve tutku

**Satürn**: Zorluklar, dersler ve uzun vadelilik

## Kompozit vs Sinastri

Sinastri iki bireyin etkileşimini, kompozit ise oluşan üçüncü varlığı (ilişkiyi) gösterir. İkisi de önemlidir.

## Kompozitte Ev Konumları

Gezegenler hangi evlere düşerse, ilişkinin o yaşam alanlarında odaklandığını gösterir.
        ''',
        category: ArticleCategory.relationships,
        publishedAt: DateTime.now().subtract(const Duration(days: 4)),
        author: 'Venus One Team',
        readTimeMinutes: 11,
        tags: ['kompozit', 'ilişki haritası', 'uyum'],
      ),

      AstrologyArticle(
        id: '13',
        title: 'Burç Uyumları: Hangi Burçlar Birbirine Uyar?',
        summary: 'Element ve modalite uyumlarına göre burç çiftleri analizi.',
        content: '''
Burç uyumu, astrolojinin en popüler konularından biridir. Ancak sadece güneş burcuna bakmak yeterli değildir.

## Element Uyumları

**Ateş + Ateş**: Tutkulu ama bazen çatışmalı
**Toprak + Toprak**: İstikrarlı ama bazen monoton
**Hava + Hava**: Entelektüel ama bazen yüzeysel
**Su + Su**: Derin ama bazen aşırı duygusal

**Ateş + Hava**: Birbirini besler (harika uyum!)
**Toprak + Su**: Birbirini tamamlar (güçlü temel)
**Ateş + Toprak**: Zor ama dengeleyici
**Hava + Su**: Farklı diller, anlayış gerektirir

## Modalite Uyumları

**Öncü + Sabit**: Başlatma + sürdürme
**Sabit + Değişken**: Kararlılık + esneklik
**Öncü + Değişken**: Liderlik + uyum

## Unutmayın

Güneş burcu uyumu sadece bir faktördür. Ay, Venüs, Mars ve yükselenler de çok önemlidir. "Uyumsuz" burçlar bile mükemmel ilişkiler kurabilir!
        ''',
        category: ArticleCategory.relationships,
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        author: 'Venus One Team',
        readTimeMinutes: 8,
        tags: ['uyum', 'burç uyumu', 'elementler'],
      ),

      AstrologyArticle(
        id: '14',
        title: '7. Ev ve Evlilik Potansiyeli',
        summary: '7. evinizin ve yöneticisinin ideal partneriniz hakkında söyledikleri.',
        content: '''
7. ev, astrolojide ortaklıklar ve evlilik evidir. Bu ev, bilinçli ilişkilerimizi ve eş arayışımızı gösterir.

## 7. Ev Başlangıcı (Descendant)

Yükselenin tam karşısında yer alır. Bu burç, çektiğiniz ve aradığınız partner tipini gösterir.

**Koç Descendant**: Cesur, bağımsız partnerler
**Boğa Descendant**: Güvenilir, istikrarlı partnerler
**İkizler Descendant**: İletişimci, zeki partnerler
**Yengeç Descendant**: Koruyucu, duygusal partnerler
...ve diğerleri

## 7. Evdeki Gezegenler

**Güneş**: Evlilik yoluyla kimlik bulma
**Ay**: Duygusal güvenlik için partner ihtiyacı
**Venüs**: Doğal ilişki kişisi
**Mars**: Tutkulu ama çatışmalı ilişkiler
**Satürn**: Geç evlilik veya ciddi partner

## 7. Ev Yöneticisi

7. evin başladığı burcun yöneticisinin konumu, partner bulmayı nerede ve nasıl deneyimleyeceğinizi gösterir.
        ''',
        category: ArticleCategory.relationships,
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        author: 'Venus One Team',
        readTimeMinutes: 10,
        tags: ['7. ev', 'evlilik', 'partner', 'descendant'],
      ),

      AstrologyArticle(
        id: '15',
        title: 'Kuzey Düğümü ve Ruh Eşi Kavramı',
        summary: 'Düğüm ekseni ve karmik ilişkilerin astrolojik yorumu.',
        content: '''
Ay düğümleri, karmik hikayenizi ve ruhsal yolculuğunuzu gösterir. İlişkilerde de önemli ipuçları sunar.

## Kuzey ve Güney Düğümü

**Güney Düğümü**: Geçmiş yaşam mirası, comfort zone
**Kuzey Düğümü**: Bu yaşamın amacı, büyüme yönü

## Düğüm Bağlantıları ve Karmik İlişkiler

Birinin gezegenleri diğerinin düğümlerine değdiğinde karmik bir bağ hissedilir.

**Gezegen + Kuzey Düğümü**: Geleceğe yönelik, büyütücü
**Gezegen + Güney Düğümü**: Tanıdık, geçmişten gelen

## Ruh Eşi Göstergeleri

- Güneş/Ay kavuşum düğümler
- Venüs düğüm açıları
- 7. ev - düğüm bağlantıları
- Juno (evlilik asteroidi) açıları

## Önemli Not

"Ruh eşi" kavramı romantik değil, ruhsal büyüme için gelen ilişkiyi ifade eder. Her zaman kolay olmayabilir!
        ''',
        category: ArticleCategory.relationships,
        publishedAt: DateTime.now(),
        author: 'Venus One Team',
        readTimeMinutes: 9,
        tags: ['düğümler', 'karma', 'ruh eşi', 'ilişki'],
      ),

      // TRANSIT ARTICLES (16-22)
      AstrologyArticle(
        id: '16',
        title: 'Merkür Retrosu: Korkulacak Bir Şey Yok',
        summary: 'Merkür retrosunun gerçek anlamı ve bu dönemi nasıl verimli geçirebilirsiniz.',
        content: '''
Merkür retrosu, astrolojide en çok konuşulan dönemdir. Yılda 3-4 kez gerçekleşir ve her biri yaklaşık 3 hafta sürer.

## Merkür Retrosu Nedir?

Dünya'dan bakıldığında Merkür'ün geriye hareket ediyor gibi görünmesidir. Aslında gezegen geriye gitmiyor, bu bir optik illüzyon.

## Etkileri

- İletişim aksaklıkları
- Teknoloji sorunları
- Seyahat gecikmeleri
- Yanlış anlaşılmalar
- Geçmişten gelen konular

## Yapılması Gerekenler

✓ Yedek alın (veriler, belgeler)
✓ Detaylara dikkat edin
✓ Eski projeleri tamamlayın
✓ Eski arkadaşlarla bağlantı kurun
✓ Düşünün, araştırın, revize edin

## Kaçınılması Gerekenler

✗ Büyük sözleşmeler imzalamak
✗ Yeni teknoloji satın almak
✗ Yeni projelere başlamak
✗ Önemli kararlar vermek

## Gölge Dönemleri

Retro öncesi ve sonrası 2 haftalık gölge dönemleri de dikkat gerektirir.
        ''',
        category: ArticleCategory.currentTransits,
        publishedAt: DateTime.now().subtract(const Duration(days: 14)),
        author: 'Venus One Team',
        readTimeMinutes: 7,
        tags: ['merkür', 'retro', 'transit'],
      ),

      AstrologyArticle(
        id: '17',
        title: 'Venüs Retrosu ve Aşk Hayatınız',
        summary: 'Her 18 ayda bir gerçekleşen Venüs retrosunun ilişkilere etkisi.',
        content: '''
Venüs retrosu yaklaşık 40 gün sürer ve 18 ayda bir gerçekleşir. Aşk, güzellik ve değerler gezegeninin geriye hareketi önemli dönemlerden biridir.

## Venüs Retrosu Etkileri

- Eski aşkların geri dönmesi
- Mevcut ilişkilerin sorgulanması
- Değerlerin yeniden değerlendirilmesi
- Finansal gözden geçirmeler
- Güzellik ve stil değişiklikleri

## İlişkilerde Ne Beklenmeli?

Bu dönemde:
- Eski sevgilileri düşünebilirsiniz
- İlişkinizi sorgulamanız normal
- Yeni ilişkilere acele etmeyin
- Büyük aşk kararları vermeyin

## Fırsata Çevirmek

- İlişki kalıplarınızı analiz edin
- Neyi gerçekten değerli bulduğunuzu keşfedin
- Geçmiş ilişkilerden ders çıkarın
- Öz değerinizi yeniden değerlendirin

## Güzellik Değişiklikleri

Saç kesimi, estetik müdahaleler gibi değişiklikler için ideal değil. Sonuçtan memnun kalmayabilirsiniz.
        ''',
        category: ArticleCategory.currentTransits,
        publishedAt: DateTime.now().subtract(const Duration(days: 11)),
        author: 'Venus One Team',
        readTimeMinutes: 8,
        tags: ['venüs', 'retro', 'aşk', 'ilişki'],
      ),

      AstrologyArticle(
        id: '18',
        title: 'Satürn Dönüşü: 29 Yaş Krizi',
        summary: 'Satürn\'ün doğum konumuna döndüğü büyük yaşam dönüm noktası.',
        content: '''
Satürn dönüşü, Satürn'ün doğum haritanızdaki konumuna geri döndüğü zamandır. İlki 27-30 yaş civarında gerçekleşir.

## Satürn Döngüsü

- **1. Dönüş**: 27-30 yaş
- **2. Dönüş**: 56-60 yaş
- **3. Dönüş**: 84-90 yaş

## 1. Satürn Dönüşü

Bu dönemde:
- Gerçek yetişkinliğe geçiş
- Temelsiz yapıların çökmesi
- Kariyer ve yaşam yönü sorgulanması
- Ciddi ilişki kararları
- Sorumluluk üstlenme

## Belirtiler

- Yorgunluk ve baskı hissi
- Yaşam sorgulaması
- Kısıtlamalar ve engeller
- Yapı değişikliği ihtiyacı

## Bu Dönemden Geçmek

1. Gerçekçi olun
2. Sağlam temeller atın
3. Olgunluğu kucaklayın
4. Sahte olan ne varsa bırakın
5. Sabırlı olun - yaklaşık 2.5 yıl sürer
        ''',
        category: ArticleCategory.currentTransits,
        publishedAt: DateTime.now().subtract(const Duration(days: 9)),
        author: 'Venus One Team',
        readTimeMinutes: 10,
        tags: ['satürn', 'dönüşü', '29 yaş', 'olgunluk'],
      ),

      AstrologyArticle(
        id: '19',
        title: 'Jüpiter Transitleri ve Şans Dönemleri',
        summary: 'Şans ve genişleme gezegeni Jüpiter\'in transitlerinden nasıl faydalanabilirsiniz.',
        content: '''
Jüpiter, astrolojinin "büyük iyileştirici"sidir. Her burçta yaklaşık 1 yıl kalır ve değdiği yerlere büyüme ve fırsatlar getirir.

## Jüpiter Ne Yapar?

- Genişletir ve büyütür
- Fırsatlar sunar
- İyimserlik getirir
- Aşırılığa yol açabilir

## Ev Transitleri

**Jüpiter 1. evde**: Kişisel büyüme, yeni başlangıçlar
**Jüpiter 2. evde**: Finansal fırsatlar
**Jüpiter 7. evde**: İlişki fırsatları, evlilik
**Jüpiter 10. evde**: Kariyer atılımı

## Jüpiter Dönüşü

Her 12 yılda Jüpiter doğum konumuna döner (12, 24, 36, 48... yaşlar). Bu özellikle şanslı ve genişleme dolu yıllardır.

## Dikkat Edilmesi Gerekenler

- Aşırıya kaçmamak
- Şişmanlık riski
- Abartılı iyimserlik
- Detayları gözden kaçırma
        ''',
        category: ArticleCategory.currentTransits,
        publishedAt: DateTime.now().subtract(const Duration(days: 7)),
        author: 'Venus One Team',
        readTimeMinutes: 8,
        tags: ['jüpiter', 'transit', 'şans', 'fırsat'],
      ),

      AstrologyArticle(
        id: '20',
        title: 'Tutulmalar ve Kader Anları',
        summary: 'Güneş ve Ay tutulmalarının astrolojik önemi ve hayatınıza etkileri.',
        content: '''
Tutulmalar, astrolojide en güçlü kozmik olaylardan biridir. Yılda 4-6 tutulma gerçekleşir.

## Tutulma Türleri

**Güneş Tutulması** (Yeni Ay\'da): Yeni başlangıçlar, kapıların açılması

**Ay Tutulması** (Dolunay\'da): Sonuçlanmalar, ortaya çıkışlar

## Tutulmalar Neden Güçlü?

Tutulmalar Ay düğümleri yakınında gerçekleşir, bu yüzden karmik ve kadersel niteliktedir.

## Tutulmanın Etkisi

- Doğum haritanızda hangi eve düşerse o alan etkilenir
- Etkisi 6 ay öncesi ve sonrasına yayılabilir
- Kadersel olaylar tetiklenir
- Ani değişimler mümkün

## Tutulma Döneminde

✓ Olaylara dikkat edin
✓ Kapanan kapıları zorlamayın
✓ Açılan fırsatları değerlendirin
✓ Meditasyon ve içsel çalışma

✗ Büyük kararlar vermeyin
✗ Ritüeller için ideal değil
✗ Aceleci davranmayın
        ''',
        category: ArticleCategory.currentTransits,
        publishedAt: DateTime.now().subtract(const Duration(days: 5)),
        author: 'Venus One Team',
        readTimeMinutes: 9,
        tags: ['tutulma', 'güneş tutulması', 'ay tutulması', 'kader'],
      ),

      AstrologyArticle(
        id: '21',
        title: 'Pluto Transitleri: Derin Dönüşüm',
        summary: 'Pluto\'nun zorlu ama dönüştürücü transitlerini anlamak.',
        content: '''
Pluto en yavaş hareket eden ana gezegendir. Bir burçta 12-31 yıl kalır ve değdiği yerlerde köklü dönüşümler yaratır.

## Pluto\'nun Doğası

- Yıkım ve yeniden yapım
- Güç dinamikleri
- Derin psikolojik süreçler
- Ölüm ve yeniden doğuş metaforu
- Kontrolü bırakma

## Ev Transitleri

**Pluto 1. evde**: Kimlik dönüşümü
**Pluto 4. evde**: Aile ve köklerin dönüşümü
**Pluto 7. evde**: İlişkilerde güç mücadelesi
**Pluto 10. evde**: Kariyer ve statü dönüşümü

## Pluto\'yla Baş Etmek

1. Kontrol etmeye çalışmayın
2. Direnmek işe yaramaz
3. Gölgenizle yüzleşin
4. Bırakmanız gerekeni bırakın
5. Dönüşüme güvenin

## Zaman Çerçevesi

Pluto transitleri yıllarca sürer. Sabır gerektirir ama sonuç kalıcı dönüşümdür.
        ''',
        category: ArticleCategory.currentTransits,
        publishedAt: DateTime.now().subtract(const Duration(days: 3)),
        author: 'Venus One Team',
        readTimeMinutes: 10,
        tags: ['pluto', 'transit', 'dönüşüm', 'güç'],
      ),

      AstrologyArticle(
        id: '22',
        title: 'Uranüs Transitleri: Beklenmedik Değişimler',
        summary: 'Özgürlük ve devrim gezegeni Uranüs transitlerinin etkileri.',
        content: '''
Uranüs, değişim ve özgürlük gezegenidir. Bir burçta 7 yıl kalır ve ani, beklenmedik olaylar getirir.

## Uranüs\'ün Doğası

- Ani değişimler
- Özgürlük arayışı
- Gelenek karşıtlığı
- Teknoloji ve yenilik
- Bağımsızlık

## Ev Transitleri

**Uranüs 1. evde**: Kişisel devrim, görünüm değişikliği
**Uranüs 4. evde**: Ev/aile yapısında beklenmedik değişimler
**Uranüs 7. evde**: İlişkilerde özgürlük ihtiyacı, ani ayrılıklar
**Uranüs 10. evde**: Kariyer değişikliği, bağımsız çalışma

## Uranüs Karşıtlığı (40-42 yaş)

"Orta yaş krizi" olarak bilinen bu transit, otantik benliğinize dönme çağrısıdır.

## Uranüs\'le Baş Etmek

- Esnekliği koruyun
- Değişime direnmeyin
- Özgünlüğünüzü keşfedin
- Rutinleri sorgulamaktan korkmayın
        ''',
        category: ArticleCategory.currentTransits,
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        author: 'Venus One Team',
        readTimeMinutes: 8,
        tags: ['uranüs', 'transit', 'değişim', 'özgürlük'],
      ),

      // CAREER ARTICLES (23-26)
      AstrologyArticle(
        id: '23',
        title: '10. Ev ve Kariyer Yolunuz',
        summary: '10. eviniz ve Midheaven burcunuzun kariyer potansiyeliniz hakkında söyledikleri.',
        content: '''
10. ev, astrolojide kariyer, toplumsal konum ve kamusal imaj evidir. Bu ev, profesyonel hayatınızı şekillendirir.

## Midheaven (MC)

10. evin başlangıç noktası olan Midheaven, kariyer yolunuzu ve toplum içindeki rolünüzü gösterir.

**Koç MC**: Liderlik, girişimcilik, rekabetçi alanlar
**Boğa MC**: Finans, sanat, konfor sektörleri
**İkizler MC**: İletişim, medya, eğitim
**Yengeç MC**: Bakım, ev, gıda sektörleri
**Aslan MC**: Eğlence, yaratıcılık, yöneticilik
**Başak MC**: Sağlık, analiz, hizmet
**Terazi MC**: Hukuk, diplomasi, güzellik
**Akrep MC**: Psikoloji, finans, araştırma
**Yay MC**: Eğitim, yayıncılık, seyahat
**Oğlak MC**: Yönetim, yapı, geleneksel alanlar
**Kova MC**: Teknoloji, insancıl işler, yenilik
**Balık MC**: Sanat, sağlık, spiritüel işler

## 10. Ev Yöneticisi

MC burcunun yöneticisinin konumu, kariyerinizi nasıl bulacağınızı gösterir.

## 10. Evdeki Gezegenler

10. evde gezegen varsa kariyer hayatınızda o enerjiler baskındır.
        ''',
        category: ArticleCategory.career,
        publishedAt: DateTime.now().subtract(const Duration(days: 13)),
        author: 'Venus One Team',
        readTimeMinutes: 11,
        tags: ['kariyer', '10. ev', 'midheaven', 'meslek'],
      ),

      AstrologyArticle(
        id: '24',
        title: 'Merkür ve İletişim Becerileri',
        summary: 'Merkür burcunuzun düşünce ve iletişim tarzınızı nasıl şekillendirdiği.',
        content: '''
Merkür, zihin ve iletişim gezegenidir. Merkür burcunuz, nasıl düşündüğünüzü ve iletişim kurduğunuzu gösterir.

## Merkür Burçlarının Düşünce Tarzları

**Ateş Merkürü** (Koç, Aslan, Yay): Hızlı, doğrudan, ilham dolu. Büyük resmi görür ama detayları atlayabilir.

**Toprak Merkürü** (Boğa, Başak, Oğlak): Pratik, sistematik, somut. Yavaş ama kapsamlı düşünür.

**Hava Merkürü** (İkizler, Terazi, Kova): Analitik, objektif, meraklı. Fikirleri kolayca birleştirir.

**Su Merkürü** (Yengeç, Akrep, Balık): Sezgisel, empatik, sembolik. Duyguları düşünceye entegre eder.

## İş Hayatında Merkür

- Müzakereler ve anlaşmalar
- Yazılı ve sözlü iletişim
- Öğrenme ve öğretme
- Problem çözme yaklaşımı

## Merkür Evleri

Merkür hangi evdeyse, o alanda iletişim ve düşünce odaklı olursunuz.
        ''',
        category: ArticleCategory.career,
        publishedAt: DateTime.now().subtract(const Duration(days: 10)),
        author: 'Venus One Team',
        readTimeMinutes: 8,
        tags: ['merkür', 'iletişim', 'düşünce', 'kariyer'],
      ),

      AstrologyArticle(
        id: '25',
        title: '6. Ev: Günlük İş ve Rutinler',
        summary: '6. evinizin çalışma tarzınızı, sağlığınızı ve günlük rutinlerinizi nasıl etkilediği.',
        content: '''
6. ev, günlük çalışma ortamınızı, sağlık alışkanlıklarınızı ve hizmet etme tarzınızı gösterir.

## 6. Ev ve Çalışma

Bu ev, "büyük kariyer" olan 10. evden farklı olarak günlük işlerinizi ve çalışma ortamınızı gösterir.

**6. Ev Başlangıcı Burcu**: İdeal çalışma ortamınız
**6. Evdeki Gezegenler**: Çalışma enerjiniz
**6. Ev Yöneticisi**: İş bulma tarzınız

## 6. Ev ve Sağlık

Bu ev aynı zamanda fiziksel sağlık ve wellness rutinlerinizi gösterir.

- Beslenme alışkanlıkları
- Egzersiz tercihleri
- Stres yönetimi
- Hastalık eğilimleri

## 6. Ev ve Hizmet

Bu ev, başkalarına nasıl hizmet ettiğinizi de gösterir. Gönüllülük, yardım ve pratik destek bu evin konularıdır.

## Sağlıklı Rutinler Oluşturmak

6. evinizin burcuna göre uygun rutinler geliştirmek sağlığınızı destekler.
        ''',
        category: ArticleCategory.career,
        publishedAt: DateTime.now().subtract(const Duration(days: 8)),
        author: 'Venus One Team',
        readTimeMinutes: 9,
        tags: ['6. ev', 'sağlık', 'rutin', 'çalışma'],
      ),

      AstrologyArticle(
        id: '26',
        title: 'Jüpiter ve Satürn: Kariyer İkilisi',
        summary: 'Bu iki gezegenin kariyer ve başarı üzerindeki birlikte etkileri.',
        content: '''
Jüpiter ve Satürn, kariyer açısından en önemli iki gezegendir. Biri büyütür, diğeri yapılandırır.

## Jüpiter: Genişleme

- Fırsatları gösterir
- Hangi alanda şanslısınız
- Büyüme ve gelişme potansiyeli
- Risk alma kapasitesi

## Satürn: Yapı

- Zorluklarınız ve dersleriniz
- Disiplin ve çalışkanlık alanları
- Uzun vadeli başarı potansiyeli
- Otorite ve sorumluluk

## Jüpiter-Satürn Dengesi

Başarı için her ikisi de gereklidir:
- Jüpiter vizyonu verir
- Satürn gerçekleştirir

## Büyük Kavuşum

Her 20 yılda Jüpiter ve Satürn kavuşumu, toplumsal ve kariyer döngülerinde önemli bir başlangıçtır.

## Haritanızda

Bu iki gezegenin konumu, evleri ve açıları kariyer hikayenizi anlatır.
        ''',
        category: ArticleCategory.career,
        publishedAt: DateTime.now().subtract(const Duration(days: 6)),
        author: 'Venus One Team',
        readTimeMinutes: 10,
        tags: ['jüpiter', 'satürn', 'kariyer', 'başarı'],
      ),

      // SPIRITUAL ARTICLES (27-30)
      AstrologyArticle(
        id: '27',
        title: 'Kuzey ve Güney Düğümü: Ruhsal Yolculuk',
        summary: 'Ay düğümlerinin gösterdiği karmik geçmiş ve ruhsal amaç.',
        content: '''
Ay düğümleri, güneş yörüngesi ile ay yörüngesinin kesiştiği noktalardır. Astrolojide ruhsal evrimizimin yolunu gösterir.

## Güney Düğümü

Geçmiş yaşam yeteneklerinizi ve konfor alanınızı gösterir. Bu enerjiler size tanıdık gelir ama gelişiminizi engelleyebilir.

## Kuzey Düğümü

Bu yaşamdaki ruhsal amacınızı gösterir. Buraya doğru büyümek zor ama tatmin edicidir.

## Düğüm Burçları

**Koç ND / Terazi GD**: Bağımsızlığı öğrenmek
**Boğa ND / Akrep GD**: Basitlik ve huzur
**İkizler ND / Yay GD**: Detayları ve dinlemeyi öğrenmek
**Yengeç ND / Oğlak GD**: Duygusal güvenlik
**Aslan ND / Kova GD**: Bireysel ifade
**Başak ND / Balık GD**: Pratiklik ve düzen

## Düğüm Evleri

Düğümlerinizin evleri, bu ruhsal yolculuğun hangi yaşam alanlarında gerçekleştiğini gösterir.
        ''',
        category: ArticleCategory.spirituality,
        publishedAt: DateTime.now().subtract(const Duration(days: 4)),
        author: 'Venus One Team',
        readTimeMinutes: 12,
        tags: ['düğümler', 'karma', 'ruhsal yolculuk', 'amaç'],
      ),

      AstrologyArticle(
        id: '28',
        title: '12. Ev: Bilinçaltı ve Spiritüellik',
        summary: '12. evin gizemli dünyası ve spiritüel potansiyeli.',
        content: '''
12. ev, astrolojinin en gizemli evidir. Bilinçaltı, spiritüellik ve gizli düşmanları temsil eder.

## 12. Ev Temaları

- Bilinçaltı kalıplar
- Spiritüel pratikler
- Gizli kendini sabotaj
- Kurumlar (hastane, hapishane, manastır)
- Kaçış ve yalnızlık
- Kollektif bilinç

## 12. Evdeki Gezegenler

**Güneş**: Bilinçaltında kimlik arayışı
**Ay**: Gizli duygusal dünya
**Venüs**: Gizli aşklar, sanat yeteneği
**Mars**: Bastırılmış öfke
**Neptün**: Güçlü spiritüel bağlantı

## 12. Ev ve Şifa

Bu ev aynı zamanda şifa potansiyelinizi gösterir. Başkalarına görünmeyen şekillerde yardım etme yeteneği.

## Meditasyon ve İçsel Çalışma

12. ev güçlü olanlar meditasyon, terapi ve spiritüel pratiklerden çok fayda görür.
        ''',
        category: ArticleCategory.spirituality,
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        author: 'Venus One Team',
        readTimeMinutes: 10,
        tags: ['12. ev', 'bilinçaltı', 'spiritüellik', 'meditasyon'],
      ),

      AstrologyArticle(
        id: '29',
        title: 'Neptün: Rüyalar ve İlham',
        summary: 'Neptün\'ün spiritüel, sanatsal ve romantik etkileri.',
        content: '''
Neptün, astrolojinin en spiritüel gezegenidir. Hayal gücü, ilham, rüyalar ve spiritüellik ile ilgilidir.

## Neptün\'ün Doğası

- Sınırların çözülmesi
- İlham ve yaratıcılık
- Spiritüel bağlantı
- Kaçış ve hayal
- Empati ve şefkat

## Neptün\'ün Zorlukları

- Yanılsama ve aldanma
- Gerçeklikten kaçış
- Bağımlılık eğilimleri
- Sınır eksikliği
- Kurban psikolojisi

## Neptün Burçları

Neptün bir burçta 14 yıl kaldığı için nesil etkisidir.

## Haritanızda Neptün

- **Ev konumu**: Hangi alanda hayal gücü ve ilham var
- **Açıları**: Nasıl ifade ediliyor
- **Güç/zayıflık**: Güçlü Neptün = güçlü sezgi

## Neptün\'le Çalışmak

Sanat, müzik, meditasyon, şifa pratikleri ve spiritüel arayış Neptün enerjisini olumlu yönlendirir.
        ''',
        category: ArticleCategory.spirituality,
        publishedAt: DateTime.now(),
        author: 'Venus One Team',
        readTimeMinutes: 9,
        tags: ['neptün', 'spiritüellik', 'rüyalar', 'ilham'],
      ),

      AstrologyArticle(
        id: '30',
        title: 'Kiron: Yaralı Şifacı',
        summary: 'Kiron asteroidi ve derin yaralarımızı şifaya dönüştürme potansiyelimiz.',
        content: '''
Kiron, Satürn ve Uranüs arasında yörüngesi olan bir asteroittir. "Yaralı Şifacı" arketipi ile bilinir.

## Kiron Mitolojisi

Kiron, mitolojide yarısı insan yarısı at olan bir centaur\'dur. Büyük bir şifacı olmasına rağmen kendi yarasını iyileştiremez.

## Kiron\'un Astrolojik Anlamı

- Derin, iyileşmeyen yaralar
- Şifa yeteneği
- Kırılganlık ve güç
- Öğretmenlik potansiyeli
- Başkalarına yardım yoluyla şifa

## Kiron Burçları

**Koç Kiron**: Kimlik ve öz değer yaraları
**Boğa Kiron**: Güvenlik ve değer yaraları
**İkizler Kiron**: İletişim ve ifade yaraları
...

## Kiron Dönüşü (50 yaş civarı)

Kiron\'un doğum konumuna dönmesi, yaralarla barışma ve şifacı potansiyeli aktive etme zamanıdır.

## Şifacı Olmak

Kiron güçlü olanlar, kendi yaralarını deneyimledikleri için başkalarına derin empatiyle yardım edebilir.
        ''',
        category: ArticleCategory.spirituality,
        publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
        author: 'Venus One Team',
        readTimeMinutes: 10,
        tags: ['kiron', 'şifa', 'yara', 'dönüşüm'],
      ),

      // TRENDING/POPULAR ARTICLES (31-40)
      AstrologyArticle(
        id: '31',
        title: 'Ay Fazları ve Manifestasyon Ritüelleri',
        summary: 'Her ay fazına uygun manifestasyon teknikleri ve niyet belirleme.',
        content: '''
Ay'ın 29.5 günlük döngüsü, manifestasyon ve niyet belirleme için güçlü bir çerçeve sunar.

## Yeni Ay: Tohum Ekme

Yeni Ay karanlıktır - yeni başlangıçlar için ideal zaman.

**Ritüel Önerileri:**
- Niyet listesi yazın (elle, kağıda)
- Yeni Ay meditasyonu
- Vizyon panosu oluşturun
- Yeni projeler başlatın
- Sessizlik ve içe dönüş

## Hilal Ay: Büyüme

İnancınızı güçlendirin, eyleme geçin.

## İlk Dördün: Eylem

Engellerle yüzleşin, kararlılık gösterin.

## Kabaran Ay: İnce Ayar

Stratejinizi gözden geçirin, sabırlı olun.

## Dolunay: Hasat ve Şükür

Dolunay, enerjinin doruğudur. Manifestasyonların gerçekleşme zamanı.

**Ritüel Önerileri:**
- Şükür listesi yazın
- Bırakma ritüeli
- Dolunay banyosu
- Kristal şarj etme
- Meditasyon ve enerji çalışması

## Azalan Ay: Arınma

Bırakmak istediğiniz şeyleri serbest bırakın.
        ''',
        category: ArticleCategory.spirituality,
        publishedAt: DateTime.now().subtract(const Duration(hours: 6)),
        author: 'Venus One Team',
        readTimeMinutes: 11,
        tags: ['ay fazları', 'manifestasyon', 'ritüel', 'niyet'],
      ),

      AstrologyArticle(
        id: '32',
        title: 'Burç Burcuna Sabah Ritüelleri',
        summary: 'Güneş burcunuza göre ideal sabah rutini ve enerji yönetimi.',
        content: '''
Her burcun enerjisi farklıdır. Burç özelliklerinize uygun bir sabah rutini oluşturmak gününüzü dönüştürebilir.

## Ateş Burçları (Koç, Aslan, Yay)

**İdeal Uyanış**: Erken, enerjik
**Ritüeller**:
- Dinamik egzersiz veya yoga
- Motivasyon müziği
- Günün niyetini yüksek sesle söyleyin
- Kırmızı veya turuncu içeren kahvaltı

## Toprak Burçları (Boğa, Başak, Oğlak)

**İdeal Uyanış**: Yavaş, ritüellerle
**Ritüeller**:
- Sabit bir uyku-uyanma saati
- Dokunsal deneyimler (yumuşak havlu, güzel koku)
- Besleyici kahvaltı
- Günlük planlama ve liste yapma

## Hava Burçları (İkizler, Terazi, Kova)

**İdeal Uyanış**: Uyarıcı, değişken
**Ritüeller**:
- Sabah haberleri veya podcast
- Sosyal medya kontrolü (sınırlı)
- Hafif stretching
- Günlük yazma veya sesli düşünme

## Su Burçları (Yengeç, Akrep, Balık)

**İdeal Uyanış**: Nazik, kademeli
**Ritüeller**:
- Rüya günlüğü tutma
- Meditasyon veya dua
- Su ile arınma
- Sezgisel kart çekme
        ''',
        category: ArticleCategory.beginners,
        publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
        author: 'Venus One Team',
        readTimeMinutes: 8,
        tags: ['sabah rutini', 'wellness', 'burçlar', 'enerji'],
      ),

      AstrologyArticle(
        id: '33',
        title: 'Ruh Eşi Mi Karşıma Çıktı? Astrolojik İşaretler',
        summary: 'Gerçek ruh eşini astrololojik açıdan nasıl tanırsın?',
        content: '''
"Ruh eşi" kavramı romantize edilse de astrolojide belirli göstergeleri vardır.

## Güçlü Ruh Eşi Göstergeleri

### Düğüm Bağlantıları
Birinin Güneşi, Ayı veya Venüsü diğerinin Kuzey Düğümüne değiyorsa karmik bir bağ vardır.

### Satürn Bağlantıları
Satürn karması! Satürn-Güneş veya Satürn-Ay kavuşumları ciddi, uzun süreli bağları gösterir.

### 12. Ev Bağlantıları
Birinin gezegenleri diğerinin 12. evine düşerse spiritüel, açıklanamaz bir çekim oluşur.

### Vertex Bağlantıları
Vertex noktası "kadersel karşılaşmalar"ı gösterir. Vertex üzerine düşen gezegenler anlam taşır.

## Dikkat Edilmesi Gerekenler

**Yoğunluk ≠ Uyumluluk**
Çok yoğun hisler her zaman sağlıklı ilişki anlamına gelmez.

**Karşılıklı Büyüme**
Gerçek ruh eşileri birbirini büyütür, tüketmez.

**Zorluklar Normal**
Ruh eşi ilişkileri de zorlu olabilir - amaç birlikte evrimleşmektir.

## Dikkat: Karmik İlişki ≠ Ruh Eşi

Karmik ilişkiler ders öğretir, ruh eşileri birlikte büyür.
        ''',
        category: ArticleCategory.relationships,
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        author: 'Venus One Team',
        readTimeMinutes: 10,
        tags: ['ruh eşi', 'karma', 'ilişki', 'kader'],
      ),

      AstrologyArticle(
        id: '34',
        title: 'Burcuna Göre Self-Care Rehberi',
        summary: 'Güneş burcunuza özel kendinize bakım önerileri ve şifa pratikleri.',
        content: '''
Her burcun enerjisi farklı self-care ihtiyaçları gerektirir. İşte size özel bakım rehberi.

## Koç
- **İhtiyaç**: Hareket, meydan okuma
- **Öneri**: Yoğun spor, boks, yürüyüş
- **Kaçının**: Hareketsizlik, sıkıcı rutinler

## Boğa
- **İhtiyaç**: Duyusal keyif, konfor
- **Öneri**: Spa, masaj, lezzetli yemek
- **Kaçının**: Aşırı harcama, tembellik

## İkizler
- **İhtiyaç**: Zihinsel uyarım, sosyalleşme
- **Öneri**: Yeni bir şey öğrenin, sohbet
- **Kaçının**: Aşırı bilgi tüketimi

## Yengeç
- **İhtiyaç**: Ev, güvenlik, aile
- **Öneri**: Ev yapımı yemek, nostalji
- **Kaçının**: Başkalarını fazla önemsemek

## Aslan
- **İhtiyaç**: Yaratıcılık, takdir görme
- **Öneri**: Sanat, performans, övgü
- **Kaçının**: Kendini küçümseme

## Başak
- **İhtiyaç**: Düzen, temizlik, sağlık
- **Öneri**: Detoks, organize etme
- **Kaçının**: Mükemmeliyetçilik

## Terazi - Balık
*(Diğer burçlar için detaylı içerik devam eder)*
        ''',
        category: ArticleCategory.spirituality,
        publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
        author: 'Venus One Team',
        readTimeMinutes: 12,
        tags: ['self-care', 'bakım', 'wellness', 'burçlar'],
      ),

      AstrologyArticle(
        id: '35',
        title: '2025 Yılı Burç Tahminleri: Genel Bakış',
        summary: 'Jüpiter, Satürn ve önemli geçişlerin 2025 yılı etkileri.',
        content: '''
2025, astrolojik açıdan önemli dönüşümler vadeden bir yıl. İşte öne çıkan temalar.

## Jüpiter İkizler\'de (2024-2025)

İletişim, öğrenme ve ağ kurma alanında fırsatlar. Özellikle hava burçları için şanslı bir dönem.

## Satürn Balık\'ta

Spiritüel konularda yapılanma, hayal ile gerçek arasında denge kurma. Sınırlar ve empati.

## Uranüs Boğa\'dan Çıkıyor

Finansal ve değer sistemlerinde uzun süredir devam eden devrimin sonu. Yeni bir çağ başlıyor.

## Tutulma Ekseni

Koç-Terazi ekseninde tutulmalar devam ediyor. İlişkiler ve bireysellik teması öne çıkıyor.

## Burçlara Göre Ana Temalar

**Ateş Burçları**: Yenilik ve liderlik fırsatları
**Toprak Burçları**: Finansal yeniden yapılanma
**Hava Burçları**: Büyüme ve genişleme
**Su Burçları**: Duygusal derinleşme ve şifa
        ''',
        category: ArticleCategory.currentTransits,
        publishedAt: DateTime.now(),
        author: 'Venus One Team',
        readTimeMinutes: 15,
        tags: ['2025', 'yıllık', 'tahmin', 'transit'],
      ),

      AstrologyArticle(
        id: '36',
        title: 'Gece Doğanlar vs Gündüz Doğanlar: Sekt',
        summary: 'Doğum saatinize göre hangi gezegenler sizin için daha önemli?',
        content: '''
Antik astrolojide "sekt" kavramı, gece ve gündüz doğumlarını ayırır ve hangi gezegenlerin daha aktif olduğunu gösterir.

## Gündüz Sektı (Güneş ufkun üstünde)

**Işık Gezegeni**: Güneş
**İyi Gezegen**: Jüpiter
**Zor Gezegen**: Satürn (daha yapıcı)
**Mars**: Daha zorlu

Gündüz doğanlar genellikle:
- Dışa dönük enerjiler
- Sosyal ve görünür konular
- Jüpiter'in bolluğundan faydalanır

## Gece Sektı (Güneş ufkun altında)

**Işık Gezegeni**: Ay
**İyi Gezegen**: Venüs
**Zor Gezegen**: Mars (daha yapıcı)
**Satürn**: Daha zorlu

Gece doğanlar genellikle:
- İçe dönük enerjiler
- Özel ve duygusal konular
- Venüs'ün uyumundan faydalanır

## Pratik Uygulama

Doğum saatinizi öğrenin ve:
- İyi gezegeninizi güçlendirin
- Zor gezegeninizle çalışın
        ''',
        category: ArticleCategory.beginners,
        publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
        author: 'Venus One Team',
        readTimeMinutes: 9,
        tags: ['sekt', 'gece doğum', 'gündüz doğum', 'antik'],
      ),

      AstrologyArticle(
        id: '37',
        title: 'Lilith: Gölge Dişil Enerji',
        summary: 'Kara Ay Lilith\'in doğum haritanızdaki anlamı ve gücü.',
        content: '''
Lilith (Kara Ay), bastırılmış dişil enerjiyi, isyanı ve özgürleşmeyi temsil eder.

## Lilith Nedir?

Astronomik olarak Ay'ın yörüngesinin uzak noktasıdır. Astrolojik olarak:
- Bastırılmış öfke
- Red edilen benlik parçaları
- Cinsel güç
- İsyan ve özgürlük
- Dışlanmış dişil

## Lilith Mitolojisi

Yahudi mitolojisinde Lilith, Adem'in ilk eşiydi ve boyun eğmeyi reddetti. Bu arketip bağımsızlık ve isyanı simgeler.

## Burçlarda Lilith

**Koç Lilith**: Öfke ve bağımsızlık gücü
**Boğa Lilith**: Duyusal özgürleşme
**Akrep Lilith**: Derin dönüşüm gücü
**Balık Lilith**: Spiritüel isyan

## Lilith'le Çalışmak

- Red ettiğiniz yanlarınızı kabul edin
- Sağlıksız uysallıktan çıkın
- Otantik gücünüzü keşfedin
- Gölge çalışması yapın
        ''',
        category: ArticleCategory.spirituality,
        publishedAt: DateTime.now().subtract(const Duration(hours: 4)),
        author: 'Venus One Team',
        readTimeMinutes: 10,
        tags: ['lilith', 'gölge', 'dişil', 'güç'],
      ),

      AstrologyArticle(
        id: '38',
        title: 'Para ve Bolluk: 2. ve 8. Ev Analizi',
        summary: 'Finansal durumunuzu ve para ilişkinizi gösteren astrolojik faktörler.',
        content: '''
Astrolojide maddi konular iki ev tarafından yönetilir: 2. ev (kendi kazancınız) ve 8. ev (paylaşılan kaynaklar).

## 2. Ev: Kendi Değeriniz

Bu ev şunları gösterir:
- Nasıl para kazanırsınız
- Neyi değerli bulursunuz
- Öz değer algınız
- Maddi güvenlik ihtiyacınız

**2. Ev Burçları ve Para**:
- Toprak burçları: Pratik ve biriktirici
- Ateş burçları: Cömert ve harcamacı
- Hava burçları: Değişken ve fırsatçı
- Su burçları: Duygusal harcama

## 8. Ev: Paylaşılan Kaynaklar

Bu ev şunları gösterir:
- Miras, yatırım, borç
- Partnerinizin parası
- Vergi ve sigorta
- Psikolojik dönüşüm

## Bolluk Blokajları

Satürn 2. veya 8. evde bolluk korkularını gösterebilir. Bu farkındalıkla çalışılabilir.

## Jüpiter ve Şans

Jüpiter bu evlerde finansal fırsatları genişletir.
        ''',
        category: ArticleCategory.career,
        publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
        author: 'Venus One Team',
        readTimeMinutes: 11,
        tags: ['para', 'bolluk', '2. ev', '8. ev', 'finans'],
      ),

      AstrologyArticle(
        id: '39',
        title: 'Astroloji ve Psikoloji: Jung\'un Mirası',
        summary: 'Carl Jung\'un astrolojiyle ilişkisi ve arketip kavramının bağlantısı.',
        content: '''
Carl Jung, modern psikolojinin kurucularından biri olarak astrolojiyi ciddiye alan nadir bilim insanlarından biriydi.

## Jung ve Astroloji

Jung, hastaların doğum haritalarını incelemiş ve şöyle söylemiştir: "Astroloji, tüm psikolojik bilgiyi içerir."

## Kolektif Bilinçdışı

Jung'un "kolektif bilinçdışı" kavramı, astrolojinin arketipsel sembolleriyle örtüşür:
- Gezegenler = Arketipler
- Burçlar = Enerji kalıpları
- Evler = Yaşam alanları

## Arketip Eşleşmeleri

**Güneş**: Kahraman, Benlik
**Ay**: Anne, Bilinçdışı
**Venüs**: Sevgili, Anima
**Mars**: Savaşçı, Animus
**Satürn**: Bilge Yaşlı, Gölge

## Senkronisite

Jung'un "anlamlı tesadüf" kavramı, astrolojinin temelini oluşturur. Gökyüzü ve yeryüzü aynı kalıbı yansıtır.

## Modern Psikolojik Astroloji

Bugün birçok terapist, astrolojiyi kendini tanıma aracı olarak kullanır.
        ''',
        category: ArticleCategory.spirituality,
        publishedAt: DateTime.now().subtract(const Duration(hours: 7)),
        author: 'Venus One Team',
        readTimeMinutes: 12,
        tags: ['jung', 'psikoloji', 'arketip', 'bilinçdışı'],
      ),

      AstrologyArticle(
        id: '40',
        title: 'Tarot ve Astroloji: Güçlü İkili',
        summary: 'Tarot kartları ile astrolojik sembollerin bağlantısı.',
        content: '''
Tarot ve astroloji, aynı arketipsel sistemin iki farklı dilidir. Birlikte kullanıldığında güçlü içgörüler sunar.

## Major Arcana ve Gezegenler

**0 Fool**: Uranüs (özgürlük, risk)
**I Magician**: Merkür (iletişim)
**II High Priestess**: Ay (sezgi)
**III Empress**: Venüs (bolluk)
**IV Emperor**: Koç (otorite)
**V Hierophant**: Boğa (gelenek)

## Burçlar ve Kartlar

Her burç bir Major Arcana kartıyla eşleşir:
- Koç: Emperor
- Boğa: Hierophant
- İkizler: Lovers
- Yengeç: Chariot
- ...

## Minor Arcana ve Elementler

**Değnekler**: Ateş burçları
**Kupalar**: Su burçları
**Kılıçlar**: Hava burçları
**Pentagramlar**: Toprak burçları

## Birlikte Kullanım

Doğum haritanızı okurken ilgili tarot kartlarına da bakabilirsiniz. Bu, sembolleri derinleştirir.
        ''',
        category: ArticleCategory.spirituality,
        publishedAt: DateTime.now().subtract(const Duration(hours: 9)),
        author: 'Venus One Team',
        readTimeMinutes: 10,
        tags: ['tarot', 'kartlar', 'semboller', 'major arcana'],
      ),
    ];
  }
}
