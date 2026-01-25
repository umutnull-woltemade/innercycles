/**
 * Astrobobo Firebase Cloud Functions
 * Dream interpretation, cosmic guidance, and user management
 */

const { onRequest, onCall } = require("firebase-functions/v2/https");
const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");

// Initialize Firebase Admin
initializeApp();
const db = getFirestore();

// ============================================
// DREAM INTERPRETATION API
// ============================================

/**
 * Interpret a dream based on symbols and zodiac sign
 * Callable function from Flutter app
 */
exports.interpretDream = onCall({ region: "europe-west1" }, async (request) => {
  const { dreamText, zodiacSign, locale = "tr" } = request.data;

  if (!dreamText || dreamText.length < 10) {
    throw new Error("Dream text must be at least 10 characters");
  }

  // Extract symbols from dream
  const symbols = extractDreamSymbols(dreamText, locale);

  // Get zodiac-specific interpretation
  const zodiacContext = getZodiacContext(zodiacSign);

  // Build interpretation
  const interpretation = {
    free: {
      reflection: generateReflection(dreamText, zodiacSign, locale),
      symbols: symbols.slice(0, 2), // Free users get 2 symbols
      emotion: detectDominantEmotion(dreamText, locale),
    },
    premium: {
      symbols: symbols, // All symbols
      deepAnalysis: generateDeepAnalysis(dreamText, zodiacSign, symbols, locale),
      guidance: generateGuidance(zodiacSign, symbols, locale),
      zodiacContext: zodiacContext,
    },
    metadata: {
      symbolCount: symbols.length,
      createdAt: new Date().toISOString(),
      locale: locale,
    }
  };

  // Save to Firestore if user is authenticated
  if (request.auth) {
    await db.collection("users").doc(request.auth.uid).collection("dreams").add({
      text: dreamText,
      interpretation: interpretation,
      zodiacSign: zodiacSign,
      createdAt: FieldValue.serverTimestamp(),
    });
  }

  return interpretation;
});

/**
 * Get symbol dictionary for SEO pages
 */
exports.getSymbol = onRequest({ region: "europe-west1", cors: true }, async (req, res) => {
  const slug = req.query.slug || req.params.slug;

  if (!slug) {
    res.status(400).json({ error: "Symbol slug required" });
    return;
  }

  const symbolDoc = await db.collection("dreamSymbols").doc(slug).get();

  if (!symbolDoc.exists) {
    res.status(404).json({ error: "Symbol not found" });
    return;
  }

  res.json(symbolDoc.data());
});

/**
 * List all symbols for sitemap generation
 */
exports.listSymbols = onRequest({ region: "europe-west1", cors: true }, async (req, res) => {
  const limit = parseInt(req.query.limit) || 100;
  const offset = parseInt(req.query.offset) || 0;

  const snapshot = await db.collection("dreamSymbols")
    .orderBy("popularity", "desc")
    .limit(limit)
    .offset(offset)
    .get();

  const symbols = snapshot.docs.map(doc => ({
    slug: doc.id,
    ...doc.data()
  }));

  res.json({
    symbols,
    count: symbols.length,
    hasMore: symbols.length === limit
  });
});

// ============================================
// USER MEMORY SYSTEM (Retention Engine)
// ============================================

/**
 * Update user memory when a new dream is saved
 */
exports.updateUserMemory = onDocumentCreated(
  "users/{userId}/dreams/{dreamId}",
  async (event) => {
    const snapshot = event.data;
    const userId = event.params.userId;
    const dreamData = snapshot.data();

    // Extract patterns from dream
    const symbols = dreamData.interpretation?.premium?.symbols || [];
    const emotion = dreamData.interpretation?.free?.emotion;

    // Update user memory document
    const memoryRef = db.collection("users").doc(userId).collection("memory").doc("patterns");

    await memoryRef.set({
      recurringSymbols: FieldValue.arrayUnion(...symbols.map(s => s.name)),
      emotionHistory: FieldValue.arrayUnion({
        emotion: emotion,
        date: new Date().toISOString()
      }),
      dreamCount: FieldValue.increment(1),
      lastDreamAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),
    }, { merge: true });
  }
);

