import '../models/zodiac_sign.dart';
import '../providers/app_providers.dart';

/// Content for ExtendedHoroscopeService (English Only)
class ExtendedHoroscopeContent {
  // ============ WEEKLY CONTENT ============

  static List<String> getWeeklyOverviews(ZodiacSign sign, AppLanguage language) {
    final signName = sign.name;
    final elementName = sign.element.name;

    return [
      'This week cosmic energies are intensifying for $signName. As planets align in your favor, doors to great opportunities are opening. Listen to your inner voice and follow your intuition.',
      'The universe is sending you powerful messages this week. $signName energy is at its peak and it\'s time to show your potential. Take bold steps, leave your fears behind.',
      'Throughout the week the $elementName element is strengthening. Use this energy to your advantage. While deep transformations occur in your inner world, concrete changes will also be seen in the outer world.',
      'The stars paint a bright picture for $signName this week. New connections, unexpected opportunities and spiritual openings await you. Stay open and trust the flow.',
      'The planetary dance in the sky carries special messages for $signName. This week you may experience destiny moments and make life-changing decisions. Your intuition is sharper than ever.',
      'For $signName this week the energy flow is positive. Obstacles are being removed, paths are opening. The news or development you\'ve been waiting for may come this week.',
      'Cosmic winds are filling $signName\'s sails. If you know which direction you want to go, the universe is ready to support you. Keep your intentions clear.',
      'This week universal energy embraces $signName. Creativity, inspiration and motivation are at their peak. Ideal timing to start projects you\'ve been postponing.',
    ];
  }

  static List<String> getWeeklyLoveContent(AppLanguage language) {
    return [
      'A lively period is starting in your love life this week. Under Venus\' influence, you can establish deeper connections in your relationships. Surprise encounters are likely for singles.',
      'Your heart chakra is being activated this week. You may be emotionally sensitive but this also allows you to feel love more deeply. Create special moments with your partner.',
      'Romantic energies are rising. A new chapter may open in your relationship or an important meeting may happen for singles. Keep your heart open.',
      'This week love can come from unexpected places. Trust your intuition and follow the signs the universe offers you. Fateful connections are possible.',
      'Venus\' favorable aspects are illuminating your love life. While passion reignites for couples, singles are radiating magnetic charm. Flirtation energy is strong.',
      'Communication in relationships is critically important this week. Express your feelings openly, listen to the other side. Misunderstandings are being resolved, bonds are strengthening.',
      'Get ready for romantic surprises. The universe may bring you good news about love. Someone from the past may re-enter your life or someone new may appear.',
      'A week to be brave in love. Don\'t suppress your feelings, take risks. Don\'t be afraid of reciprocation - the universe rewards courage.',
    ];
  }

  static List<String> getWeeklyCareerContent(AppLanguage language) {
    return [
      'Important developments may occur in your career this week. Your leadership abilities are coming to the fore. Share your ideas boldly.',
      'New doors are opening in your professional life. Think strategically this week and review your long-term plans. Changes are in your favor.',
      'Your creativity at work is at its peak. Your innovative ideas will attract attention. Teamwork and collaborations can bring fruitful results.',
      'Positive news may come in financial matters. Trust your intuition in your financial decisions this week but don\'t neglect logic either.',
      'Time to climb the career ladder. You may catch the attention of your superiors, news of promotion or raise may come. Make yourself visible.',
      'A favorable week for job interviews and negotiations. Express your wishes clearly, ask for what you deserve. The universe supports you.',
      'New job opportunities may knock on your door. Update your LinkedIn profile, expand your network. Offers may come from unexpected places.',
      'Your projects are gaining momentum this week. Obstacles are being removed, processes are accelerating. Delayed approvals, expected decisions may come this week.',
    ];
  }

  static List<String> getWeeklyHealthContent(AppLanguage language) {
    return [
      'Your energy level is high this week. Make time for physical activities. Pay attention to the signals your body sends you.',
      'Focus on your mental and emotional health. Try meditation or yoga for stress management. Spending time in nature will do you good.',
      'Review your diet this week. Give your body the nutrients it needs. Pay attention to your sleep patterns.',
      'Take breaks to maintain your energy balance. Show yourself compassion and avoid excessive fatigue. Healing energies are strong.',
    ];
  }

