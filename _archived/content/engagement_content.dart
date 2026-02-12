/// Reflection-Focused Content Library for Venus One
/// Lifestyle reflection and self-awareness content
/// Content designed for personal growth and mindful exploration
library;

/// Content disclaimer for all content in this file
const String engagementContentDisclaimer =
    'All content is for reflection and self-awareness purposes only. This is not prediction or fortune-telling.';

// ============================================================
// PAGE 1: HOMEPAGE (/)
// ============================================================

class HomepageContent {
  // PURPOSE & USER INTENT:
  // - First impression, brand introduction
  // - User seeks: "What can this app do for me?"
  // - Emotional state: curious, possibly skeptical, seeking meaning

  // COMPETITOR BENCHMARK:
  // - Co-Star: Personalized daily push, emotional hook immediately
  // - Nebula: Visual storytelling, mystical atmosphere
  // - Astro-Seek: Tool-first approach, data richness visible
  // - Venus One Gap: Needs stronger emotional hook + clear value proposition

  static const String heroTitle = 'Your Reflection Journey Begins Here';

  static const String heroSubtitle =
      'Explore archetypal themes for self-discovery. Personality insights, daily reflection prompts, and mindfulness tools — all in one place.';

  static const String introSection = '''
Venus One is a lifestyle reflection app that uses symbolic themes from various cultural traditions to support personal growth and self-awareness.

What you'll find here:
• Personality archetype exploration
• Daily, weekly, and seasonal reflection prompts
• Relationship pattern reflection tools
• Card-based journaling and number symbolism
• Symbolic theme exploration for self-discovery

Archetypes are cultural patterns that can serve as mirrors for self-reflection. These symbols are not fixed destinies, but tools for exploring your inner world. We don't make claims about outcomes — we invite you to ask "what does this theme evoke in me?"
''';

  static const String whatWeOfferSection = '''
## What Does This Platform Offer?

**Your Personal Cosmic Map**
Your natal chart, a snapshot of the sky at the moment of your birth, is your unique cosmic fingerprint. The positions of the Sun, Moon, Ascendant, and all planets come together to tell your story.

**Daily Cosmic Weather**
Each day the sky carries different energy. Our daily horoscope readings gently convey how this energy might reflect on your sign. These are not directives, but thought-provoking suggestions.

**Relationship Dynamics**
The meeting of two charts is the intersection of two universes. Explore the cosmic dimension of your relationships with synastry analysis — but remember, no chart can tell whether a relationship will "work or not."

**Symbolic Tools**
Tarot, numerology, Kabbalah, and aura readings — all of these are different languages for speaking with your subconscious. The answers are not in the cards or numbers, but within you; these tools can only help you reach those answers.
''';

  static const String howToUseSection = '''
## How to Use Venus One?

**1. Enter Your Birth Information**
Date of birth, time, and place — these three pieces of information are the key to your cosmic map. Even without the exact time, a basic analysis can be done, but the Ascendant cannot be calculated.

**2. Choose the Area You're Curious About**
Daily energy, relationship compatibility, or deep natal analysis? Each tool offers a different perspective.

**3. Read, Think, Reflect**
Read the interpretations not as "right/wrong" but with the question "what does this evoke in me?" The most valuable insights come from moments when they meet your own inner voice.

**4. Save and Return**
Create a profile to save your chart. As transits change, the sky will present different messages to you.
''';

  static const String whatThisIsNotSection = '''
## What This Platform Is NOT

**It's Not a Fortune-Telling Service**
We don't make specific claims about what happens on a given date. These reflections are built on symbolic tendencies, not certainties.

**It's Not Psychological Counseling**
For serious emotional or mental health issues, please seek professional support. Astrology can be a complementary tool, but it doesn't replace treatment.

**It Doesn't Make Relationship Decisions For You**
No chart can answer the question "Should I marry this person?" The decisions are yours; the stars only offer perspectives to think about.

**It Makes No Scientific Claims**
Astrology is not empirical science. It's a symbolic language system spanning thousands of years. Accepting this, you can use it for your own inner journey.
''';

  static const String curiosityHooksSection = '''
## People Here Also Explore...

→ "What makes my personality archetype unique?"
→ "How can cultural symbols help me reflect on my life?"
→ "What patterns do I notice in my relationships?"
→ "How can I use dream journaling for self-discovery?"
→ "What seasonal themes might be meaningful to reflect on?"
''';

  static const List<Map<String, String>> faqs = [
    {
      'question': 'Does astrology really work?',
      'answer':
          'Astrology is a symbolic language system spanning thousands of years. It depends on your definition of "work" — if you expect precise prophecies, you may be disappointed. However, it can be a powerful tool for self-discovery, inner reflection, and different perspectives. Instead of seeking scientific proof, we suggest focusing on what it evokes in you.',
    },
    {
      'question': 'What if I don\'t know my birth time?',
      'answer':
          'Without a birth time, your Sun sign, Moon sign (approximate), and planetary positions can still be calculated. However, the exact time is needed for the Ascendant and house placements. You can use a default time like "noon 12:00," but skip the house interpretations in that case.',
    },
    {
      'question': 'Are daily horoscopes the same for everyone?',
      'answer':
          'Everyone with the same sign shares the same general energy, but other factors in your individual chart (Moon sign, Ascendant, planetary aspects) personalize your experience. That\'s why sometimes it "hits exactly" and sometimes "doesn\'t resonate at all."',
    },
    {
      'question': 'Are tarot and astrology the same thing?',
      'answer':
          "No. Astrology is a system based on planetary positions, while tarot is a reading practice using symbolic cards. Both are tools for inner reflection but use different languages. You can find both on Venus One.",
    },
    {
      'question': 'What difference does Premium membership make?',
      'answer':
          'With Premium membership, you get detailed transit reports, unlimited synastry analysis, advanced progression tracking, and an ad-free experience. Basic features are free.',
    },
    {
      'question': 'Is my data safe?',
      'answer':
          'Your birth information is stored encrypted on your device. It is not shared with third parties. You can delete your account at any time.',
    },
  ];

