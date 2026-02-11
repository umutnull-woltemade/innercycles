// ignore_for_file: unused_element

import 'dart:math';
import '../models/zodiac_sign.dart';
import '../models/extended_horoscope.dart';
import '../providers/app_providers.dart';
import 'extended_horoscope_content.dart';
import 'l10n_service.dart';

class ExtendedHoroscopeService {
  // ============ WEEKLY HOROSCOPE ============

  static WeeklyHoroscope generateWeeklyHoroscope(
    ZodiacSign sign,
    DateTime weekStart, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final weekEnd = weekStart.add(const Duration(days: 6));
    final seed =
        weekStart.year * 10000 + _getWeekOfYear(weekStart) * 100 + sign.index;
    final seededRandom = Random(seed);

    final overviews = ExtendedHoroscopeContent.getWeeklyOverviews(
      sign,
      language,
    );
    final loves = ExtendedHoroscopeContent.getWeeklyLoveContent(language);
    final careers = ExtendedHoroscopeContent.getWeeklyCareerContent(language);
    final healths = ExtendedHoroscopeContent.getWeeklyHealthContent(language);
    final financials = ExtendedHoroscopeContent.getWeeklyFinancialContent(
      language,
    );
    final affirmations = ExtendedHoroscopeContent.getWeeklyAffirmations(
      language,
    );
    final days = ExtendedHoroscopeContent.getDays(language);

    return WeeklyHoroscope(
      sign: sign,
      weekStart: weekStart,
      weekEnd: weekEnd,
      overview: overviews[seededRandom.nextInt(overviews.length)],
      loveWeek: loves[seededRandom.nextInt(loves.length)],
      careerWeek: careers[seededRandom.nextInt(careers.length)],
      healthWeek: healths[seededRandom.nextInt(healths.length)],
      financialWeek: financials[seededRandom.nextInt(financials.length)],
      overallRating: seededRandom.nextInt(5) + 1,
      luckyDay: days[seededRandom.nextInt(days.length)],
      weeklyAffirmation:
          affirmations[seededRandom.nextInt(affirmations.length)],
      keyDates: _generateKeyDates(weekStart, seededRandom, language),
    );
  }

