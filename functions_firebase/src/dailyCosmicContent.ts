/**
 * PART 4: Daily Auto-Generation System
 *
 * Cloud Function that runs daily to generate cosmic content for all zodiac signs.
 * Stores results in Firestore for app consumption.
 */

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

// Initialize if not already done
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

// ═══════════════════════════════════════════════════════════════
// TYPES
// ═══════════════════════════════════════════════════════════════

interface ZodiacSign {
  id: string;
  nameTr: string;
  symbol: string;
}

interface CosmicContent {
  heroHeadline: string;
  personalMessage: string;
  microMessages: string[];
  shadowChallenge: string;
  lightStrength: string;
  planetaryAction: string;
  collectiveMoment: string;
  premiumCuriosity: string;
}

interface StorySlide {
  slideNumber: number;
  mainText: string;
  subText: string | null;
  accent: string;
}

interface SocialFormats {
  storySlides: StorySlide[];
  squareCaption: string;
  portraitCaption: string;
  reelsScript: string;
}

interface DailyContent {
  date: string;
  sign: ZodiacSign;
  masterContent: CosmicContent;
  socialFormats: SocialFormats;
  generatedAt: admin.firestore.Timestamp;
  moonPhase: string;
}

// ═══════════════════════════════════════════════════════════════
// ZODIAC DATA
// ═══════════════════════════════════════════════════════════════

const ZODIAC_SIGNS: ZodiacSign[] = [
  { id: 'aries', nameTr: 'Koç', symbol: '♈' },
  { id: 'taurus', nameTr: 'Boğa', symbol: '♉' },
  { id: 'gemini', nameTr: 'İkizler', symbol: '♊' },
  { id: 'cancer', nameTr: 'Yengeç', symbol: '♋' },
  { id: 'leo', nameTr: 'Aslan', symbol: '♌' },
  { id: 'virgo', nameTr: 'Başak', symbol: '♍' },
  { id: 'libra', nameTr: 'Terazi', symbol: '♎' },
  { id: 'scorpio', nameTr: 'Akrep', symbol: '♏' },
  { id: 'sagittarius', nameTr: 'Yay', symbol: '♐' },
  { id: 'capricorn', nameTr: 'Oğlak', symbol: '♑' },
  { id: 'aquarius', nameTr: 'Kova', symbol: '♒' },
  { id: 'pisces', nameTr: 'Balık', symbol: '♓' },
];

// ═══════════════════════════════════════════════════════════════
// CONTENT GENERATION
// ═══════════════════════════════════════════════════════════════

function getMoonPhase(date: Date): string {
  const knownNewMoon = new Date('2000-01-06T18:14:00Z');
  const daysSince = (date.getTime() - knownNewMoon.getTime()) / 86400000;
  const lunarCycle = 29.53059;
  const phaseDay = daysSince % lunarCycle;

  if (phaseDay < 1.85) return 'yeni_ay';
  if (phaseDay < 7.38) return 'hilal_buyuyen';
  if (phaseDay < 11.07) return 'ilk_dordun';
  if (phaseDay < 14.77) return 'siskin_buyuyen';
  if (phaseDay < 18.46) return 'dolunay';
  if (phaseDay < 22.15) return 'siskin_kuculen';
  if (phaseDay < 25.84) return 'son_dordun';
  return 'hilal_kuculen';
}

