/// TAROT CONTENT - ARCHETYPAL SYMBOLS FOR REFLECTION
///
/// Detailed archetypal content for 22 Major Arcana cards.
/// For each card: symbolic meaning, reflection themes, archetype, journaling prompts.
/// Content is designed for self-reflection, not fortune-telling or prediction.
library;

/// Content disclaimer for all tarot content
const String tarotContentDisclaimer = '''
Tarot cards are symbolic tools for self-reflection and personal exploration.
They do not predict future events or outcomes.

Card interpretations describe archetypal themes and psychological patterns,
not destined events. Use these themes as journaling prompts and reflection topics.

This is not fortune-telling. It is a tool for inner exploration.
''';

import '../providers/app_providers.dart';

class MajorArcanaContent {
  final int number;
  final String name;
  final String nameTr;
  final String archetype;
  final String element;
  final String planet;
  final String hebrewLetter;
  final String keywords;
  final String shortMeaning;
  final String deepMeaning;
  final String reversedMeaning;
  final String symbolism;
  final String spiritualLesson;
  final String loveReading;
  final String careerReading;
  final String advice;
  final String meditation;
  final String viralQuote;
  final String shadowAspect;

  const MajorArcanaContent({
    required this.number,
    required this.name,
    required this.nameTr,
    required this.archetype,
    required this.element,
    required this.planet,
    required this.hebrewLetter,
    required this.keywords,
    required this.shortMeaning,
    required this.deepMeaning,
    required this.reversedMeaning,
    required this.symbolism,
    required this.spiritualLesson,
    required this.loveReading,
    required this.careerReading,
    required this.advice,
    required this.meditation,
    required this.viralQuote,
    required this.shadowAspect,
  });

  /// Localized card name based on language
  String localizedName(AppLanguage language) {
    switch (language) {
      case AppLanguage.tr:
        return nameTr;
      case AppLanguage.en:
      case AppLanguage.de:
      case AppLanguage.fr:
      default:
        return name;
    }
  }
}