  // NAVIGATION STRATEGY
  static const Map<String, String> internalLinks = {
    '/birth-chart': 'Calculate your birth chart →',
    '/horoscope': 'Discover today\'s zodiac energy →',
    '/compatibility': 'Analyze your relationship compatibility →',
    '/tarot': 'Draw your daily tarot card →',
    '/transits': 'See current planetary transits →',
  };

  static const Map<String, String> journeyPaths = {
    'educational': 'How does astrology work? → /glossary',
    'personal': 'Calculate my chart → /birth-chart',
    'exploratory': 'See my daily energy → /horoscope',
    'deep': 'Examine my transits → /transits',
  };

  static const Map<String, String> ctas = {
    'primary': 'Calculate My Birth Chart',
    'secondary': 'Check My Daily Horoscope',
    'soft': 'I just want to browse...',
  };
}

// ============================================================
// PAGE 2: HOROSCOPE HUB (/horoscope)
// ============================================================

class HoroscopeHubContent {
  // PURPOSE & USER INTENT:
  // - Gateway to all zodiac content
  // - User seeks: daily guidance, emotional validation, curiosity
  // - Quick access to their sign + exploration of others

  // COMPETITOR BENCHMARK:
  // - Co-Star: Personalized, AI-driven, emotional
  // - Astro.com: Traditional, detailed, educational
  // - Nebula: Visual, mystical, story-driven
  // - Gap: Venus One needs more depth before sign selection

  static const String heroTitle = 'Daily Horoscope Readings';

  static const String heroSubtitle =
      'Discover what cosmic energies are whispering to you today. 12 signs, 12 different energy flows.';

  static const String introSection = '''
Horoscope readings are a symbolic interpretation of how the current energy in the sky might reflect on your Sun sign.

Each day the Moon passes through a different sign, planets make different angles. These cosmic movements create a collective energy field. Horoscope readings describe how this energy might touch 12 different archetypes.

**Important Note:** The Sun sign alone doesn't tell the whole story. Your Moon sign, Ascendant, and other planetary placements also shape your daily experience. That's why sometimes readings "fit perfectly," and sometimes they feel distant.
''';

  static const String howToReadSection = '''
## How to Read Horoscope Readings?

**1. Read Your Sun Sign**
The most basic layer. General energy and main themes are here.

**2. Read Your Ascendant Sign**
If you know your Ascendant, read it too. The Ascendant can more directly reflect your experiences in the outer world.

**3. Read Your Moon Sign**
The emotional layer. Your Moon sign is important for your inner world and emotional reactions.

**4. Ask "What Does This Evoke in Me?"**
Instead of taking interpretations literally, pay attention to which sentences stir something inside you. That resonance is what's meaningful for you.

**5. Think Periodically, Not Daily**
A single day's reading may not always hit. Weekly and monthly perspectives offer a broader picture.
''';

  static const String whatThisIsNotSection = '''
## What This Is NOT

**It's Not a Precise Prediction**
We don't use definitive statements like "Expect money today" or "Arguments are certain today." Instead, we talk about energy tendencies.

**It's Not a Personalized Natal Analysis**
Horoscope readings offer a general perspective. See birth chart analysis for the details of your personal chart.

**It's Not a Decision Maker**
Horoscope readings don't answer the question "Should I sign today?" Your decisions are your responsibility.
''';

  static const String elementalWisdomSection = '''
## Today's Energy by Elements

**Fire Signs (Aries, Leo, Sagittarius)**
Action, initiative, and courage energy. Today, movement and expression may be at the forefront for fire signs.

**Earth Signs (Taurus, Virgo, Capricorn)**
Practicality, tangibility, and stability. Tangible results may be important for earth signs today.

**Air Signs (Gemini, Libra, Aquarius)**
Communication, ideas, and connections. Conversations and mental activity may be intense for air signs today.

**Water Signs (Cancer, Scorpio, Pisces)**
Emotions, intuitions, and depth. Inner processes and emotional awareness may be at the forefront for water signs today.
''';