  static List<String> getWeeklyFinancialContent(AppLanguage language) {
    return [
      'Be careful in financial matters this week. Think twice before big expenses. It\'s the perfect time to make savings plans.',
      'Financial abundance energy is strengthening. Unexpected gains or opportunities may come. But keep your feet on the ground.',
      'Research investments but don\'t rush. This week is ideal for developing your financial awareness.',
      'Develop a new perspective on money. Activate abundance consciousness and let go of scarcity fears.',
    ];
  }

  static List<String> getWeeklyAffirmations(AppLanguage language) {
    return [
      'I am open to the universe\'s abundance and everything is fine.',
      'Every day I am getting better in every way.',
      'I recognize the power within me and I use it.',
      'I attract love and I give love.',
      'I let go of my fears and move forward with confidence.',
      'I am on the right path in my spiritual journey.',
    ];
  }

  static List<String> getDays(AppLanguage language) {
    return ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  }

  static List<String> getKeyDateEvents(AppLanguage language) {
    return [
      'romantic opportunities',
      'career breakthroughs',
      'financial decisions',
      'health focus',
      'social events',
      'inner peace',
    ];
  }

  // ============ MONTHLY CONTENT ============

  static List<String> getMonthlyOverviews(ZodiacSign sign, AppLanguage language) {
    final signName = sign.name;
    final elementName = sign.element.name;

    return [
      'This month is a time of transformation and renewal for $signName. Planets are forming strong aspects, preparing the ground for fundamental changes in your life. The transformation that begins in your inner world will reflect on your outer world.',
      'The energies of the month support $signName. This period is ideal for discovering yourself, realizing your potential and growing spiritually. Take advantage of the opportunities the universe offers you.',
      'Cosmic flow is on your side this month. As $elementName energy strengthens, your natural talents and strengths come to the fore. Act with confidence and focus on your goals.',
      'Planets are performing a special choreography for $signName this month. Doors of fate are opening, new possibilities are emerging. Events that will change the flow of your life may occur.',
      'Throughout the month $signName\'s energy is intense. There may be emotional ups and downs but each one will make you stronger. Be patient, the process is working for you.',
      'This month universal energy surrounds $signName. The changes you\'ve been waiting for are starting. Let go of your fears, be open to the new.',
      'The cosmic calendar is opening important pages for you this month. There are turning points in your personal and professional life. Every decision you make shapes your future.',
      'A fruitful month begins for $signName. Time to reap the rewards of your efforts, time to approach your goals. The universe sees and rewards your efforts.',
    ];
  }

  static List<String> getMonthlyLoveContent(AppLanguage language) {
    return [
      'There are important developments in your love life this month. Under Venus\' influence, your relationships are deepening and new romantic bonds can be formed. Keep your heart open.',
      'Transformation is happening in relationships this month. An ideal period to break old patterns and establish more authentic bonds. Be brave and express your feelings.',
      'Romantic energies are intensifying. Important encounters for singles, a passionate period for couples begins. Let yourself be swept away by the magic of love.',
      'Your heart chakra is working overtime this month. Deep emotional connections, meaningful conversations and romantic moments await you. Lower your defenses.',
      'Strong romantic atmosphere throughout the month. Surprise dates, unexpected confessions or opening a new chapter in your relationship are possible.',
      'Time for clarity in relationships. Uncertainties are being resolved, emotions are becoming clear. You may get the answer to "Where do I stand?" this month.',
      'A lucky month begins in love. Destiny moments for singles, a period of falling in love again for couples. Romance is in the air.',
      'Emotional bonds are strengthening this month. Every moment you spend with loved ones is precious. Create quality time, collect memories.',
    ];
  }

  static List<String> getMonthlyCareerContent(AppLanguage language) {
    return [
      'Your career goals are becoming clear this month. There is new opportunity and advancement potential in the professional field. Time to show your leadership abilities.',
      'Make strategic moves in your work life. This month you can prepare the ground for long-term plans and make important decisions. Trust your vision.',
      'Your professional relationships are strengthening. A fruitful period for networking and collaborations. Share your ideas and seek support.',
      'There is activity in the career field throughout the month. Meetings, interviews, new projects... Energy is high, opportunities are plentiful. Be active.',
      'Time to stand out at work this month. Showcase your talents, present your ideas. Your chances of catching your superiors\' attention are high.',
      'Determination and focus are needed in the professional field. Stay away from distractions, set your priorities. Results will come.',
      'Winds of change are blowing in your work life. New roles, responsibilities or a completely different career path may come up.',
      'Your luck shines bright in the business world throughout the month. Unexpected opportunities, positive news or financial gains are possible.',
    ];
  }