function generateMasterContent(sign: ZodiacSign, dayOfYear: number): CosmicContent {
  // Seeded random for consistency within same day
  const seed = dayOfYear + sign.id.charCodeAt(0);
  const random = (max: number) => ((seed * 9301 + 49297) % 233280) % max;

  const headlines: Record<string, string[]> = {
    aries: ['Bugün cesaretin test ediliyor.', 'Ateşin içinden geçme zamanı.', 'Liderlik sende.'],
    taurus: ['Köklerin seni taşıyor.', 'Sabır bugün en büyük gücün.', 'Değerini bil.'],
    gemini: ['İki dünya arasında dans ediyorsun.', 'Kelimeler bugün silahın.', 'Merakın kapıları açıyor.'],
    cancer: ['Ay seninle konuşuyor.', 'Duygularının derinliğinde cevap var.', 'Koruyucu kabuğun altında güç saklı.'],
    leo: ['Güneş senin için doğuyor.', 'Işığın karanlığı yırtıyor.', 'Tahtın hazır.'],
    virgo: ['Detaylarda evren gizli.', 'Mükemmellik değil, anlam ara.', 'Şifa veren ellerin var.'],
    libra: ['Denge noktasındasın.', 'Güzellik ve adalet senin silahın.', 'İlişkilerde dönüşüm zamanı.'],
    scorpio: ['Karanlıktan korkmuyorsun.', 'Dönüşüm kapıda.', 'Derinliklerde hazine var.'],
    sagittarius: ['Ufuk seni çağırıyor.', 'Ok yaydan çıkmak üzere.', 'Özgürlük senin doğum hakkın.'],
    capricorn: ['Zirve görüş mesafesinde.', 'Disiplin bugün süper gücün.', 'Zamanın ustası sensin.'],
    aquarius: ['Geleceği sen yazıyorsun.', 'Farklılığın senin armağanın.', 'Devrim içinden başlıyor.'],
    pisces: ['Rüyalar gerçeğe dönüşüyor.', 'Sezgilerin keskin.', 'Okyanus derinliğinde yüzüyorsun.'],
  };

  const microMessages: Record<string, string[]> = {
    aries: ['Sessizliğin bugün daha çok iş görüyor.', 'Herkes enerjine erişmeyi hak etmiyor.', 'Sabır en keskin silahın.'],
    taurus: ['Bırakmak bazen sahiplenmektir.', 'Değişim düşman değil, davet.', 'Köklerin sağlam.'],
    gemini: ['Her düşünceni takip etmek zorunda değilsin.', 'Sessizlik de bir cevap.', 'Çelişkilerin seni zenginleştiriyor.'],
    cancer: ['Kırılganlık zayıflık değil.', 'Geçmiş öğretmen, ev değil.', 'Sevilmek için mükemmel olmana gerek yok.'],
    leo: ['Alkış olmadan da değerlisin.', 'Görünmez olduğunda kim oluyorsun?', 'Sen zaten ışıksın.'],
    virgo: ['Kusursuz değil, gerçek ol.', 'Yardım istemek zayıflık değil.', 'Büyük resmi gör.'],
    libra: ['Hayır demek de sevgi.', 'Dengeyi kendinde bul.', 'Kararsızlık da bir karar.'],
    scorpio: ['Kontrol illüzyon.', 'Güvenmek risk değil, hediye.', 'Affetmek seni özgürleştirir.'],
    sagittarius: ['Kaçış çözüm değil.', 'Cevap burada da olabilir.', 'Macera içeride de var.'],
    capricorn: ['Başarı mutluluk garantisi değil.', 'Mola vermek vazgeçmek değil.', 'Yolculuk önemli.'],
    aquarius: ['Farklı olmak için farklı olma.', 'Kalp de akıl kadar önemli.', 'Devrim önce kendinde.'],
    pisces: ['Rüya güzel, gerçeklik de.', 'Sınırlar sevgisizlik değil.', 'Kaçış değil, yüzleş.'],
  };

  const signHeadlines = headlines[sign.id] || headlines.aries;
  const signMicros = microMessages[sign.id] || microMessages.aries;

  return {
    heroHeadline: signHeadlines[random(signHeadlines.length)],
    personalMessage: `Bugün ${sign.nameTr} burçları için özel bir gün. İçindeki ışığı takip et.`,
    microMessages: signMicros,
    shadowChallenge: 'İç huzursuzluk dikkat istiyor.',
    lightStrength: 'Sezgilerin güçlü, güven.',
    planetaryAction: 'Bugün bir adım at.',
    collectiveMoment: `Senin burcundan pek çok kişi bugün aynı şeyi hissediyor.`,
    premiumCuriosity: 'Bu, bugünün sadece bir katmanı.',
  };
}

function generateSocialFormats(content: CosmicContent, sign: ZodiacSign): SocialFormats {
  const storySlides: StorySlide[] = [
    { slideNumber: 1, mainText: content.heroHeadline, subText: `${sign.symbol} ${sign.nameTr}`, accent: '✨' },
    { slideNumber: 2, mainText: content.microMessages[0], subText: null, accent: '✦' },
    { slideNumber: 3, mainText: content.microMessages[1], subText: null, accent: '✧' },
    { slideNumber: 4, mainText: content.planetaryAction, subText: null, accent: '☉' },
    { slideNumber: 5, mainText: `Gölge: ${content.shadowChallenge}`, subText: `Işık: ${content.lightStrength}`, accent: '☯' },
    { slideNumber: 6, mainText: content.premiumCuriosity, subText: '@astrobobo', accent: '✨' },
  ];

  const hashtags = `#${sign.id} #${sign.nameTr.toLowerCase()} #astroloji #burcyorumu #kozmikenerji #astrobobo`;

  return {
    storySlides,
    squareCaption: `${content.heroHeadline}\n\n${content.microMessages[0]}\n\n${hashtags}`,
    portraitCaption: `${sign.symbol} ${sign.nameTr}\n\n${content.heroHeadline}\n\n${content.microMessages[0]}\n\n${hashtags}`,
    reelsScript: `[0-3s] ${sign.symbol} ${sign.nameTr}\n[4-7s] ${content.heroHeadline}\n[8-12s] ${content.microMessages[0]}\n[13-16s] ${content.planetaryAction}\n[17-18s] ${content.premiumCuriosity}`,
  };
}