  static const List<Map<String, String>> faqs = [
    {
      'question': 'Why does my horoscope sometimes not resonate at all?',
      'answer':
          'Because you\'re only looking at your Sun sign. Your chart has 10 planets, 12 houses, and countless aspects. The Sun sign is just one piece. Also, readings describe possibilities, not certainties.',
    },
    {
      'question': 'Should I read my Ascendant or Sun sign?',
      'answer':
          'Read both. The Sun sign reflects your inner identity, the Ascendant reflects your experiences in the outer world. Some astrologers find the Ascendant more important, some the Sun. You can prioritize whichever "fits" you better.',
    },
    {
      'question': 'Do daily readings really change every day?',
      'answer':
          'Yes. The Moon changes signs every 2.5 days, planets are constantly moving. That\'s why cosmic energy is truly different every day.',
    },
    {
      'question': 'What should I do when I see a negative reading?',
      'answer':
          'Read negative readings not as "warnings" but as "invitations to awareness." "Be careful in communication today" doesn\'t mean arguments are certain. It just suggests paying a bit more attention to that area.',
    },
    {
      'question': 'Are compatibility readings accurate?',
      'answer':
          'They show general tendencies, but no sign combination is "impossible" or "perfect." Individual charts, personal development, and communication quality are much more determinant.',
    },
    {
      'question': 'Are weekly and monthly readings more accurate than daily?',
      'answer':
          'They may feel more consistent because they offer a broader perspective. Daily readings describe micro energy, weekly/monthly readings describe macro themes.',
    },
  ];

  // 12 ZODIAC SIGNS - Quick Access Cards
  static const List<Map<String, String>> zodiacQuickCards = [
    {
      'sign': 'aries',
      'name': 'Aries',
      'symbol': '♈',
      'dates': 'March 21 - April 19',
      'element': 'Fire',
      'hook': 'Which door do you want to break down today?',
    },
    {
      'sign': 'taurus',
      'name': 'Taurus',
      'symbol': '♉',
      'dates': 'April 20 - May 20',
      'element': 'Earth',
      'hook': 'What do you want to protect, what do you want to grow today?',
    },
    {
      'sign': 'gemini',
      'name': 'Gemini',
      'symbol': '♊',
      'dates': 'May 21 - June 20',
      'element': 'Air',
      'hook': 'Which story will you tell today?',
    },
    {
      'sign': 'cancer',
      'name': 'Cancer',
      'symbol': '♋',
      'dates': 'June 21 - July 22',
      'element': 'Water',
      'hook': 'Who will you open your heart to today?',
    },
    {
      'sign': 'leo',
      'name': 'Leo',
      'symbol': '♌',
      'dates': 'July 23 - August 22',
      'element': 'Fire',
      'hook': 'Which stage will you shine on today?',
    },
    {
      'sign': 'virgo',
      'name': 'Virgo',
      'symbol': '♍',
      'dates': 'August 23 - September 22',
      'element': 'Earth',
      'hook': 'What do you want to improve today?',
    },
    {
      'sign': 'libra',
      'name': 'Libra',
      'symbol': '♎',
      'dates': 'September 23 - October 22',
      'element': 'Air',
      'hook': 'Where are you seeking balance today?',
    },
    {
      'sign': 'scorpio',
      'name': 'Scorpio',
      'symbol': '♏',
      'dates': 'October 23 - November 21',
      'element': 'Water',
      'hook': 'Which depth will you dive into today?',
    },
    {
      'sign': 'sagittarius',
      'name': 'Sagittarius',
      'symbol': '♐',
      'dates': 'November 22 - December 21',
      'element': 'Fire',
      'hook': 'Which horizon are you running towards today?',
    },
    {
      'sign': 'capricorn',
      'name': 'Capricorn',
      'symbol': '♑',
      'dates': 'December 22 - January 19',
      'element': 'Earth',
      'hook': 'Which peak are you climbing today?',
    },
    {
      'sign': 'aquarius',
      'name': 'Aquarius',
      'symbol': '♒',
      'dates': 'January 20 - February 18',
      'element': 'Air',
      'hook': 'Which rule will you rewrite today?',
    },
    {
      'sign': 'pisces',
      'name': 'Pisces',
      'symbol': '♓',
      'dates': 'February 19 - March 20',
      'element': 'Water',
      'hook': 'Which dream will you dive into today?',
    },
  ];

  static const Map<String, String> internalLinks = {
    '/birth-chart': 'See your full chart →',
    '/transits': 'Today\'s planetary transits →',
    '/compatibility': 'Analyze your compatibility →',
    '/tarot': 'Your daily tarot card →',
    '/weekly-horoscope': 'Weekly overview →',
  };

  static const Map<String, String> ctas = {
    'primary': 'Select My Sign',
    'secondary': 'View Weekly Reading',
    'soft': 'Compare all signs',
  };
}

// ============================================================
// PAGES 3-14: INDIVIDUAL ZODIAC SIGN PAGES
// ============================================================

class ZodiacSignContent {
  final String sign;
  final String name;
  final String symbol;
  final String dates;
  final String element;
  final String modality;
  final String ruler;
  final String rulerMeaning;
  final String essence;
  final String extendedDescription;
  final String lightSide;
  final String shadowSide;
  final String loveStyle;
  final String careerStyle;
  final String healthFocus;
  final String dreamPatterns;
  final List<String> commonDreamSymbols;
  final List<String> compatibleSigns;
  final List<String> challengingSigns;
  final List<Map<String, String>> faqs;
  final String dailyAffirmation;
  final Map<String, String> internalLinks;

