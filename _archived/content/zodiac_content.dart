import '../models/zodiac_sign.dart';

/// Comprehensive zodiac sign content with detailed information
class ZodiacContent {
  static ZodiacDetailedInfo getDetailedInfo(ZodiacSign sign) {
    return _zodiacData[sign]!;
  }

  static List<ZodiacDetailedInfo> getAllZodiacInfo() {
    return ZodiacSign.values.map((sign) => _zodiacData[sign]!).toList();
  }

  static final Map<ZodiacSign, ZodiacDetailedInfo> _zodiacData = {
    // ============== ARIES ==============
    ZodiacSign.aries: ZodiacDetailedInfo(
      sign: ZodiacSign.aries,
      overview:
          '''Aries is the first sign of the zodiac, symbolizing new beginnings, courage, and pioneering spirit. Those born between March 21 - April 19 belong to this sign. Ruled by Mars, this fire sign is known for boundless energy, leadership capacity, and entrepreneurial spirit.

Aries individuals are natural-born leaders. They don't hesitate to walk ahead of the crowd, take risks, and venture into the unknown. Being "first" is in their nature - they're always the first to take action, speak up, and make a move.

The Ram, symbol of this sign, represents determination and willpower. Just like a ram climbing a mountain, they're ready to overcome any obstacle to reach their goals. The fire element gives them passion, excitement, and vital energy.''',

      personality: PersonalityTraits(
        strengths: [
          'Courage and bravery - fear cannot stop them',
          'Natural leadership ability and charisma',
          'Entrepreneurial spirit and risk-taking capacity',
          'Honesty and directness',
          'High energy and dynamism',
          'Quick decision-making ability',
          'Competitive and success-oriented nature',
          'Independence and self-confidence',
          'Optimism and positive outlook',
          'Protective and loyal friend',
        ],
        weaknesses: [
          'Impatience and hasty behavior',
          'Tendency to act without thinking',
          'Difficulty controlling anger',
          'Selfishness and ego issues',
          'Overlooking details',
          'Instability in long-term projects',
          'Insensitivity to others\' feelings',
          'Resistance to authority',
          'Excessive competitiveness',
          'Speaking without listening',
        ],
        hiddenTraits: [
          'Despite their tough exterior, they may carry deep insecurity',
          'Beneath their hard shell lies a romantic and sensitive heart',
          'They secretly fear rejection',
          'Failure affects them deeply but they don\'t show it',
          'They would do anything to protect their loved ones',
        ],
      ),

      loveAndRelationships: LoveProfile(
        generalApproach:
            '''Aries in love is passionate, direct, and intense - just like in other areas of life. When they fall in love, the whole world stops - that person becomes the center of their life. They don't enjoy flirting games; they approach the person they're interested in directly.

Aries love is fiery and exciting. Surprises, spontaneous romantic gestures, and adventure-filled dates are their style. Boredom is the biggest threat to their relationships.

They want to maintain their independence in relationships. They may struggle with clingy or jealous partners. Their ideal partner is someone who can stand on their own feet, has self-confidence, and enjoys life.''',
        compatibleSigns: [
          SignCompatibility(
            sign: ZodiacSign.leo,
            percentage: 95,
            description:
                'Perfect match! Two fire signs can burn brightly together. Mutual admiration and passion form the foundation of this relationship.',
          ),
          SignCompatibility(
            sign: ZodiacSign.sagittarius,
            percentage: 93,
            description:
                'An adventure-filled relationship. Both value freedom and enjoy exploring the world together.',
          ),
          SignCompatibility(
            sign: ZodiacSign.gemini,
            percentage: 85,
            description:
                'Intellectual compatibility and fun. Gemini\'s wit enchants Aries, Aries\' energy excites Gemini.',
          ),
          SignCompatibility(
            sign: ZodiacSign.aquarius,
            percentage: 82,
            description:
                'Meeting of independent spirits. They respect each other\'s freedom.',
          ),
        ],
        challengingSigns: [
          SignCompatibility(
            sign: ZodiacSign.cancer,
            percentage: 45,
            description:
                'Aries\' harshness may hurt Cancer. Cancer\'s emotionality may overwhelm Aries.',
          ),
          SignCompatibility(
            sign: ZodiacSign.capricorn,
            percentage: 50,
            description:
                'Both want leadership. Power struggle is inevitable but can be overcome with mutual respect.',
          ),
        ],
        loveAdvice: [
          'Learn to listen to your partner\'s feelings',
          'Be patient - not everything needs to happen instantly',
          'Control your anger, don\'t say things you\'ll regret',
          'Compromise is the foundation of relationships, you don\'t always have to be right',
          'Don\'t underestimate romantic gestures',
        ],
      ),

      careerAndMoney: CareerProfile(
        strengths: [
          'Leadership and management',
          'Entrepreneurship and business creation',
          'Quick decision-making',
          'Risk management',
          'Motivation and team management',
          'Success in competitive environments',
          'Innovative thinking',
          'Crisis management',
        ],
        idealCareers: [
          CareerSuggestion(
            title: 'Entrepreneur / CEO',
            description:
                'Starting and managing your own business, utilizing natural leadership skills',
            suitabilityScore: 98,
          ),
          CareerSuggestion(
            title: 'Athlete / Coach',
            description: 'Utilizing competitive spirit and physical energy',
            suitabilityScore: 95,
          ),
          CareerSuggestion(
            title: 'Sales Director',
            description: 'Persuasion ability and goal-oriented work',
            suitabilityScore: 92,
          ),
          CareerSuggestion(
            title: 'Emergency Doctor / Surgeon',
            description: 'Quick decision-making and working under pressure',
            suitabilityScore: 90,
          ),
          CareerSuggestion(
            title: 'Police / Military',
            description: 'Courage, protection, and action',
            suitabilityScore: 88,
          ),
          CareerSuggestion(
            title: 'Stuntman / Action Actor',
            description: 'Risk-taking and physical courage',
            suitabilityScore: 85,
          ),
        ],
        moneyHabits:
            '''Aries shows their typical character with money too: earn fast, spend fast. They can make big purchases with instant decisions. Budget planning is boring for them but an important skill they need to learn.

They don't hesitate to take risks in investments. This sometimes brings big gains, sometimes big losses. They prefer opportunities promising quick returns rather than long-term investments.

They need motivation to save money. A concrete goal (car, house, travel) directs them to savings. The abstract concept of "saving for the future" doesn't appeal to them.''',
        financialAdvice: [
          'Apply the 24-hour waiting rule for big purchases',
          'Open an automatic savings account',
          'Diversify your portfolio, don\'t put all eggs in one basket',
          'Consider getting financial advisor help',
          'Create an emergency fund',
        ],
      ),

      healthAndWellness: HealthProfile(
        bodyAreas: ['Head', 'Face', 'Brain', 'Eyes', 'Upper jaw'],
        commonIssues: [
          'Migraines and headaches',
          'Facial skin problems',
          'Eye strain',
          'Sinusitis',
          'Stress-related tension',
          'Sudden fever spikes',
        ],
        exerciseRecommendations: [
          'High-intensity interval training (HIIT)',
          'Boxing and martial arts',
          'Running and sprinting',
          'Competitive team sports',
          'CrossFit',
          'Mountain climbing',
        ],
        stressManagement:
            '''Aries needs physical activity to cope with stress. Staying still is their biggest enemy. When anger and tension accumulate, intense workout or running works wonders.

Although meditation and breathing exercises may seem difficult at first, they help greatly with anger control through regular practice. Hobbies requiring patience (puzzles, gardening) have a balancing effect.

Sleep pattern is critical for Aries. When they don't sleep enough, anger control becomes difficult and decision-making ability weakens.''',
        dietaryAdvice: [
          'Diet rich in red meat and protein',
          'Spicy foods speed up metabolism',
          'Pay attention to iron-rich foods',
          'Control caffeine intake - you already have enough energy',
          'Hydration is very important - drink plenty of water',
        ],
      ),

      luckyElements: LuckyElements(
        numbers: [1, 9, 17, 27, 36, 45],
        colors: ['Red', 'Orange', 'Golden yellow', 'White'],
        days: ['Tuesday', 'Saturday'],
        gemstones: ['Diamond', 'Ruby', 'Red coral', 'Agate'],
        metals: ['Iron', 'Steel'],
        flowers: ['Carnation', 'Poppy', 'Lily'],
        direction: 'East',
      ),

      famousPeople: [
        FamousPerson(
          name: 'Leonardo da Vinci',
          profession: 'Artist, Inventor',
          birthDate: 'April 15, 1452',
        ),
        FamousPerson(
          name: 'Lady Gaga',
          profession: 'Singer',
          birthDate: 'March 28, 1986',
        ),
        FamousPerson(
          name: 'Robert Downey Jr.',
          profession: 'Actor',
          birthDate: 'April 4, 1965',
        ),
        FamousPerson(
          name: 'Elton John',
          profession: 'Musician',
          birthDate: 'March 25, 1947',
        ),
        FamousPerson(
          name: 'Mariah Carey',
          profession: 'Singer',
          birthDate: 'March 27, 1969',
        ),
        FamousPerson(
          name: 'Emma Watson',
          profession: 'Actress',
          birthDate: 'April 15, 1990',
        ),
        FamousPerson(
          name: 'Quentin Tarantino',
          profession: 'Director',
          birthDate: 'March 27, 1963',
        ),
        FamousPerson(
          name: 'Charlie Chaplin',
          profession: 'Actor, Director',
          birthDate: 'April 16, 1889',
        ),
      ],

      mythologyAndSymbolism:
          '''The Aries constellation holds an important place in ancient mythology. In Greek mythology, the ram with the Golden Fleece saved Phrixus and Helle. This ram was placed in the sky by Zeus and became a constellation.

The ram symbol represents courage, warrior spirit, and leadership in many cultures. In ancient Egypt, Amon-Ra was depicted as a ram-headed god. In Celtic mythology, the ram was a symbol of masculine power and fertility.

Astrologically, Aries begins with the spring equinox - this is the time of rebirth, new beginnings, and nature's awakening. Therefore, the Aries sign is deeply connected with life energy and renewal.

Mars' rulership gives Aries the warrior spirit, competitiveness, and power to take action. Mars bears the name of the Roman god of war and is the source of courage and determination in the Aries character.''',

      seasonalAdvice: SeasonalAdvice(
        spring:
            'Spring is your season! Ideal time to start new projects, focus on fitness goals, and revitalize your social life. Making big decisions around your birthday can be lucky.',
        summer:
            'Your energy is at its peak. Make vacation plans but control excessive ambitions. Exciting developments in love life possible. Watch out for sunburns!',
        autumn:
            'Time to slow down. Focus on relationships and inner world. Be cautious with financial matters. Good period for learning new skills.',
        winter:
            'Be career-focused. Make long-term plans. Strengthen family relationships. Don\'t reduce physical activity, it protects against winter depression.',
      ),

      lifeLessons: [
        'Patience is a virtue - everything has its time',
        'Listening to others is as important as making your voice heard',
        'Being strong doesn\'t always mean fighting',
        'Making mistakes is human, learning from mistakes is wisdom',
        'Leadership is about serving',
        'Anger controls you if not controlled',
        'Independence is important but connection is also beautiful',
        'You don\'t have to win every race',
      ],
    ),

    // ============== TAURUS ==============
    ZodiacSign.taurus: ZodiacDetailedInfo(
      sign: ZodiacSign.taurus,
      overview:
          '''Taurus is the second sign of the zodiac, symbolizing stability, security, and life's pleasures. Those born between April 20 - May 20 belong to this sign. Ruled by Venus, this earth sign is known for loyalty, determination, and sensual pleasures.

Taurus individuals often value building life's solid foundations. They are traditionally associated with reliability, patience, and determination. Those who resonate with Taurus traits may explore themes of trustworthiness and stability.

The Bull, symbol of this sign, represents strength and endurance. The earth element gives them practicality, tangibility, and a grounded perspective. Venus' rulership brings deep interest in beauty, art, and love.''',

      personality: PersonalityTraits(
        strengths: [
          'Extraordinary loyalty and reliability',
          'Patience and perseverance',
          'Practical thinking and problem-solving',
          'Financial intelligence and frugality',
          'Understanding and appreciating sensual pleasures',
          'Determination and consistency',
          'Calming and balancing presence',
          'Aesthetic sense and art appreciation',
          'Harmony with nature',
          'Protective and nurturing',
        ],
        weaknesses: [
          'Stubbornness and inflexibility',
          'Resistance to change',
          'Excessive attachment to material things',
          'Tendency toward laziness',
          'Possessive behavior',
          'Jealousy',
          'Inability to break from routine',
          'Overeating and excessive consumption',
          'Holding grudges',
          'Slowness in decision-making',
        ],
        hiddenTraits: [
          'Deep insecurity may lie beneath their calm exterior',
          'They fear change but actually want to grow',
          'They are extremely romantic and poetic but struggle to show it',
          'Rejection wounds them deeply',
          'They quietly make great sacrifices for those they love',
        ],
      ),

      loveAndRelationships: LoveProfile(
        generalApproach:
            '''Taurus in love is slow but deep. They don't fall in love immediately, they take time to get to know someone. But once they commit, their loyalty is unwavering. For them, love is a marathon, not a sprint.

They love romantic gestures - a nice dinner, quality gifts, physical closeness. The five senses are their love language. They attach great importance to touch, smell, and taste.

Security is the foundation of love for Taurus. They don't open up to someone they don't trust. In choosing partners, they look for long-term compatibility, valuing lasting bonds over momentary attractions.''',
        compatibleSigns: [
          SignCompatibility(
            sign: ZodiacSign.cancer,
            percentage: 96,
            description:
                'Perfect home and family compatibility. Both value security and loyalty. Together they build a peaceful home.',
          ),
          SignCompatibility(
            sign: ZodiacSign.virgo,
            percentage: 94,
            description:
                'Natural compatibility as earth signs. A practical, reliable couple who understand each other.',
          ),
          SignCompatibility(
            sign: ZodiacSign.pisces,
            percentage: 88,
            description:
                'A romantic and dreamlike bond. Pisces\' sensitivity softens Taurus, Taurus\' solidity keeps Pisces safe.',
          ),
          SignCompatibility(
            sign: ZodiacSign.capricorn,
            percentage: 92,
            description:
                'Long-term success together. Perfect compatibility in work and family goals.',
          ),
        ],
        challengingSigns: [
          SignCompatibility(
            sign: ZodiacSign.leo,
            percentage: 55,
            description:
                'Stubbornness clash. Both struggle to compromise. Power struggle can be exhausting.',
          ),
          SignCompatibility(
            sign: ZodiacSign.aquarius,
            percentage: 48,
            description:
                'Very different worlds. Aquarius\' changeability stresses Taurus. Taurus\' routine bores Aquarius.',
          ),
        ],
        loveAdvice: [
          'Be open to change - relationships evolve too',
          'Possessiveness suffocates love, allow freedom',
          'Control your jealousy',
          'Expressing emotions is not weakness',
          'Sometimes being spontaneous revitalizes relationships',
        ],
      ),

      careerAndMoney: CareerProfile(
        strengths: [
          'Financial planning and investment',
          'Long-term project management',
          'Reliability and consistency',
          'Attention to detail',
          'Art and design talents',
          'Negotiation skills',
          'Quality control',
          'Customer relations',
        ],
        idealCareers: [
          CareerSuggestion(
            title: 'Banker / Finance Manager',
            description: 'Money management and long-term planning',
            suitabilityScore: 97,
          ),
          CareerSuggestion(
            title: 'Chef / Gastronomy Expert',
            description: 'Sensual experiences and flavor creation',
            suitabilityScore: 95,
          ),
          CareerSuggestion(
            title: 'Architect / Interior Designer',
            description: 'Combining aesthetics and practicality',
            suitabilityScore: 93,
          ),
          CareerSuggestion(
            title: 'Real Estate Consultant',
            description: 'Property valuation and long-term investment',
            suitabilityScore: 91,
          ),
          CareerSuggestion(
            title: 'Musician / Sound Engineer',
            description: 'Sensual sensitivity and art',
            suitabilityScore: 88,
          ),
          CareerSuggestion(
            title: 'Gardener / Landscape Architect',
            description: 'Working with nature and tangible results',
            suitabilityScore: 86,
          ),
        ],
        moneyHabits:
            '''Taurus is the zodiac's best money manager. Financial security is their top priority. They are frugal but not stingy - they spend on quality but don't waste.

They are conservative about investments. They prefer real estate, gold, or fixed-income investments over stocks. They think long-term and don't make sudden decisions.

They don't hesitate to spend money on luxury and quality products. For them, cheap and poor quality is more expensive in the long run. They embrace the "cry once" philosophy.''',
        financialAdvice: [
          'Excessive conservatism may sometimes cause you to miss opportunities',
          'Consider diversifying your investment portfolio',
          'Don\'t lose sight of the budget when spending on luxury',
          'Emergency fund is recommended',
          'Sometimes you may need to take risks',
        ],
      ),

      healthAndWellness: HealthProfile(
        bodyAreas: ['Neck', 'Throat', 'Thyroid', 'Vocal cords', 'Shoulders'],
        commonIssues: [
          'Thyroid problems',
          'Throat infections',
          'Neck pain and stiffness',
          'Voice problems',
          'Weight control difficulties',
          'Slow metabolism',
        ],
        exerciseRecommendations: [
          'Walking and hiking',
          'Yoga and pilates',
          'Swimming',
          'Dancing (especially salsa, tango)',
          'Gardening',
          'Weight training (slow pace)',
        ],
        stressManagement:
            '''Taurus solves stress with physical comfort. Massage, hot bath, aromatherapy are wonderful stress relievers for them. Spending time in nature renews their spirit.

Eating is both pleasure and stress management tool for Taurus. However, this can lead to overeating during stressful periods. Mindful eating practices are important.

Music is a powerful healing tool for Taurus. Soothing melodies or favorite songs melt stress. Playing an instrument or singing is especially beneficial.''',
        dietaryAdvice: [
          'Focus on foods that speed up your metabolism',
          'Watch your portions',
          'Don\'t eat heavy meals in the evening',
          'Consume iodine-rich foods for thyroid health',
          'Support metabolism by drinking plenty of water',
        ],
      ),

      luckyElements: LuckyElements(
        numbers: [2, 6, 15, 24, 33, 42],
        colors: ['Green', 'Pink', 'Earth tones', 'Pastel colors'],
        days: ['Friday', 'Monday'],
        gemstones: ['Emerald', 'Sapphire', 'Aquamarine', 'Jade'],
        metals: ['Copper', 'Bronze'],
        flowers: ['Rose', 'Daisy', 'Lily'],
        direction: 'Southeast',
      ),

      famousPeople: [
        FamousPerson(
          name: 'Adele',
          profession: 'Singer',
          birthDate: 'May 5, 1988',
        ),
        FamousPerson(
          name: 'Dwayne Johnson',
          profession: 'Actor, Wrestler',
          birthDate: 'May 2, 1972',
        ),
        FamousPerson(
          name: 'Queen Elizabeth II',
          profession: 'Queen',
          birthDate: 'April 21, 1926',
        ),
        FamousPerson(
          name: 'David Beckham',
          profession: 'Football Player',
          birthDate: 'May 2, 1975',
        ),
        FamousPerson(
          name: 'Cher',
          profession: 'Singer, Actress',
          birthDate: 'May 20, 1946',
        ),
        FamousPerson(
          name: 'George Clooney',
          profession: 'Actor, Director',
          birthDate: 'May 6, 1961',
        ),
        FamousPerson(
          name: 'William Shakespeare',
          profession: 'Writer',
          birthDate: 'April 23, 1564',
        ),
        FamousPerson(
          name: 'Penelope Cruz',
          profession: 'Actress',
          birthDate: 'April 28, 1974',
        ),
      ],

      mythologyAndSymbolism:
          '''The Taurus constellation is one of the symbols greatly valued by ancient civilizations. In Greek mythology, it represents the white bull form Zeus transformed into to abduct Europa. This legend symbolizes the union of beauty, power, and love.

In Egypt, the Apis bull was considered sacred and worshiped as a symbol of fertility and power. In Sumerian civilization, the "Bull of Heaven" was seen as the guardian of paradise.

Astrologically, Taurus corresponds to the middle of spring - when nature blooms and fruits begin to form. Therefore, it is associated with abundance, fertility, and growth.

Venus' rulership gives Taurus appreciation for beauty, artistic talent, and deep commitment to love. Venus is also associated with wealth and luxury, explaining Taurus' interest in the material world.''',

      seasonalAdvice: SeasonalAdvice(
        spring:
            'Your birthday season! Ideal for new beginnings. Connect with garden work and nature. Set financial goals.',
        summer:
            'Relaxation and enjoyment time. Spend quality vacation time. Focus on romance in love life. Pay attention to healthy eating.',
        autumn:
            'Plan career moves. Suitable for home projects. Review financial matters. Acquire new hobbies.',
        winter:
            'Turn to your inner world. Spend quality time with loved ones. Plan for the future. Enjoy comfort and warmth.',
      ),

      lifeLessons: [
        'Change is inevitable and part of growth',
        'Material security is important but not everything',
        'Flexibility is a sign of strength',
        'Trying to control others tires you',
        'Sometimes letting go is stronger than holding on',
        'Stepping out of comfort zone develops you',
        'Don\'t define yourself by what you own',
        'You can change for things you value',
      ],
    ),

    // ============== GEMINI ==============
    ZodiacSign.gemini: _createDetailedInfo(
      ZodiacSign.gemini,
      '''Gemini is the third sign of the zodiac, symbolizing communication, intelligence, and versatility. Those born between May 21 - June 20 belong to this sign. Ruled by Mercury, this air sign is known for curiosity, adaptability, and social skills.

Gemini individuals are mental gymnastics masters. They can easily switch from one topic to another, manage multiple projects simultaneously, and adapt to any environment. Boredom is their biggest enemy.

The Twins, symbol of this sign, represents dual nature and versatility. The air element gives them mental agility, communication ability, and social harmony. Mercury's rulership brings speed, wit, and verbal expression power.''',
    ),

    // ============== CANCER ==============
    ZodiacSign.cancer: _createDetailedInfo(
      ZodiacSign.cancer,
      '''Cancer is the fourth sign of the zodiac, symbolizing emotional depth, family, and protectiveness. Those born between June 21 - July 22 belong to this sign. Ruled by the Moon, this water sign is known for empathy, intuition, and maternal instinct.

Cancer individuals are masters of the emotional world. They can instantly sense others' feelings, empathize, and console. Home is a sacred place for them.

The Crab, symbol of this sign, represents the protective shell and sensitive inner world. The water element gives them emotional fluidity, intuition, and deep feelings. The Moon's rulership brings cyclical nature, emotional fluctuations, and maternal energy.''',
    ),

    // ============== LEO ==============
    ZodiacSign.leo: _createDetailedInfo(
      ZodiacSign.leo,
      '''Leo is the fifth sign of the zodiac, symbolizing creativity, leadership, and self-expression. Those born between July 23 - August 22 belong to this sign. Ruled by the Sun, this fire sign is known for charisma, generosity, and showmanship.

Leo individuals are natural stars. They're noticed when they enter a room, listened to when they speak. Life for them is a stage, every day a new performance.

The Lion, symbol of this sign, is the universal symbol of royalty, power, and courage. The fire element gives them passion, creativity, and warmth. The Sun's rulership brings vital energy, self-confidence, and the need to be central.''',
    ),

    // ============== VIRGO ==============
    ZodiacSign.virgo: _createDetailedInfo(
      ZodiacSign.virgo,
      '''Virgo is the sixth sign of the zodiac, symbolizing analysis, perfectionism, and service. Those born between August 23 - September 22 belong to this sign. Ruled by Mercury, this earth sign is known for precision, practicality, and attention to detail.

Virgo individuals are masters of organization and efficiency. They see what others miss and know how to improve things. Their analytical minds are constantly at work.

The Maiden, symbol of this sign, represents purity, harvest, and the gathering of wisdom. The earth element gives them practicality, reliability, and groundedness. Mercury's rulership brings analytical thinking and communication skills.''',
    ),

    // ============== LIBRA ==============
    ZodiacSign.libra: _createDetailedInfo(
      ZodiacSign.libra,
      '''Libra is the seventh sign of the zodiac, symbolizing balance, harmony, and relationships. Those born between September 23 - October 22 belong to this sign. Ruled by Venus, this air sign is known for diplomacy, fairness, and aesthetic sense.

Libra individuals are natural peacemakers. They see all sides of an issue and strive for fairness. Beauty and harmony in all things are essential to them.

The Scales, symbol of this sign, represent justice, balance, and partnership. The air element gives them social grace and intellectual approach to life. Venus' rulership brings love of beauty, art, and harmonious relationships.''',
    ),

    // ============== SCORPIO ==============
    ZodiacSign.scorpio: _createDetailedInfo(
      ZodiacSign.scorpio,
      '''Scorpio is the eighth sign of the zodiac, symbolizing passion, transformation, and mystery. Those born between October 23 - November 21 belong to this sign. Ruled by Pluto and Mars, this water sign is known for intensity, determination, and depth.

Scorpio individuals are masters of transformation. They understand life's depths and aren't afraid to explore the shadows. Their emotional intensity is unmatched.

The Scorpion, symbol of this sign, represents protection, power, and rebirth. The water element gives them emotional depth and intuition. Pluto's rulership brings transformative power and ability to see beneath surfaces.''',
    ),

    // ============== SAGITTARIUS ==============
    ZodiacSign.sagittarius: _createDetailedInfo(
      ZodiacSign.sagittarius,
      '''Sagittarius is the ninth sign of the zodiac, symbolizing adventure, freedom, and philosophy. Those born between November 22 - December 21 belong to this sign. Ruled by Jupiter, this fire sign is known for optimism, exploration, and truth-seeking.

Sagittarius individuals are eternal explorers. Whether through travel, education, or philosophy, they're always seeking expansion and understanding. Freedom is essential to their wellbeing.

The Archer, symbol of this sign, represents the aim toward higher knowledge and distant horizons. The fire element gives them enthusiasm and spontaneity. Jupiter's rulership brings luck, growth, and philosophical wisdom.''',
    ),

    // ============== CAPRICORN ==============
    ZodiacSign.capricorn: _createDetailedInfo(
      ZodiacSign.capricorn,
      '''Capricorn is the tenth sign of the zodiac, symbolizing ambition, discipline, and success. Those born between December 22 - January 19 belong to this sign. Ruled by Saturn, this earth sign is known for determination, responsibility, and achievement.

Capricorn individuals are master builders. They set goals and work tirelessly to achieve them. Long-term planning and structured approach are their strengths.

The Sea-Goat, symbol of this sign, represents the ability to navigate both emotional depths and worldly heights. The earth element gives them practicality and perseverance. Saturn's rulership brings discipline, structure, and wisdom through experience.''',
    ),

    // ============== AQUARIUS ==============
    ZodiacSign.aquarius: _createDetailedInfo(
      ZodiacSign.aquarius,
      '''Aquarius is the eleventh sign of the zodiac, symbolizing innovation, humanity, and originality. Those born between January 20 - February 18 belong to this sign. Ruled by Uranus and Saturn, this air sign is known for independence, progressiveness, and humanitarian ideals.

Aquarius individuals are visionary thinkers. They see possibilities others miss and aren't afraid to challenge convention. Their focus extends beyond self to collective wellbeing.

The Water Bearer, symbol of this sign, represents the sharing of knowledge and humanitarian ideals. The air element gives them intellectual approach and social awareness. Uranus' rulership brings innovation, rebellion, and sudden insights.''',
    ),

    // ============== PISCES ==============
    ZodiacSign.pisces: _createDetailedInfo(
      ZodiacSign.pisces,
      '''Pisces is the twelfth sign of the zodiac, symbolizing empathy, imagination, and spirituality. Those born between February 19 - March 20 belong to this sign. Ruled by Neptune and Jupiter, this water sign is known for intuition, compassion, and artistic sensitivity.

Pisces individuals are deeply connected to the unseen realms. They feel what others cannot and often express this through creative or spiritual pursuits. Boundaries between self and other can be fluid for them.

The Fish, symbol of this sign, represents the connection between conscious and unconscious, material and spiritual. The water element gives them emotional depth and psychic sensitivity. Neptune's rulership brings dreams, imagination, and transcendence.''',
    ),
  };

