#!/usr/bin/env dart
// ignore_for_file: avoid_print

/// SEO Blog Generator for Venus One
///
/// Generates SEO-optimized blog content for various astrology topics.
/// Usage: dart run scripts/seo_blog_generator.dart <topic> [options]
///
/// Topics:
///   - daily-horoscope <sign>
///   - zodiac-guide <sign>
///   - planet-in-sign <planet> <sign>
///   - birth-chart-guide
///   - aspect-guide <aspect>

import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    printUsage();
    exit(1);
  }

  final topic = args[0];

  switch (topic) {
    case 'daily-horoscope':
      if (args.length < 2) {
        print('Error: Sign required for daily-horoscope');
        exit(1);
      }
      generateDailyHoroscope(args[1]);
      break;
    case 'zodiac-guide':
      if (args.length < 2) {
        print('Error: Sign required for zodiac-guide');
        exit(1);
      }
      generateZodiacGuide(args[1]);
      break;
    case 'planet-in-sign':
      if (args.length < 3) {
        print('Error: Planet and sign required for planet-in-sign');
        exit(1);
      }
      generatePlanetInSign(args[1], args[2]);
      break;
    case 'birth-chart-guide':
      generateBirthChartGuide();
      break;
    case 'aspect-guide':
      if (args.length < 2) {
        print('Error: Aspect required for aspect-guide');
        exit(1);
      }
      generateAspectGuide(args[1]);
      break;
    case 'all-signs':
      generateAllSignsHoroscopes();
      break;
    default:
      print('Unknown topic: $topic');
      printUsage();
      exit(1);
  }
}

void printUsage() {
  print('''
SEO Blog Generator for Venus One

Usage: dart run scripts/seo_blog_generator.dart <topic> [options]

Topics:
  daily-horoscope <sign>     Generate daily horoscope article
  zodiac-guide <sign>        Generate comprehensive zodiac sign guide
  planet-in-sign <planet> <sign>  Generate planet in sign interpretation
  birth-chart-guide          Generate birth chart explanation article
  aspect-guide <aspect>      Generate aspect explanation article
  all-signs                  Generate horoscopes for all 12 signs

Signs: aries, taurus, gemini, cancer, leo, virgo, libra, scorpio, sagittarius, capricorn, aquarius, pisces

Planets: sun, moon, mercury, venus, mars, jupiter, saturn, uranus, neptune, pluto

Aspects: conjunction, opposition, trine, square, sextile
''');
}

