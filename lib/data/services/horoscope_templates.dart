import 'dart:math';
import '../models/zodiac_sign.dart';
import '../providers/app_providers.dart';

/// Horoscope content templates for algorithmic generation
/// Uses seeded random selection for deterministic, reproducible daily readings
class HoroscopeTemplates {
  // General daily opening statements (50+ variations)
  static List<String> getGeneralOpenings({AppLanguage language = AppLanguage.tr}) {
    return language == AppLanguage.tr ? _generalOpeningsTr : _generalOpeningsEn;
  }

  static const List<String> _generalOpeningsTr = [
    'Bugün enerjin yüksek ve motivasyonun güçlü.',
    'Evren sana yeni fırsatlar sunuyor.',
    'İç sesin bugün özellikle güçlü konuşuyor.',
    'Bugün değişim rüzgarları esiyor.',
    'Yıldızlar senin için olumlu bir hizalanma içinde.',
    'Bugün kendine odaklanman gereken bir gün.',
    'Sabırlı olmak bugün en büyük gücün olacak.',
    'Yaratıcılığın bugün zirve yapıyor.',
    'Bugün duygusal farkındalığın artıyor.',
    'Yeni başlangıçlar için ideal bir gün.',
    'Bugün geçmişle yüzleşme zamanı olabilir.',
    'Evren seni doğru yola yönlendiriyor.',
    'İç huzurun bugün ön planda olacak.',
    'Cesaret gerektiren adımlar için uygun bir gün.',
    'Bugün detaylara dikkat etmen gerekiyor.',
    'Sosyal bağlantıların bugün güçleniyor.',
    'Finansal konularda dikkatli olman gereken bir gün.',
    'Bugün sezgilerin seni yanıltmayacak.',
    'Beklenmedik haberler alabilirsin.',
    'Bugün öz güvenin artıyor.',
    'Evren sana bir mesaj gönderiyor.',
    'Ruhsal gelişimin için önemli bir gün.',
    'Bugün pratik düşünce ön planda.',
    'Romantik enerjiler güçleniyor.',
    'Kariyer odaklı düşünceler ön planda olacak.',
    'Bugün aile konuları gündeme gelebilir.',
    'İletişim becerilerin bugün parlıyor.',
    'Bugün eski dostlardan haber alabilirsin.',
    'Yeni projeler için ilham dolu bir gün.',
    'Bugün dinlenmeye öncelik ver.',
    'Evren sana cesaret veriyor.',
    'İçsel dönüşüm için güçlü bir gün.',
    'Bugün sınırlarını zorlamaktan korkma.',
    'Olumlu enerjiler etrafını sarıyor.',
    'Bugün mantık ve duygu dengesini kur.',
    'Yeni insanlarla tanışma fırsatı doğabilir.',
    'Bugün hedeflerine odaklan.',
    'Evren seni destekliyor.',
    'İç çatışmalar bugün çözüme kavuşabilir.',
    'Bugün liderlik özelliklerini göster.',
    'Sanatsal ilhamlar güçleniyor.',
    'Bugün rutinlerini gözden geçir.',
    'Beklenmedik fırsatlar kapını çalabilir.',
    'Bugün empati gücün artıyor.',
    'Evren sana sabır dersi veriyor.',
    'İç dünyana yolculuk için ideal bir gün.',
    'Bugün çevrene pozitif enerji yay.',
    'Kişisel gelişim için motive olduğun bir gün.',
    'Bugün risk almaktan korkma.',
    'Evren seninle işbirliği yapıyor.',
  ];