/// 22 Major Arcana Cards
final Map<int, MajorArcanaContent> majorArcanaContents = {
  0: const MajorArcanaContent(
    number: 0,
    name: 'The Fool',
    nameTr: 'Deli / Aptal',
    archetype: 'Innocent Traveler',
    element: 'Air',
    planet: 'Uranus',
    hebrewLetter: 'Aleph (א)',
    keywords:
        'New beginnings, innocence, spontaneity, leap of faith, potential',
    shortMeaning:
        'The courage to step into the unknown. Pure potential and unlimited possibilities.',
    deepMeaning: '''
The Fool is both the beginning and end of the Tarot journey - the number 0 represents infinity. They have not yet experienced anything, but carry the potential of all experiences.

In Kabbalah, the letter Aleph symbolizes breath and the beginning of spirit. The Fool is the soul's first descent into the material realm - not yet conditioned, pure consciousness.

They stand at the edge of a cliff but are not afraid - because they don't know they can fall. Is this ignorance, or the deepest wisdom? Perhaps they are both the same thing.

According to Jung, The Fool is the "puer aeternus" - the eternal child archetype. The spirit that never ages, never crystallizes, that can be reborn at any moment.
''',
    reversedMeaning: '''
The reversed Fool indicates recklessness, thoughtlessness, or fear of taking action.

Perhaps you've been waiting at the edge of the cliff for too long - afraid to jump. Or the opposite: you're jumping without thinking and having to deal with the consequences.

The question is: Are your fears holding you back, or is there real danger? Sometimes "foolishness" is actually wisdom - and sometimes it really is foolishness.
''',
    symbolism: '''
• White sun: Pure consciousness, enlightenment
• White rose: Innocence, purity
• Small bag: Minimal baggage carried from the past
• White dog: Instincts, loyal guide
• Cliff: The unknown, potential
• Colorful clothes: All experiences of life
• Mountains: Future challenges and achievements
''',
    spiritualLesson: '''
Spiritual lesson: Trust and surrender.

Life is a leap - every moment. Let go of the illusion of control and surrender to the flow. The universe will catch you - but first you must jump.

Saying "I don't know" takes courage. And sometimes it's the wisest answer.
''',
    loveReading: '''
Reflection theme: New beginnings in relationships.

This card may invite you to reflect on patterns you carry from past relationships.
Consider: How do you approach new connections? What would it mean to see each person as a fresh beginning?

Journaling prompt: "What past patterns might I want to release in my approach to relationships?"

*This is a reflection theme, not a prediction of romantic events.*
''',
    careerReading: '''
Reflection theme: Professional new beginnings and calculated risk.

This card may invite you to reflect on opportunities you haven't explored.
Consider: What "illogical" ideas have you dismissed? What would feel like a fresh start professionally?

Journaling prompt: "What professional leap have I been hesitant to take, and what holds me back?"

*This is a reflection theme, not a career prediction.*
''',
    advice: 'A reflection invitation: Consider what it would mean to trust the unknown. What would change if you approached today with beginner\'s mind?',
    meditation: '''
Close your eyes. Imagine you're standing at the edge of a cliff. You can't see below - only clouds.

Feel the fear. Then let it go. Take a step. You're not falling - you're flying.

Mantra: "I trust the unknown. Every step leads me to the right place."
''',
    viralQuote:
        '"Be a Fool: Jump, trust, fly. You have nothing to lose - because everything is already with you."',
    shadowAspect:
        'Irresponsibility, escape, disconnection from reality, childish behavior, not considering consequences.',
  ),

  1: const MajorArcanaContent(
    number: 1,
    name: 'The Magician',
    nameTr: 'Büyücü',
    archetype: 'Creative Will',
    element: 'Air',
    planet: 'Mercury',
    hebrewLetter: 'Beth (ב)',
    keywords: 'Manifestation, willpower, skill, concentration, action',
    shortMeaning:
        'The power to turn thoughts into reality. "As above, so below."',
    deepMeaning: '''
The Magician is the point where cosmic energy transforms into matter. With one hand pointing to the sky and the other to the earth - they are a channel.

The fundamental principle of Hermetic teaching is embodied here: "As above, so below." The Magician is the one who applies this principle.

On their table are symbols of the four elements: Wand (Fire/Will), Cup (Water/Emotion), Sword (Air/Thought), Pentacle (Earth/Matter). All tools are in their hands - now they just need to use them.

The infinity symbol (∞) above their head shows unlimited potential. They are a creator - and so are you.
''',
    reversedMeaning: '''
The reversed Magician indicates misuse of power or wasted potential.

Perhaps you're using your talents for manipulation. Perhaps you're unaware of your power and underestimating yourself.

You have the tools but you're not using them. Or you're using them for the wrong purposes. Question your intentions.
''',
    symbolism: '''
• Infinity symbol (∞): Unlimited potential
• White headband: Pure consciousness
• Red cloak: Passion and will
• White inner garment: Purity and wisdom
• Four elements: Tools of creation
• Roses and lilies: Balance of passion and purity
• Hands pointing up and down: "As above, so below"
''',
    spiritualLesson: '''
Spiritual lesson: You are a creator.

Don't underestimate the power of your thoughts. Every thought is a seed, every intention is magic. What are you creating?

Magic is not supernatural - it's knowing nature's hidden laws. And you can learn these laws.
''',
    loveReading: '''
Time to take an active role in love. Nothing happens by waiting - take the first step.

Your attraction energy is high. You can attract what you want - but first know clearly what you want.

Warning: Avoid manipulation. True magic is attraction, not force.
''',
    careerReading: '''
Your manifestation power in career is at its peak. Start projects, give presentations, take leadership.

Time to bring all your skills together. You are more talented than you think.

Excellent for entrepreneurship, sales, marketing, and creative projects.
''',
    advice: 'Know your power. Focus. Set intention. Then take action.',
    meditation: '''
Close your eyes. Imagine yourself at the center of the universe. Touch the sky with one hand, the earth with the other.

Cosmic energy enters through your crown, transforms in your heart, flows through your hands.

Mantra: "I am a channel. The power of the universe flows through me."
''',
    viralQuote:
        '"Be a Magician: Think, intend, create. You are the hand of the universe, the pen of the cosmos."',
    shadowAspect:
        'Manipulation, deception, power intoxication, misuse of talents.',
  ),

  2: const MajorArcanaContent(
    number: 2,
    name: 'The High Priestess',
    nameTr: 'Yüksek Rahibe',
    archetype: 'Intuitive Wisdom',
    element: 'Water',
    planet: 'Moon',
    hebrewLetter: 'Gimel (ג)',
    keywords: 'Intuition, mystery, subconscious, inner knowledge, silence',
    shortMeaning:
        'She who sees the invisible, knows the unknown. The voice of inner wisdom.',
    deepMeaning: '''
The High Priestess is the guardian of the veil between conscious and unconscious. The veil behind her covers the world of mysteries - but she can allow passage.

In Kabbalah, the letter Gimel means "camel" - crossing the desert, carrying the unknown. So is the Priestess: She is the carrier of hidden knowledge.

Isis, Persephone, Artemis - all ancient goddesses unite in her. She is the archetype of feminine wisdom: Receptive, intuitive, cyclical.

The Torah scroll in her hands represents unwritten knowledge. Some things cannot be told in words - they can only be known.
''',
    reversedMeaning: '''
The reversed Priestess indicates suppression of intuition or misuse of hidden knowledge.

Perhaps you're silencing your inner voice. Perhaps you're ignoring your intuition while trying to be "logical."

Or the opposite: You're using hidden knowledge to manipulate others. Secrets give power - but also responsibility.
''',
    symbolism: '''
• Blue cloak: Subconscious, intuition
• Moon crown: Feminine energy, cycles
• Black and white pillars (B and J): Duality, polarity
• Veil: The boundary between visible and invisible
• Water: Emotion, flow of intuition
• Pomegranates: Persephone's fruit, underworld wisdom
• Torah/scroll: Hidden knowledge
''',
    spiritualLesson: '''
Spiritual lesson: Listen in silence.

Answers are not outside - they're inside. Meditation, dreams, intuitions... All are voices of your inner wisdom.

Sometimes the most powerful action is inaction. Wait, observe, listen.
''',
    loveReading: '''
There's something hidden in love. Perhaps things the other side isn't saying, perhaps things you haven't noticed.

Trust your intuition. If you feel "something is wrong," you're probably right. But don't react immediately - first, listen.

Be mysterious. Don't explain everything immediately. A little secret increases attraction.
''',
    careerReading: '''
Research, analysis, and access to hidden information are prominent in career.

There are opportunities that haven't emerged yet. Observe the market, competitors, trends.

Psychology, research, archiving, consulting fields are suitable.
''',
    advice: 'Be silent and listen. The answer is coming - but in silence.',
    meditation: '''
Close your eyes. Imagine sitting in a temple under moonlight. There's a veil before you.

Feel the desire to look behind the veil. But don't rush. The veil will open in its own time.

Mantra: "I hear my inner wisdom. Answers come to me in silence."
''',
    viralQuote: '"Be the Priestess: Be silent, listen, know. The mystery is in you - you are the mystery."',
    shadowAspect:
        'Secrecy obsession, passivity, disconnection from reality, manipulative use of intuition.',
  ),

  3: const MajorArcanaContent(
    number: 3,
    name: 'The Empress',
    nameTr: 'İmparatoriçe',
    archetype: 'Goddess of Abundance',
    element: 'Earth',
    planet: 'Venus',
    hebrewLetter: 'Daleth (ד)',
    keywords: 'Abundance, creativity, fertility, nature, compassion, beauty',
    shortMeaning:
        'The fertile power of life. Source of abundance, beauty, and compassion.',
    deepMeaning: '''
The Empress is the Great Mother - the womb from which all life is born. She is the Tarot reflection of Gaia, Demeter, Ishtar.

In Kabbalah, Daleth means "door." The Empress is the doorway for spirit to pass into matter - the door of birth, of creation.

The Priestess's hidden wisdom is embodied in the Empress. Ideas are seeds - the Empress nurtures them, feeds them, transforms them into fruit.

Her throne is in the wheat field, her feet in water, a crown of stars on her head. She is the union of heaven and earth, spirit and matter.
''',
    reversedMeaning: '''
The reversed Empress indicates creative blockage, barrenness, or excessive dependency.

Perhaps you're neglecting to care for yourself. Perhaps you're giving so much to others that your own resources are drying up.

Or the opposite: Excessive possessiveness, suffocating love, "protective mother" syndrome.
''',
    symbolism: '''
• Wheat field: Abundance, harvest
• Starry crown: Cosmic mother
• Venus symbol (on heart): Love and beauty
• Red velvet: Passion and life force
• Waterfall/water: Flow of emotion, cleansing
• Trees: Growth, roots
• Cushion: Comfort, nourishment
''',
    spiritualLesson: '''
Spiritual lesson: Nourish yourself.

You must fill before giving. To spread love to others, you must first love yourself.

Nature is your teacher. Watch and learn how trees grow, how flowers bloom.
''',
    loveReading: '''
A period of abundance in love. Current relationship deepens, new relationship blossoms.

Perfect time for compassion and romance. Express your feelings, show your love.

Pregnancy, marriage, or a new stage in the relationship may occur.
''',
    careerReading: '''
Creative projects are growing in career. Seeds you planted are sprouting.

Art, design, beauty, health, work related to children are prominent.

Be patient - harvest time is approaching.
''',
    advice:
        'Nourish - yourself, others, your projects. Water with love, wait with patience.',
    meditation: '''
Close your eyes. Imagine sitting in an abundant garden. Flowers, fruits, birds are all around you.

Feel your connection to the earth. Roots descend from your feet deep into the ground.

Mantra: "I am a source of abundance. I multiply as I give."
''',
    viralQuote:
        '"Be the Empress: Nourish, grow, bloom. Your love is the power that transforms the world."',
    shadowAspect:
        'Overprotectiveness, creating dependency, self-neglect, emotional manipulation.',
  ),

  4: const MajorArcanaContent(
    number: 4,
    name: 'The Emperor',
    nameTr: 'İmparator',
    archetype: 'Authority Figure',
    element: 'Fire',
    planet: 'Mars / Aries',
    hebrewLetter: 'Heh (ה)',
    keywords: 'Authority, structure, order, leadership, protection, discipline',
    shortMeaning: 'The power representing order and law. Protective father, leader.',
    deepMeaning: '''
The Emperor is the power that establishes order within chaos. He gives form and structure to the Empress's creative energy.

In Kabbalah, the letter Heh means "window." The Emperor is the window through which cosmic order opens to the world - laws descend through him.

His stone throne symbolizes solid foundations. Ram heads represent Mars energy and courage. In his hand is the ankh - the key of life.

According to Jung, the Emperor is the "senex" archetype - the wise elder, guardian of social order. But beware: Excessive rigidity can turn into tyranny.
''',
    reversedMeaning: '''
The reversed Emperor indicates tyranny, excessive control, or lack of authority.

Perhaps you're imposing too strict rules - on yourself or others. Or perhaps the opposite: You're living a life devoid of structure and discipline.

There may be issues with the father figure. Inability to establish a healthy relationship with authority.
''',
    symbolism: '''
• Stone throne: Solidity, permanence
• Ram heads: Courage, leadership, Mars
• Red cloak: Power, passion
• Armor: Protection, defense
• Ankh: Key of life
• Mountains: Achievements, conquered peaks
• Orb: Worldly power
''',
    spiritualLesson: '''
Spiritual lesson: Power comes with responsibility.

Leadership is not power over others - it's taking responsibility for them.

You can build structure - but structure shouldn't become a prison. Rules should serve, not enslave.
''',
    loveReading: '''
Seeking stability and security in love. Long-term commitments, marriage, starting a family.

But beware: Being controlling suffocates the relationship. If you're looking for a partner, not a subject - be an equal.

There may be a relationship with a father figure or someone older.
''',
    careerReading: '''
Leadership and management are prominent in career. Setting rules, building structure, organization.

Good time for starting your own business, management position, or consulting.

Law, management, construction, finance fields are prominent.
''',
    advice: 'Build structure. Set the rules. But don\'t forget flexibility.',
    meditation: '''
Close your eyes. Imagine sitting on a stone throne at the top of a mountain. Your kingdom stretches below.

Feel the responsibility on your shoulders. But not as burden - as honor.

Mantra: "I stand on solid foundations. My power is for service."
''',
    viralQuote:
        '"Be the Emperor: Build, protect, govern. But remember - the crown is heavy, the bearer must be strong."',
    shadowAspect:
        'Tyranny, excessive control, rigidity, emotional distance, power intoxication.',
  ),

  5: const MajorArcanaContent(
    number: 5,
    name: 'The Hierophant',
    nameTr: 'Hierophant / Başrahip',
    archetype: 'Spiritual Teacher',
    element: 'Earth',
    planet: 'Taurus',
    hebrewLetter: 'Vav (ו)',
    keywords: 'Tradition, institutions, teaching, faith, morality, ritual',
    shortMeaning: 'Teacher of sacred knowledge. Tradition and spiritual guidance.',
    deepMeaning: '''
Hierophant means "one who shows the sacred." He is the bridge that makes the invisible visible - carrying spiritual knowledge into everyday life.

In Kabbalah, the letter Vav means "nail/connection." The Hierophant is the nail that connects heaven and earth.

The High Priestess's hidden knowledge is transmitted to society through the Hierophant. He is not individual but collective wisdom.

But beware: Tradition can be both guide and prison. The Hierophant's lesson is to distinguish wisdom from dogma.
''',
    reversedMeaning: '''
The reversed Hierophant indicates blind adherence to traditions or complete rejection of them.

Perhaps you're accepting rules without questioning. Perhaps you're rejecting every authority and seeking your own path.

Spiritual seeking can turn into a personal journey. Time to learn from within, not from outside.
''',
    symbolism: '''
• Triple crown: Three realms (physical, mental, spiritual)
• Two keys: Keys to conscious and subconscious
• Crossed scepter: Union of worldly and spiritual authority
• Two pillars: Duality, balance
• Two students: Transmission of knowledge
• Red and white garments: Passion and purity
• Hand gesture: Sacred teaching (mudra)
''',
    spiritualLesson: '''
Spiritual lesson: Wisdom multiplies by being passed on.

Be a teacher - but first be a student. Learn traditions, then add your own understanding.

Not dogma, but living wisdom. Not rules, but principles.
''',
    loveReading: '''
Traditional path in love. Formal relationship, engagement, marriage, family approval.

If you're not traditional, this card can be a challenge. Will you follow society's pressure or your own heart?

There may be a relationship with a teacher or mentor figure.
''',
    careerReading: '''
Institutional structures, education, and traditional paths are prominent in career.

Certificates, diplomas, formal education are valuable. Find a mentor or be one.

Education, religion, law, large institutions are suitable fields.
''',
    advice:
        'Learn tradition, but don\'t be its slave. Find a teacher or teach yourself.',
    meditation: '''
Close your eyes. Imagine kneeling before a sage in an ancient temple.

The sage whispers something to you. Listen. This is a special message for you.

Mantra: "I receive wisdom, I share wisdom. I am a bridge."
''',
    viralQuote:
        '"Be the Hierophant: Learn, teach, transmit. Wisdom multiplies as it\'s shared."',
    shadowAspect:
        'Dogmatism, blind obedience, fear of authority, excessive conservatism.',
  ),

  6: const MajorArcanaContent(
    number: 6,
    name: 'The Lovers',
    nameTr: 'Aşıklar',
    archetype: 'Union',
    element: 'Air',
    planet: 'Gemini',
    hebrewLetter: 'Zayin (ז)',
    keywords: 'Love, choice, union, harmony, values, relationships',
    shortMeaning: 'Sacred union. The heart\'s choice, alignment of values.',
    deepMeaning: '''
The Lovers card is not just romantic love - it's the archetype of all unions. The dance of opposites, the merging of polarities.

In Kabbalah, Zayin means "sword." The Lovers symbolizes the ability to make choices with the sword of discernment.

At the bottom of the card are Eve and Adam, above is the angel Raphael. This shows the connection of human love with divine love.

According to Jung, this is the union of anima/animus - the marriage of inner feminine and masculine energies. True love starts with yourself.
''',
    reversedMeaning: '''
The reversed Lovers indicates disharmony, value conflicts, or a difficult choice.

Perhaps your heart pulls one way, your mind another. Perhaps you're avoiding making a choice.

There may be problems in relationships, infidelity, or lack of trust. But the real question is: Are you true to yourself?
''',
    symbolism: '''
• Angel Raphael: Divine guidance, healing
• Eve and Adam: Feminine and masculine, subconscious and conscious
• Tree of Knowledge (with snake): Temptation, experience
• Tree of Life (with flames): Passion, life force
• Sun: Consciousness, enlightenment
• Mountain: Peak to be achieved
• Nakedness: Innocence, vulnerability
''',
    spiritualLesson: '''
Spiritual lesson: Choice is freedom.

Every choice opens one door, closes another. Choose with love, not fear.

True union is not two halves making a whole - it's two wholes dancing together.
''',
    loveReading: '''
An important period in love. A new relationship, a deep connection, or a new level in your current relationship.

Trust your heart's choice. But look not just at passion - also at the alignment of your values.

Soulmate energy. But a soulmate is not perfect - it's the person who helps you grow.
''',
    careerReading: '''
An important choice in career. Does it align with your values?

Good time for partnerships, collaborations, mergers.

Where is your heart pulling you? Sometimes career choices that seem "illogical" are the right ones.
''',
    advice:
        'Choose with your heart. But listen to your mind too. The real choice is the harmony of both.',
    meditation: '''
Close your eyes. Imagine a mirror in front of you. In the mirror is your "other half" - your opposite pole.

Approach them. When you touch, the two energies merge. Neither disappears - they transform.

Mantra: "I unite with myself. All parts within me are in harmony."
''',
    viralQuote:
        '"Be in love: With yourself, with life, with the universe. True love begins inside."',
    shadowAspect:
        'Dependency, wrong choices, disconnection from values, indecisiveness.',
  ),

  7: const MajorArcanaContent(
    number: 7,
    name: 'The Chariot',
    nameTr: 'Savaş Arabası',
    archetype: 'Victory Warrior',
    element: 'Water',
    planet: 'Cancer',
    hebrewLetter: 'Cheth (ח)',
    keywords: 'Victory, willpower, determination, control, progress, conquest',
    shortMeaning: 'Will that directs opposing forces. Moving forward by overcoming obstacles.',
    deepMeaning: '''
The Chariot is the symbol of inner and outer victory. The black and white sphinxes represent opposing forces - and the warrior directs them.

In Kabbalah, Cheth means "fence/boundary." The Chariot is transcending boundaries through discipline and will.

This card is meditation in motion. The warrior holds no reins - they control the sphinxes with the mind. True control is not forcing - it's directing.

According to Jung, this is the ego's mastery over unconscious forces. But beware: Not to suppress, but to integrate.
''',
    reversedMeaning: '''
The reversed Chariot indicates losing control or moving in the wrong direction.

Perhaps you're pushing too hard, fighting too much - and burning out. Perhaps you've handed control to others.

You might be running from obstacles instead of fighting them. Or you're fighting the wrong battles.
''',
    symbolism: '''
• Black and white sphinxes: Opposing forces, polarity
• Starry canopy: Cosmic protection
• Crescents: Moon energy, cycles
• Armor: Protection, preparation
• Wing symbols: Spiritual ascension
• City walls (behind): Conquered fortresses
• Reinless control: Mental power
''',
    spiritualLesson: '''
Spiritual lesson: Victory is not conquering - it's mastering.

Your enemy is not outside - it's inside. Fear, doubt, laziness... Fight these.

But "fighting" is not forcing. Move with the flow, but directing.
''',
    loveReading: '''
Time for progress and conquest in love. Take action for the relationship you want.

But beware: Love is not a battlefield. Focus on uniting, not conquering.

Long-distance relationships, meetings during travel may occur.
''',
    careerReading: '''
Victory is near in career. Projects are completing, goals are being achieved.

Get ahead in competition. But play fair - cheating is short-term victory, long-term loss.

Sales, leadership, entrepreneurship, sports fields are prominent.
''',
    advice:
        'Focus on your path. When obstacles arise, consider how to manage them rather than letting them manage you.',
    meditation: '''
Close your eyes. You're standing in a war chariot. Before you are two forces - one pulling you left, one right.

Let go of the reins. Direct with your mind. Both are your power - move forward together.

Mantra: "I manage opposites. My will carries me to my goal."
''',
    viralQuote:
        '"Be a warrior: Don\'t fight challenges, fight yourself. True victory is inner peace."',
    shadowAspect:
        'Aggression, excessive control, crushing others, emotionless progress.',
  ),

  8: const MajorArcanaContent(
    number: 8,
    name: 'Strength',
    nameTr: 'Güç',
    archetype: 'Inner Strength',
    element: 'Fire',
    planet: 'Leo',
    hebrewLetter: 'Teth (ט)',
    keywords: 'Inner strength, courage, compassion, patience, soft power',
    shortMeaning: 'Compassion that tames the lion. True strength is inner strength.',
    deepMeaning: '''
The Strength card is the opposite of The Chariot. There was control by force - here is transformation through compassion.

In Kabbalah, Teth means "serpent" - kundalini energy, life force. The woman gently directs this wild energy.

The infinity symbol above her head shows connection to The Magician. But The Magician uses external power - Strength uses inner power.

This is the archetype of feminine power: Not to break, but to transform. Not to suppress, but to integrate.
''',
    reversedMeaning: '''
Reversed Strength indicates lack of self-confidence or misuse of power.

Perhaps you're afraid of the "lion" inside you - suppressing your emotions, your passions. Perhaps you've released the lion and lost control.

You might be struggling to show yourself compassion. Or you're too harsh with others.
''',
    symbolism: '''
• Infinity symbol: Unlimited inner strength
• Lion: Inner wild nature, ego, passion
• White dress: Purity, innocence
• Flower wreath: Harmony with nature
• Mountains: Challenges to overcome
• Gentle touch: Transformation through compassion
• Yellow (lion's color): Sun energy
''',
    spiritualLesson: '''
Spiritual lesson: The greatest strength is conquering yourself.

Anger, fear, jealousy - these are your "lions." Don't kill them, tame them. They are also your power.

Compassion is not weakness - it is the highest strength.
''',
    loveReading: '''
Patience and understanding are needed in love. Approach gently instead of forcing.

Accept your partner's "wild" sides - and your own wild sides too.

Passionate but controlled love. Managing the fire, not extinguishing it.
''',
    careerReading: '''
Use soft power in career. Persuade instead of forcing, inspire instead of influencing.

Handle difficult situations with patience. Don't react - respond.

Psychology, therapy, working with animals, leadership coaching fields are suitable.
''',
    advice: 'Don\'t show off strength. True strength is not shown - it\'s felt.',
    meditation: '''
Close your eyes. A lion sits before you. Its eyes look at you - challenging, but also waiting.

Approach without fear. Place your hand gently on its head. The lion closes its eyes, calms down.

Mantra: "I am at peace with the wild force within me. My compassion is my strength."
''',
    viralQuote:
        '"Be strong: Don\'t break, transform. True strength is taming the lion with love."',
    shadowAspect:
        'Suppressed anger, passive-aggressive behavior, excessive control, feeling powerless.',
  ),

  9: const MajorArcanaContent(
    number: 9,
    name: 'The Hermit',
    nameTr: 'Ermiş',
    archetype: 'Wise Seeker',
    element: 'Earth',
    planet: 'Virgo',
    hebrewLetter: 'Yod (י)',
    keywords: 'Introspection, solitude, seeking, wisdom, guidance, retreat',
    shortMeaning:
        'The sage holding light in darkness. Inner seeking and solitary journey.',
    deepMeaning: '''
The Hermit is the sage who discovers the inner world by withdrawing from the outer world. The lantern in his hand symbolizes the truth he seeks - and this truth is within.

In Kabbalah, Yod is the smallest and most sacred letter - the divine spark. The Hermit is the one who seeks and carries this spark.

He stands alone at the mountaintop. The journey has been difficult - but the perspective at the summit is worth it.

This card is the embodiment of the "know thyself" principle. Seek not others' answers, but your own truth.
''',
    reversedMeaning: '''
The reversed Hermit indicates excessive isolation or escape from inner seeking.

Perhaps loneliness makes you sick - but you can't connect with people either. Perhaps you're "seeking" by running from everything.

Closing off instead of turning inward. Disconnecting from the world instead of seeking wisdom.
''',
    symbolism: '''
• Lantern: Inner light, wisdom
• Star (in lantern): Light of truth
• Gray cloak: Humility, invisibility
• Staff: Support of wisdom
• Mountaintop: Spiritual ascension
• Snow: Purity, clarity
• Solitude: Inner journey
''',
    spiritualLesson: '''
Spiritual lesson: Answers are within.

Stop asking others. Stop searching in books. Sit in silence and listen.

Solitude is not punishment - it's a gift. Being able to be alone with yourself is the greatest freedom.
''',
    loveReading: '''
Time for a break in love. Being alone or questioning the relationship may be needed.

This is not disconnection - it's deepening. How can you unite with another without knowing yourself?

There may be an older, wise mentor/partner.
''',
    careerReading: '''
Time for research, specialization, and deepening in career.

Step away from the crowd. Focus on your niche area. Don't do what everyone else does.

Consulting, research, writing, spiritual professions are suitable.
''',
    advice:
        'Withdraw. Listen. Seek your light - and when you find it, show it to others too.',
    meditation: '''
Close your eyes. You're walking on a dark mountain path. The lantern in your hand is the only light source.

With each step you can only see a few meters ahead. But that's enough. Take one more step.

Mantra: "Even in darkness I carry my light. My path is shown to me."
''',
    viralQuote:
        '"Be the Hermit: Withdraw, be silent, go deep. Light is not in others - it\'s within."',
    shadowAspect:
        'Excessive isolation, alienation, superiority complex, social disconnection.',
  ),

  10: const MajorArcanaContent(
    number: 10,
    name: 'Wheel of Fortune',
    nameTr: 'Kader Çarkı',
    archetype: 'Cosmic Cycle',
    element: 'Fire',
    planet: 'Jupiter',
    hebrewLetter: 'Kaph (כ)',
    keywords: 'Fate, cycles, change, luck, karma, turning point',
    shortMeaning:
        'The only constant is change. The turn of fate and cosmic cycles.',
    deepMeaning: '''
The Wheel of Fortune represents the cyclical nature of the universe. Everything turns - good days, bad days, seasons, lives.

In Kabbalah, Kaph means "palm of hand" - receptivity, accepting fate. But the wheel is not just random - it turns according to karmic laws.

Around the wheel, four fixed figures (bull, lion, eagle, angel) represent four elements and four evangelists. They don't change - what changes are those on the wheel.

The sphinx (on top) symbolizes wisdom, Anubis (on left) the fall, the serpent (on right) the rise. Which one are you?
''',
    reversedMeaning: '''
The reversed Wheel indicates resistance to change or bad luck.

Perhaps you're at the bottom of the cycle and the way up seems hopeless. Perhaps you're resisting change, clinging to the past.

It may be time to pay karmic debts. Consequences of past actions.
''',
    symbolism: '''
• Wheel: Cycles, change
• TARO/ROTA/ORAT: Tarot, torah, rota (path)
• Sphinx: Wisdom, the unchanging
• Anubis: Fall, dark period
• Serpent: Rise, transformation
• Four figures: Four elements, stability
• Clouds: Mysterious nature
''',
    spiritualLesson: '''
Spiritual lesson: Resisting change is suffering.

The wheel will turn - whether you want it or not. Move with the flow.

But don't be passive either. Karma is the result of your actions. Plant good seeds.
''',
    loveReading: '''
Unexpected changes in love. New encounters, surprise developments, fate moments.

"Right place at right time" energy. But remember: Luck finds those who are prepared.

There may be karmic connections from past relationships.
''',
    careerReading: '''
The cycle is changing in career. Lucky opportunities or unexpected turns.

Good time to take risks - but calculated risk. The wheel is turning in your favor.

Gambling, finance, investment, fields requiring opportunism.
''',
    advice: 'Be ready for change. Stay in the center while the wheel turns - there is peace there.',
    meditation: '''
Close your eyes. You're standing in the center of a massive wheel. The wheel turns - but you are fixed.

Around you people rise, fall. You watch - without participating, but fully aware.

Mantra: "I am the unchanging within change. I find peace in the center."
''',
    viralQuote:
        '"The wheel turns: Today\'s peak may be tomorrow\'s valley. Dance with change."',
    shadowAspect: 'Loss of control, fatalism, passivity, cycle of bad luck.',
  ),

  11: const MajorArcanaContent(
    number: 11,
    name: 'Justice',
    nameTr: 'Adalet',
    archetype: 'Cosmic Judge',
    element: 'Air',
    planet: 'Libra',
    hebrewLetter: 'Lamed (ל)',
    keywords: 'Justice, balance, truth, law, karma, decision',
    shortMeaning:
        'The universal law of balance. Facing the consequences of our actions.',
    deepMeaning: '''
Justice is the guardian of cosmic balance. The scales in her hand show that all actions are weighed - nothing is lost.

In Kabbalah, Lamed means "teacher." Justice teaches us the law of karma: Every action creates a reaction.

Her sword is sharp - it separates truth from illusion, right from wrong. Her eyes are not blindfolded (unlike in some versions) - she is not impartial, she sees the truth.

This card promises "to each what they deserve." Is this a threat or consolation? It depends on your actions.
''',
    reversedMeaning: '''
Reversed Justice indicates injustice, imbalance, or refusing responsibility.

Perhaps you feel you've been wronged. Perhaps you're not accepting the consequences of what you've done.

There may be legal problems, legal disputes. Or time to face the question "what have I done?" within yourself.
''',
    symbolism: '''
• Scales: Balance, weighing, evaluation
• Sword: Sharp decision, discrimination
• Crown: Authority, sovereignty
• Red cloak: Action, passion
• Two pillars: Duality, balance
• Purple curtain: Mystery, inner knowledge
• Square throne: Solidity, order
''',
    spiritualLesson: '''
Spiritual lesson: Every action creates an energy.

Karma is not a complex punishment system - it's a simple law of physics. You reap what you sow.

Be fair - to others and to yourself. Judging yourself and forgiving yourself are both parts of justice.
''',
    loveReading: '''
Balance and reciprocity are needed in love. One-sided sacrifice is not sustainable.

Is there justice in the relationship? Are you both giving and receiving equally?

Karmic lessons from past relationships may be completing.
''',
    careerReading: '''
Fair results in career. You're getting what your work deserves - good or bad.

Be careful with legal matters, contracts, agreements. Put everything in writing.

Law, judiciary, arbitration, auditing fields are prominent.
''',
    advice: 'Be fair. Stand behind your decisions. Accept the consequences.',
    meditation: '''
Close your eyes. You're standing before scales. In one pan are your actions, in the other are the consequences.

Is the scale balanced? If not, which actions are lacking or excessive?

Mantra: "I take responsibility for my actions. Justice begins with me."
''',
    viralQuote: '"Justice balances with time - you reap what you sow."',
    shadowAspect:
        'Harsh judgment, revenge, irresponsibility, blame, self-deception.',
  ),

  12: const MajorArcanaContent(
    number: 12,
    name: 'The Hanged Man',
    nameTr: 'Asılan Adam',
    archetype: 'Sacred Sacrifice',
    element: 'Water',
    planet: 'Neptune',
    hebrewLetter: 'Mem (מ)',
    keywords:
        'Surrender, waiting, sacrifice, perspective change, enlightenment',
    shortMeaning:
        'The world looks different when viewed upside down. Surrender and new perspective.',
    deepMeaning: '''
The Hanged Man is the card of paradox. Bound but free, fallen but risen, suffering but peaceful.

In Kabbalah, Mem means "water." The Hanged Man is surrendering to the flow of water - letting go instead of resisting.

Odin hung himself on the Yggdrasil tree for wisdom. Jesus was hung on the cross for humanity. This archetype represents enlightenment through sacrifice.

The halo of light around his head shows that this "punishment" is actually a blessing. Pain is transformative.
''',
    reversedMeaning: '''
The reversed Hanged Man indicates unnecessary sacrifice or resistance to change.

Perhaps you're sanctifying suffering - being a "martyr" pleases you. Perhaps you're avoiding making the necessary sacrifice.

You're stuck - but most of your bonds are your own hands. Letting go is up to you.
''',
    symbolism: '''
• Upside-down position: Perspective change
• T-shaped tree: Tau cross, sacrifice
• Halo of light: Enlightenment, holiness
• Blue clothes: Wisdom, peace
• Red pants: Connection to material world
• Bound foot: Voluntary surrender
• Free hands: Inner freedom
''',
    spiritualLesson: '''
Spiritual lesson: Sometimes letting go is stronger than fighting.

Let go of the need for control. Trust the universe's plan. Don't rush.

Sacrifice is not losing - it's transforming. Letting go of something makes room for something else.
''',
    loveReading: '''
A waiting period in love. Wait instead of forcing, let it flow.

Perhaps you need to give up something for the relationship. Or you should see what the relationship is teaching you.

There may be a relationship "on hold" - it will take time to clarify.
''',
    careerReading: '''
Time for a break in career. Wait until the situation clarifies.

Forcing isn't working. Step back, gain perspective, then act.

Sabbatical, thinking about career change, research period.
''',
    advice:
        'Surrender. Wait. Change your perspective. Sometimes doing nothing is the right action.',
    meditation: '''
Close your eyes. Imagine yourself hanging upside down. Uncomfortable at first, then... peace.

The world looks upside down. But maybe when the world is already upside down, you're looking the right way.

Mantra: "I surrender. I trust the universe's timing."
''',
    viralQuote:
        '"Hang: Surrender, let go, wait. Sometimes the greatest power is doing nothing."',
    shadowAspect:
        'Victim mentality, passivity, martyr complex, not taking necessary action.',
  ),

  13: const MajorArcanaContent(
    number: 13,
    name: 'Death',
    nameTr: 'Ölüm',
    archetype: 'Transformer',
    element: 'Water',
    planet: 'Scorpio',
    hebrewLetter: 'Nun (נ)',
    keywords: 'Transformation, ending, new beginning, letting go, metamorphosis',
    shortMeaning: 'Every ending is a beginning. Death is the door to rebirth.',
    deepMeaning: '''
The Death card is Tarot's most misunderstood card. It represents not physical death, but ego death - transformation.

In Kabbalah, Nun means "fish" - living in the depths, unseen. So is Death: Invisible but everywhere.

The skeleton is armored, on a white horse. This is not a disaster, but a natural process. The sun is rising (in the background) - not an end, but a transition.

This is the most transformative card in all the Major Arcana. A power to be honored, not feared.
''',
    reversedMeaning: '''
Reversed Death indicates resistance to change or incomplete transformation.

Something that should die is still alive - perhaps an old habit, perhaps a dead relationship, perhaps an outdated belief.

You're afraid to let go. But holding on is also a kind of death - being buried alive.
''',
    symbolism: '''
• Skeleton: What is permanent, not temporary
• Armor: Inevitability, protection
• White horse: Purity, power
• Banner (white rose): Rebirth, purity
• Sun (on horizon): New beginning
• River: Flow, transition
• Falling figures: Old selves
''',
    spiritualLesson: '''
Spiritual lesson: Death is part of life.

Every moment something dies, something is born. When you exhale, a part of you dies. When you inhale, you renew.

Letting go requires mourning. Mourning is the continuation of love.
''',
    loveReading: '''
Time for transformation in love. A relationship is ending or completely transforming.

This ending may be painful. But keeping a dead relationship alive kills both.

New love can only come when you truly let go of the old.
''',
    careerReading: '''
Big change in career. One era is closing, a new one is beginning.

Leaving a job, career change, company transformation may occur.

Don't be afraid. When one door closes, other doors open.
''',
    advice: 'Let go. Don\'t hold on. Every ending carries the seed of a beginning.',
    meditation: '''
Close your eyes. Imagine your old self before you - your past, old beliefs, worn-out patterns.

Thank it. Embrace it. Then let it go. Watch how it transforms - not disappearing, just changing form.

Mantra: "I don't fear death. Every ending is a new beginning."
''',
    viralQuote:
        '"Die and be reborn: Every day, every moment. Transformation is the breath of the universe."',
    shadowAspect: 'Fear of change, obsessive clinging, destructiveness, nihilism.',
  ),

  14: const MajorArcanaContent(
    number: 14,
    name: 'Temperance',
    nameTr: 'Denge / Ölçülülük',
    archetype: 'Alchemist',
    element: 'Fire',
    planet: 'Sagittarius',
    hebrewLetter: 'Samekh (ס)',
    keywords: 'Balance, harmony, moderation, integration, patience, healing',
    shortMeaning: 'Harmony of opposites. The art of alchemy - turning lead into gold.',
    deepMeaning: '''
Temperance is the healing card that comes after Death. Transformation has occurred - now a new balance must be found.

In Kabbalah, Samekh means "support." Balance is the invisible structure that keeps us standing.

The angel pours water between two cups - conscious and subconscious, material and spiritual unite. This is the alchemical process.

One foot in water, one on land. A bridge between two worlds. Neither entirely introverted nor entirely extroverted.
''',
    reversedMeaning: '''
Reversed Temperance indicates excess, imbalance, or disharmony.

Perhaps one area of life has overwhelmed the others. Perhaps you can't find the "middle way."

Going back and forth between extremes. Too much one day, nothing the next.
''',
    symbolism: '''
• Angel: Protector, healer
• Two cups: Conscious/subconscious, matter/spirit
• Flowing water: Energy flow, alchemy
• One foot on land, one in water: Between two worlds
• Sun (on horizon): Goal, enlightenment
• Iris flowers: Rainbow goddess, bridge
• Crown: Higher consciousness
''',
    spiritualLesson: '''
Spiritual lesson: The middle way is the hardest path.

Extremes are easy - balance is hard. Living "not too little, not too much" requires mastery.

Patience is the key to alchemy. Lead doesn't turn to gold in one day.
''',
    loveReading: '''
Time for balance and harmony in love. Find the middle way.

Not too dependent, not too distant. Not too passionate, not too cold.

Healing process in relationship. Old wounds are healing, new balance is being established.
''',
    careerReading: '''
Work-life balance is critical in career. Both overworking and laziness are harmful.

Time to integrate different skills, projects, teams.

Health, therapy, consulting, mediation fields are suitable.
''',
    advice:
        'Establish balance. Be patient. Uniting opposites often creates something greater than either alone.',
    meditation: '''
Close your eyes. You have two cups in your hands - fire in one, water in the other.

Slowly pour from one to the other. Fire and water merge - steam rises.

Mantra: "I unite opposites. I find strength in balance."
''',
    viralQuote: '"Find balance: Not too little, not too much. True mastery is standing in the middle."',
    shadowAspect:
        'Extremes, addiction, avoidance, artificial harmony, self-deception.',
  ),

  15: const MajorArcanaContent(
    number: 15,
    name: 'The Devil',
    nameTr: 'Şeytan',
    archetype: 'Shadow',
    element: 'Earth',
    planet: 'Capricorn',
    hebrewLetter: 'Ayin (ע)',
    keywords: 'Addiction, passion, shadow, materialism, restriction, illusion',
    shortMeaning: 'The chains are your own creation. Confronting the shadow, liberation.',
    deepMeaning: '''
The Devil is one of Tarot's most misunderstood cards. It's not an external force - it's the reflection of the inner shadow.

In Kabbalah, Ayin means "eye." The Devil forces us to see what we don't want to see.

The Baphomet figure is the dark face of "as above, so below." Two naked figures are chained - but notice: The chains are loose, they could leave if they wanted.

Jung's "shadow" concept is embodied here. Everything we suppress, reject, refuse to accept.
''',
    reversedMeaning: '''
The reversed Devil indicates liberation from the shadow or denial of the shadow.

Perhaps you're breaking free from addiction, toxic relationship, harmful pattern. Perhaps you're still ignoring your shadow.

The liberation process has begun - but be careful, returning to old patterns is easy.
''',
    symbolism: '''
• Baphomet: Duality, matter and spirit
• Chained figures: Voluntary bondage
• Loose chains: Exit is possible
• Torch (pointing down): Destructive passion
• Horns and tails: Animal nature
• Black background: Subconscious, darkness
• Inverted pentagram: Materialism, fallen spirit
''',
    spiritualLesson: '''
Spiritual lesson: Accept your shadow.

Everything you reject, suppress, becomes stronger. Don't fight the shadow - know it, understand it, integrate it.

Addictions are for silencing the shadow's voice. But the voice doesn't quiet - it just screams louder.
''',
    loveReading: '''
Addiction, control, or toxic patterns are at play in love.

Is the relationship liberating you or chaining you? Be honest.

Passionate but destructive love. You know it's "bad," but you can't let go.
''',
    careerReading: '''
Material dependency or value conflict in career.

Are you selling your soul for money? Have you crossed your ethical line?

Corporate traps, golden cages. Giving up freedom for security.
''',
    advice:
        'Look at your chains. Who put them on? The answer is in the mirror. Exit is possible - do you want it?',
    meditation: '''
Close your eyes. You're in a dark room. Your shadow stands before you - bigger than you, frightening.

Walk toward it. Say "I see you." Say "You are also part of me."

The shadow shrinks. It no longer frightens - it just looks at you.

Mantra: "I accept my shadow. It's part of me - but it's not me."
''',
    viralQuote:
        '"Look at the Devil\'s face - you\'ll see your own eyes. You put on the chains, you take them off."',
    shadowAspect:
        'Addiction, control, manipulation, materialism, self-deception.',
  ),

  16: const MajorArcanaContent(
    number: 16,
    name: 'The Tower',
    nameTr: 'Kule',
    archetype: 'Destructive Enlightenment',
    element: 'Fire',
    planet: 'Mars',
    hebrewLetter: 'Peh (פ)',
    keywords: 'Sudden change, destruction, revelation, crisis, collapse, liberation',
    shortMeaning:
        'When lightning strikes, truth is revealed. Enlightenment born from destruction.',
    deepMeaning: '''
The Tower is the card of inevitable destruction. Structures built on false foundations must fall - so truth can emerge.

In Kabbalah, Peh means "mouth." The Tower is the painful truth the universe tells you - even if you don't want to hear it.

Lightning is divine intervention. The crown falls - ego is destroyed. People fall - but perhaps they're learning to fly.

This card frightens - but the most liberating experiences are often the most painful ones.
''',
    reversedMeaning: '''
The reversed Tower indicates avoided destruction or inner transformation.

Perhaps you narrowly escaped disaster. Perhaps the destruction is internal - not visible from outside but everything has changed inside.

Resistance to change, postponing the inevitable. But postponed destruction comes bigger.
''',
    symbolism: '''
• Tower: Ego, false structures
• Lightning: Divine intervention, sudden truth
• Falling crown: Ego destruction
• Falling figures: Old self
• Flames: Fire of transformation
• Dark night: Dark night of the soul
• 22 flames: 22 Major Arcana, complete cycle
''',
    spiritualLesson: '''
Spiritual lesson: Sometimes things must be destroyed.

False security, false identity, false relationships... Destruction hurts, but living with falseness hurts more.

Turn crisis into opportunity. What can be salvaged from the wreckage?
''',
    loveReading: '''
Sudden ending, shocking revelation, or the relationship being shaken to its foundations in love.

Infidelity, lies, or long-ignored problems exploding.

Painful - but knowing the truth is better than living with lies.
''',
    careerReading: '''
Sudden change in career. Being fired, company bankruptcy, sector change.

Your plans are collapsing - but perhaps they were the wrong plans.

Stay calm in crisis. Don't make panic decisions.
''',
    advice:
        'Don\'t resist destruction. Let it collapse. You\'ll build something new from the wreckage.',
    meditation: '''
Close your eyes. You're standing on top of a great tower. Lightning flashes, the tower shakes.

Don't be afraid. Jump. You're learning to fly as you fall.

You're not falling toward the ground, but toward the sky.

Mantra: "I don't fear destruction. Every collapse is the beginning of a new rise."
''',
    viralQuote:
        '"Let it fall: False foundations, false lives, false selves. What is real cannot be destroyed."',
    shadowAspect:
        'Destructiveness, sudden anger outbursts, creating chaos, self-sabotage.',
  ),

  17: const MajorArcanaContent(
    number: 17,
    name: 'The Star',
    nameTr: 'Yıldız',
    archetype: 'Hope',
    element: 'Air',
    planet: 'Aquarius',
    hebrewLetter: 'Tzaddi (צ)',
    keywords: 'Hope, inspiration, peace, healing, spirituality, abundance',
    shortMeaning: 'The calm after the storm. Universal hope and healing.',
    deepMeaning: '''
The Star is the healing and hope that comes after the Tower's destruction. After the darkest night, stars become visible.

In Kabbalah, Tzaddi means "fish hook" - drawing wisdom from the depths. The Star is the source of cosmic wisdom.

The naked woman pours water from two jugs - nourishing conscious and subconscious. The large star (Sirius?) and seven small stars symbolize cosmic guidance.

This card is not the promise "everything will be fine" - it's the awareness that "everything is already perfect as it is."
''',
    reversedMeaning: '''
The reversed Star indicates loss of hope, crisis of faith, or disconnection from reality.

Perhaps you feel lost in the darkness - you can't see the stars. Perhaps excessive idealism has disconnected you from reality.

The healing process may have stalled. Patience is needed.
''',
    symbolism: '''
• Large star: Cosmic guidance
• Seven small stars: Chakras, planets
• Naked woman: Vulnerability, purity
• Two jugs: Conscious/subconscious
• Flowing water: Healing, abundance
• Lake: Subconscious, intuition
• Bird (in tree): Spirit, freedom
''',
    spiritualLesson: '''
Spiritual lesson: Even in the darkest night, stars shine.

Hope doesn't depend on conditions. Even if the outer world is dark, the inner light doesn't extinguish.

Healing takes time. Be patient - but don't lose hope.
''',
    loveReading: '''
Healing and renewal in love. Past wounds are finding healing.

New hope, new inspiration. Idealistic but grounded love.

Soulmate energy - but first find your own light.
''',
    careerReading: '''
New hopes, inspiring projects, creative ideas in career.

Recovery after difficult period. Good time for new beginnings.

Art, music, charitable work, environmental protection fields are prominent.
''',
    advice:
        'Keep your hope. Share your light. Be patient for healing - but believe healing is coming.',
    meditation: '''
Close your eyes. On a starry night, you're sitting by a clear lake.

Look at the sky. The stars are speaking to you - each one is a message.

Mantra: "I receive guidance from the universe. Light is always with me."
''',
    viralQuote:
        '"Be a star: Shine in darkness, spread hope, give healing. Even in the darkest night, there is light."',
    shadowAspect: 'Excessive idealism, disconnection from reality, passive hope, fantasy.',
  ),

  18: const MajorArcanaContent(
    number: 18,
    name: 'The Moon',
    nameTr: 'Ay',
    archetype: 'Depths of the Subconscious',
    element: 'Water',
    planet: 'Pisces',
    hebrewLetter: 'Qoph (ק)',
    keywords: 'Illusion, subconscious, fears, shadows, intuition, dreams',
    shortMeaning:
        'Everything looks different in moonlight. The dark waters of the subconscious.',
    deepMeaning: '''
The Moon represents the dark and mysterious world of the subconscious. The Sun shows truth - the Moon shows truth's shadows.

In Kabbalah, Qoph means "back of head" - seeing the unseen. The Moon is the card of inner vision.

The path between two towers is the passage from conscious to subconscious. Dog and wolf symbolize our domestic and wild nature. The crayfish is primitive forces rising from the depths to the surface.

This card gives not clarity - but uncertainty. And sometimes uncertainty liberates from the patterns that certainty imposes.
''',
    reversedMeaning: '''
The reversed Moon indicates confronting fears or illusions dissipating.

Perhaps you feared the darkness - but now you can see. Perhaps fears are hiding the truth.

Subconscious messages are becoming clear. Dreams are becoming understandable.
''',
    symbolism: '''
• Moon: Subconscious, cycles, feminine
• Two towers: Passage gates
• Dog and wolf: Domestic/wild nature
• Crayfish: Rising from subconscious
• Path: Subconscious journey
• Water: Emotions, intuition
• Moon's face: Dual nature, light/shadow
''',
    spiritualLesson: '''
Spiritual lesson: You can't reach light without passing through darkness.

Face your fears. Know your shadows. The subconscious is not an enemy - just an unrecognized friend.

Dreams, intuitions, "meaningless" feelings... Listen to them all. Messages are encrypted but real.
''',
    loveReading: '''
Uncertainty, hidden feelings, or illusions in love.

Are you seeing reality, or what you want to see? There may be things you don't know about your partner.

Trust your intuition - but distinguish paranoia from intuition.
''',
    careerReading: '''
Uncertainty in career. No clear picture - wait.

Suitable for creative work, art, psychology, mystery fields.

This period is not suitable for important decisions - more information is needed.
''',
    advice:
        'Walk in the darkness. Your eyes will adjust. Trust your intuition - but verify.',
    meditation: '''
Close your eyes. You're on a forest path in moonlight. Shadows are moving - or does it just seem so?

Don't be afraid. Keep walking. Shadows are just shadows - not real.

Mantra: "I see even in darkness. My intuition guides me."
''',
    viralQuote:
        '"Look at the Moon: Not full, incomplete - but beautiful. Darkness is also part of light."',
    shadowAspect: 'Fear, paranoia, illusion, deception, subconscious suppression.',
  ),

  19: const MajorArcanaContent(
    number: 19,
    name: 'The Sun',
    nameTr: 'Güneş',
    archetype: 'Joy and Enlightenment',
    element: 'Fire',
    planet: 'Sun',
    hebrewLetter: 'Resh (ר)',
    keywords: 'Joy, success, vitality, enlightenment, positivity, clarity',
    shortMeaning: 'The sun illuminates everything. Joy, success, and childlike happiness.',
    deepMeaning: '''
The Sun is Tarot's most positive card. After the Moon's uncertainty, the sun clarifies everything.

In Kabbalah, Resh means "head." The Sun is the peak of conscious awareness.

Naked child on white horse - innocence and victory together. Sunflowers always turn toward light - so should you.

This card is not external success - it's inner enlightenment. But when inner light shines, the outer world is also illuminated.
''',
    reversedMeaning: '''
The reversed Sun indicates temporary eclipse or excessive optimism.

Perhaps the sun is behind clouds - but it's still there. Perhaps unrealistic expectations led to disappointment.

The inner child may be wounded. Preserve your capacity for joy.
''',
    symbolism: '''
• Sun: Consciousness, enlightenment, life force
• Child: Innocence, joy, new beginning
• White horse: Purity, victory
• Sunflowers: Turning toward light, growth
• Wall: Overcome obstacles
• Red flag: Life force, celebration
• Nakedness: Nothing to hide
''',
    spiritualLesson: '''
Spiritual lesson: Joy is the natural state of the soul.

Happiness doesn't depend on external conditions - it's an inner decision. Set the child within you free.

Be like the sun: Shine, warm, illuminate - unconditional, without expectation.
''',
    loveReading: '''
Period of happiness, harmony, and joy in love.

The relationship is blossoming. Children may be a topic - physical or creative projects.

Have fun like a child with your partner. Seriousness isn't everything.
''',
    careerReading: '''
Success and recognition in career. You're getting what your efforts deserve.

Creative projects are shining. Leadership comes naturally.

Work with children, entertainment, art, outdoor activities are prominent.
''',
    advice: 'Shine. Smile. Share your joy. Set the child within you free.',
    meditation: '''
Close your eyes. A warm sun is caressing your face. Remember that pure joy you felt as a child.

That child is still within you. Greet them. Play with them.

Mantra: "My light is shining. My joy is contagious. The child within me is free."
''',
    viralQuote:
        '"Be the Sun: Shine, warm, illuminate. Unconditional, unrequited - just be."',
    shadowAspect: 'Naivety, excessive optimism, arrogant light, denying the shadow.',
  ),

  20: const MajorArcanaContent(
    number: 20,
    name: 'Judgement',
    nameTr: 'Yargı / Diriliş',
    archetype: 'Cosmic Call',
    element: 'Fire / Water',
    planet: 'Pluto',
    hebrewLetter: 'Shin (ש)',
    keywords: 'Rebirth, calling, judgment, awakening, liberation, atonement',
    shortMeaning:
        'The trumpet sounds - time to wake up. Rebirth and cosmic call.',
    deepMeaning: '''
Judgement is not the end - it's a new beginning. The angels' trumpet awakens souls.

In Kabbalah, Shin means "tooth" and "fire" - transformative power. Judgement is purification by fire.

Figures rising from graves are awakening from past lives, old selves, suppressed potential.

This card is not "apocalypse" but "apokalypsis" (Greek "lifting of the veil"). Truth is revealed.
''',
    reversedMeaning: '''
Reversed Judgement indicates not hearing the call or not forgiving yourself.

Perhaps the inner voice is calling but you're not hearing - or hearing and ignoring.

You can't escape the past. Forgiving yourself feels difficult.
''',
    symbolism: '''
• Angel (Gabriel): Divine call
• Trumpet: Wake-up call
• Red cross (flag): Transformation, sacrifice
• Rising figures: Rebirth
• Coffins: Old selves
• Mountains: Overcome obstacles
• Water: Emotional purification
''',
    spiritualLesson: '''
Spiritual lesson: It's never too late.

Whatever the past, you can wake up now. The call comes every moment - do you hear it?

Judging yourself and forgiving yourself are parts of the same process. Do both.
''',
    loveReading: '''
Re-evaluation in love. Question the relationship - but don't destroy it.

Karmic completions from past relationships. Old loves may return - but with a different perspective.

Second chances are possible - but conscious choice is needed.
''',
    careerReading: '''
A calling is coming in career. What is your true mission?

Perhaps a path you've postponed for years. Perhaps a completely different career.

This is not an "all or nothing" moment - but a turning point.
''',
    advice: 'Hear the call. Answer. Forgive the past. Be reborn.',
    meditation: '''
Close your eyes. You hear a trumpet sound from afar. It's calling you.

Rise from the ground. Leave your old self behind. The new you is being born.

Mantra: "I hear the call. I am awakening. I am being reborn."
''',
    viralQuote:
        '"Awaken: The trumpet sounds. The past is behind, the future uncertain - but now is here."',
    shadowAspect: 'Self-judgment, guilt, escaping the call, not forgiving.',
  ),

  21: const MajorArcanaContent(
    number: 21,
    name: 'The World',
    nameTr: 'Dünya',
    archetype: 'Completion',
    element: 'Earth',
    planet: 'Saturn',
    hebrewLetter: 'Tav (ת)',
    keywords: 'Completion, wholeness, success, integration, end of cycle',
    shortMeaning:
        'The journey is complete. Wholeness, success, and the threshold of a new cycle.',
    deepMeaning: '''
The World is the last card of Major Arcana - but also the threshold of a new beginning. The Fool's journey is complete.

In Kabbalah, Tav is the last letter and means "sign." The World is the sign of spiritual journey completion.

The dancing figure has found balance with two wands - polarities integrated. The wreath (ouroboros-like) symbolizes cyclicity.

The figures in four corners (bull, lion, eagle, angel) represent fixed signs and four elements - all in harmony.
''',
    reversedMeaning: '''
The reversed World indicates incomplete completion or being stuck in a cycle.

Perhaps you're very close to the goal but can't take the last step. Perhaps you've achieved success but aren't satisfied.

Before a new beginning, the old cycle needs to close.
''',
    symbolism: '''
• Dancing figure: Completed soul
• Two wands: Integrated polarities
• Laurel wreath: Victory, cyclicity
• Four figures: Four elements, four fixed signs
• Purple veil: Wisdom, spirituality
• Infinity shape: Cyclical nature
• White background: Infinite possibilities
''',
    spiritualLesson: '''
Spiritual lesson: Completion is not the end - it's a new beginning.

Every cycle is preparation for the next. Every end is a beginning. The universe is spiral - not circular.

Success is not a destination - it's the journey itself.
''',
    loveReading: '''
Completion and wholeness in love. The relationship reaches a new level.

Suitable for marriage, living together, lasting commitments.

Feeling whole within yourself - approaching a relationship as "choice" not "need."
''',
    careerReading: '''
Great success in career. Long-term goals are being realized.

Project is completing. Promotion, award, recognition.

But beware: One cycle is ending. What's next?
''',
    advice:
        'Celebrate. Give thanks. Integrate. And prepare - a new journey is about to begin.',
    meditation: '''
Close your eyes. You're standing at the center of the universe. Four directions greet you.

Feel your connection to everything. You're not separate - you're part of the whole.

Mantra: "I am whole. One with the universe. And the journey continues."
''',
    viralQuote:
        '"The World is yours: Complete, celebrate, continue. Every end is the opening of a new song."',
    shadowAspect:
        'Illusion of completion, stagnation, fear of new beginning, arrogant satisfaction.',
  ),
};

/// Viral sharing texts for Tarot
class TarotViralTexts {
  static const List<String> generalTexts = [
    'What do the cards say? 🎴',
    'Today\'s archetype is with you 🔮',
    'The universe is sending a message ✨',
    'Tarot mirror: See what\'s within 🪞',
    'Ancient symbols, deep insights 🌟',
  ];

  static String getForCard(int number) {
    final card = majorArcanaContents[number];
    if (card == null) return generalTexts[0];
    return card.viralQuote;
  }
}