  static ZodiacDetailedInfo _createDetailedInfo(
    ZodiacSign sign,
    String overview,
  ) {
    return ZodiacDetailedInfo(
      sign: sign,
      overview: overview,
      personality: PersonalityTraits(
        strengths: sign.traits.take(5).toList(),
        weaknesses: ['Detailed information coming soon'],
        hiddenTraits: ['Detailed information coming soon'],
      ),
      loveAndRelationships: LoveProfile(
        generalApproach: 'Detailed love analysis coming soon.',
        compatibleSigns: [],
        challengingSigns: [],
        loveAdvice: ['Detailed advice coming soon'],
      ),
      careerAndMoney: CareerProfile(
        strengths: ['Detailed information coming soon'],
        idealCareers: [],
        moneyHabits: 'Detailed financial analysis coming soon.',
        financialAdvice: ['Detailed advice coming soon'],
      ),
      healthAndWellness: HealthProfile(
        bodyAreas: ['Detailed information coming soon'],
        commonIssues: ['Detailed information coming soon'],
        exerciseRecommendations: ['Detailed recommendations coming soon'],
        stressManagement: 'Detailed stress management coming soon.',
        dietaryAdvice: ['Detailed recommendations coming soon'],
      ),
      luckyElements: LuckyElements(
        numbers: [1, 7, 13],
        colors: ['Coming soon'],
        days: ['Coming soon'],
        gemstones: ['Coming soon'],
        metals: ['Coming soon'],
        flowers: ['Coming soon'],
        direction: 'Coming soon',
      ),
      famousPeople: [],
      mythologyAndSymbolism: 'Detailed mythology information coming soon.',
      seasonalAdvice: SeasonalAdvice(
        spring: 'Detailed advice coming soon',
        summer: 'Detailed advice coming soon',
        autumn: 'Detailed advice coming soon',
        winter: 'Detailed advice coming soon',
      ),
      lifeLessons: ['Detailed lessons coming soon'],
    );
  }
}