final Map<String, Map<String, String>> zodiacData = {
  'aries': {
    'name': 'Aries',
    'symbol': '♈',
    'element': 'Fire',
    'modality': 'Cardinal',
    'ruler': 'Mars',
    'dates': 'March 21 - April 19',
    'traits': 'Bold, ambitious, competitive, energetic, pioneering',
  },
  'taurus': {
    'name': 'Taurus',
    'symbol': '♉',
    'element': 'Earth',
    'modality': 'Fixed',
    'ruler': 'Venus',
    'dates': 'April 20 - May 20',
    'traits': 'Reliable, patient, practical, devoted, sensual',
  },
  'gemini': {
    'name': 'Gemini',
    'symbol': '♊',
    'element': 'Air',
    'modality': 'Mutable',
    'ruler': 'Mercury',
    'dates': 'May 21 - June 20',
    'traits': 'Curious, adaptable, communicative, witty, versatile',
  },
  'cancer': {
    'name': 'Cancer',
    'symbol': '♋',
    'element': 'Water',
    'modality': 'Cardinal',
    'ruler': 'Moon',
    'dates': 'June 21 - July 22',
    'traits': 'Nurturing, intuitive, protective, emotional, loyal',
  },
  'leo': {
    'name': 'Leo',
    'symbol': '♌',
    'element': 'Fire',
    'modality': 'Fixed',
    'ruler': 'Sun',
    'dates': 'July 23 - August 22',
    'traits': 'Confident, dramatic, creative, generous, warm-hearted',
  },
  'virgo': {
    'name': 'Virgo',
    'symbol': '♍',
    'element': 'Earth',
    'modality': 'Mutable',
    'ruler': 'Mercury',
    'dates': 'August 23 - September 22',
    'traits': 'Analytical, practical, diligent, modest, helpful',
  },
  'libra': {
    'name': 'Libra',
    'symbol': '♎',
    'element': 'Air',
    'modality': 'Cardinal',
    'ruler': 'Venus',
    'dates': 'September 23 - October 22',
    'traits': 'Diplomatic, fair-minded, social, cooperative, gracious',
  },
  'scorpio': {
    'name': 'Scorpio',
    'symbol': '♏',
    'element': 'Water',
    'modality': 'Fixed',
    'ruler': 'Pluto',
    'dates': 'October 23 - November 21',
    'traits': 'Passionate, resourceful, brave, stubborn, mysterious',
  },
  'sagittarius': {
    'name': 'Sagittarius',
    'symbol': '♐',
    'element': 'Fire',
    'modality': 'Mutable',
    'ruler': 'Jupiter',
    'dates': 'November 22 - December 21',
    'traits': 'Optimistic, adventurous, philosophical, honest, freedom-loving',
  },
  'capricorn': {
    'name': 'Capricorn',
    'symbol': '♑',
    'element': 'Earth',
    'modality': 'Cardinal',
    'ruler': 'Saturn',
    'dates': 'December 22 - January 19',
    'traits': 'Disciplined, responsible, ambitious, patient, practical',
  },
  'aquarius': {
    'name': 'Aquarius',
    'symbol': '♒',
    'element': 'Air',
    'modality': 'Fixed',
    'ruler': 'Uranus',
    'dates': 'January 20 - February 18',
    'traits': 'Progressive, original, independent, humanitarian, intellectual',
  },
  'pisces': {
    'name': 'Pisces',
    'symbol': '♓',
    'element': 'Water',
    'modality': 'Mutable',
    'ruler': 'Neptune',
    'dates': 'February 19 - March 20',
    'traits': 'Compassionate, artistic, intuitive, gentle, wise',
  },
};

void generateDailyHoroscope(String sign) {
  final signKey = sign.toLowerCase();
  if (!zodiacData.containsKey(signKey)) {
    print('Unknown sign: $sign');
    exit(1);
  }

  final data = zodiacData[signKey]!;
  final today = DateTime.now();
  final dateStr =
      '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

  final article =
      '''
---
title: "${data['name']} Horoscope for Today - $dateStr"
description: "Get your daily ${data['name']} horoscope. Discover what the stars have in store for ${data['name']} (${data['dates']}) today."
date: $dateStr
category: daily-horoscope
sign: $signKey
schema_type: Article
---

# ${data['name']} Horoscope for Today ${data['symbol']}

**${data['dates']}** | **Element:** ${data['element']} | **Ruler:** ${data['ruler']}

## Today's Overview

As a ${data['name']}, you embody the qualities of being ${data['traits']}. Today, the cosmic energies are aligning to bring you unique opportunities and challenges.

## Love & Relationships

The planetary movements today influence your relationships in meaningful ways. Whether you're single or in a partnership, pay attention to the emotional currents around you.

## Career & Finance

Your professional life receives cosmic attention today. The ${data['element']} energy of your sign helps you navigate workplace dynamics with characteristic ${data['name']} determination.

## Health & Wellness

Take care of your physical and mental wellbeing today. As a ${data['modality']} sign, you benefit from maintaining consistent routines while staying open to new approaches.

## Lucky Elements Today

- **Lucky Number:** ${(today.day + today.month) % 9 + 1}
- **Lucky Color:** ${_getLuckyColor(signKey)}
- **Best Time:** ${_getBestTime(signKey)}

## Cosmic Advice

Remember that your birth chart is unique. While this general horoscope provides guidance, your personal planetary placements offer deeper insights. [Explore your complete birth chart](/birth-chart) for personalized cosmic guidance.

---

*Get your personalized daily horoscope based on your complete birth chart with [Venus One](https://venusone.app).*
''';

  print(article);
}