  const ZodiacSignContent({
    required this.sign,
    required this.name,
    required this.symbol,
    required this.dates,
    required this.element,
    required this.modality,
    required this.ruler,
    required this.rulerMeaning,
    required this.essence,
    required this.extendedDescription,
    required this.lightSide,
    required this.shadowSide,
    required this.loveStyle,
    required this.careerStyle,
    required this.healthFocus,
    required this.dreamPatterns,
    required this.commonDreamSymbols,
    required this.compatibleSigns,
    required this.challengingSigns,
    required this.faqs,
    required this.dailyAffirmation,
    required this.internalLinks,
  });
}

class AllZodiacContent {
  static const aries = ZodiacSignContent(
    sign: 'aries',
    name: 'Aries',
    symbol: '♈',
    dates: 'March 21 - April 19',
    element: 'Fire',
    modality: 'Cardinal',
    ruler: 'Mars',
    rulerMeaning:
        'Mars, the warrior planet, gives Aries courage, initiative, and direct action energy.',
    essence: '''
Aries, as the first sign of the zodiac, is the "I am" archetype. The beginning of spring, new births, first steps... Aries energy carries the courage to dive into life and the drive to be a pioneer.

Those born under this sign are generally known for their leadership potential, competitive spirit, and impatient energy. The "leap before you look" approach is both their strength and their trial.
''',
    extendedDescription: '''
## The Depth of Aries

Aries begins at the zero point of the zodiac wheel — just like a baby coming into the world. That's why Aries energy is pure, unprocessed, and direct. The rawest form of the "I" concept lives here.

**Archetypal Theme: The Warrior**
Aries' archetype is the warrior, but this battle isn't necessarily physical. Fighting for an idea, blazing a new trail, going where no one has gone... These are all Aries energy.

**Element Effect: Fire**
The fire element brings passion, inspiration, and spontaneity. Aries is the most "blazing" form of fire — sudden and intense like striking a match.

**Modality: Cardinal**
Cardinal signs are initiators. Aries excels at starting something, but finishing isn't always their strong suit.

**Shadow Side**
Every sign has a shadow. Aries' shadow can be impatience, anger control issues, and a tendency to steamroll others. Facing this shadow is Aries' growth journey.
''',
    lightSide:
        'Courage, leadership, honesty, energy, initiative, protectiveness, innovation',
    shadowSide:
        'Impatience, anger outbursts, selfishness, acting without thinking, not listening',
    loveStyle: '''
Aries is passionate and direct in love. They don't hesitate to make the first move. They enjoy the chase but may lose interest after "winning" — this is their trial.

**Ideal Partner Dynamic:** Someone who can keep up with Aries' energy but won't blindly submit. Challenge keeps them alive.

**Watch Point:** Conflict can sometimes substitute for "closeness" for Aries. It's important to see the vulnerability behind the anger.
''',
    careerStyle: '''
Aries may struggle in corporate hierarchies — starting their own business or leadership positions suits them better.

**Strong Areas:** Entrepreneurship, sales, sports, military/security, emergency response work.

**Watch Point:** Routine and detailed work can overwhelm Aries. They may need to develop patience in teamwork.
''',
    healthFocus:
        'Head region, headaches, feverish illnesses. Physical activity is essential but injury risk is high. Suppressed anger may manifest as physical symptoms.',
    dreamPatterns: '''
Aries' dreams are usually action-packed and intense. Chases, races, battles, falling from heights or flying dreams are common.

**Symbolic Interpretation:** "Not being able to catch up" or "being blocked" themes often appear in Aries dreams — reflecting subconscious impatience and need for control.
''',
    commonDreamSymbols: [
      'Fire or burning',
      'Running or racing',
      'Fighting or conflict',
      'Driving fast',
      'Weapons or sharp objects',
      'Red color',
      'Ram or lamb',
    ],
    compatibleSigns: ['Leo', 'Sagittarius', 'Gemini', 'Aquarius'],
    challengingSigns: ['Cancer', 'Capricorn', 'Libra'],
    faqs: [
      {
        'question': 'Why is Aries so impatient?',
        'answer':
            'Mars rulership and cardinal modality give Aries a "now" focused energy. Not the future or past, but the present moment matters. This impatience is actually a reflection of an intense passion for life.',
      },
      {
        'question': 'Does Aries want leadership or dictatorship?',
        'answer':
            'A developed Aries is a leader who empowers others. An undeveloped Aries crushes to maintain control. The difference is self-awareness and emotional maturity.',
      },
      {
        'question': 'How do you maintain a relationship with Aries?',
        'answer':
            'Keep the excitement alive, be challenging but respectful, don\'t be passive-aggressive (Aries wants direct communication), and respect their independence.',
      },
      {
        'question': 'Why does Aries get bored so quickly?',
        'answer':
            'The search for novelty is in Aries\' nature. Chasing, exploring keeps them alive. They may lose interest after "winning" — this is an area they need to consciously work on.',
      },
      {
        'question': 'What is Aries\' biggest fear?',
        'answer':
            'Being insignificant, invisible, slowing down, or "losing." Aries\' hidden fear is powerlessness.',
      },
      {
        'question': 'How does Aries calm down?',
        'answer':
            'Physical activity (sports, walking, boxing), competitive games, starting new projects. Meditation is difficult but moving meditation (running, swimming) may work.',
      },
    ],
    dailyAffirmation:
        'My strength carries me forward, but my wisdom guides me on the right path.',
    internalLinks: {
      '/compatibility': 'Signs compatible with Aries →',
      '/birth-chart': 'Mars\' position in your chart →',
      '/horoscope/leo': 'Another fire sign: Leo →',
      '/horoscope/sagittarius': 'Another fire sign: Sagittarius →',
      '/transits': 'How is Mars transit affecting you? →',
      '/tarot': 'Tarot for Aries energy →',
    },
  );