  static const List<String> _generalOpeningsEn = [
    'Your energy is high and your motivation is strong today.',
    'The universe is offering you new opportunities.',
    'Your inner voice speaks especially loud today.',
    'Winds of change are blowing today.',
    'The stars are in a favorable alignment for you.',
    'Today is a day to focus on yourself.',
    'Patience will be your greatest strength today.',
    'Your creativity peaks today.',
    'Your emotional awareness is increasing today.',
    'An ideal day for new beginnings.',
    'Today might be the time to face the past.',
    'The universe is guiding you to the right path.',
    'Your inner peace will be at the forefront today.',
    'A suitable day for steps that require courage.',
    'You need to pay attention to details today.',
    'Your social connections are strengthening today.',
    'A day to be careful about financial matters.',
    'Your intuition won\'t mislead you today.',
    'You might receive unexpected news.',
    'Your self-confidence is rising today.',
    'The universe is sending you a message.',
    'An important day for your spiritual development.',
    'Practical thinking is at the forefront today.',
    'Romantic energies are strengthening.',
    'Career-focused thoughts will be prominent.',
    'Family matters may come up today.',
    'Your communication skills shine today.',
    'You might hear from old friends today.',
    'An inspiring day for new projects.',
    'Prioritize rest today.',
    'The universe gives you courage.',
    'A powerful day for inner transformation.',
    'Don\'t be afraid to push your limits today.',
    'Positive energies surround you.',
    'Balance logic and emotion today.',
    'An opportunity to meet new people may arise.',
    'Focus on your goals today.',
    'The universe supports you.',
    'Internal conflicts may find resolution today.',
    'Show your leadership qualities today.',
    'Artistic inspirations are strengthening.',
    'Review your routines today.',
    'Unexpected opportunities might knock on your door.',
    'Your empathy power increases today.',
    'The universe is giving you a patience lesson.',
    'An ideal day for a journey into your inner world.',
    'Spread positive energy to those around you today.',
    'A day when you feel motivated for personal growth.',
    'Don\'t be afraid to take risks today.',
    'The universe is collaborating with you.',
  ];

  // Love/Relationship advice (50+ variations)
  static List<String> getLoveAdvice({AppLanguage language = AppLanguage.tr}) {
    return language == AppLanguage.tr ? _loveAdviceTr : _loveAdviceEn;
  }

  static const List<String> _loveAdviceTr = [
    'Aşk hayatında güzel sürprizler olabilir.',
    'Partnerinle derin bir bağ kurabilirsin.',
    'Yalnızsan, yeni biri ile tanışma ihtimalin yüksek.',
    'Romantik jestler bugün karşılık bulacak.',
    'İlişkinde iletişimi güçlendirmeye odaklan.',
    'Duygularını ifade etmekten çekinme.',
    'Partnerinin ihtiyaçlarına kulak ver.',
    'Aşk hayatında netlik kazanacaksın.',
    'Eski bir aşk aklına gelebilir.',
    'Kalp kırıklıkları bugün iyileşmeye başlayabilir.',
    'Romantik bir davet alabilirsin.',
    'Partnerinle kaliteli zaman geçir.',
    'Flört enerjin bugün yüksek.',
    'İlişkinde güven konuları gündeme gelebilir.',
    'Sevdiklerinle bağlarını güçlendir.',
    'Aşkta sabırlı ol, her şey zamanla.',
    'Duygusal yakınlık kurma fırsatı doğuyor.',
    'Partnerinle ortak hedefler belirleyin.',
    'Aşk hayatında yeni bir sayfa açılıyor.',
    'Geçmiş ilişki kalıplarını gözden geçir.',
    'Romantizmi günlük hayata taşı.',
    'Partnerini olduğu gibi kabul et.',
    'Aşkta risk almak seni ödüllendirebilir.',
    'Duygusal bağlarını derinleştir.',
    'İlişkinde denge kurmaya çalış.',
    'Sevgi dolu anlar seni bekliyor.',
    'Aşk hayatında netleşme zamanı.',
    'Partnerinle açık iletişim kur.',
    'Romantik hayallerin gerçekleşebilir.',
    'Aşkta cesur adımlar atma zamanı.',
    'Duygusal iyileşme sürecinde ilerleme.',
    'Yeni aşk kapıları açılıyor.',
    'Partnerinle birlikte büyüyün.',
    'Aşk hayatında sürprizlere açık ol.',
    'Kalbinin sesini dinle.',
    'İlişkinde uyum artıyor.',
    'Romantik enerjiler zirvede.',
    'Aşkta tutku yeniden alevleniyor.',
    'Partnerinle güzel anılar biriktirin.',
    'Duygusal destek alacaksın.',
    'Aşk hayatında berraklık geliyor.',
    'Yeni tanışıklıklar önemli olabilir.',
    'Partnerinle empati kurmaya çalış.',
    'Aşkta olgunlaşma zamanı.',
    'Romantik atmosfer yaratmaya odaklan.',
    'Duygusal bağlılık güçleniyor.',
    'Aşk hayatında pozitif gelişmeler.',
    'Partnerinle geleceği konuşun.',
    'Kalbin açık ve hazır.',
    'Aşkta yeni başlangıçlar mümkün.',
  ];