void generateZodiacGuide(String sign) {
  final signKey = sign.toLowerCase();
  if (!zodiacData.containsKey(signKey)) {
    print('Unknown sign: $sign');
    exit(1);
  }

  final data = zodiacData[signKey]!;

  final article =
      '''
---
title: "Everything You Need to Know About ${data['name']} ${data['symbol']}"
description: "Complete guide to the ${data['name']} zodiac sign. Learn about ${data['name']} personality traits, compatibility, career strengths, and more."
category: zodiac-guide
sign: $signKey
schema_type: Article
---

# Complete Guide to ${data['name']} ${data['symbol']}

**Dates:** ${data['dates']} | **Element:** ${data['element']} | **Modality:** ${data['modality']} | **Ruler:** ${data['ruler']}

## ${data['name']} Overview

${data['name']} is the ${_getSignNumber(signKey)} sign of the zodiac. As a ${data['element']} sign with ${data['modality']} quality, ${data['name']} individuals are known for being ${data['traits']}.

## Core Personality Traits

### Strengths
${data['name']} natives possess remarkable qualities that set them apart:
- Natural ${_getPrimaryStrength(signKey)}
- Strong ${_getSecondaryStrength(signKey)}
- Exceptional ${_getTertiaryStrength(signKey)}

### Challenges
Like all signs, ${data['name']} has areas for growth:
- Tendency toward ${_getPrimaryChallenge(signKey)}
- Can struggle with ${_getSecondaryChallenge(signKey)}

## ${data['name']} in Love & Relationships

When it comes to matters of the heart, ${data['name']} brings their characteristic ${(data['element'])?.toLowerCase() ?? 'elemental'} energy to relationships.

### Most Compatible Signs
1. ${_getMostCompatible(signKey, 0)}
2. ${_getMostCompatible(signKey, 1)}
3. ${_getMostCompatible(signKey, 2)}

### Challenging Matches
1. ${_getLeastCompatible(signKey, 0)}
2. ${_getLeastCompatible(signKey, 1)}

## Career & Professional Life

${data['name']} thrives in careers that allow them to express their natural talents. Best career paths include:
- ${_getCareer(signKey, 0)}
- ${_getCareer(signKey, 1)}
- ${_getCareer(signKey, 2)}

## The ${data['ruler']} Connection

As the ruling planet of ${data['name']}, ${data['ruler']} infuses this sign with its distinctive energy. Understanding your ${data['ruler']} placement in your birth chart reveals deeper layers of your ${data['name']} nature.

## ${data['name']} and the Elements

As a ${data['element']} sign, ${data['name']} shares elemental kinship with:
${_getElementalSiblings(signKey).map((s) => '- $s').join('\n')}

## Discover Your Complete ${data['name']} Profile

This overview captures the essence of ${data['name']}, but your personal birth chart tells a much richer story. Your Moon sign, Rising sign, and planetary placements add unique dimensions to your cosmic identity.

[Calculate your complete birth chart](/birth-chart) to understand how ${data['name']} energy expresses uniquely in you.

---

*Explore the depths of your astrological profile with [Venus One](https://venusone.app).*
''';

  print(article);
}