  static const taurus = ZodiacSignContent(
    sign: 'taurus',
    name: 'Taurus',
    symbol: '♉',
    dates: 'April 20 - May 20',
    element: 'Earth',
    modality: 'Fixed',
    ruler: 'Venus',
    rulerMeaning:
        'Venus, the planet of beauty and value, gives Taurus aesthetic sensitivity, loyalty, and a quest for material security.',
    essence: '''
Taurus, as the second sign of the zodiac, is the "I have" archetype. Taurus solidifies, protects, and grows what Aries started.

Those born under this sign are generally known for being patient, determined, and fond of sensory pleasures. Resistance to change is both their strength (stability) and their trial (stubbornness).
''',
    extendedDescription: '''
## The Depth of Taurus

Taurus falls in mid-spring, when nature is at its most fertile. That's why Taurus energy is about productivity, nurturing, and protection.

**Archetypal Theme: The Gardener**
Taurus' archetype is the gardener — they plant seeds in the soil, wait patiently, nurture, and harvest. They don't expect quick results, but want to reap what they sow.

**Element Effect: Earth**
The earth element brings practicality, tangibility, and durability. Taurus is the most "fertile" form of earth — nourishing and productive.

**Modality: Fixed**
Fixed signs are sustainers. Taurus continues, protects, and deepens what's been started. They resist change but once they change, they don't go back.

**Shadow Side**
Taurus' shadow can be stubbornness, over-attachment to material things, possessiveness, and laziness. "Comfort zone" addiction can hinder growth.
''',
    lightSide:
        'Loyalty, patience, reliability, sensory intelligence, aesthetics, practicality, determination',
    shadowSide:
        'Stubbornness, possessiveness, resistance to change, materialism, laziness, jealousy',
    loveStyle: '''
Taurus is loyal, sensual, and protective in love. They seek and offer security. Experiences that appeal to all five senses are important in romance.

**Ideal Partner Dynamic:** Someone reliable, loyal, who can provide material and emotional stability. Sudden changes or uncertainty overwhelm Taurus.

**Watch Point:** Possessiveness, jealousy, and control tendencies should be monitored. The difference between "I love you" and "you're mine" matters.
''',
    careerStyle: '''
Taurus thrives in jobs offering long-term projects, tangible results, and financial security.

**Strong Areas:** Finance, banking, real estate, agriculture, food/restaurant, art, music, luxury sector.

**Watch Point:** Avoidance of risk-taking, struggle in innovation-requiring environments. May need to step out of comfort zone.
''',
    healthFocus:
        'Neck and throat region, thyroid, voice. Tendency to overeat and metabolism issues. Stress accumulates when eating — physical activity and time in nature provide healing.',
    dreamPatterns: '''
Taurus' dreams are usually sensory and concrete. Food, garden, home, money, sexuality themes are common.

**Symbolic Interpretation:** "Losing something" or "being evicted from home" dreams may reflect security anxieties, "feast" dreams may reflect the search for abundance and satisfaction.
''',
    commonDreamSymbols: [
      'Food or feast',
      'Garden or field',
      'House or property',
      'Money or jewelry',
      'Bull or cow',
      'Green color',
      'Soil or flowers',
    ],
    compatibleSigns: ['Virgo', 'Capricorn', 'Cancer', 'Pisces'],
    challengingSigns: ['Leo', 'Aquarius', 'Scorpio'],
    faqs: [
      {
        'question': 'Why is Taurus so stubborn?',
        'answer':
            'Fixed modality and earth element give Taurus a deep "rooting" energy. Change is a threat because it shakes their security. Stubbornness is actually a protection mechanism.',
      },
      {
        'question': 'Why is Taurus so attached to money?',
        'answer':
            'Money for Taurus isn\'t just money, it\'s a symbol of security and freedom. Material stability is the foundation of Taurus\' inner peace.',
      },
      {
        'question': 'Can you argue with a Taurus?',
        'answer':
            'Taurus tolerates for a long time but once they explode, it can be intense. Direct, calm, and respectful communication works best. If you pressure them, they build walls.',
      },
      {
        'question': 'How do you influence a Taurus?',
        'answer':
            'Not with logic, but with experience. Instead of telling, show them, let them taste, let them experience. Taurus is convinced through their senses.',
      },
      {
        'question': 'How does Taurus act when in love?',
        'answer':
            'They start slow and cautious but once attached, they\'re loyal and devoted. They seek gifts, physical closeness, and stability.',
      },
      {
        'question': 'How does Taurus adapt to change?',
        'answer':
            'With great difficulty, but they adapt when forced. They can transition with small steps, at their own pace, and while maintaining a sense of control.',
      },
    ],
    dailyAffirmation:
        'My patience is my strength, change is my growth, I deserve abundance.',
    internalLinks: {
      '/compatibility': 'Signs compatible with Taurus →',
      '/birth-chart': 'Venus\' position in your chart →',
      '/horoscope/virgo': 'Another earth sign: Virgo →',
      '/horoscope/capricorn': 'Another earth sign: Capricorn →',
      '/transits': 'How is Venus transit affecting you? →',
      '/numerology': 'Taurus and numbers →',
    },
  );