  static int _getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysDiff = date.difference(firstDayOfYear).inDays;
    return (daysDiff / 7).ceil() + 1;
  }

  static List<String> _generateKeyDates(
    DateTime weekStart,
    Random seededRandom,
    AppLanguage language,
  ) {
    final keyDates = <String>[];
    final numDates = seededRandom.nextInt(3) + 1;
    final events = ExtendedHoroscopeContent.getKeyDateEvents(language);

    for (int i = 0; i < numDates; i++) {
      final day = weekStart.add(Duration(days: seededRandom.nextInt(7)));
      final dayStr = '${day.day}.${day.month}';
      keyDates.add('$dayStr - ${events[seededRandom.nextInt(events.length)]}');
    }
    return keyDates;
  }

  // ============ MONTHLY HOROSCOPE ============

  static MonthlyHoroscope generateMonthlyHoroscope(
    ZodiacSign sign,
    int month,
    int year, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final seed = year * 10000 + month * 100 + sign.index;
    final seededRandom = Random(seed);

    final overviews = ExtendedHoroscopeContent.getMonthlyOverviews(
      sign,
      language,
    );
    final loves = ExtendedHoroscopeContent.getMonthlyLoveContent(language);
    final careers = ExtendedHoroscopeContent.getMonthlyCareerContent(language);
    final healths = ExtendedHoroscopeContent.getMonthlyHealthContent(language);
    final financials = ExtendedHoroscopeContent.getMonthlyFinancialContent(
      language,
    );
    final spirituals = ExtendedHoroscopeContent.getMonthlySpiritualContent(
      language,
    );
    final mantras = ExtendedHoroscopeContent.getMonthlyMantras(language);
    final transits = _getMonthlyTransits(sign, month, language);

    final weeklyRatings = <String, int>{
      'week1': seededRandom.nextInt(5) + 1,
      'week2': seededRandom.nextInt(5) + 1,
      'week3': seededRandom.nextInt(5) + 1,
      'week4': seededRandom.nextInt(5) + 1,
    };

    final luckyDays = <String>[];
    for (int i = 0; i < 3; i++) {
      luckyDays.add('${seededRandom.nextInt(28) + 1}');
    }

    return MonthlyHoroscope(
      sign: sign,
      month: month,
      year: year,
      overview: overviews[seededRandom.nextInt(overviews.length)],
      loveMonth: loves[seededRandom.nextInt(loves.length)],
      careerMonth: careers[seededRandom.nextInt(careers.length)],
      healthMonth: healths[seededRandom.nextInt(healths.length)],
      financialMonth: financials[seededRandom.nextInt(financials.length)],
      spiritualGuidance: spirituals[seededRandom.nextInt(spirituals.length)],
      overallRating: seededRandom.nextInt(5) + 1,
      luckyDays: luckyDays,
      monthlyMantra: mantras[seededRandom.nextInt(mantras.length)],
      keyTransits: transits[seededRandom.nextInt(transits.length)],
      weeklyRatings: weeklyRatings,
    );
  }

  // ============ LOVE HOROSCOPE ============

  static LoveHoroscope generateLoveHoroscope(
    ZodiacSign sign,
    DateTime date, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final seed = date.year * 10000 + date.month * 100 + date.day + sign.index;
    final seededRandom = Random(seed);

    final outlooks = ExtendedHoroscopeContent.getRomanticOutlooks(
      sign,
      language,
    );
    final singles = ExtendedHoroscopeContent.getSingleAdvice(language);
    final couples = ExtendedHoroscopeContent.getCouplesAdvice(language);
    final souls = ExtendedHoroscopeContent.getSoulConnectionContent(language);
    final venus = ExtendedHoroscopeContent.getVenusInfluence(language);
    final intimacy = ExtendedHoroscopeContent.getIntimacyAdvice(language);

    final compatibleSigns = _getCompatibleSigns(sign);
    final challengingSigns = _getChallengingSigns(sign);

    return LoveHoroscope(
      sign: sign,
      date: date,
      romanticOutlook: outlooks[seededRandom.nextInt(outlooks.length)],
      singleAdvice: singles[seededRandom.nextInt(singles.length)],
      couplesAdvice: couples[seededRandom.nextInt(couples.length)],
      soulConnection: souls[seededRandom.nextInt(souls.length)],
      passionRating: seededRandom.nextInt(5) + 1,
      romanceRating: seededRandom.nextInt(5) + 1,
      communicationRating: seededRandom.nextInt(5) + 1,
      bestMatch: compatibleSigns[seededRandom.nextInt(compatibleSigns.length)],
      challengingMatch:
          challengingSigns[seededRandom.nextInt(challengingSigns.length)],
      venusInfluence: venus[seededRandom.nextInt(venus.length)],
      intimacyAdvice: intimacy[seededRandom.nextInt(intimacy.length)],
    );
  }

  // ============ YEARLY HOROSCOPE ============

  static YearlyHoroscope generateYearlyHoroscope(
    ZodiacSign sign,
    int year, {
    AppLanguage language = AppLanguage.tr,
  }) {
    final seed = year * 100 + sign.index;
    final seededRandom = Random(seed);

    final overviews = ExtendedHoroscopeContent.getYearlyOverviews(
      sign,
      language,
    );
    final loves = ExtendedHoroscopeContent.getYearlyLoveContent(language);
    final careers = ExtendedHoroscopeContent.getYearlyCareerContent(language);
    final healths = ExtendedHoroscopeContent.getYearlyHealthContent(language);
    final financials = ExtendedHoroscopeContent.getYearlyFinancialContent(
      language,
    );
    final spirituals = ExtendedHoroscopeContent.getYearlySpiritualContent(
      language,
    );
    final affirmations = ExtendedHoroscopeContent.getYearlyAffirmations(
      language,
    );
    final themes = ExtendedHoroscopeContent.getYearlyThemes(language);
    final transits = _getMajorTransits(year, language);

    final monthlyRatings = <int, int>{};
    for (int i = 1; i <= 12; i++) {
      monthlyRatings[i] = seededRandom.nextInt(5) + 1;
    }

    final luckyMonths = <String>[];
    final challengingMonths = <String>[];
    final months = ExtendedHoroscopeContent.getMonths(language);

    for (int i = 0; i < 3; i++) {
      luckyMonths.add(months[seededRandom.nextInt(12)]);
    }
    for (int i = 0; i < 2; i++) {
      challengingMonths.add(months[seededRandom.nextInt(12)]);
    }

    return YearlyHoroscope(
      sign: sign,
      year: year,
      yearOverview: overviews[seededRandom.nextInt(overviews.length)],
      loveYear: loves[seededRandom.nextInt(loves.length)],
      careerYear: careers[seededRandom.nextInt(careers.length)],
      healthYear: healths[seededRandom.nextInt(healths.length)],
      financialYear: financials[seededRandom.nextInt(financials.length)],
      spiritualJourney: spirituals[seededRandom.nextInt(spirituals.length)],
      overallRating: seededRandom.nextInt(5) + 1,
      monthlyRatings: monthlyRatings,
      majorTransits: transits,
      luckyMonths: luckyMonths,
      challengingMonths: challengingMonths,
      yearlyAffirmation:
          affirmations[seededRandom.nextInt(affirmations.length)],
      keyTheme: themes[seededRandom.nextInt(themes.length)],
    );
  }

  // ============ ECLIPSE CALENDAR ============

  static List<EclipseEvent> getEclipsesForYear(
    int year, {
    AppLanguage language = AppLanguage.tr,
  }) {
    // Real eclipse data for 2024-2026
    final eclipses = <EclipseEvent>[];

    // Helper to get localized eclipse content
    String getEclipseText(String eclipseId, String field) {
      final key = 'eclipses.$eclipseId.$field';
      final localized = L10nService.get(key, language);
      return localized != key
          ? localized
          : ''; // Return empty if not found, will use fallback
    }

    if (year == 2024) {
      eclipses.addAll([
        EclipseEvent(
          date: DateTime(2024, 3, 25),
          type: EclipseType.lunarPenumbral,
          zodiacSign: ZodiacSign.libra,
          title: getEclipseText('2024_03_25', 'title').isNotEmpty
              ? getEclipseText('2024_03_25', 'title')
              : (language == AppLanguage.tr
                    ? 'Terazi Burcunda Yarıgölge Ay Tutulması'
                    : 'Penumbral Lunar Eclipse in Libra'),
          description: getEclipseText('2024_03_25', 'description').isNotEmpty
              ? getEclipseText('2024_03_25', 'description')
              : (language == AppLanguage.tr
                    ? 'Bu tutulma ilişkilerinizde denge arayışını tetikliyor.'
                    : 'This eclipse triggers a search for balance in your relationships.'),
          spiritualMeaning: getEclipseText('2024_03_25', 'spiritual').isNotEmpty
              ? getEclipseText('2024_03_25', 'spiritual')
              : (language == AppLanguage.tr
                    ? 'İlişkilerdeki dengesizlikleri fark etme ve düzeltme zamanı. Terazi enerjisi, adalet ve harmoni arayışını güçlendiriyor.'
                    : 'Time to recognize and correct imbalances in relationships. Libra energy strengthens the search for justice and harmony.'),
          practicalAdvice: getEclipseText('2024_03_25', 'advice').isNotEmpty
              ? getEclipseText('2024_03_25', 'advice')
              : (language == AppLanguage.tr
                    ? 'Partnerlilkte karşılıklı ihtiyaçları gözden geçirin. Taviz vermek ile sınır koymak arasındaki dengeyi bulun.'
                    : 'Review mutual needs in partnerships. Find the balance between compromise and setting boundaries.'),
          mostAffectedSigns: [
            ZodiacSign.libra,
            ZodiacSign.aries,
            ZodiacSign.cancer,
            ZodiacSign.capricorn,
          ],
          isVisible: true,
          peakTime: '10:13 UTC',
          magnitude: 0.96,
        ),
        EclipseEvent(
          date: DateTime(2024, 4, 8),
          type: EclipseType.solarTotal,
          zodiacSign: ZodiacSign.aries,
          title: getEclipseText('2024_04_08', 'title').isNotEmpty
              ? getEclipseText('2024_04_08', 'title')
              : (language == AppLanguage.tr
                    ? 'Koç Burcunda Tam Güneş Tutulması'
                    : 'Total Solar Eclipse in Aries'),
          description: getEclipseText('2024_04_08', 'description').isNotEmpty
              ? getEclipseText('2024_04_08', 'description')
              : (language == AppLanguage.tr
                    ? 'Güçlü bir yeni başlangıç enerjisi. Cesaretle ileri atılma zamanı.'
                    : 'Powerful new beginning energy. Time to step forward with courage.'),
          spiritualMeaning: getEclipseText('2024_04_08', 'spiritual').isNotEmpty
              ? getEclipseText('2024_04_08', 'spiritual')
              : (language == AppLanguage.tr
                    ? 'Kimlik dönüşümü ve yeniden doğuş. Eski benliği bırakıp, yeni bir sayfa açma fırsatı.'
                    : 'Identity transformation and rebirth. Opportunity to leave the old self behind and open a new chapter.'),
          practicalAdvice: getEclipseText('2024_04_08', 'advice').isNotEmpty
              ? getEclipseText('2024_04_08', 'advice')
              : (language == AppLanguage.tr
                    ? 'Büyük kararlar almak için ideal. Yeni projelere başlayın, cesur adımlar atın.'
                    : 'Ideal for making big decisions. Start new projects, take bold steps.'),
          mostAffectedSigns: [
            ZodiacSign.aries,
            ZodiacSign.libra,
            ZodiacSign.cancer,
            ZodiacSign.capricorn,
          ],
          isVisible: false,
          peakTime: '18:17 UTC',
          magnitude: 1.0,
        ),
        EclipseEvent(
          date: DateTime(2024, 9, 18),
          type: EclipseType.lunarPartial,
          zodiacSign: ZodiacSign.pisces,
          title: getEclipseText('2024_09_18', 'title').isNotEmpty
              ? getEclipseText('2024_09_18', 'title')
              : (language == AppLanguage.tr
                    ? 'Balık Burcunda Kısmi Ay Tutulması'
                    : 'Partial Lunar Eclipse in Pisces'),
          description: getEclipseText('2024_09_18', 'description').isNotEmpty
              ? getEclipseText('2024_09_18', 'description')
              : (language == AppLanguage.tr
                    ? 'Duygusal derinlik ve ruhsal uyanış.'
                    : 'Emotional depth and spiritual awakening.'),
          spiritualMeaning: getEclipseText('2024_09_18', 'spiritual').isNotEmpty
              ? getEclipseText('2024_09_18', 'spiritual')
              : (language == AppLanguage.tr
                    ? 'İç sesin güçlendiği bir dönem. Sezgilerinize güvenin, rüyalarınıza dikkat edin.'
                    : 'A period when your inner voice strengthens. Trust your intuitions, pay attention to your dreams.'),
          practicalAdvice: getEclipseText('2024_09_18', 'advice').isNotEmpty
              ? getEclipseText('2024_09_18', 'advice')
              : (language == AppLanguage.tr
                    ? 'Meditasyon ve içe dönüş pratikleri için ideal. Duygusal bagajlarınızı bırakın.'
                    : 'Ideal for meditation and introspection practices. Let go of emotional baggage.'),
          mostAffectedSigns: [
            ZodiacSign.pisces,
            ZodiacSign.virgo,
            ZodiacSign.gemini,
            ZodiacSign.sagittarius,
          ],
          isVisible: true,
          peakTime: '02:44 UTC',
          magnitude: 0.08,
        ),
        EclipseEvent(
          date: DateTime(2024, 10, 2),
          type: EclipseType.solarAnnular,
          zodiacSign: ZodiacSign.libra,
          title: getEclipseText('2024_10_02', 'title').isNotEmpty
              ? getEclipseText('2024_10_02', 'title')
              : (language == AppLanguage.tr
                    ? 'Terazi Burcunda Halkalı Güneş Tutulması'
                    : 'Annular Solar Eclipse in Libra'),
          description: getEclipseText('2024_10_02', 'description').isNotEmpty
              ? getEclipseText('2024_10_02', 'description')
              : (language == AppLanguage.tr
                    ? 'İlişki dinamiklerinde köklü değişiklikler.'
                    : 'Fundamental changes in relationship dynamics.'),
          spiritualMeaning: getEclipseText('2024_10_02', 'spiritual').isNotEmpty
              ? getEclipseText('2024_10_02', 'spiritual')
              : (language == AppLanguage.tr
                    ? 'Ortaklıklar ve bağlantılar konusunda yeni bir vizyon. Karşılıklılık ilkesini yeniden tanımlama.'
                    : 'A new vision for partnerships and connections. Redefining the principle of reciprocity.'),
          practicalAdvice: getEclipseText('2024_10_02', 'advice').isNotEmpty
              ? getEclipseText('2024_10_02', 'advice')
              : (language == AppLanguage.tr
                    ? 'Sözleşmeler, anlaşmalar ve resmi birliktelikler için dikkatli olun. Yeni ortaklıklar kurulabilir.'
                    : 'Be careful with contracts, agreements, and formal partnerships. New partnerships may form.'),
          mostAffectedSigns: [
            ZodiacSign.libra,
            ZodiacSign.aries,
            ZodiacSign.cancer,
            ZodiacSign.capricorn,
          ],
          isVisible: false,
          peakTime: '18:45 UTC',
          magnitude: 0.93,
        ),
      ]);
    } else if (year == 2025) {
      eclipses.addAll([
        EclipseEvent(
          date: DateTime(2025, 3, 14),
          type: EclipseType.lunarTotal,
          zodiacSign: ZodiacSign.virgo,
          title: getEclipseText('2025_03_14', 'title').isNotEmpty
              ? getEclipseText('2025_03_14', 'title')
              : (language == AppLanguage.tr
                    ? 'Başak Burcunda Tam Ay Tutulması'
                    : 'Total Lunar Eclipse in Virgo'),
          description: getEclipseText('2025_03_14', 'description').isNotEmpty
              ? getEclipseText('2025_03_14', 'description')
              : (language == AppLanguage.tr
                    ? 'Detaylara dikkat ve mükemmeliyetçilikle yüzleşme.'
                    : 'Attention to details and confronting perfectionism.'),
          spiritualMeaning: getEclipseText('2025_03_14', 'spiritual').isNotEmpty
              ? getEclipseText('2025_03_14', 'spiritual')
              : (language == AppLanguage.tr
                    ? 'Kendini eleştirme kalıplarını bırakma. Kusurlarınızı kabullenme ve şefkat geliştirme.'
                    : 'Releasing self-criticism patterns. Accepting your flaws and developing compassion.'),
          practicalAdvice: getEclipseText('2025_03_14', 'advice').isNotEmpty
              ? getEclipseText('2025_03_14', 'advice')
              : (language == AppLanguage.tr
                    ? 'Sağlık rutinlerinizi gözden geçirin. İş süreçlerini iyileştirin ama takıntılı olmayın.'
                    : 'Review your health routines. Improve work processes but don\'t become obsessive.'),
          mostAffectedSigns: [
            ZodiacSign.virgo,
            ZodiacSign.pisces,
            ZodiacSign.gemini,
            ZodiacSign.sagittarius,
          ],
          isVisible: true,
          peakTime: '06:58 UTC',
          magnitude: 1.0,
        ),
        EclipseEvent(
          date: DateTime(2025, 3, 29),
          type: EclipseType.solarPartial,
          zodiacSign: ZodiacSign.aries,
          title: getEclipseText('2025_03_29', 'title').isNotEmpty
              ? getEclipseText('2025_03_29', 'title')
              : (language == AppLanguage.tr
                    ? 'Koç Burcunda Kısmi Güneş Tutulması'
                    : 'Partial Solar Eclipse in Aries'),
          description: getEclipseText('2025_03_29', 'description').isNotEmpty
              ? getEclipseText('2025_03_29', 'description')
              : (language == AppLanguage.tr
                    ? 'Yeni başlangıçlar için enerji patlaması.'
                    : 'Energy burst for new beginnings.'),
          spiritualMeaning: getEclipseText('2025_03_29', 'spiritual').isNotEmpty
              ? getEclipseText('2025_03_29', 'spiritual')
              : (language == AppLanguage.tr
                    ? 'Öncü ruhunuzu kucaklayın. Liderlik potansiyelinizi aktive edin.'
                    : 'Embrace your pioneering spirit. Activate your leadership potential.'),
          practicalAdvice: getEclipseText('2025_03_29', 'advice').isNotEmpty
              ? getEclipseText('2025_03_29', 'advice')
              : (language == AppLanguage.tr
                    ? 'Girişimcilik ve yeni projeler için ideal. Korku yerine cesareti seçin.'
                    : 'Ideal for entrepreneurship and new projects. Choose courage over fear.'),
          mostAffectedSigns: [
            ZodiacSign.aries,
            ZodiacSign.libra,
            ZodiacSign.cancer,
            ZodiacSign.capricorn,
          ],
          isVisible: false,
          peakTime: '10:50 UTC',
          magnitude: 0.94,
        ),
        EclipseEvent(
          date: DateTime(2025, 9, 7),
          type: EclipseType.lunarTotal,
          zodiacSign: ZodiacSign.pisces,
          title: getEclipseText('2025_09_07', 'title').isNotEmpty
              ? getEclipseText('2025_09_07', 'title')
              : (language == AppLanguage.tr
                    ? 'Balık Burcunda Tam Ay Tutulması'
                    : 'Total Lunar Eclipse in Pisces'),
          description: getEclipseText('2025_09_07', 'description').isNotEmpty
              ? getEclipseText('2025_09_07', 'description')
              : (language == AppLanguage.tr
                    ? 'Derin duygusal arınma ve ruhsal yükseliş.'
                    : 'Deep emotional cleansing and spiritual ascension.'),
          spiritualMeaning: getEclipseText('2025_09_07', 'spiritual').isNotEmpty
              ? getEclipseText('2025_09_07', 'spiritual')
              : (language == AppLanguage.tr
                    ? 'Kolektif bilinçle bağlantı. Şifa ve sezgisel yeteneklerin güçlenmesi.'
                    : 'Connection with collective consciousness. Strengthening of healing and intuitive abilities.'),
          practicalAdvice: getEclipseText('2025_09_07', 'advice').isNotEmpty
              ? getEclipseText('2025_09_07', 'advice')
              : (language == AppLanguage.tr
                    ? 'Sanatsal ve yaratıcı çalışmalar için bereketli. Bağımlılıklarla yüzleşme zamanı.'
                    : 'Fruitful for artistic and creative work. Time to confront addictions.'),
          mostAffectedSigns: [
            ZodiacSign.pisces,
            ZodiacSign.virgo,
            ZodiacSign.gemini,
            ZodiacSign.sagittarius,
          ],
          isVisible: true,
          peakTime: '18:11 UTC',
          magnitude: 1.0,
        ),
        EclipseEvent(
          date: DateTime(2025, 9, 21),
          type: EclipseType.solarPartial,
          zodiacSign: ZodiacSign.virgo,
          title: getEclipseText('2025_09_21', 'title').isNotEmpty
              ? getEclipseText('2025_09_21', 'title')
              : (language == AppLanguage.tr
                    ? 'Başak Burcunda Kısmi Güneş Tutulması'
                    : 'Partial Solar Eclipse in Virgo'),
          description: getEclipseText('2025_09_21', 'description').isNotEmpty
              ? getEclipseText('2025_09_21', 'description')
              : (language == AppLanguage.tr
                    ? 'Pratik düzenlemeler ve sağlık odağı.'
                    : 'Practical adjustments and health focus.'),
          spiritualMeaning: getEclipseText('2025_09_21', 'spiritual').isNotEmpty
              ? getEclipseText('2025_09_21', 'spiritual')
              : (language == AppLanguage.tr
                    ? 'Hizmet ve alçakgönüllülük temalı bir döngü. Günlük ritüellerin kutsallığını keşfetme.'
                    : 'A cycle themed around service and humility. Discovering the sacredness of daily rituals.'),
          practicalAdvice: getEclipseText('2025_09_21', 'advice').isNotEmpty
              ? getEclipseText('2025_09_21', 'advice')
              : (language == AppLanguage.tr
                    ? 'Sağlık check-up\'ları planlayın. İş yerinde verimlilik artışı için adımlar atın.'
                    : 'Schedule health check-ups. Take steps for productivity increase at work.'),
          mostAffectedSigns: [
            ZodiacSign.virgo,
            ZodiacSign.pisces,
            ZodiacSign.gemini,
            ZodiacSign.sagittarius,
          ],
          isVisible: false,
          peakTime: '19:42 UTC',
          magnitude: 0.86,
        ),
      ]);
    } else if (year == 2026) {
      eclipses.addAll([
        EclipseEvent(
          date: DateTime(2026, 2, 17),
          type: EclipseType.solarAnnular,
          zodiacSign: ZodiacSign.aquarius,
          title: getEclipseText('2026_02_17', 'title').isNotEmpty
              ? getEclipseText('2026_02_17', 'title')
              : (language == AppLanguage.tr
                    ? 'Kova Burcunda Halkalı Güneş Tutulması'
                    : 'Annular Solar Eclipse in Aquarius'),
          description: getEclipseText('2026_02_17', 'description').isNotEmpty
              ? getEclipseText('2026_02_17', 'description')
              : (language == AppLanguage.tr
                    ? 'İnsanlık ve topluluk bilinci öne çıkıyor.'
                    : 'Humanity and community consciousness come to the fore.'),
          spiritualMeaning: getEclipseText('2026_02_17', 'spiritual').isNotEmpty
              ? getEclipseText('2026_02_17', 'spiritual')
              : (language == AppLanguage.tr
                    ? 'Kolektif amaçlarla bireysel hedeflerin uyumu. Gelecek vizyonu netleşiyor.'
                    : 'Alignment of collective purposes with individual goals. Future vision becomes clearer.'),
          practicalAdvice: getEclipseText('2026_02_17', 'advice').isNotEmpty
              ? getEclipseText('2026_02_17', 'advice')
              : (language == AppLanguage.tr
                    ? 'Sosyal projeler ve grup çalışmaları için ideal. Teknoloji ve inovasyon alanında fırsatlar.'
                    : 'Ideal for social projects and group work. Opportunities in technology and innovation.'),
          mostAffectedSigns: [
            ZodiacSign.aquarius,
            ZodiacSign.leo,
            ZodiacSign.taurus,
            ZodiacSign.scorpio,
          ],
          isVisible: false,
          peakTime: '12:02 UTC',
          magnitude: 0.96,
        ),
        EclipseEvent(
          date: DateTime(2026, 3, 3),
          type: EclipseType.lunarTotal,
          zodiacSign: ZodiacSign.virgo,
          title: getEclipseText('2026_03_03', 'title').isNotEmpty
              ? getEclipseText('2026_03_03', 'title')
              : (language == AppLanguage.tr
                    ? 'Başak Burcunda Tam Ay Tutulması'
                    : 'Total Lunar Eclipse in Virgo'),
          description: getEclipseText('2026_03_03', 'description').isNotEmpty
              ? getEclipseText('2026_03_03', 'description')
              : (language == AppLanguage.tr
                    ? 'Mükemmeliyetçilik ve hizmet temalarının doruk noktası.'
                    : 'Culmination of perfectionism and service themes.'),
          spiritualMeaning: getEclipseText('2026_03_03', 'spiritual').isNotEmpty
              ? getEclipseText('2026_03_03', 'spiritual')
              : (language == AppLanguage.tr
                    ? 'Eleştirici zihni şefkatle dengeleme. İyileştirme ve arınma süreçleri.'
                    : 'Balancing the critical mind with compassion. Healing and purification processes.'),
          practicalAdvice: getEclipseText('2026_03_03', 'advice').isNotEmpty
              ? getEclipseText('2026_03_03', 'advice')
              : (language == AppLanguage.tr
                    ? 'Sağlık konularına öncelik verin. Organizasyon ve planlama zamanı.'
                    : 'Prioritize health matters. Time for organization and planning.'),
          mostAffectedSigns: [
            ZodiacSign.virgo,
            ZodiacSign.pisces,
            ZodiacSign.gemini,
            ZodiacSign.sagittarius,
          ],
          isVisible: true,
          peakTime: '11:33 UTC',
          magnitude: 1.0,
        ),
        EclipseEvent(
          date: DateTime(2026, 8, 12),
          type: EclipseType.solarTotal,
          zodiacSign: ZodiacSign.leo,
          title: getEclipseText('2026_08_12', 'title').isNotEmpty
              ? getEclipseText('2026_08_12', 'title')
              : (language == AppLanguage.tr
                    ? 'Aslan Burcunda Tam Güneş Tutulması'
                    : 'Total Solar Eclipse in Leo'),
          description: getEclipseText('2026_08_12', 'description').isNotEmpty
              ? getEclipseText('2026_08_12', 'description')
              : (language == AppLanguage.tr
                    ? 'Yaratıcılık ve kendini ifade patlaması.'
                    : 'Explosion of creativity and self-expression.'),
          spiritualMeaning: getEclipseText('2026_08_12', 'spiritual').isNotEmpty
              ? getEclipseText('2026_08_12', 'spiritual')
              : (language == AppLanguage.tr
                    ? 'İç güneşinizi parlatın. Otantik benliğinizi cesaretle ortaya koyun.'
                    : 'Shine your inner sun. Courageously reveal your authentic self.'),
          practicalAdvice: getEclipseText('2026_08_12', 'advice').isNotEmpty
              ? getEclipseText('2026_08_12', 'advice')
              : (language == AppLanguage.tr
                    ? 'Sanat, eğlence ve yaratıcı projeler için mükemmel. Çocuklarla ilgili konular öne çıkabilir.'
                    : 'Perfect for art, entertainment, and creative projects. Matters related to children may come to the fore.'),
          mostAffectedSigns: [
            ZodiacSign.leo,
            ZodiacSign.aquarius,
            ZodiacSign.taurus,
            ZodiacSign.scorpio,
          ],
          isVisible: true,
          peakTime: '17:46 UTC',
          magnitude: 1.0,
        ),
        EclipseEvent(
          date: DateTime(2026, 8, 28),
          type: EclipseType.lunarPartial,
          zodiacSign: ZodiacSign.pisces,
          title: getEclipseText('2026_08_28', 'title').isNotEmpty
              ? getEclipseText('2026_08_28', 'title')
              : (language == AppLanguage.tr
                    ? 'Balık Burcunda Kısmi Ay Tutulması'
                    : 'Partial Lunar Eclipse in Pisces'),
          description: getEclipseText('2026_08_28', 'description').isNotEmpty
              ? getEclipseText('2026_08_28', 'description')
              : (language == AppLanguage.tr
                    ? 'Duygusal ve ruhsal boyutlarda son düzenlemeler.'
                    : 'Final adjustments in emotional and spiritual dimensions.'),
          spiritualMeaning: getEclipseText('2026_08_28', 'spiritual').isNotEmpty
              ? getEclipseText('2026_08_28', 'spiritual')
              : (language == AppLanguage.tr
                    ? 'Mistik deneyimler ve sezgisel açılımlar. Geçmişle barışma.'
                    : 'Mystical experiences and intuitive openings. Making peace with the past.'),
          practicalAdvice: getEclipseText('2026_08_28', 'advice').isNotEmpty
              ? getEclipseText('2026_08_28', 'advice')
              : (language == AppLanguage.tr
                    ? 'Meditatif pratikler ve ruhsal çalışmalar için ideal. Bağımlılık konularına dikkat.'
                    : 'Ideal for meditative practices and spiritual work. Pay attention to addiction matters.'),
          mostAffectedSigns: [
            ZodiacSign.pisces,
            ZodiacSign.virgo,
            ZodiacSign.gemini,
            ZodiacSign.sagittarius,
          ],
          isVisible: true,
          peakTime: '04:13 UTC',
          magnitude: 0.93,
        ),
      ]);
    }

    return eclipses;
  }

  static EclipseEvent? getNextEclipse({AppLanguage language = AppLanguage.tr}) {
    final now = DateTime.now();
    final currentYear = now.year;

    for (int year = currentYear; year <= currentYear + 2; year++) {
      final eclipses = getEclipsesForYear(year, language: language);
      for (final eclipse in eclipses) {
        if (eclipse.date.isAfter(now)) {
          return eclipse;
        }
      }
    }
    return null;
  }

  // ============ CONTENT GENERATORS ============

  static List<String> _getWeeklyOverviews(ZodiacSign sign) {
    return [
      'Bu hafta ${sign.nameTr} burcu için kozmik enerjiler yoğunlaşıyor. Gezegenler sizin lehinize hizalanırken, büyük fırsatların kapıları aralanıyor. İç sesinize kulak verin ve sezgilerinizi takip edin.',
      'Evren bu hafta size güçlü mesajlar gönderiyor. ${sign.nameTr} enerjisi dorukta ve potansiyelinizi ortaya koyma zamanı. Cesur adımlar atın, korkularınızı geride bırakın.',
      'Hafta boyunca ${sign.element.nameTr} elementi güçleniyor. Bu enerjiyi kendi avantajınıza kullanın. İç dünyanızda derin dönüşümler yaşanırken, dış dünyada da somut değişiklikler görülecek.',
      'Bu hafta ${sign.nameTr} burcu için yeni bağlantılar ve fırsatlar temalarını keşfetmek için iyi bir dönem. Açık kalın ve kendinize güvenin.',
      'Bu hafta ${sign.nameTr} burcu için önemli yaşam temalarını düşünme dönemi. Değerlerinizle uyumlu kararları düşünün. Sezgilerinize güvenin.',
      '${sign.nameTr} burcu için bu hafta enerji akışı olumlu yönde. Engeller kalkıyor, yollar açılıyor. Uzun süredir beklediğiniz haber veya gelişme bu hafta gelebilir.',
      'Kozmik rüzgarlar ${sign.nameTr} burcunun yelkenlerini şişiriyor. Hangi yöne gitmek istediğinizi biliyorsanız, evren sizi desteklemeye hazır. Niyetlerinizi net tutun.',
      'Bu hafta evrensel enerji ${sign.nameTr} burcunu kucaklıyor. Yaratıcılık, ilham ve motivasyon dorukta. Ertelediğiniz projelere başlamak için ideal bir zamanlama.',
    ];
  }

  static List<String> _getWeeklyLoveContent(ZodiacSign sign) {
    return [
      'Aşk hayatınızda bu hafta hareketli bir dönem başlıyor. Venüs etkisi altında, ilişkilerinizde daha derin bağlar kurabilirsiniz. Bekarlar için sürpriz karşılaşmalar olası.',
      'Kalp çakranız bu hafta aktive oluyor. Duygusal açıdan hassas olabilirsiniz ama bu, sevgiyi daha derin hissetmenize de olanak tanıyor. Partnerinizle özel anlar yaratın.',
      'Romantik enerjiler yükseliyor. İlişkinizde yeni bir sayfa açılabilir veya bekarlar için önemli bir tanışma gerçekleşebilir. Kalbinizi açık tutun.',
      'Bu hafta aşk ve bağlantı temalarını düşünmek için güzel bir dönem. Sezgilerinize güvenin ve anlamlı bağlantıları fark edin.',
      'Venüs\'ün olumlu açıları aşk hayatınızı ışıklandırıyor. Çiftler için tutku yeniden alevlenirken, bekarlar manyetik çekicilik yayıyor. Flört enerjisi güçlü.',
      'İlişkilerde iletişim bu hafta kritik öneme sahip. Duygularınızı açıkça ifade edin, karşı tarafı dinleyin. Yanlış anlamalar çözülüyor, bağlar güçleniyor.',
      'Romantik sürprizlere hazır olun. Evren aşk konusunda size güzel haberler getirebilir. Geçmişten biri yeniden hayatınıza girebilir veya yeni biri çıkabilir.',
      'Aşkta cesur olma haftası. Duygularınızı bastırmayın, risk alın. Karşılık görmekten korkmayın - evren cesareti ödüllendirir.',
    ];
  }

  static List<String> _getWeeklyCareerContent(ZodiacSign sign) {
    return [
      'Kariyer alanında bu hafta önemli gelişmeler yaşanabilir. Liderlik yetenekleriniz ön plana çıkıyor. Fikirlerinizi cesurca paylaşın.',
      'Profesyonel yaşamınızda yeni kapılar açılıyor. Bu hafta stratejik düşünün ve uzun vadeli planlarınızı gözden geçirin. Değişimler lehinize.',
      'İş yerinde yaratıcılığınız dorukta. Yenilikçi fikirleriniz dikkat çekecek. Ekip çalışması ve işbirlikleri bereketli sonuçlar getirebilir.',
      'Maddi konularda olumlu haberler gelebilir. Bu hafta finansal kararlarınızda sezgilerinize güvenin ama mantığı da ihmal etmeyin.',
      'Kariyer basamaklarında yükseliş zamanı. Üstlerinizin dikkatini çekebilir, terfi veya zam haberi gelebilir. Kendinizi görünür kılın.',
      'İş görüşmeleri ve müzakereler için elverişli bir hafta. İsteklerinizi net ifade edin, hak ettiğinizi isteyin. Evren sizi destekliyor.',
      'Yeni iş fırsatları kapınızı çalabilir. LinkedIn profilinizi güncelleyin, ağınızı genişletin. Beklenmedik yerlerden teklifler gelebilir.',
      'Projeleriniz bu hafta hız kazanıyor. Engeller kalkıyor, süreçler hızlanıyor. Ertelenen onaylar, beklenen kararlar bu hafta gelebilir.',
    ];
  }

  static List<String> _getWeeklyHealthContent(ZodiacSign sign) {
    return [
      'Enerji seviyeniz bu hafta yüksek. Fiziksel aktivitelere zaman ayırın. Bedeninizin size gönderdiği sinyallere dikkat edin.',
      'Zihinsel ve duygusal sağlığınıza odaklanın. Stres yönetimi için meditasyon veya yoga deneyin. Doğada vakit geçirmek size iyi gelecek.',
      'Bu hafta beslenme düzeninizi gözden geçirin. Vücudunuzun ihtiyaç duyduğu besinleri verin. Uyku düzeninize dikkat edin.',
      'Enerji dengenizi korumak için molalar verin. Kendinize şefkat gösterin ve aşırı yorgunluktan kaçının. Şifa enerjileri güçlü.',
    ];
  }

  static List<String> _getWeeklyFinancialContent(ZodiacSign sign) {
    return [
      'Finansal konularda bu hafta dikkatli olun. Büyük harcamalardan önce iki kez düşünün. Tasarruf planları yapmanın tam zamanı.',
      'Maddi bolluk enerjisi güçleniyor. Beklenmedik kazançlar veya fırsatlar gelebilir. Ama ayaklarınızı yere basın.',
      'Yatırımlar için araştırma yapın ama aceleci davranmayın. Bu hafta finansal bilincinizi geliştirmek için ideal.',
      'Para konularında yeni bir bakış açısı geliştirin. Bolluk bilincini aktive edin ve kıtlık korkularını bırakın.',
    ];
  }

  static List<String> _getWeeklyAffirmations(ZodiacSign sign) {
    return [
      'Evrenin bolluğuna açığım ve her şey yolunda.',
      'Her gün her anlamda daha iyiye gidiyorum.',
      'İçimdeki gücü fark ediyorum ve onu kullanıyorum.',
      'Sevgiyi çekiyorum ve sevgi veriyorum.',
      'Korkularımı bırakıyor, güvenle ilerliyorum.',
      'Ruhsal yolculuğumda doğru yöndeyim.',
    ];
  }

  static List<String> _getMonthlyOverviews(ZodiacSign sign) {
    return [
      'Bu ay ${sign.nameTr} burcu için dönüşüm ve yenilenme zamanı. Gezegenler güçlü açılar oluşturarak, hayatınızda köklü değişikliklere zemin hazırlıyor. İç dünyanızda başlayan dönüşüm, dış dünyanıza yansıyacak.',
      'Ayın enerjileri ${sign.nameTr} burcunu destekliyor. Bu dönem kendinizi keşfetmek, potansiyelinizi gerçekleştirmek ve ruhsal olarak büyümek için ideal. Evrenin size sunduğu fırsatları değerlendirin.',
      'Kozmik akış bu ay sizden yana. ${sign.element.nameTr} enerjisi güçlenirken, doğal yetenekleriniz ve güçlü yanlarınız ön plana çıkıyor. Özgüvenle hareket edin ve hedeflerinize odaklanın.',
      'Gezegenler bu ay ${sign.nameTr} burcu için özel bir koreografi sergiliyor. Kader kapıları aralanıyor, yeni olanaklar beliriyor. Hayatınızın akışını değiştirecek olaylar yaşanabilir.',
      'Ay boyunca ${sign.nameTr} burcunun enerjisi yoğun. Duygusal iniş çıkışlar yaşanabilir ama her biri sizi daha güçlü kılacak. Sabırlı olun, süreç size çalışıyor.',
      'Bu ay evrensel enerji ${sign.nameTr} burcunu sarmalıyor. Uzun süredir beklediğiniz değişimler başlıyor. Korkularınızı bırakın, yeniye açılın.',
      'Kozmik takvim bu ay sizin için önemli sayfalar açıyor. Kişisel ve profesyonel yaşamınızda dönüm noktaları var. Her kararınız geleceğinizi şekillendiriyor.',
      '${sign.nameTr} burcu için bereketli bir ay başlıyor. Emeklerinizin karşılığını alma, hedeflerinize yaklaşma zamanı. Evren çabalarınızı görüyor ve ödüllendiriyor.',
    ];
  }

  static List<String> _getMonthlyLoveContent(ZodiacSign sign) {
    return [
      'Aşk hayatınızda bu ay önemli gelişmeler var. Venüs\'ün etkisi altında, ilişkileriniz derinleşiyor ve yeni romantik bağlar kurulabilir. Kalbinizi açık tutun.',
      'Bu ay ilişkilerde dönüşüm yaşanıyor. Eski kalıpları kırmak ve daha otantik bağlar kurmak için ideal bir dönem. Cesur olun ve duygularınızı ifade edin.',
      'Romantik enerjiler yoğunlaşıyor. Bekarlar için önemli karşılaşmalar, çiftler için tutkulu bir dönem başlıyor. Aşkın büyüsüne kendinizi bırakın.',
      'Kalp çakranız bu ay aktif. Derin duygusal bağlantılar, anlamlı konuşmalar ve romantik temalar için güzel bir dönem. Savunmalarınızı indirmeyi düşünün.',
      'Ay boyunca romantik atmosfer güçlü. Sürpriz randevular, beklenmedik itiraflar veya ilişkinizde yeni bir sayfa açılması mümkün.',
      'İlişkilerde netlik zamanı. Belirsizlikler çözülüyor, duygular berraklaşıyor. "Nerede duruyorum?" sorusunun cevabını bu ay alabilirsiniz.',
      'Aşk ve ilişki temalarını keşfetmek için güzel bir ay. İlişkilerinizde neyin önemli olduğunu düşünün. Romantik enerji güçlü.',
      'Bu ay duygusal bağlar güçleniyor. Sevdiklerinizle geçirdiğiniz her an değerli. Kaliteli zaman yaratın, anılar biriktirin.',
    ];
  }

  static List<String> _getMonthlyCareerContent(ZodiacSign sign) {
    return [
      'Kariyer hedefleriniz bu ay netleşiyor. Profesyonel alanda yeni fırsatlar ve ilerleme potansiyeli var. Liderlik yeteneklerinizi gösterme zamanı.',
      'İş hayatınızda stratejik hamleler yapın. Bu ay uzun vadeli planlar için zemin hazırlayabilir, önemli kararlar alabilirsiniz. Vizyonunuza güvenin.',
      'Profesyonel ilişkileriniz güçleniyor. Ağ kurma ve işbirlikleri için bereketli bir dönem. Fikirlerinizi paylaşın ve destek arayın.',
      'Kariyer alanında ay boyunca hareketlilik var. Toplantılar, görüşmeler, yeni projeler... Enerji yüksek, fırsatlar bol. Aktif olun.',
      'Bu ay iş yerinde öne çıkma zamanı. Yeteneklerinizi sergileyin, fikirlerinizi sunun. Üstlerinizin dikkatini çekme şansınız yüksek.',
      'Profesyonel alanda kararlılık ve odaklanma gerekiyor. Dikkat dağıtıcılardan uzak durun, önceliklerinizi belirleyin. Sonuçlar gelecek.',
      'İş hayatında değişim rüzgarları esiyor. Yeni roller, sorumluluklar veya tamamen farklı bir kariyer yolu gündeme gelebilir.',
      'Ay boyunca iş dünyasında şansınız parlak. Beklenmedik fırsatlar, olumlu haberler veya maddi kazançlar mümkün.',
    ];
  }

  static List<String> _getMonthlyHealthContent(ZodiacSign sign) {
    return [
      'Sağlığınıza bu ay özel önem verin. Beslenme, uyku ve egzersiz dengesini gözden geçirin. Bedeniniz size mesajlar gönderiyor - dinleyin.',
      'Enerji seviyelerinizi optimize etmek için doğru zamanlama önemli. Stres yönetimi ve zihinsel sağlık bu ay odak noktası olsun.',
      'Bütünsel sağlık yaklaşımını benimseyin. Beden, zihin ve ruh dengesini kurarak, yaşam kalitenizi artırın.',
    ];
  }

  static List<String> _getMonthlyFinancialContent(ZodiacSign sign) {
    return [
      'Finansal konularda bu ay bilinçli hareket edin. Bütçenizi gözden geçirin, gereksiz harcamaları kısın ve geleceğe yatırım yapın.',
      'Maddi bolluk enerjisi güçleniyor. Yeni gelir kaynakları veya beklenmedik kazançlar mümkün. Ama yine de temkinli olun.',
      'Para ile ilişkinizi gözden geçirin. Bolluk bilincini geliştirmek için çalışın. Verdiğiniz değer, aldığınızı belirler.',
    ];
  }

  static List<String> _getMonthlySpiritualContent(ZodiacSign sign) {
    return [
      'Ruhsal yolculuğunuzda önemli bir dönemdesiniz. İç sesinize kulak verin, meditasyon ve farkındalık pratiklerine zaman ayırın.',
      'Evrenle bağlantınız güçleniyor. Senkronisiteler artıyor, işaretler netleşiyor. Ruhsal rehberleriniz sizinle iletişim halinde.',
      'İç dünyanızda derin keşifler yapma zamanı. Gölge yanlarınızla yüzleşin, eski yaraları iyileştirin ve bütünleşin.',
    ];
  }

  static List<String> _getMonthlyMantras(ZodiacSign sign) {
    return [
      'Değişimi kucaklıyorum ve onunla büyüyorum.',
      'Her deneyim, ruhsal evrimimin bir parçası.',
      'Evrenin planına güveniyorum.',
      'Gücüm içimde ve her an erişebilirim.',
      'Sevgiyle hareket ediyor, sevgiyle çekiyorum.',
    ];
  }

  static List<String> _getMonthlyTransits(
    ZodiacSign sign,
    int month,
    AppLanguage language,
  ) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? [
            'At the beginning of the month, Mercury\'s movement activates the communication field. Mid-month Venus transit brings love and finance issues to the fore.',
            'Mars energy is strong this month. You can take bold steps in matters requiring action and determination. Emotional peak during the full moon period.',
            'Jupiter\'s favorable aspect brings luck and opportunities. Saturn\'s influence emphasizes discipline and responsibility themes.',
          ]
        : [
            'Ay başında Merkür\'ün hareketi iletişim alanını aktive ediyor. Ay ortasında Venüs geçişi aşk ve finans konularını ön plana çıkarıyor.',
            'Mars enerjisi bu ay güçlü. Eylem ve kararlılık gerektiren konularda cesur adımlar atabilirsiniz. Dolunay döneminde duygusal doruk noktası.',
            'Jüpiter\'in olumlu açısı şans ve fırsatlar getiriyor. Satürn\'ün etkisi ise disiplin ve sorumluluk temalarını vurguluyor.',
          ];
  }

  static List<String> _getRomanticOutlooks(ZodiacSign sign) {
    return [
      'Bugün romantik enerjiler güçlü. Venüs size göz kırpıyor - beklenmedik romantik gelişmeler olabilir. Kalbinizi açık tutun ve aşkın sihrine kendinizi bırakın.',
      'Aşk hayatınızda bugün derin bağlantılar kurabilirsiniz. Duygusal açıdan hassas olabilirsiniz ama bu, sevgiyi daha yoğun hissetmenizi sağlıyor.',
      'Romantik potansiyel yüksek. İster biriyle tanışın ister mevcut ilişkinizi derinleştirin - bugün kalp çakranız parlıyor.',
      'Tutku ve romantizm dengede. Bugün hem fiziksel hem duygusal bağlantılar için ideal. Cesaretinizi toplayın ve ilk adımı atın.',
    ];
  }

  static List<String> _getSingleAdvice(ZodiacSign sign) {
    return [
      'Bekarlar için bugün sürpriz karşılaşmalar mümkün. Sosyal etkinliklere katılın, yeni insanlarla tanışmaya açık olun. Ruh eşiniz yakınınızda olabilir.',
      'Kendinizi sevmeye odaklanın - bu, doğru kişiyi çekmenin anahtarı. Bugün kendi değerinizi hatırlayın ve standartlarınızdan ödün vermeyin.',
      'Yeni bağlantılar için enerji güçlü. Ama aceleci davranmayın - kalıcı ilişkiler zaman ister. Sabırlı olun ve akışa güvenin.',
      'Anlamlı bağlantılar için güzel bir dönem. Sezgilerinize güvenin - birini gördüğünüzde içinizde bir şeyin kıpırdadığını hissederseniz, bu önemli bir işaret.',
    ];
  }

  static List<String> _getCouplesAdvice(ZodiacSign sign) {
    return [
      'Çiftler için bugün ilişkinizi derinleştirme fırsatı var. Kaliteli zaman geçirin, duygularınızı paylaşın ve birbirinizi dinleyin.',
      'İlişkinizde yenilenme enerjisi güçlü. Rutini kırın, sürprizler yapın ve tutkuyu yeniden ateşleyin. Küçük jestler büyük farklar yaratır.',
      'İletişim bugün kritik. Partnerlınızla açık ve dürüst konuşun. Yanlış anlamalar varsa, bugün çözme şansınız var.',
      'Birlikte büyümek için bugünü kullanın. Ortak hedefler belirleyin, hayaller paylaşın ve geleceğe birlikte bakın.',
    ];
  }

  static List<String> _getSoulConnectionContent(ZodiacSign sign) {
    return [
      'Ruhsal bağlantılar bugün güçleniyor. Karşınızdaki kişiyle sadece fiziksel değil, ruhsal düzeyde de bağ kurabilirsiniz. Bu, sıradan bir ilişkinin ötesinde.',
      'Ruh eşi enerjisi aktif. Geçmiş yaşamlardan gelen bağlantılar yüzeye çıkabilir. Tanıdık hissettiren yabancılara dikkat edin.',
      'Karmik ilişki temaları öne çıkıyor. Bazı insanlar hayatımıza bir ders için gelir - bugün bu dersleri görebilirsiniz.',
      'Koşulsuz sevgi enerjisi güçlü. Beklentisiz sevmek ve sevilmek - bugün bunun ne demek olduğunu anlayabilirsiniz.',
    ];
  }

  static List<String> _getVenusInfluence(ZodiacSign sign) {
    return [
      'Venüs bugün ${sign.nameTr} burcunu destekliyor. Güzellik, aşk ve harmoni temaları güçleniyor. Kendinize bakım yapın ve iç güzelliğinizi yansıtın.',
      'Venüs enerjisi romantik alanı ışıklandırıyor. Çekicilik ve manyetizmanız artıyor. Bu enerjiyi bilinçli kullanın.',
      'Aşk gezegeni size gülümsüyor. Hem verici hem alıcı olun - sevgi alışverişi bugün dengede.',
    ];
  }

  static List<String> _getIntimacyAdvice(ZodiacSign sign) {
    return [
      'Yakınlık bugün farklı boyutlarda deneyimlenebilir. Fiziksel yakınlık kadar duygusal ve ruhsal yakınlık da önemli.',
      'Güven ve açıklık, gerçek yakınlığın anahtarı. Bugün savunmalarınızı indirin ve kendinizi gösterin.',
      'Bedensel farkındalık yüksek. Dokunuşun şifa gücünü keşfedin. Sevgiyi fiziksel olarak ifade etmekten çekinmeyin.',
    ];
  }

  static List<ZodiacSign> _getCompatibleSigns(ZodiacSign sign) {
    // Same element + complementary elements
    switch (sign.element) {
      case Element.fire:
        return [
          ZodiacSign.aries,
          ZodiacSign.leo,
          ZodiacSign.sagittarius,
          ZodiacSign.gemini,
          ZodiacSign.libra,
          ZodiacSign.aquarius,
        ];
      case Element.earth:
        return [
          ZodiacSign.taurus,
          ZodiacSign.virgo,
          ZodiacSign.capricorn,
          ZodiacSign.cancer,
          ZodiacSign.scorpio,
          ZodiacSign.pisces,
        ];
      case Element.air:
        return [
          ZodiacSign.gemini,
          ZodiacSign.libra,
          ZodiacSign.aquarius,
          ZodiacSign.aries,
          ZodiacSign.leo,
          ZodiacSign.sagittarius,
        ];
      case Element.water:
        return [
          ZodiacSign.cancer,
          ZodiacSign.scorpio,
          ZodiacSign.pisces,
          ZodiacSign.taurus,
          ZodiacSign.virgo,
          ZodiacSign.capricorn,
        ];
    }
  }

  static List<ZodiacSign> _getChallengingSigns(ZodiacSign sign) {
    // Square and opposite signs
    final index = sign.index;
    return [
      ZodiacSign.values[(index + 3) % 12],
      ZodiacSign.values[(index + 6) % 12],
      ZodiacSign.values[(index + 9) % 12],
    ];
  }

  static List<String> _getYearlyOverviews(ZodiacSign sign) {
    return [
      'Bu yıl ${sign.nameTr} burcu için dönüşüm, büyüme ve kendini gerçekleştirme yılı. Gezegenler sizin için güçlü bir enerji alanı oluşturuyor. Cesur adımlar atma, yeni başlangıçlar yapma ve hayallerinizi gerçekleştirme zamanı.',
      'Kozmik enerji bu yıl ${sign.nameTr} burcunu destekliyor. İster kariyer, ister aşk, ister kişisel gelişim olsun - her alanda ilerleme potansiyeli var. Fırsatları değerlendirin ve potansiyelinizi ortaya koyun.',
      'Evrensel akış bu yıl sizin yanınızda. ${sign.element.nameTr} elementi güçlenirken, doğal yetenekleriniz parlamaya başlıyor. Kendinize güvenin ve büyük hayaller kurun.',
      'Bu yıl ${sign.nameTr} burcu için yeni fırsat temaları belirginleşiyor. Uzun süredir düşündüğünüz değişimleri düşünmek için iyi bir zaman olabilir. Refleksiyon ve cesaret temalarını keşfedin.',
      'Gezegenler bu yıl ${sign.nameTr} burcuna özel bir yol çiziyor. Kişisel dönüşüm, ruhsal büyüme ve maddi başarı bir arada. Her ay yeni bir hediye sunacak.',
      '${sign.nameTr} burcu için yıldızların parladığı bir yıl başlıyor. Şans, fırsat ve bereket enerjileri güçlü. Evren size "evet" diyor - siz de kendinize "evet" deyin.',
      'Bu yıl ${sign.nameTr} burcunun potansiyelini tam olarak ortaya koyacağı bir dönem. Ertelediğiniz hayalleri gerçekleştirin, korktuğunuz adımları atın. Evren arkanızda.',
      'Kozmik takvim bu yıl ${sign.nameTr} burcu için önemli sayfalar açıyor. Kariyer, aşk, sağlık ve ruhsal gelişim alanlarında kayda değer ilerlemeler mümkün.',
    ];
  }

  static List<String> _getYearlyLoveContent(ZodiacSign sign) {
    return [
      'Aşk hayatınızda bu yıl önemli dönüm noktaları keşfedilebilir. Bekarlar için anlamlı bağlantılar, çiftler için ilişkiyi derinleştirme temaları. Kalp çakranız yıl boyunca aktif.',
      'Romantik enerjiler yoğun bir yıl için güzel bir dönem. İlişkilerde dönüşüm ve derin bağlantılar temaları keşfedilebilir. Aşka açık olun.',
      'Bu yıl aşk, beklenmedik şekillerde hayatınıza girebilir. Eski kalıpları bırakın, yeni deneyimlere açık olun. Evrenin planına güvenin.',
      'Venüs bu yıl ${sign.nameTr} burcuna özel bir dans sergiliyor. Bekarlar için anlamlı bağlantı temaları öne çıkıyor, çiftler için ilişkiyi derinleştirme fırsatları keşfedilebilir.',
      'Aşk hayatınızda bu yıl köklü dönüşümler mümkün. İlişki statünüz değişebilir - bekarlar çift olabilir, çiftler yeni bir aşamaya geçebilir.',
      'Romantik alanda büyüme temalarını keşfetmek için güzel bir yıl. Kalp kırıklıkları iyileşme fırsatı sunar, yeni bağlantılar keşfedilebilir.',
      'Bu yıl ilişkilerde derin bağlantılar kurma zamanı. Yüzeysel ilişkiler dökülürken, gerçek, anlamlı bağlar güçleniyor. Kaliteli zaman için niceliği feda edin.',
      'Aşkta cesaret yılı. Duygularınızı ifade edin, risk alın, kalbinizin sesini dinleyin. Evren cesaretli aşıkları ödüllendiriyor.',
    ];
  }

  static List<String> _getYearlyCareerContent(ZodiacSign sign) {
    return [
      'Kariyer alanında bu yıl büyük adımlar atabilirsiniz. Profesyonel hedeflerinize ulaşmak için gerekli enerji ve fırsatlar mevcut. Vizyonunuza odaklanın.',
      'İş hayatınızda dönüşüm yılı. Yeni roller, sorumluluklar veya tamamen yeni bir kariyer yolu gündeme gelebilir. Değişime açık olun.',
      'Profesyonel başarı için bereketli bir yıl. Liderlik yetenekleriniz ön plana çıkıyor, fikirleriniz değer görüyor. Kendinizi gösterme zamanı.',
      'Kariyer alanında büyüme temaları öne çıkıyor. Profesyonel gelişim, yeni sorumluluklar veya farklı iş deneyimleri keşfedilebilir. Fırsatlara açık olun.',
      'Bu yıl profesyonel alanda parlamak için ideal. Projeleriniz dikkat çekiyor, çabalarınız takdir görüyor. Görünürlüğünüzü artırın.',
      'İş dünyasında şansınız açık. Yeni ortaklıklar, anlaşmalar veya iş fırsatları kapınızı çalabilir. Networking\'e önem verin.',
      'Girişimcilik enerjisi güçlü bir yıl. Kendi işinizi kurma hayaliniz varsa, bu yıl harekete geçme zamanı. Evren cesur girişimcileri destekliyor.',
      'Kariyer hedeflerinize ulaşmak için gereken her şey bu yıl elinizin altında. Tek gereken odaklanmak ve kararlılıkla ilerlemek.',
    ];
  }

  static List<String> _getYearlyHealthContent(ZodiacSign sign) {
    return [
      'Sağlık alanında bu yıl farkındalık geliştirin. Bütünsel yaklaşımla beden, zihin ve ruh dengesini kurun. Önleyici sağlık önemli.',
      'Enerji seviyelerinizi optimize etmek için yaşam tarzı değişiklikleri yapın. Beslenme, egzersiz ve uyku düzeninizi gözden geçirin.',
      'Şifa enerjileri bu yıl güçlü. Eski sağlık sorunlarını çözme, yeni alışkanlıklar edinme ve genel iyilik halini yükseltme zamanı.',
    ];
  }

  static List<String> _getYearlyFinancialContent(ZodiacSign sign) {
    return [
      'Finansal açıdan bu yıl istikrar ve büyüme potansiyeli var. Akıllı yatırımlar, bilinçli harcamalar ve uzun vadeli planlama önemli.',
      'Finansal farkındalık temaları öne çıkıyor. Yeni perspektifler, farklı yaklaşımlar veya değer bilinci keşfedilebilir.',
      'Para ile ilişkinizi dönüştürme yılı. Bolluk bilincini geliştirin, kısıtlayıcı inançları bırakın ve bereketin akmasına izin verin.',
    ];
  }

  static List<String> _getYearlySpiritualContent(ZodiacSign sign) {
    return [
      'Ruhsal yolculuğunuzda bu yıl önemli ilerleme temaları öne çıkıyor. Farkındalık derinleşiyor, sezgiler güçleniyor, evrenle bağlantı kuvvetleniyor.',
      'İç keşif yılı. Meditasyon, farkındalık pratikleri ve ruhsal çalışmalar için ideal bir dönem. Kendinizi tanıma yolculuğu derinleşiyor.',
      'Uyanış ve dönüşüm temaları güçlü. Eski kalıpları bırakma, yeni bilinç seviyelerine yükselme ve ruhsal olarak evrilme zamanı.',
    ];
  }

  static List<String> _getYearlyAffirmations(ZodiacSign sign) {
    return [
      'Bu yıl en yüksek potansiyelimi gerçekleştiriyorum.',
      'Evrenin bolluğu hayatımın her alanına akıyor.',
      'Her gün, her anlamda büyüyor ve gelişiyorum.',
      'Ruhsal yolculuğumda doğru zamanda doğru yerdeyim.',
      'Sevgi ve bereket beni her yerde takip ediyor.',
    ];
  }

  static List<String> _getYearlyThemes(ZodiacSign sign) {
    return [
      'Dönüşüm ve Yeniden Doğuş',
      'Kendini Gerçekleştirme',
      'Bolluk ve Bereket',
      'İlişkilerde Derinleşme',
      'Ruhsal Uyanış',
      'Cesaret ve Eylem',
      'Denge ve Harmoni',
      'Şifa ve Bütünleşme',
    ];
  }

  static List<String> _getMajorTransits(int year, AppLanguage language) {
    final isEn = language == AppLanguage.en;
    return isEn
        ? [
            'Jupiter\'s sign change is the main theme of the year. Luck and expansion energy is shifting to new areas.',
            'Saturn\'s movement emphasizes responsibility and maturation issues.',
            'The eclipse axis activates relationship and identity themes.',
            'Uranus triggers unexpected changes and the search for freedom.',
            'Neptune strengthens spiritual depth and imagination.',
          ]
        : [
            'Jüpiter\'in burç değişimi yılın ana teması. Şans ve genişleme enerjisi yeni alanlara kayıyor.',
            'Satürn\'ün hareketi sorumluluk ve olgunlaşma konularını vurguluyor.',
            'Tutulma ekseni ilişki ve kimlik temalarını aktive ediyor.',
            'Uranüs beklenmedik değişimler ve özgürlük arayışını tetikliyor.',
            'Neptün ruhsal derinlik ve hayal gücünü güçlendiriyor.',
          ];
  }
}