void generatePlanetInSign(String planet, String sign) {
  final planetName =
      planet[0].toUpperCase() + planet.substring(1).toLowerCase();
  final signKey = sign.toLowerCase();

  if (!zodiacData.containsKey(signKey)) {
    print('Unknown sign: $sign');
    exit(1);
  }

  final data = zodiacData[signKey]!;

  final article =
      '''
---
title: "$planetName in ${data['name']}: What It Means in Your Birth Chart"
description: "Discover what $planetName in ${data['name']} reveals about your personality, relationships, and life path. Complete astrological interpretation."
category: planet-interpretations
planet: ${planet.toLowerCase()}
sign: $signKey
schema_type: Article
---

# $planetName in ${data['name']} ${data['symbol']}

## Understanding $planetName in ${data['name']}

When $planetName occupies the sign of ${data['name']} in your birth chart, it creates a distinctive blend of planetary and zodiacal energies. ${data['name']}'s ${data['element']} element and ${data['modality']} quality color how $planetName expresses in your life.

## Key Themes

### Core Expression
$planetName in ${data['name']} manifests as:
- ${_getPlanetSignTheme(planet.toLowerCase(), signKey, 0)}
- ${_getPlanetSignTheme(planet.toLowerCase(), signKey, 1)}
- ${_getPlanetSignTheme(planet.toLowerCase(), signKey, 2)}

### Strengths
This placement gifts you with:
- Natural ability to ${_getPlanetSignStrength(planet.toLowerCase(), signKey, 0)}
- Strong capacity for ${_getPlanetSignStrength(planet.toLowerCase(), signKey, 1)}

### Growth Areas
Areas that may require conscious development:
- Learning to balance ${_getPlanetSignChallenge(planet.toLowerCase(), signKey, 0)}
- Developing ${_getPlanetSignChallenge(planet.toLowerCase(), signKey, 1)}

## $planetName in ${data['name']} Through the Houses

The house position of your $planetName in ${data['name']} adds another layer of meaning:

- **1st House:** Self-expression and identity
- **2nd House:** Values and resources
- **3rd House:** Communication and learning
- **4th House:** Home and family
- **5th House:** Creativity and romance
- **6th House:** Work and health
- **7th House:** Partnerships
- **8th House:** Transformation and shared resources
- **9th House:** Philosophy and expansion
- **10th House:** Career and public life
- **11th House:** Community and future vision
- **12th House:** Spirituality and the unconscious

## Famous People with $planetName in ${data['name']}

Throughout history, many notable individuals have shared this placement, demonstrating its potential in various fields.

## Discover Your Complete Chart

$planetName in ${data['name']} is just one piece of your astrological puzzle. Your complete birth chart reveals how this placement interacts with your other planetary positions.

[Get your personalized birth chart analysis](/birth-chart) to see the full picture.

---

*Unlock the secrets of your cosmic blueprint with [Venus One](https://venusone.app).*
''';

  print(article);
}

