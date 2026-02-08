// ════════════════════════════════════════════════════════════════════════════
// FORBIDDEN PHRASES - App Store 4.3(b) Compliance
// ════════════════════════════════════════════════════════════════════════════
//
// This module contains lists of forbidden phrases that must not appear in
// user-facing content to ensure Apple App Store compliance.
//
// USAGE:
// - Import FORBIDDEN_REGEX_EN or FORBIDDEN_REGEX_TR to test content
// - Use SAFE_REPLACEMENTS to auto-fix detected phrases
// ════════════════════════════════════════════════════════════════════════════

// ══════════════════════════════════════════════════════════════════════════
// ENGLISH FORBIDDEN PHRASES
// ══════════════════════════════════════════════════════════════════════════

export const FORBIDDEN_PHRASES_EN = {
  // Astrology-specific
  astrology: ['astrology', 'astrological', 'astrologer'],
  horoscope: ['horoscope', 'horoscopes', 'daily horoscope', 'weekly horoscope'],
  zodiac: ['zodiac', 'zodiac sign', 'sun sign', 'moon sign', 'rising sign', 'ascendant'],
  birthChart: ['birth chart', 'natal chart', 'chart reading', 'chart analysis'],
  planets: [
    'mercury retrograde', 'venus in', 'mars in', 'jupiter in', 'saturn return',
    'planetary influence', 'planetary alignment', 'celestial bodies', 'planetary transit'
  ],
  houses: ['first house', 'second house', 'seventh house', 'twelfth house', 'house placement'],

  // Fortune/Prediction
  fortune: ['fortune', 'fortune telling', 'fortune teller', 'your fortune'],
  prediction: ['prediction', 'predict', 'predicted', 'prophecy', 'prophetic'],
  destiny: ['destiny', 'fate', 'fated', 'destined', 'meant to be'],
  future: [
    'your future', 'in your future', 'future holds', 'what awaits',
    'will happen', 'going to happen', 'expect to see'
  ],

  // Cosmic claims
  cosmic: ['cosmic influence', 'cosmic energy', 'stars say', 'stars indicate', 'stars align'],
  spiritual: ['spirit guide', 'spirit message', 'channeling', 'psychic', 'clairvoyant'],

  // Health/Medical claims
  medical: ['cure', 'heal', 'treatment', 'diagnose', 'medical advice', 'health advice'],

  // Financial claims
  financial: ['financial advice', 'investment', 'guaranteed returns', 'get rich']
} as const;

// ══════════════════════════════════════════════════════════════════════════
// TURKISH FORBIDDEN PHRASES
// ══════════════════════════════════════════════════════════════════════════

export const FORBIDDEN_PHRASES_TR = {
  // Astrology-specific
  astroloji: ['astroloji', 'astrolojik', 'astrolog'],
  burc: ['burç', 'burçlar', 'günlük burç', 'haftalık burç', 'burç yorumu'],
  harita: ['doğum haritası', 'natal harita', 'yıldız haritası', 'harita analizi'],
  gezegenler: [
    'merkür retrosu', 'venüs geçişi', 'mars geçişi', 'satürn dönüşü',
    'gezegen etkisi', 'gezegen dizilimi', 'gök cisimleri'
  ],
  evler: ['birinci ev', 'yedinci ev', 'on ikinci ev', 'ev yerleşimi'],

  // Fortune/Prediction
  fal: ['fal', 'falcılık', 'falcı', 'kahve falı', 'tarot falı'],
  kehanet: ['kehanet', 'kehanetle', 'öngörü', 'tahmin'],
  kader: ['kader', 'kaderiniz', 'alın yazısı', 'yazgı', 'mukadderat'],
  gelecek: [
    'geleceğiniz', 'gelecekte', 'sizi bekleyen', 'olacak',
    'gerçekleşecek', 'yaşayacaksınız'
  ],

  // Cosmic claims
  kozmik: ['kozmik etki', 'kozmik enerji', 'yıldızlar söylüyor', 'yıldızlar diyor'],
  ruhani: ['ruh rehberi', 'ruhani mesaj', 'medyum', 'durugörü'],

  // Health claims
  saglik: ['tedavi', 'şifa', 'iyileştirme', 'tanı', 'sağlık tavsiyesi'],

  // Financial claims
  finansal: ['yatırım tavsiyesi', 'garantili kazanç', 'zengin olma']
} as const;

// ══════════════════════════════════════════════════════════════════════════
// COMPILED REGEX PATTERNS
// ══════════════════════════════════════════════════════════════════════════