  static List<String> getMonthlyHealthContent(AppLanguage language) {
    return [
      'Pay special attention to your health this month. Review your nutrition, sleep and exercise balance. Your body is sending you messages - listen.',
      'Proper timing is important to optimize your energy levels. Stress management and mental health should be the focus this month.',
      'Adopt a holistic health approach. Improve your quality of life by establishing body, mind and soul balance.',
    ];
  }

  static List<String> getMonthlyFinancialContent(AppLanguage language) {
    return [
      'Positive developments in financial matters this month. Your income potential is increasing, opportunities for new sources of income are emerging.',
      'Financial abundance energy is strengthening. Investments made in the past may start to bear fruit.',
      'Budget management is important. Distinguish between needs and wants, cut unnecessary expenses.',
    ];
  }

  static List<String> getMonthlySpiritualContent(AppLanguage language) {
    return [
      'This month is ideal for deepening your spiritual practice. Meditation, yoga or breath work can accelerate your inner transformation.',
      'Your intuition is strengthening. Pay attention to the messages coming from your inner voice and dreams. The universe is guiding you.',
      'Time to discover the depth of your soul. Introspective practices and self-inquiry questions can bring profound realizations.',
    ];
  }

  static List<String> getMonthlyMantras(AppLanguage language) {
    return [
      'I am transforming and renewing with each passing day.',
      'I trust the flow of the universe.',
      'I am worthy of love and abundance.',
      'Every challenge is an opportunity for growth.',
      'I am at peace with myself and the world.',
      'My inner light guides my path.',
    ];
  }

