/// InnerCycles Homepage Content Library
/// Rich, scroll-worthy content sections for homepage expansion
/// Topics: Venus archetypes, love patterns, attachment styles, and more
/// Multi-language support: Turkish (tr) and English (en)
library;

import '../providers/app_providers.dart';

/// Model for homepage content sections with multi-language support
class VenusContentSection {
  final String id;
  final String emoji;
  final String titleTr;
  final String titleEn;
  final String subtitleTr;
  final String subtitleEn;
  final String? badgeTr;
  final String? badgeEn;
  final String route;
  final String fullContentTr;
  final String fullContentEn;

  const VenusContentSection({
    required this.id,
    required this.emoji,
    required this.titleTr,
    required this.titleEn,
    required this.subtitleTr,
    required this.subtitleEn,
    this.badgeTr,
    this.badgeEn,
    required this.route,
    required this.fullContentTr,
    required this.fullContentEn,
  });

  /// Get localized title
  String getTitle(AppLanguage lang) =>
      lang == AppLanguage.en ? titleEn : titleTr;

  /// Get localized subtitle
  String getSubtitle(AppLanguage lang) =>
      lang == AppLanguage.en ? subtitleEn : subtitleTr;

  /// Get localized badge
  String? getBadge(AppLanguage lang) =>
      lang == AppLanguage.en ? badgeEn : badgeTr;

  /// Get localized full content
  String getFullContent(AppLanguage lang) =>
      lang == AppLanguage.en ? fullContentEn : fullContentTr;
}

