/// Venus One Homepage Content Library
/// Rich, scroll-worthy content sections for homepage expansion
/// Topics: Venus archetypes, love patterns, attachment styles, and more
library;

/// Model for homepage content sections
class VenusContentSection {
  final String id;
  final String emoji;
  final String title;
  final String subtitle;
  final String? badge;
  final String route;
  final String fullContent;

  const VenusContentSection({
    required this.id,
    required this.emoji,
    required this.title,
    required this.subtitle,
    this.badge,
    required this.route,
    required this.fullContent,
  });
}

/// 12 Rich Venus-themed content sections
class VenusHomepageContent {
  static const List<VenusContentSection> sections = [
    // 1. Venus Archetypes
    VenusContentSection(
      id: 'venus-archetypes',
      emoji: '🌹',
      title: 'Venus Arketipleri',
      subtitle: 'Afrodit, Inanna, Ishtar — Aşkın kadim yüzleri',
      badge: 'Yeni',
      route: '/content/venus-archetypes',
      fullContent: '''
# Venus Arketipleri: Aşkın Kadim Yüzleri

Venus sadece bir gezegen değil, aynı zamanda binlerce yıllık bir arketiptir. Sümer'in Inanna'sından Yunan'ın Afrodit'ine, Babil'in Ishtar'ından Roma'nın Venus'üne — aşk tanrıçası farklı kültürlerde farklı yüzler almıştır.

## Inanna (Sümer)
Gökyüzünün Kraliçesi. Hem savaşçı hem aşık. Yeraltına iniş ve geri dönüş mitosunda, dönüşümün ve yeniden doğuşun sembolü.

## Ishtar (Babil)
Bereket, savaş ve cinsellik tanrıçası. Aşkın karanlık ve aydınlık yönlerini birlikte taşıyan güçlü bir figür.

## Afrodit (Yunan)
Deniz köpüklerinden doğan güzellik tanrıçası. Eros (tutku), Philia (dostluk) ve Agape (koşulsuz sevgi) — üç aşk türünün efendisi.

## Venus (Roma)
Bahçelerin ve güzelliğin tanrıçası. Roma'nın kurucu mitosuyla iç içe geçmiş, medeniyetin sembolü.

**Senin Venus'ün hangi arketipe daha yakın?** Doğum haritandaki Venus yerleşimi, bu kadim arketiplerden hangisinin enerjisini daha çok taşıdığını gösterebilir.
''',
    ),

    // 2. Love Languages by Zodiac
    VenusContentSection(
      id: 'love-languages',
      emoji: '💕',
      title: 'Burçlara Göre Aşk Dilleri',
      subtitle: 'Her burç farklı sever, farklı sevilmek ister',
      badge: 'Popüler',
      route: '/content/love-languages',
      fullContent: '''
# Burçlara Göre Aşk Dilleri

Gary Chapman'ın 5 aşk dili teorisi ile astrolojiyi birleştirdiğimizde, her burcun kendine özgü sevgi ifade biçimlerini görebiliriz.

## Ateş Burçları (Koç, Aslan, Yay)
**Birincil Aşk Dili:** Fiziksel Dokunuş & Nitelikli Zaman
Ateş burçları sevgilerini eylemle gösterir. Macera paylaşmak, birlikte hareket etmek onlar için aşkın ta kendisidir.

## Toprak Burçları (Boğa, Başak, Oğlak)
**Birincil Aşk Dili:** Hizmet Eylemleri & Hediyeler
Toprak burçları pratik sevgiyi tercih eder. Yemek yapmak, tamir etmek, somut destekler onların "seni seviyorum" demesidir.

## Hava Burçları (İkizler, Terazi, Kova)
**Birincil Aşk Dili:** Onaylayıcı Sözler & Nitelikli Zaman
Hava burçları kelimelerle ve entelektüel paylaşımla bağ kurar. Derin sohbetler onlar için romantizmin özüdür.

## Su Burçları (Yengeç, Akrep, Balık)
**Birincil Aşk Dili:** Nitelikli Zaman & Fiziksel Dokunuş
Su burçları duygusal bağ ve yakınlık arar. Birlikte sessiz kalmak bile onlar için derin bir paylaşımdır.
''',
    ),

    // 3. Attachment Styles
    VenusContentSection(
      id: 'attachment-styles',
      emoji: '🔗',
      title: 'Bağlanma Stilleri',
      subtitle: 'Venus yerleşimin nasıl bağlandığını anlatır',
      route: '/content/attachment-styles',
      fullContent: '''
# Bağlanma Stilleri ve Venus

Psikolojideki bağlanma teorisi ile Venus yerleşimlerini birleştirdiğimizde, ilişkilerdeki kalıplarımızı daha iyi anlayabiliriz.

## Güvenli Bağlanma
**Venus göstergeleri:** Boğa, Terazi, Yengeç'te Venus
Bu yerleşimler dengeli, güvenli bağlar kurma eğilimindedir. Yakınlık ve özerklik arasında denge kurabilirler.

## Kaygılı Bağlanma
**Venus göstergeleri:** Yengeç, Akrep, Balık'ta Venus (stres altında)
Reddedilme korkusu, aşırı bağlanma, sürekli güvence arayışı. Su burçlarındaki Venus bazen bu kalıbı tetikleyebilir.

## Kaçıngan Bağlanma
**Venus göstergeleri:** Kova, Yay, Koç'ta Venus (savunma modunda)
Duygusal mesafe, bağımsızlık takıntısı, yakınlıktan kaçınma. Ateş ve hava Venus'ü bazen bu kalıba düşebilir.

## Dağınık Bağlanma
**Venus göstergeleri:** Zorlayıcı açılar (Plüton, Satürn karesi)
Hem yakınlık istemek hem ondan korkmak. Çelişkili davranışlar, itme-çekme döngüleri.

**Not:** Bunlar kesin tanılar değil, farkındalık araçlarıdır. Her birey benzersizdir.
''',
    ),

    // 4. Shadow Work in Relationships
    VenusContentSection(
      id: 'shadow-work',
      emoji: '🌑',
      title: 'İlişkilerde Gölge Çalışması',
      subtitle: 'Venus retrosu ve karanlık yönlerimiz',
      route: '/content/shadow-work',
      fullContent: '''
# İlişkilerde Gölge Çalışması

Carl Jung'un gölge kavramı, astrolojide özellikle Venus retrosu dönemlerinde öne çıkar. Bastırdığımız, reddettiğimiz veya görmek istemediğimiz yönlerimiz ilişkilerimize nasıl yansır?

## Venus Retrosu Ne Getirir?
- Eski ilişkilerin geri dönüşü
- Çözülmemiş duyguların yüzeye çıkması
- Değerler ve zevklerin sorgulanması
- Mali konularda yeniden değerlendirme

## Gölge Kalıpları
**Kıskançlık:** Başkasında gördüğümüz ama kendimizde kabul etmediğimiz şey
**Bağımlılık:** Kendimizde eksik hissettiğimizi dışarıda arama
**İdealizasyon:** Partneri gerçekçi olmayan standartlara koyma
**Değersizlik:** Sevilmeyi hak etmediğine inanma

## İyileşme Yolu
1. Kalıbı fark et
2. Kökenini araştır (çocukluk, geçmiş ilişkiler)
3. Duyguyu kabul et
4. Yeni bir anlatı yaz
5. Sınır koy, kendinle barış yap
''',
    ),

    // 5. Divine Feminine/Masculine
    VenusContentSection(
      id: 'divine-balance',
      emoji: '☯️',
      title: 'İlahi Dişil/Eril',
      subtitle: 'İçindeki dengeyi bul',
      route: '/content/divine-balance',
      fullContent: '''
# İlahi Dişil ve Eril Enerji Dengesi

Her insanda hem dişil (yin) hem de eril (yang) enerji vardır. Cinsiyet kimliğinden bağımsız olarak, bu enerjilerin dengesi içsel bütünlüğümüzü belirler.

## Dişil Enerji (Ay, Venus, Neptün)
- Alıcılık
- Sezgi
- Yaratıcılık
- Şefkat
- Akış
- İç dünya

## Eril Enerji (Güneş, Mars, Jüpiter)
- Eylem
- Mantık
- Yapı
- Koruma
- Odaklanma
- Dış dünya

## Dengesizlik Belirtileri
**Aşırı Eril:** Tükenmişlik, duygusal kopukluk, kontrol takıntısı
**Aşırı Dişil:** Sınır eksikliği, kararsızlık, pasiflik

## Denge Yolu
- Her iki enerjiyi de onurlandır
- Duruma göre geçiş yap
- İçsel evlilik: Kendi içinde bütünleş
- İlişkilerde tamamlanma yerine paylaşım ara
''',
    ),

    // 6. Heart Chakra Wisdom
    VenusContentSection(
      id: 'heart-chakra',
      emoji: '💚',
      title: 'Kalp Çakrası Bilgeliği',
      subtitle: 'Aşk enerjisi ve şifa',
      route: '/content/heart-chakra',
      fullContent: '''
# Kalp Çakrası (Anahata) ve Aşk Enerjisi

Yedi ana çakradan dördüncüsü olan Kalp Çakrası, alt ve üst çakralar arasında köprü görevi görür. Venus enerjisiyle doğrudan bağlantılıdır.

## Kalp Çakrası Özellikleri
- **Konum:** Göğüs merkezi
- **Renk:** Yeşil (şifa), Pembe (sevgi)
- **Element:** Hava
- **Gezegen:** Venus
- **Mantra:** YAM

## Dengeli Kalp Çakrası
- Koşulsuz sevgi verebilme
- Sağlıklı sınırlar
- Kendini ve başkalarını kabul
- Şefkat ve empati
- Bağışlama yeteneği

## Dengesiz Kalp Çakrası
**Eksik aktivasyon:** Duygusal kapalılık, güvensizlik, yalnızlık
**Aşırı aktivasyon:** Kodepandans, sınır yokluğu, kendini feda

## Şifa Pratikleri
- Yeşil ve pembe kristaller (gül kuvarsı, yeşil aventurin)
- Kalbi açan yoga pozisyonları
- Nefes çalışmaları
- Bağışlama meditasyonları
- Doğada zaman geçirme
''',
    ),

    // 7. Synastry Basics
    VenusContentSection(
      id: 'synastry-basics',
      emoji: '⚡',
      title: 'Sinastri Temelleri',
      subtitle: 'İlişki astrolojisine giriş',
      badge: 'Eğitim',
      route: '/content/synastry-basics',
      fullContent: '''
# Sinastri: İlişki Astrolojisinin Temelleri

Sinastri, iki kişinin doğum haritalarının karşılaştırılmasıdır. Hangi enerjilerin uyumlu, hangilerinin zorlayıcı olduğunu gösterir.

## Temel Karşılaştırmalar

### Güneş-Güneş
İki benliğin buluşması. Aynı veya uyumlu element = doğal anlayış.

### Ay-Ay
Duygusal uyum. Ev hissi, güvenlik duygusu.

### Venus-Mars
Romantik ve cinsel çekim. Karşılıklı cazibe dinamikleri.

### Merkür-Merkür
İletişim tarzları. Birbirini anlama kolaylığı.

## Önemli Açılar
- **Kavuşum (0°):** Yoğun birleşme
- **Trigon (120°):** Doğal uyum, akış
- **Kare (90°):** Gerilim, büyüme fırsatı
- **Karşıt (180°):** Çekim ve meydan okuma

## Unutma
Sinastri bir "uyumluluk testi" değildir. Hiçbir harita bir ilişkinin işleyip işlemeyeceğini söyleyemez. Farkındalık ve bilinçli çaba her şeyi değiştirebilir.
''',
    ),

    // 8. Venus Return
    VenusContentSection(
      id: 'venus-return',
      emoji: '🔄',
      title: 'Venus Dönüşü',
      subtitle: 'Kişisel aşk döngülerin',
      route: '/content/venus-return',
      fullContent: '''
# Venus Dönüşü: Kişisel Aşk Döngüsü

Venus yaklaşık 225 günde (yaklaşık 8 ay) Güneş'in etrafında bir tur atar. Her yıl, Venus natal pozisyonuna döndüğünde "Venus Dönüşü" yaşarsın.

## Venus Dönüşü Ne Anlama Gelir?
- İlişkilerde yeni başlangıçlar
- Değerlerinin yeniden değerlendirilmesi
- Güzellik ve zevklerde tazlenme
- Finansal konularda yeni perspektifler

## Nasıl Hesaplanır?
Doğum haritandaki Venus'ün derece ve burcu belirlenir. Transitdeki Venus aynı noktaya geldiğinde dönüş gerçekleşir.

## Venus Dönüşü Ritüelleri
1. **Niyet belirleme:** İlişkilerde ne istediğini netleştir
2. **Güzellik ritüeli:** Kendine bakım günü
3. **Şükran listesi:** Hayatındaki güzellikleri yaz
4. **Bırakma:** Artık hizmet etmeyen kalıpları serbest bırak
5. **Davet:** Yeni aşkı, bolluğu, güzelliği davet et

## 8 Yıllık Venus Döngüsü
Venus her 8 yılda bir gökyüzünde bir pentagram (beş köşeli yıldız) çizer. Bu 8 yıllık döngü, daha büyük ilişki temalarını işaret eder.
''',
    ),

    // 9. Self-Love Rituals
    VenusContentSection(
      id: 'self-love',
      emoji: '🪞',
      title: 'Kendini Sevme Ritüelleri',
      subtitle: 'Venus ilhamlı öz-bakım pratikleri',
      route: '/content/self-love',
      fullContent: '''
# Venus İlhamlı Kendini Sevme Ritüelleri

Başkalarını sevmeden önce kendini sevmek klişe gibi görünebilir, ama Venus enerjisi tam da bununla ilgilidir. Kendi değerini bilmek, sağlıklı ilişkilerin temelidir.

## Günlük Ritüeller

### Sabah Ayna Ritüeli
Aynaya bak ve kendine üç olumlu şey söyle. "Ben değerliyim", "Ben sevilmeye layığım", "Ben yeterliyim."

### Güzellik Zamanı
Her gün 15 dakika sadece kendine ayır. Cilt bakımı, saç tarama, vücut losyonu — bunlar lüks değil, öz-sevgi eylemleridir.

### Şükran Defteri
Her gece yatmadan önce, bugün kendinde takdir ettiğin üç şeyi yaz.

## Haftalık Ritüeller

### Cuma Gecesi (Venus Günü)
- Pembe mum yak
- Gül çayı veya şarabı
- Favori müziğini aç
- Dans et, şarkı söyle, kutla

### Solo Randevu
Haftada bir kez kendine randevu ver. Restorana git, sinemaya git, kitapçıda kaybol — tek başına.

## Aylık Ritüeller
- Yeni Ay'da niyet belirle
- Dolunay'da bırak
- Venus retrosu dönemlerinde eski kalıpları gözden geçir
''',
    ),

    // 10. Cosmic Dating Guide
    VenusContentSection(
      id: 'cosmic-dating',
      emoji: '💫',
      title: 'Kozmik Flört Rehberi',
      subtitle: 'Transit enerjilerine göre romantizm',
      badge: 'Popüler',
      route: '/content/cosmic-dating',
      fullContent: '''
# Kozmik Flört Rehberi

Gezegenler ilişkilerimizi dikte etmez, ama bazı zamanlar romantizm için daha elverişlidir. İşte transitlara göre flört stratejileri:

## Venus Transitları

### Venus Koç'ta
Cesur ol, ilk adımı at. Spontan randevular, macera dolu buluşmalar.

### Venus Boğa'da (yurt içi)
Yavaş ve duyusal. Güzel yemekler, dokunuşlar, konfor.

### Venus İkizler'de
Kelimeler önemli. Mesajlaşma, flört, zekice espriler.

### Venus Yengeç'te
Ev ortamı, aile tanıştırmaları, duygusal derinlik.

### Venus Aslan'da
Gösterişli jestler, romantik sürprizler, sahne ışıkları.

## Kaçınılması Gereken Zamanlar

### Venus Retrosu
Eski sevgililere mesaj atma! Yeni ilişkilere başlamak riskli.

### Mars-Plüton Karesi
Güç mücadeleleri, yoğun duygular. Tartışma riski yüksek.

### Merkür Retrosu
Yanlış anlaşılmalar olasılığı yüksek. Net iletişim zor.

## En İyi Zamanlar
- Venus-Jüpiter kavuşumu: Genişleme, şans, bolluk
- Venüs-Neptün trigonu: Romantik rüyalar gerçeğe dönüşür
- Dolunay Terazi'de: İlişki kararları, denge
''',
    ),

    // 11. Soulmate vs Twin Flame
    VenusContentSection(
      id: 'soulmate-twinflame',
      emoji: '🔥',
      title: 'Ruh Eşi vs İkiz Alev',
      subtitle: 'Astrolojik perspektifler',
      route: '/content/soulmate-twinflame',
      fullContent: '''
# Ruh Eşi vs İkiz Alev: Astrolojik Perspektif

Bu iki kavram sıkça karıştırılır. Astroloji açısından ne anlama gelirler?

## Ruh Eşi (Soulmate)
Birden fazla olabilir. Romantik olmak zorunda değil. Geçmiş yaşamlardan tanıdıklık hissi.

**Astrolojik göstergeler:**
- Kuzey/Güney Düğüm bağlantıları
- Saturn kavuşumları (karmik bağ)
- 12. ev bağlantıları
- Güneş-Ay uyumları

## İkiz Alev (Twin Flame)
Tek bir tane olduğu söylenir. Ruhun diğer yarısı. Genellikle yoğun ve zorlu.

**Astrolojik göstergeler:**
- Plüton-kişisel gezegen kavuşumları
- 8. ev bağlantıları
- Chiron açıları (yaralarla yüzleşme)
- Güneş karşıtlıkları

## Dikkat
İkiz alev kavramı bazen toksik ilişkileri romantize etmek için kullanılır. "Acı çekiyorsak ikiz aleviz" mantığı sağlıklı değil.

Gerçek ruhani bağlantı:
- Büyüme getirir
- Özgürleştirir
- Sahicilik sağlar
- Karşılıklı saygı içerir

Sadece yoğunluk, derin bağ anlamına gelmez. Huzur da aşktır.
''',
    ),

    // 12. Healing Past Relationships
    VenusContentSection(
      id: 'healing-past',
      emoji: '🩹',
      title: 'Geçmiş İlişkileri İyileştirmek',
      subtitle: 'Karmik Venus dersleri',
      route: '/content/healing-past',
      fullContent: '''
# Geçmiş İlişkileri İyileştirmek

Eski ilişkiler sadece hatıra değil, öğretmendir. Astroloji açısından, tekrar eden kalıplar karmik derslerle ilgili olabilir.

## Güney Düğüm ve Geçmiş Kalıplar
Güney Düğüm, geçmiş yaşam alışkanlıklarını temsil eder. 7. evde veya Venus ile açı yapıyorsa, ilişki kalıplarını işaret eder.

## Tekrar Eden Temalar
- Hep aynı tip insanlarla mı çıkıyorsun?
- İlişkilerin benzer şekillerde mi bitiyor?
- Aynı tartışmalar mı tekrarlanıyor?

Bunlar bilinçaltı kalıplardır ve farkındalıkla değiştirilebilir.

## İyileşme Adımları

### 1. Kabul
Olanı reddetmek yerine kabul et. "Bu oldu ve ben bununla barışıyorum."

### 2. Ders Çıkarma
"Bu ilişki bana ne öğretti?" Acıyı anlam yaratarak dönüştür.

### 3. Bağışlama
Kendini ve diğerini bağışla. Bağışlama, geçmişi onaylamak değil, şimdiden kurtulmaktır.

### 4. Serbest Bırakma
Enerji ipleini kes. Meditasyon, ritüel veya sembolik bir eylemle.

### 5. Yeni Niyet
"Bundan sonra ilişkilerimde neyi farklı yapacağım?"

## Venus Retrosu Dönemleri
Geçmiş ilişkilerle yüzleşme zamanı. Eski sevgililer dönebilir — bu kapanış için bir fırsattır, tekrar için değil.
''',
    ),
  ];

  /// Get sections by category or badge
  static List<VenusContentSection> getSectionsByBadge(String badge) {
    return sections.where((s) => s.badge == badge).toList();
  }

  /// Get popular sections
  static List<VenusContentSection> get popularSections {
    return sections.where((s) => s.badge == 'Popüler').toList();
  }

  /// Get new sections
  static List<VenusContentSection> get newSections {
    return sections.where((s) => s.badge == 'Yeni').toList();
  }

  /// Get section by ID
  static VenusContentSection? getSectionById(String id) {
    try {
      return sections.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