  static const List<String> _loveAdviceEn = [
    'There might be beautiful surprises in your love life.',
    'You can form a deep bond with your partner.',
    'If you\'re single, there\'s a high chance of meeting someone new.',
    'Romantic gestures will be reciprocated today.',
    'Focus on strengthening communication in your relationship.',
    'Don\'t hesitate to express your feelings.',
    'Listen to your partner\'s needs.',
    'You will gain clarity in your love life.',
    'An old love might come to mind.',
    'Heartbreaks may begin healing today.',
    'You might receive a romantic invitation.',
    'Spend quality time with your partner.',
    'Your flirting energy is high today.',
    'Trust issues may come up in your relationship.',
    'Strengthen bonds with your loved ones.',
    'Be patient in love, everything takes time.',
    'An opportunity for emotional intimacy is arising.',
    'Set common goals with your partner.',
    'A new page is opening in your love life.',
    'Review past relationship patterns.',
    'Bring romance into daily life.',
    'Accept your partner as they are.',
    'Taking risks in love might reward you.',
    'Deepen your emotional bonds.',
    'Try to establish balance in your relationship.',
    'Loving moments await you.',
    'Time for clarification in love life.',
    'Establish open communication with your partner.',
    'Romantic dreams may come true.',
    'Time to take bold steps in love.',
    'Progress in emotional healing process.',
    'New love doors are opening.',
    'Grow together with your partner.',
    'Be open to surprises in love life.',
    'Listen to your heart\'s voice.',
    'Harmony in your relationship is increasing.',
    'Romantic energies at peak.',
    'Passion in love is reigniting.',
    'Collect beautiful memories with your partner.',
    'You will receive emotional support.',
    'Clarity coming in love life.',
    'New acquaintances might be important.',
    'Try to empathize with your partner.',
    'Time for maturing in love.',
    'Focus on creating a romantic atmosphere.',
    'Emotional commitment strengthening.',
    'Positive developments in love life.',
    'Talk about the future with your partner.',
    'Your heart is open and ready.',
    'New beginnings in love are possible.',
  ];

  // Career/Work advice (50+ variations)
  static List<String> getCareerAdvice({AppLanguage language = AppLanguage.tr}) {
    return language == AppLanguage.tr ? _careerAdviceTr : _careerAdviceEn;
  }