void generateBirthChartGuide() {
  final article = '''
---
title: "How to Read Your Birth Chart: A Complete Guide"
description: "Learn how to read and interpret your birth chart. Understand planets, signs, houses, and aspects in astrology."
category: astrology-education
schema_type: Article
---

# How to Read Your Birth Chart: A Complete Guide

## What Is a Birth Chart?

A birth chart (also called a natal chart) is a map of the sky at the exact moment and location of your birth. It's your unique cosmic fingerprint — no two birth charts are exactly alike.

## The Three Essential Components

### 1. Planets
Your birth chart contains 10 celestial bodies, each representing different aspects of your personality:

| Planet | Represents |
|--------|-----------|
| Sun | Core identity, ego, life force |
| Moon | Emotions, instincts, inner self |
| Mercury | Communication, thinking, learning |
| Venus | Love, beauty, values |
| Mars | Action, energy, desire |
| Jupiter | Growth, luck, wisdom |
| Saturn | Structure, discipline, lessons |
| Uranus | Innovation, rebellion, change |
| Neptune | Dreams, intuition, spirituality |
| Pluto | Transformation, power, rebirth |

### 2. Signs
The 12 zodiac signs describe HOW planetary energies express:

- **Fire Signs** (Aries, Leo, Sagittarius): Passionate, energetic, inspirational
- **Earth Signs** (Taurus, Virgo, Capricorn): Practical, grounded, reliable
- **Air Signs** (Gemini, Libra, Aquarius): Intellectual, social, communicative
- **Water Signs** (Cancer, Scorpio, Pisces): Emotional, intuitive, deep

### 3. Houses
The 12 houses show WHERE in life these energies manifest:

| House | Life Area |
|-------|-----------|
| 1st | Self, appearance, first impressions |
| 2nd | Money, values, possessions |
| 3rd | Communication, siblings, short trips |
| 4th | Home, family, roots |
| 5th | Creativity, romance, children |
| 6th | Work, health, daily routines |
| 7th | Partnerships, marriage, contracts |
| 8th | Transformation, shared resources, intimacy |
| 9th | Philosophy, travel, higher education |
| 10th | Career, reputation, public life |
| 11th | Friends, groups, future goals |
| 12th | Subconscious, spirituality, hidden matters |

## The Big Three: Your Core Identity

The most important placements in your chart are:

1. **Sun Sign** - Your core essence and life purpose
2. **Moon Sign** - Your emotional nature and inner needs
3. **Rising Sign (Ascendant)** - How you appear to others

## Understanding Aspects

Aspects are geometric relationships between planets that show how different parts of your psyche interact:

- **Conjunction (0°)** - Fusion of energies
- **Opposition (180°)** - Tension and balance
- **Trine (120°)** - Harmony and flow
- **Square (90°)** - Challenge and growth
- **Sextile (60°)** - Opportunity and support

## How to Get Started

1. **Calculate your chart** - You need your exact birth date, time, and location
2. **Start with the Big Three** - Sun, Moon, and Rising
3. **Explore planet placements** - One at a time
4. **Study house positions** - Where energies express
5. **Examine aspects** - How energies interact

## Your Personal Birth Chart

Ready to explore your cosmic blueprint? [Calculate your birth chart now](/birth-chart) and discover what the stars reveal about your unique path.

---

*Begin your astrological journey with [Venus One](https://venusone.app) — personalized insights based on your complete birth chart.*
''';

  print(article);
}

void generateAspectGuide(String aspect) {
  final aspectName =
      aspect[0].toUpperCase() + aspect.substring(1).toLowerCase();

  final aspectData = {
    'conjunction': {
      'degree': '0°',
      'nature': 'Fusion',
      'keywords': 'Unity, intensity, focused energy',
    },
    'opposition': {
      'degree': '180°',
      'nature': 'Polarity',
      'keywords': 'Tension, awareness, balance',
    },
    'trine': {
      'degree': '120°',
      'nature': 'Harmony',
      'keywords': 'Flow, ease, natural talent',
    },
    'square': {
      'degree': '90°',
      'nature': 'Challenge',
      'keywords': 'Tension, growth, action',
    },
    'sextile': {
      'degree': '60°',
      'nature': 'Opportunity',
      'keywords': 'Support, potential, cooperation',
    },
  };

  if (!aspectData.containsKey(aspect.toLowerCase())) {
    print('Unknown aspect: $aspect');
    exit(1);
  }

  final data = aspectData[aspect.toLowerCase()]!;

  final article =
      '''
---
title: "Understanding the $aspectName Aspect in Astrology"
description: "Learn what $aspectName aspects mean in your birth chart. Discover how ${data['degree']} aspects influence your personality and life."
category: astrology-education
aspect: ${aspect.toLowerCase()}
schema_type: Article
---

# The $aspectName Aspect in Astrology

## What Is a $aspectName?

A $aspectName is an aspect of ${data['degree']} between two planets in a birth chart. It represents ${(data['nature'])?.toLowerCase() ?? 'dynamic'} energy — ${(data['keywords'])?.toLowerCase() ?? 'transformative'}.

## The Nature of $aspectName Aspects

$aspectName aspects are considered ${_getAspectNature(aspect.toLowerCase())} aspects in traditional astrology. They create a ${(data['nature'])?.toLowerCase() ?? 'dynamic'} between the planets involved.

### Key Characteristics
- **Degree:** ${data['degree']}
- **Nature:** ${data['nature']}
- **Keywords:** ${data['keywords']}

## $aspectName Aspects Between Different Planets

### Sun $aspectName
When the Sun forms a $aspectName, it affects your core identity and life purpose.

### Moon $aspectName
Lunar ${aspectName.toLowerCase()}s influence your emotional patterns and instinctive responses.

### Mercury $aspectName
${aspectName}s involving Mercury affect communication and thinking processes.

### Venus $aspectName
Venus ${aspectName.toLowerCase()}s impact love, relationships, and values.

### Mars $aspectName
Mars ${aspectName.toLowerCase()}s influence action, energy, and desire.

## Working with $aspectName Energy

Understanding your ${aspectName.toLowerCase()}s helps you:
1. Recognize natural patterns in your life
2. Work consciously with planetary energies
3. Make the most of cosmic opportunities
4. Navigate challenges with awareness

## Find Your ${aspectName}s

Discover all the ${aspectName.toLowerCase()} aspects in your personal birth chart. [Calculate your chart now](/birth-chart) to see how these cosmic connections shape your life.

---

*Explore the geometry of your soul with [Venus One](https://venusone.app).*
''';

  print(article);
}