// ============================================
// HELPER FUNCTIONS
// ============================================

/**
 * Extract dream symbols from text
 */
function extractDreamSymbols(dreamText, locale) {
  const lowerText = dreamText.toLowerCase();
  const symbols = [];

  // Turkish dream symbols
  const symbolPatterns = {
    // Water
    su: { name: "Su", category: "element", meaning: "Duygular ve bilinçaltı" },
    deniz: { name: "Deniz", category: "nature", meaning: "Sonsuzluk ve derinlik" },
    nehir: { name: "Nehir", category: "nature", meaning: "Hayat akışı" },
    yagmur: { name: "Yağmur", category: "weather", meaning: "Arınma ve yenilenme" },

    // Flying/Falling
    ucmak: { name: "Uçmak", category: "action", meaning: "Özgürlük ve potansiyel" },
    dusmek: { name: "Düşmek", category: "action", meaning: "Kontrol kaybı korkusu" },

    // Animals
    yilan: { name: "Yılan", category: "animal", meaning: "Dönüşüm ve şifa" },
    kopek: { name: "Köpek", category: "animal", meaning: "Sadakat ve dostluk" },
    kedi: { name: "Kedi", category: "animal", meaning: "Bağımsızlık ve sezgi" },
    at: { name: "At", category: "animal", meaning: "Güç ve özgürlük" },
    kus: { name: "Kuş", category: "animal", meaning: "Ruhsal yükseliş" },

    // Places
    ev: { name: "Ev", category: "place", meaning: "Benlik ve güvenlik" },
    okul: { name: "Okul", category: "place", meaning: "Öğrenme ve gelişim" },
    orman: { name: "Orman", category: "place", meaning: "Bilinçaltı keşfi" },
    dag: { name: "Dağ", category: "place", meaning: "Hedefler ve zorluklar" },

    // People
    anne: { name: "Anne", category: "person", meaning: "Koruma ve şefkat" },
    baba: { name: "Baba", category: "person", meaning: "Otorite ve rehberlik" },
    bebek: { name: "Bebek", category: "person", meaning: "Yeni başlangıçlar" },
    yabanc: { name: "Yabancı", category: "person", meaning: "Bilinmeyen yönler" },

    // Objects
    anahtar: { name: "Anahtar", category: "object", meaning: "Çözümler ve fırsatlar" },
    para: { name: "Para", category: "object", meaning: "Değer ve bolluk" },
    ayna: { name: "Ayna", category: "object", meaning: "Öz farkındalık" },

    // Events
    olum: { name: "Ölüm", category: "event", meaning: "Dönüşüm ve son" },
    dugun: { name: "Düğün", category: "event", meaning: "Birlik ve bağlılık" },
    kavga: { name: "Kavga", category: "event", meaning: "İç çatışma" },
    koval: { name: "Kovalanmak", category: "event", meaning: "Kaçınılan konular" },
  };

  for (const [pattern, symbolData] of Object.entries(symbolPatterns)) {
    if (lowerText.includes(pattern)) {
      symbols.push({
        ...symbolData,
        pattern: pattern,
        found: true
      });
    }
  }

  return symbols;
}

/**
 * Get zodiac-specific context
 */