  static const List<String> _careerAdviceTr = [
    'İş hayatında önemli fırsatlar doğabilir.',
    'Profesyonel becerilerini sergileme zamanı.',
    'Yeni projeler için uygun bir gün.',
    'Kariyer hedeflerini gözden geçir.',
    'İş yerinde liderlik özelliklerini göster.',
    'Finansal konularda dikkatli ol.',
    'İş arkadaşlarınla uyum içinde çalış.',
    'Yeni iş fırsatları kapını çalabilir.',
    'Profesyonel ağını genişlet.',
    'İş hayatında yaratıcı çözümler bul.',
    'Kariyer planlarını netleştir.',
    'Üstlerinle ilişkilerini güçlendir.',
    'İş hayatında sabır göster.',
    'Yeni beceriler öğrenmek için ideal bir gün.',
    'Profesyonel gelişimine yatırım yap.',
    'İş yerinde inisiyatif al.',
    'Finansal planlama için uygun bir gün.',
    'Kariyer değişikliği düşünebilirsin.',
    'İş hayatında denge kurmaya çalış.',
    'Profesyonel hedeflerine odaklan.',
    'Yeni müşteriler veya ortaklıklar mümkün.',
    'İş yerinde diplomatik ol.',
    'Kariyer fırsatlarına açık ol.',
    'Finansal istikrar için adımlar at.',
    'İş hayatında verimlilik artıyor.',
    'Profesyonel itibarını güçlendir.',
    'Yeni projeler ilham verici olabilir.',
    'İş arkadaşlarından destek alacaksın.',
    'Kariyer hedeflerine doğru ilerliyorsun.',
    'Finansal kararlar için uygun bir gün.',
    'İş hayatında değişimler olabilir.',
    'Profesyonel eğitimlere katıl.',
    'Yeni sorumluluklar alabilirsin.',
    'İş yerinde pozitif enerji yay.',
    'Kariyer planlarını gözden geçir.',
    'Finansal fırsatları değerlendir.',
    'İş hayatında başarı yaklaşıyor.',
    'Profesyonel ilişkilerini koru.',
    'Yeni fikirler sunma zamanı.',
    'İş yerinde problem çözme becerilerin parlıyor.',
    'Kariyer yolculuğunda önemli bir gün.',
    'Finansal hedeflere doğru ilerleme.',
    'İş hayatında motivasyon artıyor.',
    'Profesyonel gelişim fırsatları.',
    'Yeni ortaklıklar kurabilirsin.',
    'İş yerinde dikkatli iletişim kur.',
    'Kariyer atılımları için hazırlan.',
    'Finansal bilincin artıyor.',
    'İş hayatında yeni kapılar açılıyor.',
    'Profesyonel hedeflerine ulaşıyorsun.',
  ];

  static const List<String> _careerAdviceEn = [
    'Important opportunities may arise in your work life.',
    'Time to showcase your professional skills.',
    'A suitable day for new projects.',
    'Review your career goals.',
    'Show leadership qualities at work.',
    'Be careful about financial matters.',
    'Work in harmony with your colleagues.',
    'New job opportunities might knock on your door.',
    'Expand your professional network.',
    'Find creative solutions in work life.',
    'Clarify your career plans.',
    'Strengthen relationships with your superiors.',
    'Show patience in work life.',
    'An ideal day for learning new skills.',
    'Invest in your professional development.',
    'Take initiative at work.',
    'A suitable day for financial planning.',
    'You might consider a career change.',
    'Try to establish balance in work life.',
    'Focus on your professional goals.',
    'New clients or partnerships are possible.',
    'Be diplomatic at work.',
    'Be open to career opportunities.',
    'Take steps for financial stability.',
    'Productivity in work life is increasing.',
    'Strengthen your professional reputation.',
    'New projects might be inspiring.',
    'You will get support from colleagues.',
    'You\'re progressing toward career goals.',
    'A suitable day for financial decisions.',
    'Changes in work life may occur.',
    'Attend professional training.',
    'You might take on new responsibilities.',
    'Spread positive energy at work.',
    'Review your career plans.',
    'Evaluate financial opportunities.',
    'Success in work life is approaching.',
    'Protect your professional relationships.',
    'Time to present new ideas.',
    'Your problem-solving skills at work are shining.',
    'An important day in career journey.',
    'Progress toward financial goals.',
    'Motivation in work life is increasing.',
    'Professional development opportunities.',
    'You might establish new partnerships.',
    'Establish careful communication at work.',
    'Prepare for career breakthroughs.',
    'Your financial awareness is increasing.',
    'New doors are opening in work life.',
    'You\'re reaching your professional goals.',
  ];