void generateAllSignsHoroscopes() {
  for (final sign in zodiacData.keys) {
    print('\n--- Generating horoscope for ${sign.toUpperCase()} ---\n');
    generateDailyHoroscope(sign);
    print('\n');
  }
}

// Helper functions
String _getLuckyColor(String sign) {
  final colors = {
    'aries': 'Red',
    'taurus': 'Green',
    'gemini': 'Yellow',
    'cancer': 'Silver',
    'leo': 'Gold',
    'virgo': 'Navy Blue',
    'libra': 'Pink',
    'scorpio': 'Burgundy',
    'sagittarius': 'Purple',
    'capricorn': 'Brown',
    'aquarius': 'Electric Blue',
    'pisces': 'Sea Green',
  };
  return colors[sign] ?? 'White';
}

String _getBestTime(String sign) {
  final times = {
    'aries': 'Morning (6-9 AM)',
    'taurus': 'Late Morning (9-12 PM)',
    'gemini': 'Midday (11 AM - 2 PM)',
    'cancer': 'Evening (6-9 PM)',
    'leo': 'Afternoon (12-3 PM)',
    'virgo': 'Early Morning (5-8 AM)',
    'libra': 'Late Afternoon (3-6 PM)',
    'scorpio': 'Night (9 PM - 12 AM)',
    'sagittarius': 'Morning (7-10 AM)',
    'capricorn': 'Early Morning (4-7 AM)',
    'aquarius': 'Late Night (11 PM - 2 AM)',
    'pisces': 'Dawn/Dusk',
  };
  return times[sign] ?? 'Noon';
}

String _getSignNumber(String sign) {
  final numbers = [
    'first',
    'second',
    'third',
    'fourth',
    'fifth',
    'sixth',
    'seventh',
    'eighth',
    'ninth',
    'tenth',
    'eleventh',
    'twelfth',
  ];
  final signs = [
    'aries',
    'taurus',
    'gemini',
    'cancer',
    'leo',
    'virgo',
    'libra',
    'scorpio',
    'sagittarius',
    'capricorn',
    'aquarius',
    'pisces',
  ];
  final index = signs.indexOf(sign);
  return index >= 0 ? numbers[index] : 'first';
}

String _getPrimaryStrength(String sign) {
  final strengths = {
    'aries': 'leadership and initiative',
    'taurus': 'reliability and determination',
    'gemini': 'communication and adaptability',
    'cancer': 'intuition and nurturing',
    'leo': 'creativity and confidence',
    'virgo': 'analytical skills and precision',
    'libra': 'diplomacy and fairness',
    'scorpio': 'intensity and resourcefulness',
    'sagittarius': 'optimism and vision',
    'capricorn': 'discipline and ambition',
    'aquarius': 'innovation and independence',
    'pisces': 'compassion and imagination',
  };
  return strengths[sign] ?? 'unique abilities';
}