  static const gemini = ZodiacSignContent(
    sign: 'gemini',
    name: 'Gemini',
    symbol: '♊',
    dates: 'May 21 - June 20',
    element: 'Air',
    modality: 'Mutable',
    ruler: 'Mercury',
    rulerMeaning:
        'Mercury, the planet of communication and intellect, gives Gemini versatility, curiosity, and verbal talent.',
    essence: '''
Gemini, as the third sign of the zodiac, is the "I think and communicate" archetype. It carries duality, variety, and connection-making energy.

Those born under this sign are generally known for being curious, talkative, and adaptive. Versatility is both their strength and their trial (risk of scatteredness, superficiality).
''',
    extendedDescription: '''
## The Depth of Gemini

Gemini falls at the end of spring, when the air is most active. The Twins symbol reflects this sign's plural nature — multiple perspectives, multiple interests, multiple "selves."

**Archetypal Theme: The Messenger / Trickster**
Gemini's archetype is the messenger — they carry information, make connections, build bridges. Like mythological Hermes/Mercury, they transition between worlds.

**Element Effect: Air**
The air element brings thought, communication, and social connection. Gemini is the most "mobile" form of air — constant movement, change, flow.

**Modality: Mutable**
Mutable signs are adapters. Gemini shifts shape according to environment, person, situation. This flexibility is a strength but carries the risk of inconsistency.

**Shadow Side**
Gemini's shadow can be superficiality, gossip, indecisiveness, unreliability, and over-rationalization. They may hide in the mind to escape emotions.
''',
    lightSide:
        'Intelligence, communication skills, adaptation, curiosity, versatility, humor, sociability',
    shadowSide:
        'Superficiality, indecisiveness, gossip, inconsistency, attention scatter, emotional escape',
    loveStyle: '''
Gemini seeks mental stimulation in love. Conversation, laughter, and intellectual connection come before physical attraction for them.

**Ideal Partner Dynamic:** Someone intellectually equal, open to communication, respectful of independence, and not boring.

**Watch Point:** Tendency to get bored and "grass is always greener" syndrome. Developing emotional depth is important.
''',
    careerStyle: '''
Gemini succeeds in jobs requiring variety, communication, and rapid change.

**Strong Areas:** Media, journalism, sales, marketing, education, writing, social media, interpreting.

**Watch Point:** Long-term, monotonous projects can overwhelm Gemini. Roles allowing multitasking are ideal.
''',
    healthFocus:
        'Hands, arms, nervous system, lungs. Tendency toward anxiety and overthinking. Breathing exercises and mental rest are important.',
    dreamPatterns: '''
Gemini's dreams are usually complex, multi-scene, and communication-themed. Conversations, phones, letters, journeys are common.

**Symbolic Interpretation:** "Unable to speak" or "being misunderstood" dreams may reflect communication anxieties, "twins/copies" dreams may reflect inner conflicts.
''',
    commonDreamSymbols: [
      'Books or writings',
      'Phone or messages',
      'Travel or vehicles',
      'Twins or copies',
      'Birds or butterflies',
      'Wind or storm',
      'Yellow color',
    ],
    compatibleSigns: ['Libra', 'Aquarius', 'Aries', 'Leo'],
    challengingSigns: ['Virgo', 'Pisces', 'Sagittarius'],
    faqs: [
      {
        'question': 'Is Gemini really two-faced?',
        'answer':
            'No, but they are multi-faceted. They show different sides in different environments — this isn\'t fakeness, it\'s adaptation. However, inconsistency can cause trust issues.',
      },
      {
        'question': 'Why is Gemini so indecisive?',
        'answer':
            'Being able to see all options is both a blessing and a curse. Making the "best" choice is difficult for Gemini because they see potential in everything.',
      },
      {
        'question': 'Can you have a deep relationship with a Gemini?',
        'answer':
            'Yes, but it requires patience. Gemini may prefer to stay on the surface but can open up to someone they trust. Emotional depth can come after mental connection is established.',
      },
      {
        'question': 'Why does Gemini talk so much?',
        'answer':
            'Mercury rulership and air element make Gemini a natural communicator. Thoughts flow constantly and the need to share is intense. Sometimes listening is also a skill to learn.',
      },
      {
        'question': 'How do you calm a Gemini down?',
        'answer':
            'Distract their attention (new topic), give logical explanations, physical activity (walking, dancing), writing or talking. Mental occupation calms them.',
      },
      {
        'question': 'What does Gemini do when bored?',
        'answer':
            'They escape — mentally or physically. They seek new people, new ideas, new projects. Boredom is the biggest threat to Gemini.',
      },
    ],
    dailyAffirmation: 'My curiosity enriches me, but depth completes me.',
    internalLinks: {
      '/compatibility': 'Signs compatible with Gemini →',
      '/birth-chart': 'Mercury\'s position in your chart →',
      '/horoscope/libra': 'Another air sign: Libra →',
      '/horoscope/aquarius': 'Another air sign: Aquarius →',
      '/transits': 'How is Mercury retrograde affecting you? →',
      '/tarot': 'Tarot for Gemini energy →',
    },
  );