  // Health/Wellness advice (50+ variations)
  static List<String> getHealthAdvice({AppLanguage language = AppLanguage.tr}) {
    return language == AppLanguage.tr ? _healthAdviceTr : _healthAdviceEn;
  }

  static const List<String> _healthAdviceTr = [
    'Sağlığına ekstra dikkat göster.',
    'Fiziksel aktiviteye zaman ayır.',
    'Beslenme alışkanlıklarını gözden geçir.',
    'Stres yönetimine odaklan.',
    'Uyku düzenini korumaya çalış.',
    'Zihinsel sağlığına özen göster.',
    'Egzersiz yapmak için motivasyonun yüksek.',
    'Meditasyon veya yoga düşün.',
    'Su tüketimini artırmaya dikkat et.',
    'Enerji seviyen dengeli olacak.',
    'Doğada vakit geçirmek sana iyi gelecek.',
    'Sağlıklı sınırlar koymaya çalış.',
    'Fiziksel yorgunluk hissedebilirsin.',
    'Ruh sağlığına yatırım yap.',
    'Sağlık kontrollerini ihmal etme.',
    'Enerji seviyen bugün yüksek.',
    'Stresli durumlardan uzak dur.',
    'Sağlıklı rutinler oluştur.',
    'Nefes egzersizleri faydalı olabilir.',
    'Fiziksel aktivite moralini yükseltecek.',
    'Uyku kalitenize dikkat edin.',
    'Sağlık konusunda bilinçli kararlar al.',
    'Enerji dengesini koru.',
    'Stresin vücuduna etkisine dikkat et.',
    'Sağlıklı beslenmeye önem ver.',
    'Fiziksel ve zihinsel denge için çalış.',
    'Dinlenmeye zaman ayır.',
    'Sağlığınla ilgili profesyonel destek düşün.',
    'Enerji seviyen yükseliyor.',
    'Stres atma yöntemlerini dene.',
    'Sağlık rutinlerini gözden geçir.',
    'Fiziksel aktivite motive edici olacak.',
    'Zihinsel dinlenmeye ihtiyacın var.',
    'Sağlıklı alışkanlıklar için ideal gün.',
    'Enerji yönetimine dikkat et.',
    'Stresle başa çıkma stratejileri geliştir.',
    'Sağlık hedeflerine odaklan.',
    'Fiziksel dayanıklılığın artıyor.',
    'Zihinsel berraklık hissedeceksin.',
    'Sağlıklı yaşam tarzı için adımlar at.',
    'Enerji ve motivasyon yüksek.',
    'Stres kaynaklarını belirle.',
    'Sağlık açısından olumlu bir gün.',
    'Fiziksel ve duygusal denge kur.',
    'Zihinsel sağlık için kendinle zaman geçir.',
    'Sağlık konularında bilinçlen.',
    'Enerji seviyeni dengede tut.',
    'Stres azaltma teknikleri dene.',
    'Sağlıklı seçimler yap.',
    'Fiziksel aktiviteyle gününe başla.',
  ];

  static const List<String> _healthAdviceEn = [
    'Pay extra attention to your health.',
    'Make time for physical activity.',
    'Review your eating habits.',
    'Focus on stress management.',
    'Try to maintain your sleep schedule.',
    'Take care of your mental health.',
    'Your motivation to exercise is high.',
    'Consider meditation or yoga.',
    'Pay attention to increasing water intake.',
    'Your energy levels will be balanced.',
    'Spending time in nature will be good for you.',
    'Try to set healthy boundaries.',
    'You might feel physical fatigue.',
    'Invest in your mental health.',
    'Don\'t neglect health checkups.',
    'Your energy levels are high today.',
    'Stay away from stressful situations.',
    'Create healthy routines.',
    'Breathing exercises might be beneficial.',
    'Physical activity will boost your mood.',
    'Pay attention to your sleep quality.',
    'Make conscious decisions about health.',
    'Maintain energy balance.',
    'Pay attention to stress\'s effect on your body.',
    'Prioritize healthy eating.',
    'Work for physical and mental balance.',
    'Make time for rest.',
    'Consider professional support for your health.',
    'Your energy levels are rising.',
    'Try stress relief methods.',
    'Review health routines.',
    'Physical activity will be motivating.',
    'You need mental rest.',
    'An ideal day for healthy habits.',
    'Pay attention to energy management.',
    'Develop stress coping strategies.',
    'Focus on health goals.',
    'Your physical endurance is increasing.',
    'You will feel mental clarity.',
    'Take steps for a healthy lifestyle.',
    'Energy and motivation are high.',
    'Identify stress sources.',
    'A positive day for health.',
    'Establish physical and emotional balance.',
    'Spend time with yourself for mental health.',
    'Become aware of health matters.',
    'Keep your energy level balanced.',
    'Try stress reduction techniques.',
    'Make healthy choices.',
    'Start your day with physical activity.',
  ];