// ==================== DATA MODELS ====================

class ZodiacDetailedInfo {
  final ZodiacSign sign;
  final String overview;
  final PersonalityTraits personality;
  final LoveProfile loveAndRelationships;
  final CareerProfile careerAndMoney;
  final HealthProfile healthAndWellness;
  final LuckyElements luckyElements;
  final List<FamousPerson> famousPeople;
  final String mythologyAndSymbolism;
  final SeasonalAdvice seasonalAdvice;
  final List<String> lifeLessons;

  ZodiacDetailedInfo({
    required this.sign,
    required this.overview,
    required this.personality,
    required this.loveAndRelationships,
    required this.careerAndMoney,
    required this.healthAndWellness,
    required this.luckyElements,
    required this.famousPeople,
    required this.mythologyAndSymbolism,
    required this.seasonalAdvice,
    required this.lifeLessons,
  });
}

class PersonalityTraits {
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> hiddenTraits;

  PersonalityTraits({
    required this.strengths,
    required this.weaknesses,
    required this.hiddenTraits,
  });
}

class LoveProfile {
  final String generalApproach;
  final List<SignCompatibility> compatibleSigns;
  final List<SignCompatibility> challengingSigns;
  final List<String> loveAdvice;

  LoveProfile({
    required this.generalApproach,
    required this.compatibleSigns,
    required this.challengingSigns,
    required this.loveAdvice,
  });
}