  // CANCER
  static const cancer = ZodiacSignContent(
    sign: 'cancer',
    name: 'Cancer',
    symbol: '♋',
    dates: 'June 21 - July 22',
    element: 'Water',
    modality: 'Cardinal',
    ruler: 'Moon',
    rulerMeaning:
        'The Moon, the planet of emotions and subconscious, gives Cancer deep intuition, nurturing instinct, and emotional memory.',
    essence: '''
Cancer, as the fourth sign of the zodiac, is the "I feel and protect" archetype. It carries themes of home, family, roots, and emotional security.

Those born under this sign are generally known for being compassionate, intuitive, and protective. Emotional depth is both their strength and their vulnerability.
''',
    extendedDescription: '''
## The Depth of Cancer

Cancer begins at the summer solstice — the longest day, the peak of light but also the beginning of the turn toward darkness. This paradox reflects Cancer's emotional complexity.

**Archetypal Theme: The Mother / Caregiver**
Cancer's archetype is the mother — nurturing, protective, but sometimes smothering. This energy is gender-independent; it's about giving and receiving care.

**Element Effect: Water**
The water element brings emotions, intuition, and empathy. Cancer is the "softest" form of water — calm like a lake but deep.

**Modality: Cardinal**
Cardinal signs are initiators. Cancer takes initiative in the emotional realm — they establish their family, create their home, build safe spaces.

**Shadow Side**
Cancer's shadow can be excessive emotionality, passive-aggressiveness, manipulation (through guilt), being stuck in the past, and shell-building.
''',
    lightSide:
        'Compassion, loyalty, intuition, nurturing, emotional intelligence, memory, protectiveness',
    shadowSide:
        'Excessive sensitivity, being stuck in the past, passive-aggressiveness, shell-building, manipulation',
    loveStyle: '''
Cancer seeks security and emotional connection in love. They trust slowly but once attached, they're deep and loyal.

**Ideal Partner Dynamic:** Someone emotionally open, reliable, who values family, and has a vision of building a home.

**Watch Point:** Fear of rejection, clingy behaviors, and learning to communicate directly instead of "sulking."
''',
    careerStyle: '''
Cancer succeeds in jobs that serve people, involve care, and offer security.

**Strong Areas:** Healthcare, psychology, education (especially children), gastronomy, hospitality, real estate, family businesses.

**Watch Point:** Excessive sensitivity to criticism, being affected by office politics. May need to learn to be thick-skinned.
''',
    healthFocus:
        'Chest, stomach, digestive system. Stress may manifest in eating. Emotional loads can turn into physical symptoms. Drinking water, resting in a home environment is important.',
    dreamPatterns: '''
Cancer's dreams are usually themed around home, family, water, and the past. Old houses, memories, sea or lake are common.

**Symbolic Interpretation:** "Unable to return home" dreams may reflect security anxieties, "being underwater" dreams may reflect emotional overwhelm, "old family members" dreams may reflect unprocessed family dynamics.
''',
    commonDreamSymbols: [
      'House or old houses',
      'Mother or family members',
      'Water (sea, lake, rain)',
      'Babies or children',
      'Crab or shelled sea creatures',
      'Moon or night',
      'Silver color',
    ],
    compatibleSigns: ['Scorpio', 'Pisces', 'Taurus', 'Virgo'],
    challengingSigns: ['Aries', 'Libra', 'Capricorn'],
    faqs: [
      {
        'question': 'Why is Cancer so emotional?',
        'answer':
            'Moon rulership gives Cancer a fluctuating, cyclical emotional life. Like the Moon, Cancer also experiences constantly changing inner landscapes. This emotional depth is also a capacity for deep empathy.',
      },
      {
        'question': 'Why does Cancer sulk?',
        'answer':
            'Cancer avoids direct conflict, instead withdrawing and building a shell. This is a protection mechanism but can harm relationships. They can open up if they feel safe.',
      },
      {
        'question': 'How do you build a bond with Cancer?',
        'answer':
            'By offering patience, consistency, and emotional security. Don\'t rush, open up, share your past. Cancer needs time to build trust.',
      },
      {
        'question': 'Why does Cancer get stuck in the past?',
        'answer':
            'The Moon gives strong memory. Cancer learns from past experiences, memories nourish them. But sometimes this nostalgic tendency can make living in the "now" difficult.',
      },
      {
        'question': 'What does Cancer do when angry?',
        'answer':
            'First withdraws (shell), then may become passive-aggressive (jabs), finally explodes. The explosion is rare but can be intense. It\'s important not to let emotions accumulate.',
      },
      {
        'question': 'How do you love a Cancer?',
        'answer':
            'By listening, remembering, small gestures, caring about their family, spending time with them at home. Cancer wants sincere, not grand expressions.',
      },
    ],
    dailyAffirmation:
        'While protecting my heart, I\'m not afraid to share my love.',
    internalLinks: {
      '/compatibility': 'Signs compatible with Cancer →',
      '/birth-chart': 'Moon\'s position in your chart →',
      '/horoscope/scorpio': 'Another water sign: Scorpio →',
      '/horoscope/pisces': 'Another water sign: Pisces →',
      '/transits': 'How are Moon transits affecting you? →',
      '/dreams': 'Cancer dreams →',
    },
  );