  // Planetary influence modifiers
  static Map<String, List<String>> getPlanetaryModifiers({AppLanguage language = AppLanguage.tr}) {
    return language == AppLanguage.tr ? _planetaryModifiersTr : _planetaryModifiersEn;
  }

  static const Map<String, List<String>> _planetaryModifiersTr = {
    'mercury_retrograde': [
      'Merkür retrosu nedeniyle iletişimde dikkatli ol.',
      'Teknolojik aksaklıklar yaşanabilir.',
      'Eski konuları yeniden düşünme zamanı.',
      'Sözleşmeleri dikkatli incele.',
      'Geçmişten biri aklına gelebilir.',
    ],
    'venus_retrograde': [
      'Venüs retrosu aşk hayatını etkiliyor.',
      'Eski ilişkileri sorgulama zamanı.',
      'Finansal kararları ertele.',
      'Güzellik ve estetik konularında dikkatli ol.',
      'Değerlerini yeniden gözden geçir.',
    ],
    'mars_retrograde': [
      'Mars retrosu enerji düşüklüğüne neden olabilir.',
      'Öfke kontrolüne dikkat et.',
      'Büyük projeler başlatmaktan kaçın.',
      'Fiziksel aktivitelerde dikkatli ol.',
      'Motivasyon dalgalanmaları yaşanabilir.',
    ],
    'full_moon': [
      'Dolunay duygusal yoğunluk getiriyor.',
      'İç görüler güçleniyor.',
      'Tamamlanma ve sonuçlanma enerjisi.',
      'Duygusal arınma zamanı.',
      'Sezgilerine güven.',
    ],
    'new_moon': [
      'Yeni ay yeni başlangıçlar için ideal.',
      'Niyet belirleme zamanı.',
      'İçe dönük bir dönem.',
      'Yeni projeler planla.',
      'Tohumlar ekme zamanı.',
    ],
  };

  static const Map<String, List<String>> _planetaryModifiersEn = {
    'mercury_retrograde': [
      'Be careful with communication due to Mercury retrograde.',
      'Technological glitches may occur.',
      'Time to reconsider old matters.',
      'Examine contracts carefully.',
      'Someone from the past might come to mind.',
    ],
    'venus_retrograde': [
      'Venus retrograde is affecting your love life.',
      'Time to question old relationships.',
      'Postpone financial decisions.',
      'Be careful about beauty and aesthetics.',
      'Reevaluate your values.',
    ],
    'mars_retrograde': [
      'Mars retrograde may cause low energy.',
      'Pay attention to anger control.',
      'Avoid starting major projects.',
      'Be careful during physical activities.',
      'Motivation fluctuations may occur.',
    ],
    'full_moon': [
      'Full moon brings emotional intensity.',
      'Inner insights are strengthening.',
      'Energy of completion and conclusion.',
      'Time for emotional cleansing.',
      'Trust your intuition.',
    ],
    'new_moon': [
      'New moon is ideal for new beginnings.',
      'Time to set intentions.',
      'An introverted period.',
      'Plan new projects.',
      'Time to plant seeds.',
    ],
  };