String _getSecondaryStrength(String sign) {
  final strengths = {
    'aries': 'courage in facing challenges',
    'taurus': 'appreciation for beauty',
    'gemini': 'mental agility',
    'cancer': 'emotional intelligence',
    'leo': 'generosity of spirit',
    'virgo': 'dedication to service',
    'libra': 'aesthetic sensibility',
    'scorpio': 'psychological insight',
    'sagittarius': 'philosophical wisdom',
    'capricorn': 'strategic planning',
    'aquarius': 'humanitarian vision',
    'pisces': 'spiritual connection',
  };
  return strengths[sign] ?? 'inner wisdom';
}

String _getTertiaryStrength(String sign) {
  final strengths = {
    'aries': 'ability to inspire action',
    'taurus': 'steadfastness in adversity',
    'gemini': 'versatility in expression',
    'cancer': 'protective instincts',
    'leo': 'natural magnetism',
    'virgo': 'problem-solving abilities',
    'libra': 'relationship building',
    'scorpio': 'transformative power',
    'sagittarius': 'adventurous spirit',
    'capricorn': 'long-term planning',
    'aquarius': 'original thinking',
    'pisces': 'artistic expression',
  };
  return strengths[sign] ?? 'special talents';
}

String _getPrimaryChallenge(String sign) {
  final challenges = {
    'aries': 'impatience',
    'taurus': 'stubbornness',
    'gemini': 'inconsistency',
    'cancer': 'moodiness',
    'leo': 'ego',
    'virgo': 'perfectionism',
    'libra': 'indecision',
    'scorpio': 'jealousy',
    'sagittarius': 'restlessness',
    'capricorn': 'rigidity',
    'aquarius': 'detachment',
    'pisces': 'escapism',
  };
  return challenges[sign] ?? 'certain tendencies';
}

String _getSecondaryChallenge(String sign) {
  final challenges = {
    'aries': 'follow-through on long projects',
    'taurus': 'adapting to change',
    'gemini': 'depth of focus',
    'cancer': 'letting go of the past',
    'leo': 'accepting criticism',
    'virgo': 'self-acceptance',
    'libra': 'standing firm in conflicts',
    'scorpio': 'trusting others',
    'sagittarius': 'attention to detail',
    'capricorn': 'work-life balance',
    'aquarius': 'emotional vulnerability',
    'pisces': 'setting boundaries',
  };
  return challenges[sign] ?? 'growth areas';
}

String _getMostCompatible(String sign, int index) {
  final compatible = {
    'aries': ['Leo', 'Sagittarius', 'Gemini'],
    'taurus': ['Virgo', 'Capricorn', 'Cancer'],
    'gemini': ['Libra', 'Aquarius', 'Aries'],
    'cancer': ['Scorpio', 'Pisces', 'Taurus'],
    'leo': ['Aries', 'Sagittarius', 'Gemini'],
    'virgo': ['Taurus', 'Capricorn', 'Cancer'],
    'libra': ['Gemini', 'Aquarius', 'Leo'],
    'scorpio': ['Cancer', 'Pisces', 'Virgo'],
    'sagittarius': ['Aries', 'Leo', 'Libra'],
    'capricorn': ['Taurus', 'Virgo', 'Scorpio'],
    'aquarius': ['Gemini', 'Libra', 'Sagittarius'],
    'pisces': ['Cancer', 'Scorpio', 'Taurus'],
  };
  return compatible[sign]?[index] ?? 'Various';
}