  // LEO
  static const leo = ZodiacSignContent(
    sign: 'leo',
    name: 'Leo',
    symbol: '♌',
    dates: 'July 23 - August 22',
    element: 'Fire',
    modality: 'Fixed',
    ruler: 'Sun',
    rulerMeaning:
        'The Sun, the center of identity and life force, gives Leo radiance, creativity, and natural leadership energy.',
    essence: '''
Leo, as the fifth sign of the zodiac, is the "I create and shine" archetype. It carries themes of creativity, self-expression, and the need for recognition.

Those born under this sign are generally known for being charismatic, generous, and dramatic. The search for light is both their strength and their trial (ego, pride).
''',
    extendedDescription: '''
## The Depth of Leo

Leo falls in the hottest period of summer, when the Sun is at its strongest. Just like the Sun, Leo wants to be at the center, radiate light, and bring life.

**Archetypal Theme: The King/Queen**
Leo's archetype is the king — not one who rules, but one who protects and honors. A true king serves their people, doesn't show off.

**Element Effect: Fire**
The fire element brings passion, creativity, and vitality. Leo is the most "stable" form of fire — like a hearth fire that constantly burns.

**Modality: Fixed**
Fixed signs are sustainers. Leo is fixed in their loyalty, creative vision, and identity. They don't change, but this can sometimes be stubbornness.

**Shadow Side**
Leo's shadow can be arrogance, approval addiction, drama creation, need for control, and being closed to criticism.
''',
    lightSide:
        'Charisma, generosity, creativity, loyalty, courage, leadership, warmth',
    shadowSide:
        'Arrogance, ego, approval addiction, drama, need for control, being closed to criticism',
    loveStyle: '''
Leo is romantic, generous, and performative in love. They want to be loved and admired, but also offer deep loyalty.

**Ideal Partner Dynamic:** Someone who appreciates Leo but doesn't submit to them, who has their own light. Mutual admiration is important.

**Watch Point:** Admiration addiction, needing to be on stage in the relationship, allowing your partner to shine too.
''',

    careerStyle: '''
Leo shines in areas requiring creativity, leadership, and visibility.

**Strong Areas:** Performing arts, management, entertainment, marketing, fashion, sports, working with children.

**Watch Point:** May struggle in behind-the-scenes roles. Motivation may drop without recognition.
''',
    healthFocus:
        'Heart and back region. Stress affects the heart. Physical activity and creative expression provide healing. Depression risk when the need for praise is suppressed.',
    dreamPatterns: '''
Leo's dreams are usually themed around performance, stage, light, and recognition. Crowds, applause, stages are common.

**Symbolic Interpretation:** "Forgetting on stage" dreams may reflect performance anxiety, "lion" dreams may reflect the search for power, "coronation/becoming king" dreams may reflect the need for recognition.
''',
    commonDreamSymbols: [
      'Stage or performance',
      'Lion or cat',
      'Sun or light',
      'Gold or jewels',
      'Crowd or applause',
      'Crown or throne',
      'Orange or gold color',
    ],
    compatibleSigns: ['Aries', 'Sagittarius', 'Gemini', 'Libra'],
    challengingSigns: ['Taurus', 'Scorpio', 'Aquarius'],
    faqs: [
      {
        'question': 'Why does Leo want so much attention?',
        'answer':
            'Sun rulership gives Leo a "center" energy. Attention is validation and a sense of existence for Leo. This need can be balanced with healthy self-confidence.',
      },
      {
        'question': 'Is Leo arrogant?',
        'answer':
            'It may look that way from the outside, but many Leos have deep insecurity in their inner world. Arrogance is actually a defense mechanism. True self-confidence doesn\'t need arrogance.',
      },
      {
        'question': 'How does Leo take criticism?',
        'answer':
            'Usually with difficulty, especially in public settings. Private and gentle feedback works better. It may take time for them to understand that criticism isn\'t a personal attack.',
      },
      {
        'question': 'How do you make Leo happy?',
        'answer':
            'Appreciate them, compliment them, listen to them, make them feel special. Leo wants generous praise but senses insincerity. Tell them about things that genuinely impress you.',
      },
      {
        'question': 'Is Leo loyal?',
        'answer':
            'Very loyal — to their family, friends, loved ones. But loyalty must be mutual. If Leo feels undervalued, they may seek attention elsewhere.',
      },
      {
        'question': 'What is Leo\'s fear?',
        'answer':
            'Being unseen, being unimportant, being ordinary. Leo\'s deepest fear is going unnoticed.',
      },
    ],
    dailyAffirmation:
        'While sharing my light, I open space for others to shine too.',
    internalLinks: {
      '/compatibility': 'Signs compatible with Leo →',
      '/birth-chart': 'Sun\'s position in your chart →',
      '/horoscope/aries': 'Another fire sign: Aries →',
      '/horoscope/sagittarius': 'Another fire sign: Sagittarius →',
      '/transits': 'How is Sun transit affecting you? →',
      '/tarot': 'Tarot for Leo energy →',
    },
  );

  // Remaining signs will be added in the next section...
  // VIRGO, LIBRA, SCORPIO, SAGITTARIUS, CAPRICORN, AQUARIUS, PISCES

  static List<ZodiacSignContent> get allSigns => [
    aries,
    taurus,
    gemini,
    cancer,
    leo,
    // virgo, libra, scorpio, sagittarius, capricorn, aquarius, pisces
  ];
}