  // Lucky colors by zodiac sign
  static Map<ZodiacSign, List<String>> getLuckyColors({AppLanguage language = AppLanguage.tr}) {
    return language == AppLanguage.tr ? _luckyColorsTr : _luckyColorsEn;
  }

  static const Map<ZodiacSign, List<String>> _luckyColorsTr = {
    ZodiacSign.aries: ['Kırmızı', 'Turuncu', 'Sarı', 'Beyaz'],
    ZodiacSign.taurus: ['Yeşil', 'Pembe', 'Mavi', 'Toprak Tonları'],
    ZodiacSign.gemini: ['Sarı', 'Açık Mavi', 'Yeşil', 'Beyaz'],
    ZodiacSign.cancer: ['Gümüş', 'Beyaz', 'Krem', 'Açık Mavi'],
    ZodiacSign.leo: ['Altın', 'Turuncu', 'Sarı', 'Mor'],
    ZodiacSign.virgo: ['Yeşil', 'Kahverengi', 'Bej', 'Lacivert'],
    ZodiacSign.libra: ['Pembe', 'Açık Mavi', 'Lavanta', 'Yeşil'],
    ZodiacSign.scorpio: ['Bordo', 'Siyah', 'Mor', 'Koyu Kırmızı'],
    ZodiacSign.sagittarius: ['Mor', 'Mavi', 'Turuncu', 'Turkuaz'],
    ZodiacSign.capricorn: ['Siyah', 'Koyu Yeşil', 'Kahverengi', 'Gri'],
    ZodiacSign.aquarius: ['Mavi', 'Turkuaz', 'Mor', 'Gümüş'],
    ZodiacSign.pisces: ['Deniz Mavisi', 'Yeşil', 'Mor', 'Lila'],
  };

  static const Map<ZodiacSign, List<String>> _luckyColorsEn = {
    ZodiacSign.aries: ['Red', 'Orange', 'Yellow', 'White'],
    ZodiacSign.taurus: ['Green', 'Pink', 'Blue', 'Earth Tones'],
    ZodiacSign.gemini: ['Yellow', 'Light Blue', 'Green', 'White'],
    ZodiacSign.cancer: ['Silver', 'White', 'Cream', 'Light Blue'],
    ZodiacSign.leo: ['Gold', 'Orange', 'Yellow', 'Purple'],
    ZodiacSign.virgo: ['Green', 'Brown', 'Beige', 'Navy Blue'],
    ZodiacSign.libra: ['Pink', 'Light Blue', 'Lavender', 'Green'],
    ZodiacSign.scorpio: ['Burgundy', 'Black', 'Purple', 'Dark Red'],
    ZodiacSign.sagittarius: ['Purple', 'Blue', 'Orange', 'Turquoise'],
    ZodiacSign.capricorn: ['Black', 'Dark Green', 'Brown', 'Gray'],
    ZodiacSign.aquarius: ['Blue', 'Turquoise', 'Purple', 'Silver'],
    ZodiacSign.pisces: ['Sea Blue', 'Green', 'Purple', 'Lilac'],
  };

  /// Generate a seeded random number
  static int _generateSeed(DateTime date, ZodiacSign sign) {
    return date.year * 10000 +
        date.month * 100 +
        date.day +
        sign.index * 1000000;
  }

  /// Get a random item from a list using seeded random
  static String _getSeededItem(List<String> items, int seed, int offset) {
    final random = Random(seed + offset);
    return items[random.nextInt(items.length)];
  }