function getZodiacContext(zodiacSign) {
  const contexts = {
    aries: { element: "fire", quality: "cardinal", ruler: "Mars", theme: "aksiyon ve cesaret" },
    taurus: { element: "earth", quality: "fixed", ruler: "Venus", theme: "değer ve güvenlik" },
    gemini: { element: "air", quality: "mutable", ruler: "Mercury", theme: "iletişim ve merak" },
    cancer: { element: "water", quality: "cardinal", ruler: "Moon", theme: "duygular ve ev" },
    leo: { element: "fire", quality: "fixed", ruler: "Sun", theme: "yaratıcılık ve ifade" },
    virgo: { element: "earth", quality: "mutable", ruler: "Mercury", theme: "analiz ve hizmet" },
    libra: { element: "air", quality: "cardinal", ruler: "Venus", theme: "denge ve ilişkiler" },
    scorpio: { element: "water", quality: "fixed", ruler: "Pluto", theme: "dönüşüm ve derinlik" },
    sagittarius: { element: "fire", quality: "mutable", ruler: "Jupiter", theme: "keşif ve anlam" },
    capricorn: { element: "earth", quality: "cardinal", ruler: "Saturn", theme: "yapı ve başarı" },
    aquarius: { element: "air", quality: "fixed", ruler: "Uranus", theme: "yenilik ve toplum" },
    pisces: { element: "water", quality: "mutable", ruler: "Neptune", theme: "sezgi ve ruhsallık" },
  };

  return contexts[zodiacSign?.toLowerCase()] || contexts.aries;
}

/**
 * Detect dominant emotion in dream
 */
function detectDominantEmotion(dreamText, locale) {
  const lowerText = dreamText.toLowerCase();

  const emotions = {
    fear: ["korku", "korkut", "kabus", "dehşet", "panik", "kaç"],
    joy: ["mutlu", "sevinç", "neşe", "güzel", "harika", "muhteşem"],
    sadness: ["üzgün", "ağla", "gözyaşı", "kayıp", "özlem", "hüzün"],
    anger: ["kız", "sinir", "öfke", "kavga", "bağır"],
    love: ["aşk", "sev", "öp", "kucak", "sevgili"],
    confusion: ["karış", "kaybol", "anlam", "garip", "tuhaf"],
    peace: ["huzur", "sakin", "rahat", "dingin"],
  };

  let dominantEmotion = "neutral";
  let maxCount = 0;

  for (const [emotion, keywords] of Object.entries(emotions)) {
    const count = keywords.filter(k => lowerText.includes(k)).length;
    if (count > maxCount) {
      maxCount = count;
      dominantEmotion = emotion;
    }
  }

  return dominantEmotion;
}

/**
 * Generate reflection text
 */
function generateReflection(dreamText, zodiacSign, locale) {
  const context = getZodiacContext(zodiacSign);
  return `${context.element === "water" ? "Su elementi" : context.element === "fire" ? "Ateş elementi" : context.element === "earth" ? "Toprak elementi" : "Hava elementi"} enerjinle, bu rüya sana ${context.theme} hakkında önemli mesajlar taşıyor.`;
}

/**
 * Generate deep analysis (premium)
 */
function generateDeepAnalysis(dreamText, zodiacSign, symbols, locale) {
  const context = getZodiacContext(zodiacSign);
  const symbolNames = symbols.map(s => s.name).join(", ");

  return {
    overview: `Rüyandaki semboller (${symbolNames}) ${context.theme} temasıyla bağlantılı görünüyor.`,
    patterns: symbols.map(s => ({
      symbol: s.name,
      interpretation: `${s.name}: ${s.meaning}. ${context.element} elementi açısından bu sembol daha derin bir anlam taşıyor.`
    })),
    recommendation: `${context.ruler} gezegeninin etkisi altında, bu dönemde ${context.theme} konularına odaklanman önerilir.`
  };
}

/**
 * Generate guidance (premium)
 */
function generateGuidance(zodiacSign, symbols, locale) {
  const context = getZodiacContext(zodiacSign);

  return {
    daily: `Bugün ${context.theme} konusunda farkındalığını artır.`,
    action: `Rüyandaki sembolleri günlük hayatınla ilişkilendir.`,
    reflection: `${context.element} elementi enerjini kullanarak meditasyon yap.`
  };
}