function escapeRegex(str: string): string {
  return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

function buildRegex(phrases: Record<string, readonly string[]>): RegExp {
  const allPhrases = Object.values(phrases).flat();
  const pattern = allPhrases
    .map(phrase => `\\b${escapeRegex(phrase)}\\b`)
    .join('|');
  return new RegExp(pattern, 'gi');
}

export const FORBIDDEN_REGEX_EN = buildRegex(FORBIDDEN_PHRASES_EN);
export const FORBIDDEN_REGEX_TR = buildRegex(FORBIDDEN_PHRASES_TR);

// ══════════════════════════════════════════════════════════════════════════
// SAFE REPLACEMENTS
// ══════════════════════════════════════════════════════════════════════════

export const SAFE_REPLACEMENTS: Record<string, string> = {
  // EN replacements
  'horoscope': 'daily reflection',
  'horoscopes': 'daily reflections',
  'daily horoscope': 'morning reflection',
  'weekly horoscope': 'weekly reflection',
  'zodiac': 'personal style',
  'zodiac sign': 'personal style',
  'sun sign': 'core identity',
  'moon sign': 'emotional style',
  'rising sign': 'outward style',
  'ascendant': 'first impression',
  'birth chart': 'personal profile',
  'natal chart': 'personal profile',
  'astrology': 'self-discovery',
  'astrological': 'personal',
  'prediction': 'insight',
  'predict': 'explore',
  'predicted': 'suggested',
  'prophecy': 'reflection',
  'fortune': 'perspective',
  'fortune telling': 'self-reflection',
  'destiny': 'journey',
  'fate': 'path',
  'fated': 'connected',
  'destined': 'drawn',
  'your future': 'your potential',
  'will happen': 'may unfold',
  'going to happen': 'might emerge',
  'stars say': 'patterns suggest',
  'stars indicate': 'themes show',
  'cosmic energy': 'personal energy',
  'cosmic influence': 'inner influence',
  'psychic': 'intuitive',
  'clairvoyant': 'perceptive',
  'spirit guide': 'inner wisdom',
  'mercury retrograde': 'reflection period',
  'saturn return': 'growth phase',
  'planetary influence': 'seasonal theme',

  // TR replacements
  'burç': 'kişisel stil',
  'burçlar': 'kişisel stiller',
  'burç yorumu': 'günlük düşünce',
  'günlük burç': 'sabah yansıması',
  'haftalık burç': 'haftalık yansıma',
  'doğum haritası': 'kişisel profil',
  'natal harita': 'kişisel profil',
  'yıldız haritası': 'kişilik haritası',
  'astroloji': 'kendini keşfetme',
  'astrolojik': 'kişisel',
  'kehanet': 'içgörü',
  'öngörü': 'bakış açısı',
  'fal': 'yansıma',
  'falcılık': 'öz-yansıma',
  'kader': 'yolculuk',
  'kaderiniz': 'yolculuğunuz',
  'alın yazısı': 'yaşam yolu',
  'geleceğiniz': 'potansiyeliniz',
  'olacak': 'olabilir',
  'gerçekleşecek': 'ortaya çıkabilir',
  'yıldızlar söylüyor': 'örüntüler gösteriyor',
  'kozmik enerji': 'kişisel enerji',
  'kozmik etki': 'iç etki',
  'medyum': 'sezgisel',
  'merkür retrosu': 'yansıma dönemi',
  'gezegen etkisi': 'mevsimsel tema'
};

// ══════════════════════════════════════════════════════════════════════════
// CATEGORY DETECTION
// ══════════════════════════════════════════════════════════════════════════

export type ViolationCategory =
  | 'horoscope'
  | 'zodiac'
  | 'prediction'
  | 'fortune'
  | 'destiny'
  | 'planetary'
  | 'cosmic'
  | 'spiritual'
  | 'medical'
  | 'financial'
  | 'other';

export function categorizePhrase(phrase: string): ViolationCategory {
  const lower = phrase.toLowerCase();

  if (/horoscope|burç/.test(lower)) return 'horoscope';
  if (/zodiac|sign|ascendant/.test(lower)) return 'zodiac';
  if (/predict|kehanet|öngörü/.test(lower)) return 'prediction';
  if (/fortune|fal/.test(lower)) return 'fortune';
  if (/destiny|fate|kader/.test(lower)) return 'destiny';
  if (/planet|gezegen|retrograde|retro/.test(lower)) return 'planetary';
  if (/cosmic|kozmik|star|yıldız/.test(lower)) return 'cosmic';
  if (/spirit|psychic|medyum|ruh/.test(lower)) return 'spiritual';
  if (/cure|heal|treatment|tedavi|şifa/.test(lower)) return 'medical';
  if (/financial|investment|yatırım/.test(lower)) return 'financial';

  return 'other';
}