  /// Generate daily horoscope reading
  static Map<String, dynamic> generateDailyReading(
      DateTime date, ZodiacSign sign, {AppLanguage language = AppLanguage.tr}) {
    final seed = _generateSeed(date, sign);
    final random = Random(seed);

    // Generate readings with language support
    final generalList = getGeneralOpenings(language: language);
    final loveList = getLoveAdvice(language: language);
    final careerList = getCareerAdvice(language: language);
    final healthList = getHealthAdvice(language: language);
    final colorList = getLuckyColors(language: language);

    final general = _getSeededItem(generalList, seed, 0);
    final love = _getSeededItem(loveList, seed, 100);
    final career = _getSeededItem(careerList, seed, 200);
    final health = _getSeededItem(healthList, seed, 300);

    // Generate scores (based on seed for consistency)
    final moodScore = 0.5 + (random.nextDouble() * 0.5); // 0.5-1.0
    final loveScore = 0.4 + (random.nextDouble() * 0.6); // 0.4-1.0
    final careerScore = 0.4 + (random.nextDouble() * 0.6); // 0.4-1.0
    final healthScore = 0.5 + (random.nextDouble() * 0.5); // 0.5-1.0

    // Lucky number (1-99)
    final luckyNumber = 1 + random.nextInt(99);

    // Lucky color
    final defaultColor = language == AppLanguage.tr ? 'Beyaz' : 'White';
    final colors = colorList[sign] ?? [defaultColor];
    final luckyColor = colors[random.nextInt(colors.length)];

    return {
      'general': general,
      'love': love,
      'career': career,
      'health': health,
      'moodScore': moodScore,
      'loveScore': loveScore,
      'careerScore': careerScore,
      'healthScore': healthScore,
      'luckyNumber': luckyNumber,
      'luckyColor': luckyColor,
      'date': date,
      'sign': sign,
    };
  }

  /// Apply planetary modifier if applicable
  static String applyModifier(String reading, String modifier, {AppLanguage language = AppLanguage.tr}) {
    final modifierMap = getPlanetaryModifiers(language: language);
    final modifiers = modifierMap[modifier];
    if (modifiers != null && modifiers.isNotEmpty) {
      final random = Random();
      return '$reading ${modifiers[random.nextInt(modifiers.length)]}';
    }
    return reading;
  }

  /// Generate compatibility summary
  static String generateCompatibilitySummary(
      ZodiacSign sign1, ZodiacSign sign2, int overallScore, {AppLanguage language = AppLanguage.tr}) {
    final sign1Name = language == AppLanguage.tr ? sign1.nameTr : sign1.name;
    final sign2Name = language == AppLanguage.tr ? sign2.nameTr : sign2.name;

    if (language == AppLanguage.tr) {
      if (overallScore >= 80) {
        return '$sign1Name ve $sign2Name arasında güçlü bir uyum var. '
            'Bu ilişki karşılıklı anlayış ve derin bağ potansiyeli taşıyor.';
      } else if (overallScore >= 60) {
        return '$sign1Name ve $sign2Name iyi bir uyum sergiliyor. '
            'Bazı farklılıklar olsa da, birbirini tamamlama potansiyeli yüksek.';
      } else if (overallScore >= 40) {
        return '$sign1Name ve $sign2Name arasında orta düzeyde uyum var. '
            'İlişkinin gelişmesi için karşılıklı çaba gerekebilir.';
      } else {
        return '$sign1Name ve $sign2Name arasında zorlayıcı bir dinamik var. '
            'Bu ilişki büyüme fırsatları sunarken, sabır ve anlayış gerektiriyor.';
      }
    } else {
      if (overallScore >= 80) {
        return 'There is strong compatibility between $sign1Name and $sign2Name. '
            'This relationship carries potential for mutual understanding and deep connection.';
      } else if (overallScore >= 60) {
        return '$sign1Name and $sign2Name show good compatibility. '
            'Despite some differences, there is high potential to complement each other.';
      } else if (overallScore >= 40) {
        return 'There is moderate compatibility between $sign1Name and $sign2Name. '
            'Mutual effort may be needed for the relationship to develop.';
      } else {
        return 'There is a challenging dynamic between $sign1Name and $sign2Name. '
            'While this relationship offers growth opportunities, it requires patience and understanding.';
      }
    }
  }
}