/// 12 Rich Venus-themed content sections
class VenusHomepageContent {
  static const List<VenusContentSection> sections = [
    // 1. Venus Archetypes
    VenusContentSection(
      id: 'venus-archetypes',
      emoji: '🌹',
      titleTr: 'Venus Arketipleri',
      titleEn: 'Venus Archetypes',
      subtitleTr: 'Afrodit, Inanna, Ishtar — Aşkın kadim yüzleri',
      subtitleEn: 'Aphrodite, Inanna, Ishtar — Ancient faces of love',
      badgeTr: 'Yeni',
      badgeEn: 'New',
      route: '/content/venus-archetypes',
      fullContentTr: '''
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
      fullContentEn: '''
# Venus Archetypes: Ancient Faces of Love

Venus is not just a planet, but an archetype spanning thousands of years. From Sumerian Inanna to Greek Aphrodite, from Babylonian Ishtar to Roman Venus — the goddess of love has taken different faces across cultures.

## Inanna (Sumerian)
Queen of Heaven. Both warrior and lover. In the myth of descent and return from the underworld, a symbol of transformation and rebirth.

## Ishtar (Babylonian)
Goddess of fertility, war, and sexuality. A powerful figure carrying both dark and light aspects of love.

## Aphrodite (Greek)
The goddess of beauty born from sea foam. Eros (passion), Philia (friendship), and Agape (unconditional love) — mistress of three types of love.

## Venus (Roman)
Goddess of gardens and beauty. Intertwined with Rome's founding myth, a symbol of civilization.

**Which archetype is your Venus closer to?** Your Venus placement in your birth chart may show which of these ancient archetypes' energy you carry more strongly.
''',
    ),

    // 2. Love Languages by Zodiac
    VenusContentSection(
      id: 'love-languages',
      emoji: '💕',
      titleTr: 'Burçlara Göre Aşk Dilleri',
      titleEn: 'Love Languages by Zodiac',
      subtitleTr: 'Her burç farklı sever, farklı sevilmek ister',
      subtitleEn: 'Each sign loves differently, wants to be loved differently',
      badgeTr: 'Popüler',
      badgeEn: 'Popular',
      route: '/content/love-languages',
      fullContentTr: '''
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
      fullContentEn: '''
# Love Languages by Zodiac

When we combine Gary Chapman's 5 love languages theory with astrology, we can see each sign's unique ways of expressing love.

## Fire Signs (Aries, Leo, Sagittarius)
**Primary Love Language:** Physical Touch & Quality Time
Fire signs show their love through action. Sharing adventures, moving together is love itself for them.

## Earth Signs (Taurus, Virgo, Capricorn)
**Primary Love Language:** Acts of Service & Gifts
Earth signs prefer practical love. Cooking, fixing things, concrete support is their way of saying "I love you."

## Air Signs (Gemini, Libra, Aquarius)
**Primary Love Language:** Words of Affirmation & Quality Time
Air signs connect through words and intellectual sharing. Deep conversations are the essence of romance for them.

## Water Signs (Cancer, Scorpio, Pisces)
**Primary Love Language:** Quality Time & Physical Touch
Water signs seek emotional connection and closeness. Even being silent together is deep sharing for them.
''',
    ),

    // 3. Attachment Styles
    VenusContentSection(
      id: 'attachment-styles',
      emoji: '🔗',
      titleTr: 'Bağlanma Stilleri',
      titleEn: 'Attachment Styles',
      subtitleTr: 'Venus yerleşimin nasıl bağlandığını anlatır',
      subtitleEn: 'Your Venus placement tells how you attach',
      route: '/content/attachment-styles',
      fullContentTr: '''
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
      fullContentEn: '''
# Attachment Styles and Venus

When we combine attachment theory from psychology with Venus placements, we can better understand our patterns in relationships.

## Secure Attachment
**Venus indicators:** Venus in Taurus, Libra, Cancer
These placements tend to form balanced, secure bonds. They can maintain balance between closeness and autonomy.

## Anxious Attachment
**Venus indicators:** Venus in Cancer, Scorpio, Pisces (under stress)
Fear of rejection, over-attachment, constant need for reassurance. Venus in water signs can sometimes trigger this pattern.

## Avoidant Attachment
**Venus indicators:** Venus in Aquarius, Sagittarius, Aries (in defense mode)
Emotional distance, obsession with independence, avoidance of closeness. Fire and air Venus can sometimes fall into this pattern.

## Disorganized Attachment
**Venus indicators:** Challenging aspects (Pluto, Saturn square)
Wanting closeness while fearing it. Contradictory behaviors, push-pull cycles.

**Note:** These are not definitive diagnoses, but awareness tools. Each individual is unique.
''',
    ),

    // 4. Shadow Work in Relationships
    VenusContentSection(
      id: 'shadow-work',
      emoji: '🌑',
      titleTr: 'İlişkilerde Gölge Çalışması',
      titleEn: 'Shadow Work in Relationships',
      subtitleTr: 'Venus retrosu ve karanlık yönlerimiz',
      subtitleEn: 'Venus retrograde and our dark sides',
      route: '/content/shadow-work',
      fullContentTr: '''
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
      fullContentEn: '''
# Shadow Work in Relationships

Carl Jung's shadow concept comes to the fore in astrology, especially during Venus retrograde periods. How do the aspects we suppress, reject, or don't want to see reflect in our relationships?

## What Does Venus Retrograde Bring?
- Return of past relationships
- Surfacing of unresolved emotions
- Questioning of values and tastes
- Reassessment of financial matters

## Shadow Patterns
**Jealousy:** What we see in others but don't accept in ourselves
**Dependency:** Seeking externally what we feel we lack within
**Idealization:** Holding partners to unrealistic standards
**Worthlessness:** Believing we don't deserve to be loved

## Path to Healing
1. Recognize the pattern
2. Investigate its origin (childhood, past relationships)
3. Accept the emotion
4. Write a new narrative
5. Set boundaries, make peace with yourself
''',
    ),

    // 5. Divine Feminine/Masculine
    VenusContentSection(
      id: 'divine-balance',
      emoji: '☯️',
      titleTr: 'İlahi Dişil/Eril',
      titleEn: 'Divine Feminine/Masculine',
      subtitleTr: 'İçindeki dengeyi bul',
      subtitleEn: 'Find the balance within',
      route: '/content/divine-balance',
      fullContentTr: '''
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
      fullContentEn: '''
# Divine Feminine and Masculine Energy Balance

Every person has both feminine (yin) and masculine (yang) energy. Regardless of gender identity, the balance of these energies determines our inner wholeness.

## Feminine Energy (Moon, Venus, Neptune)
- Receptivity
- Intuition
- Creativity
- Compassion
- Flow
- Inner world

## Masculine Energy (Sun, Mars, Jupiter)
- Action
- Logic
- Structure
- Protection
- Focus
- Outer world

## Signs of Imbalance
**Excess Masculine:** Burnout, emotional disconnection, control obsession
**Excess Feminine:** Lack of boundaries, indecision, passivity

## Path to Balance
- Honor both energies
- Transition according to the situation
- Inner marriage: Integrate within yourself
- Seek sharing rather than completion in relationships
''',
    ),

    // 6. Heart Chakra Wisdom
    VenusContentSection(
      id: 'heart-chakra',
      emoji: '💚',
      titleTr: 'Kalp Çakrası Bilgeliği',
      titleEn: 'Heart Chakra Wisdom',
      subtitleTr: 'Aşk enerjisi ve şifa',
      subtitleEn: 'Love energy and healing',
      route: '/content/heart-chakra',
      fullContentTr: '''
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
      fullContentEn: '''
# Heart Chakra (Anahata) and Love Energy

The Heart Chakra, the fourth of seven main chakras, serves as a bridge between lower and upper chakras. It is directly connected to Venus energy.

## Heart Chakra Characteristics
- **Location:** Center of chest
- **Color:** Green (healing), Pink (love)
- **Element:** Air
- **Planet:** Venus
- **Mantra:** YAM

## Balanced Heart Chakra
- Ability to give unconditional love
- Healthy boundaries
- Acceptance of self and others
- Compassion and empathy
- Ability to forgive

## Imbalanced Heart Chakra
**Under-activation:** Emotional closure, distrust, loneliness
**Over-activation:** Codependency, lack of boundaries, self-sacrifice

## Healing Practices
- Green and pink crystals (rose quartz, green aventurine)
- Heart-opening yoga poses
- Breathwork
- Forgiveness meditations
- Spending time in nature
''',
    ),

    // 7. Synastry Basics
    VenusContentSection(
      id: 'synastry-basics',
      emoji: '⚡',
      titleTr: 'Sinastri Temelleri',
      titleEn: 'Synastry Basics',
      subtitleTr: 'İlişki astrolojisine giriş',
      subtitleEn: 'Introduction to relationship astrology',
      badgeTr: 'Eğitim',
      badgeEn: 'Education',
      route: '/content/synastry-basics',
      fullContentTr: '''
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
      fullContentEn: '''
# Synastry: Basics of Relationship Astrology

Synastry is the comparison of two people's birth charts. It shows which energies are compatible and which are challenging.

## Basic Comparisons

### Sun-Sun
Meeting of two selves. Same or compatible element = natural understanding.

### Moon-Moon
Emotional compatibility. Feeling of home, sense of security.

### Venus-Mars
Romantic and sexual attraction. Mutual attraction dynamics.

### Mercury-Mercury
Communication styles. Ease of understanding each other.

## Important Aspects
- **Conjunction (0°):** Intense union
- **Trine (120°):** Natural harmony, flow
- **Square (90°):** Tension, growth opportunity
- **Opposition (180°):** Attraction and challenge

## Remember
Synastry is not a "compatibility test." No chart can tell whether a relationship will work or not. Awareness and conscious effort can change everything.
''',
    ),

    // 8. Venus Return
    VenusContentSection(
      id: 'venus-return',
      emoji: '🔄',
      titleTr: 'Venus Dönüşü',
      titleEn: 'Venus Return',
      subtitleTr: 'Kişisel aşk döngülerin',
      subtitleEn: 'Your personal love cycles',
      route: '/content/venus-return',
      fullContentTr: '''
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
      fullContentEn: '''
# Venus Return: Personal Love Cycle

Venus completes one orbit around the Sun in approximately 225 days (about 8 months). Each year, when Venus returns to its natal position, you experience a "Venus Return."

## What Does Venus Return Mean?
- New beginnings in relationships
- Reassessment of your values
- Renewal in beauty and pleasures
- New perspectives on financial matters

## How Is It Calculated?
The degree and sign of Venus in your birth chart is determined. When transiting Venus reaches the same point, the return occurs.

## Venus Return Rituals
1. **Set intentions:** Clarify what you want in relationships
2. **Beauty ritual:** Self-care day
3. **Gratitude list:** Write about the beauties in your life
4. **Release:** Let go of patterns no longer serving you
5. **Invitation:** Invite new love, abundance, beauty

## 8-Year Venus Cycle
Venus draws a pentagram (five-pointed star) in the sky every 8 years. This 8-year cycle points to larger relationship themes.
''',
    ),

    // 9. Self-Love Rituals
    VenusContentSection(
      id: 'self-love',
      emoji: '🪞',
      titleTr: 'Kendini Sevme Ritüelleri',
      titleEn: 'Self-Love Rituals',
      subtitleTr: 'Venus ilhamlı öz-bakım pratikleri',
      subtitleEn: 'Venus-inspired self-care practices',
      route: '/content/self-love',
      fullContentTr: '''
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
      fullContentEn: '''
# Venus-Inspired Self-Love Rituals

Loving yourself before loving others may seem like a cliché, but Venus energy is exactly about this. Knowing your own worth is the foundation of healthy relationships.

## Daily Rituals

### Morning Mirror Ritual
Look in the mirror and tell yourself three positive things. "I am worthy," "I deserve to be loved," "I am enough."

### Beauty Time
Set aside 15 minutes just for yourself each day. Skincare, hair brushing, body lotion — these aren't luxuries, they're acts of self-love.

### Gratitude Journal
Every night before bed, write three things you appreciate about yourself today.

## Weekly Rituals

### Friday Night (Venus Day)
- Light a pink candle
- Rose tea or wine
- Play your favorite music
- Dance, sing, celebrate

### Solo Date
Give yourself a date once a week. Go to a restaurant, go to the movies, get lost in a bookstore — alone.

## Monthly Rituals
- Set intentions on New Moon
- Release on Full Moon
- Review old patterns during Venus retrograde periods
''',
    ),

    // 10. Cosmic Dating Guide
    VenusContentSection(
      id: 'cosmic-dating',
      emoji: '💫',
      titleTr: 'Kozmik Flört Rehberi',
      titleEn: 'Cosmic Dating Guide',
      subtitleTr: 'Transit enerjilerine göre romantizm',
      subtitleEn: 'Romance according to transit energies',
      badgeTr: 'Popüler',
      badgeEn: 'Popular',
      route: '/content/cosmic-dating',
      fullContentTr: '''
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
      fullContentEn: '''
# Cosmic Dating Guide

Planets don't dictate our relationships, but some times are more favorable for romance. Here are dating strategies according to transits:

## Venus Transits

### Venus in Aries
Be bold, take the first step. Spontaneous dates, adventure-filled meetings.

### Venus in Taurus (domicile)
Slow and sensual. Beautiful meals, touches, comfort.

### Venus in Gemini
Words matter. Texting, flirting, witty jokes.

### Venus in Cancer
Home setting, family introductions, emotional depth.

### Venus in Leo
Grand gestures, romantic surprises, spotlight moments.

## Times to Avoid

### Venus Retrograde
Don't text exes! Starting new relationships is risky.

### Mars-Pluto Square
Power struggles, intense emotions. High risk of arguments.

### Mercury Retrograde
High probability of misunderstandings. Clear communication is difficult.

## Best Times
- Venus-Jupiter conjunction: Expansion, luck, abundance
- Venus-Neptune trine: Romantic dreams come true
- Full Moon in Libra: Relationship decisions, balance
''',
    ),

    // 11. Soulmate vs Twin Flame
    VenusContentSection(
      id: 'soulmate-twinflame',
      emoji: '🔥',
      titleTr: 'Ruh Eşi vs İkiz Alev',
      titleEn: 'Soulmate vs Twin Flame',
      subtitleTr: 'Astrolojik perspektifler',
      subtitleEn: 'Astrological perspectives',
      route: '/content/soulmate-twinflame',
      fullContentTr: '''
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
      fullContentEn: '''
# Soulmate vs Twin Flame: Astrological Perspective

These two concepts are often confused. What do they mean from an astrological perspective?

## Soulmate
There can be more than one. Doesn't have to be romantic. Feeling of familiarity from past lives.

**Astrological indicators:**
- North/South Node connections
- Saturn conjunctions (karmic bond)
- 12th house connections
- Sun-Moon harmonies

## Twin Flame
Said to be only one. The other half of the soul. Usually intense and challenging.

**Astrological indicators:**
- Pluto-personal planet conjunctions
- 8th house connections
- Chiron aspects (facing wounds)
- Sun oppositions

## Caution
The twin flame concept is sometimes used to romanticize toxic relationships. The logic of "if we're suffering, we're twin flames" is not healthy.

True spiritual connection:
- Brings growth
- Liberates
- Provides authenticity
- Includes mutual respect

Intensity alone doesn't mean deep connection. Peace is also love.
''',
    ),

    // 12. Healing Past Relationships
    VenusContentSection(
      id: 'healing-past',
      emoji: '🩹',
      titleTr: 'Geçmiş İlişkileri İyileştirmek',
      titleEn: 'Healing Past Relationships',
      subtitleTr: 'Karmik Venus dersleri',
      subtitleEn: 'Karmic Venus lessons',
      route: '/content/healing-past',
      fullContentTr: '''
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
      fullContentEn: '''
# Healing Past Relationships

Old relationships are not just memories, they are teachers. From an astrological perspective, recurring patterns may be related to karmic lessons.

## South Node and Past Patterns
The South Node represents past life habits. If it's in the 7th house or aspecting Venus, it points to relationship patterns.

## Recurring Themes
- Are you always dating the same type of people?
- Do your relationships end in similar ways?
- Do the same arguments repeat?

These are subconscious patterns and can be changed with awareness.

## Healing Steps

### 1. Acceptance
Accept what happened rather than denying it. "This happened and I am at peace with it."

### 2. Learn the Lesson
"What did this relationship teach me?" Transform pain by creating meaning.

### 3. Forgiveness
Forgive yourself and the other. Forgiveness is not approving the past, it's freeing yourself from the present.

### 4. Release
Cut the energy cords. Through meditation, ritual, or symbolic action.

### 5. New Intention
"What will I do differently in my relationships from now on?"

## Venus Retrograde Periods
Time to face past relationships. Exes may return — this is an opportunity for closure, not repetition.
''',
    ),
  ];

  /// Get sections by category or badge (language-aware)
  static List<VenusContentSection> getSectionsByBadge(
    String badge,
    AppLanguage lang,
  ) {
    return sections.where((s) => s.getBadge(lang) == badge).toList();
  }

  /// Get popular sections (language-aware)
  static List<VenusContentSection> getPopularSections(AppLanguage lang) {
    final badge = lang == AppLanguage.en ? 'Popular' : 'Popüler';
    return sections.where((s) => s.getBadge(lang) == badge).toList();
  }

  /// Get new sections (language-aware)
  static List<VenusContentSection> getNewSections(AppLanguage lang) {
    final badge = lang == AppLanguage.en ? 'New' : 'Yeni';
    return sections.where((s) => s.getBadge(lang) == badge).toList();
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