String _getLeastCompatible(String sign, int index) {
  final challenging = {
    'aries': ['Cancer', 'Capricorn'],
    'taurus': ['Leo', 'Aquarius'],
    'gemini': ['Virgo', 'Pisces'],
    'cancer': ['Aries', 'Libra'],
    'leo': ['Taurus', 'Scorpio'],
    'virgo': ['Gemini', 'Sagittarius'],
    'libra': ['Cancer', 'Capricorn'],
    'scorpio': ['Leo', 'Aquarius'],
    'sagittarius': ['Virgo', 'Pisces'],
    'capricorn': ['Aries', 'Libra'],
    'aquarius': ['Taurus', 'Scorpio'],
    'pisces': ['Gemini', 'Sagittarius'],
  };
  return challenging[sign]?[index] ?? 'Various';
}

String _getCareer(String sign, int index) {
  final careers = {
    'aries': ['Entrepreneur', 'Athlete', 'Military'],
    'taurus': ['Finance', 'Real Estate', 'Agriculture'],
    'gemini': ['Journalism', 'Sales', 'Teaching'],
    'cancer': ['Healthcare', 'Real Estate', 'Food Industry'],
    'leo': ['Entertainment', 'Management', 'Politics'],
    'virgo': ['Healthcare', 'Research', 'Accounting'],
    'libra': ['Law', 'Design', 'Diplomacy'],
    'scorpio': ['Psychology', 'Research', 'Investigation'],
    'sagittarius': ['Education', 'Travel', 'Publishing'],
    'capricorn': ['Business', 'Government', 'Architecture'],
    'aquarius': ['Technology', 'Science', 'Social Work'],
    'pisces': ['Arts', 'Healthcare', 'Spirituality'],
  };
  return careers[sign]?[index] ?? 'Various fields';
}

List<String> _getElementalSiblings(String sign) {
  final siblings = {
    'aries': ['Leo', 'Sagittarius'],
    'taurus': ['Virgo', 'Capricorn'],
    'gemini': ['Libra', 'Aquarius'],
    'cancer': ['Scorpio', 'Pisces'],
    'leo': ['Aries', 'Sagittarius'],
    'virgo': ['Taurus', 'Capricorn'],
    'libra': ['Gemini', 'Aquarius'],
    'scorpio': ['Cancer', 'Pisces'],
    'sagittarius': ['Aries', 'Leo'],
    'capricorn': ['Taurus', 'Virgo'],
    'aquarius': ['Gemini', 'Libra'],
    'pisces': ['Cancer', 'Scorpio'],
  };
  return siblings[sign] ?? ['Other signs'];
}

String _getPlanetSignTheme(String planet, String sign, int index) {
  // Simplified placeholder - in production, this would have detailed interpretations
  final themes = [
    'Enhanced ${zodiacData[sign]?['element'] ?? 'elemental'} expression',
    'Integration of ${zodiacData[sign]?['modality'] ?? 'modal'} qualities',
    'Connection to ${zodiacData[sign]?['ruler'] ?? 'planetary'} themes',
  ];
  return themes[index];
}

String _getPlanetSignStrength(String planet, String sign, int index) {
  final strengths = [
    'channel ${zodiacData[sign]?['element'] ?? 'elemental'} energy constructively',
    'express ${zodiacData[sign]?['traits']?.split(',').first ?? 'unique'} qualities',
  ];
  return strengths[index];
}

String _getPlanetSignChallenge(String planet, String sign, int index) {
  final challenges = [
    '${zodiacData[sign]?['element'] ?? 'elemental'} impulses with practical needs',
    'patience in ${zodiacData[sign]?['modality'] ?? 'modal'} situations',
  ];
  return challenges[index];
}

String _getAspectNature(String aspect) {
  final natures = {
    'conjunction': 'neutral (can be harmonious or challenging)',
    'opposition': 'challenging',
    'trine': 'harmonious',
    'square': 'challenging',
    'sextile': 'harmonious',
  };
  return natures[aspect] ?? 'variable';
}