  static List<String> getMonths(AppLanguage language) {
    return [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
  }

  // ============ YEARLY CONTENT ============

  static List<String> getYearlyOverviews(ZodiacSign sign, AppLanguage language) {
    final signName = sign.name;

    return [
      'This year marks a major turning point for $signName. Cosmic energies support deep transformation and personal growth. Trust the process and embrace change.',
      'A year of manifestation awaits $signName. Dreams you\'ve nurtured are ready to become reality. Stay focused, work consistently, and watch miracles unfold.',
      'The stars align for $signName\'s evolution this year. Challenges become teachers, obstacles become stepping stones. Your resilience will be your greatest asset.',
      'Expansion is the theme for $signName this year. Whether in career, relationships, or personal development, growth awaits in every area of life.',
    ];
  }

  static List<String> getYearlyLoveContent(AppLanguage language) {
    return [
      'Love takes center stage this year. Deep connections, soulmate encounters, and relationship milestones await. Open your heart to the magic of love.',
      'A transformative year for matters of the heart. Old patterns break, authentic love emerges. Whether single or coupled, profound growth awaits.',
      'Venus blesses your love life throughout the year. Romance, passion, and emotional depth characterize your relationships. Love finds a way.',
    ];
  }

  static List<String> getYearlyCareerContent(AppLanguage language) {
    return [
      'Professional breakthroughs define this year. Promotions, new opportunities, and recognition for your efforts await. Your hard work pays off.',
      'Career evolution accelerates this year. Whether climbing the ladder or changing paths entirely, significant professional growth is written in the stars.',
      'Leadership opportunities emerge throughout the year. Step into your power, share your vision, and watch your professional influence expand.',
    ];
  }

  static List<String> getYearlyHealthContent(AppLanguage language) {
    return [
      'This year calls for holistic health focus. Mind, body, and spirit alignment becomes priority. Invest in your wellbeing.',
      'Energy management is key this year. Balance activity with rest, productivity with relaxation. Listen to your body\'s wisdom.',
      'Healing energies are strong throughout the year. Old health patterns can transform, new vitality emerges. Support your body\'s natural healing.',
    ];
  }

  static List<String> getYearlyFinancialContent(AppLanguage language) {
    return [
      'Financial abundance flows this year. New income streams, investment opportunities, and material growth await. Prosperity consciousness activates.',
      'Strategic financial planning pays dividends this year. Long-term thinking, wise investments, and disciplined spending create lasting wealth.',
      'Jupiter\'s blessings bring financial expansion. Opportunities for growth and prosperity emerge. Stay open to unexpected abundance.',
    ];
  }

  static List<String> getYearlySpiritualContent(AppLanguage language) {
    return [
      'A year of spiritual awakening unfolds. Deep insights, mystical experiences, and soul growth characterize this journey. Trust your path.',
      'Your spiritual practice deepens this year. Whether meditation, prayer, or contemplation, your connection to the divine strengthens.',
      'Karmic completions and new beginnings mark this year spiritually. Old cycles end, new chapters of soul evolution begin.',
    ];
  }

  static List<String> getYearlyAffirmations(AppLanguage language) {
    return [
      'This year I embrace my highest potential.',
      'I am worthy of all the blessings coming my way.',
      'Every day brings new opportunities for growth.',
      'I trust the journey and surrender to the flow.',
      'Abundance flows to me easily and effortlessly.',
      'I am the creator of my destiny.',
    ];
  }

  static List<String> getYearlyThemes(AppLanguage language) {
    return [
      'Transformation and Rebirth',
      'Manifestation and Abundance',
      'Love and Connection',
      'Career Advancement',
      'Spiritual Awakening',
      'Personal Empowerment',
      'Healing and Renewal',
      'Creative Expression',
    ];
  }

  // ============ LOVE HOROSCOPE CONTENT ============

  static List<String> getRomanticOutlooks(ZodiacSign sign, AppLanguage language) {
    final signName = sign.name;

    return [
      'Venus showers $signName with romantic blessings today. Love is in the air, and your heart is ready to receive. Stay open to unexpected connections.',
      'Passion ignites for $signName. Whether single or coupled, intense romantic energy surrounds you. Express your desires boldly.',
      'Emotional depth characterizes $signName\'s love life today. Meaningful conversations and soul connections are favored. Vulnerability is your strength.',
      'Romance blooms unexpectedly for $signName. The universe arranges beautiful meetings and tender moments. Trust the magic of love.',
    ];
  }

  static List<String> getSingleAdvice(AppLanguage language) {
    return [
      'Your magnetic energy is high today. Put yourself out there - the universe is arranging meaningful connections. Love often finds us when we least expect it.',
      'Focus on self-love first. When you fill your own cup, you attract partners who match your energy. You deserve a love that celebrates you.',
      'Stay open but discerning. Not every connection is meant to last, but every encounter teaches something. Trust your intuition about who deserves your time.',
      'The stars suggest patience. Your person is on their way. Use this time to become the best version of yourself.',
    ];
  }

  static List<String> getCouplesAdvice(AppLanguage language) {
    return [
      'Rekindle the spark today. Plan something special, express your appreciation, remember why you fell in love. Small gestures create big impacts.',
      'Communication is your superpower today. Share your feelings openly, listen deeply. Understanding bridges any gap between hearts.',
      'Passion and tenderness dance together today. Balance desire with emotional connection. Physical and spiritual intimacy intertwine beautifully.',
      'Growth happens together. Support each other\'s dreams, celebrate victories, comfort during challenges. Your partnership is a team.',
    ];
  }

  static List<String> getSoulConnectionContent(AppLanguage language) {
    return [
      'Soul connections transcend time and space. The love you seek is also seeking you. Trust the cosmic timing of heart connections.',
      'Your heart knows what your mind can\'t comprehend. Deep soul bonds form when we surrender to love\'s mysterious ways.',
      'Past life connections may surface. That instant recognition, that unexplainable familiarity - these are soul signatures.',
      'The universe conspires for true love. When hearts are meant to meet, no obstacle is insurmountable. Have faith in your romantic destiny.',
    ];
  }

  static List<String> getVenusInfluence(AppLanguage language) {
    return [
      'Venus blesses your love sector today. Beauty, harmony, and romantic opportunities abound. Let love lead the way.',
      'The planet of love amplifies your charm. You radiate attractive energy that draws others near. Use this magnetism wisely.',
      'Venus whispers of lasting love. Foundations built today can support relationships for years to come. Choose partners wisely.',
      'Under Venus\' gaze, love softens and sweetens. Harsh words dissolve, conflicts resolve. Embrace the healing power of affection.',
    ];
  }

  static List<String> getIntimacyAdvice(AppLanguage language) {
    return [
      'Emotional intimacy deepens physical connection. Share your inner world, your fears and dreams. Vulnerability creates the deepest bonds.',
      'Passion flows when barriers fall. Let go of inhibitions, embrace authentic expression. True intimacy requires courage.',
      'Sacred sensuality awakens today. Honor your body and your partner\'s as temples of pleasure. Mindful presence enhances every touch.',
      'Intimacy is a conversation without words. Listen with your heart, respond with your soul. The body speaks the language of love.',
    ];
  }
}