// ═══════════════════════════════════════════════════════════════
// CLOUD FUNCTION
// ═══════════════════════════════════════════════════════════════

/**
 * Daily cron job: Runs at 00:05 Istanbul time every day
 * Generates cosmic content for all 12 zodiac signs
 */
export const generateDailyCosmicContent = functions
  .region('europe-west1')
  .pubsub.schedule('5 0 * * *')
  .timeZone('Europe/Istanbul')
  .onRun(async (context) => {
    const today = new Date();
    const dateString = today.toISOString().split('T')[0]; // YYYY-MM-DD
    const dayOfYear = Math.floor((today.getTime() - new Date(today.getFullYear(), 0, 0).getTime()) / 86400000);
    const moonPhase = getMoonPhase(today);

    console.log(`Generating daily cosmic content for ${dateString}`);

    const batch = db.batch();

    for (const sign of ZODIAC_SIGNS) {
      try {
        const masterContent = generateMasterContent(sign, dayOfYear);
        const socialFormats = generateSocialFormats(masterContent, sign);

        const dailyContent: DailyContent = {
          date: dateString,
          sign,
          masterContent,
          socialFormats,
          generatedAt: admin.firestore.Timestamp.now(),
          moonPhase,
        };

        // Store in daily_cosmic_content/{date}/signs/{signId}
        const docRef = db
          .collection('daily_cosmic_content')
          .doc(dateString)
          .collection('signs')
          .doc(sign.id);

        batch.set(docRef, dailyContent);

        // Also update latest content for quick access
        const latestRef = db.collection('latest_cosmic_content').doc(sign.id);
        batch.set(latestRef, dailyContent);

        console.log(`Generated content for ${sign.nameTr}`);
      } catch (error) {
        console.error(`Error generating content for ${sign.nameTr}:`, error);
      }
    }

    await batch.commit();
    console.log(`Daily cosmic content generation complete for ${dateString}`);

    return null;
  });

/**
 * HTTP endpoint for manual trigger or testing
 */
export const generateCosmicContentManual = functions
  .region('europe-west1')
  .https.onRequest(async (req, res) => {
    // Simple auth check
    const authHeader = req.headers.authorization;
    if (authHeader !== `Bearer ${process.env.ADMIN_SECRET}`) {
      res.status(401).send('Unauthorized');
      return;
    }

    const today = new Date();
    const dateString = today.toISOString().split('T')[0];
    const dayOfYear = Math.floor((today.getTime() - new Date(today.getFullYear(), 0, 0).getTime()) / 86400000);
    const moonPhase = getMoonPhase(today);

    const results: Record<string, DailyContent> = {};

    for (const sign of ZODIAC_SIGNS) {
      const masterContent = generateMasterContent(sign, dayOfYear);
      const socialFormats = generateSocialFormats(masterContent, sign);

      results[sign.id] = {
        date: dateString,
        sign,
        masterContent,
        socialFormats,
        generatedAt: admin.firestore.Timestamp.now(),
        moonPhase,
      };
    }

    res.json({
      success: true,
      date: dateString,
      moonPhase,
      content: results,
    });
  });

/**
 * Get content for a specific sign and date
 */
export const getCosmicContent = functions
  .region('europe-west1')
  .https.onCall(async (data, context) => {
    const { signId, date } = data;

    if (!signId) {
      throw new functions.https.HttpsError('invalid-argument', 'Sign ID required');
    }

    const targetDate = date || new Date().toISOString().split('T')[0];

    // Try to get from daily content
    const docRef = db
      .collection('daily_cosmic_content')
      .doc(targetDate)
      .collection('signs')
      .doc(signId);

    const doc = await docRef.get();

    if (doc.exists) {
      return doc.data();
    }

    // Fallback to latest
    const latestRef = db.collection('latest_cosmic_content').doc(signId);
    const latestDoc = await latestRef.get();

    if (latestDoc.exists) {
      return latestDoc.data();
    }

    throw new functions.https.HttpsError('not-found', 'Content not found');
  });