class SignCompatibility {
  final ZodiacSign sign;
  final int percentage;
  final String description;

  SignCompatibility({
    required this.sign,
    required this.percentage,
    required this.description,
  });
}

class CareerProfile {
  final List<String> strengths;
  final List<CareerSuggestion> idealCareers;
  final String moneyHabits;
  final List<String> financialAdvice;

  CareerProfile({
    required this.strengths,
    required this.idealCareers,
    required this.moneyHabits,
    required this.financialAdvice,
  });
}

class CareerSuggestion {
  final String title;
  final String description;
  final int suitabilityScore;

  CareerSuggestion({
    required this.title,
    required this.description,
    required this.suitabilityScore,
  });
}

class HealthProfile {
  final List<String> bodyAreas;
  final List<String> commonIssues;
  final List<String> exerciseRecommendations;
  final String stressManagement;
  final List<String> dietaryAdvice;

  HealthProfile({
    required this.bodyAreas,
    required this.commonIssues,
    required this.exerciseRecommendations,
    required this.stressManagement,
    required this.dietaryAdvice,
  });
}

class LuckyElements {
  final List<int> numbers;
  final List<String> colors;
  final List<String> days;
  final List<String> gemstones;
  final List<String> metals;
  final List<String> flowers;
  final String direction;

  LuckyElements({
    required this.numbers,
    required this.colors,
    required this.days,
    required this.gemstones,
    required this.metals,
    required this.flowers,
    required this.direction,
  });
}

class FamousPerson {
  final String name;
  final String profession;
  final String birthDate;

  FamousPerson({
    required this.name,
    required this.profession,
    required this.birthDate,
  });
}

class SeasonalAdvice {
  final String spring;
  final String summer;
  final String autumn;
  final String winter;

  SeasonalAdvice({
    required this.spring,
    required this.summer,
    required this.autumn,
    required this.winter,
  });
}
