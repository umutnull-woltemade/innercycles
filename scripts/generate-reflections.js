#!/usr/bin/env node
// ════════════════════════════════════════════════════════════════════════════
// REFLECTION CONTENT GENERATOR
// ════════════════════════════════════════════════════════════════════════════
//
// Generates safe, Apple-compliant reflection prompts using OpenAI.
// All content passes through safety filter before storage.
//
// USAGE:
//   node scripts/generate-reflections.js --language=en --count=10
//   node scripts/generate-reflections.js --language=tr --count=5 --topic="gratitude"
//
// ENVIRONMENT:
//   SUPABASE_URL       - Supabase project URL
//   SUPABASE_SERVICE_KEY - Supabase service role key
//   OPENAI_API_KEY     - OpenAI API key
// ════════════════════════════════════════════════════════════════════════════

const https = require('https');

// ══════════════════════════════════════════════════════════════════════════
// CONFIGURATION
// ══════════════════════════════════════════════════════════════════════════

const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_KEY;
const OPENAI_API_KEY = process.env.OPENAI_API_KEY;

// Topics per language
const TOPICS = {
  en: [
    'morning intention setting',
    'emotional awareness',
    'personal growth',
    'relationship patterns',
    'work-life balance',
    'creative expression',
    'self-compassion',
    'mindfulness moments',
    'gratitude practice',
    'boundary setting'
  ],
  tr: [
    'sabah niyeti belirleme',
    'duygusal farkındalık',
    'kişisel gelişim',
    'ilişki kalıpları',
    'iş-yaşam dengesi',
    'yaratıcı ifade',
    'öz-şefkat',
    'farkındalık anları',
    'şükran pratiği',
    'sınır belirleme'
  ]
};

// System prompts for safe content generation
const SYSTEM_PROMPTS = {
  en: `You are a mindful reflection prompt generator. Generate thoughtful, open-ended prompts that encourage self-reflection and personal insight.

STRICT RULES:
1. NEVER mention astrology, horoscopes, zodiac signs, birth charts, or planetary influences
2. NEVER make predictions or claims about the future
3. NEVER use fortune-telling language
4. NEVER reference "stars", "cosmos", or "celestial" influences
5. Focus on present-moment awareness, patterns, and personal growth
6. Use soft, inviting language that encourages introspection
7. Keep prompts to 1-2 sentences

Example good prompts:
- "What patterns have you noticed in your energy levels this week?"
- "Take a moment to consider what brings you a sense of peace today."
- "What small act of kindness could you offer yourself right now?"

Example BAD prompts (NEVER generate):
- "The stars suggest you should focus on..."
- "Your destiny this week involves..."
- "Based on your zodiac, you might experience..."`,

  tr: `Sen düşünceli yansıma önerileri üreten bir asistansın. Öz-yansımayı ve kişisel içgörüyü teşvik eden açık uçlu öneriler üret.

KATI KURALLAR:
1. ASLA astroloji, burç, doğum haritası veya gezegen etkilerinden bahsetme
2. ASLA gelecek hakkında tahmin veya iddia yapma
3. ASLA fal dili kullanma
4. ASLA "yıldızlar", "kozmos" veya "göksel" etkilerden bahsetme
5. Şimdiki an farkındalığına, örüntülere ve kişisel gelişime odaklan
6. İç gözlemi teşvik eden yumuşak, davetkar bir dil kullan
7. Önerileri 1-2 cümle ile sınırla`
};

// ══════════════════════════════════════════════════════════════════════════
// FORBIDDEN PHRASES (Inline safety check)
// ══════════════════════════════════════════════════════════════════════════

const FORBIDDEN_PATTERNS = {
  en: [
    /\b(astrology|astrological|astrologer)\b/gi,
    /\b(horoscope|horoscopes)\b/gi,
    /\b(zodiac|zodiac sign|sun sign|moon sign|rising sign)\b/gi,
    /\b(birth chart|natal chart)\b/gi,
    /\b(mercury retrograde|planetary influence)\b/gi,
    /\b(fortune|fortune telling|fortune teller)\b/gi,
    /\b(prediction|predict|prophecy)\b/gi,
    /\b(destiny|fate|fated|destined)\b/gi,
    /\b(your future|will happen|going to happen)\b/gi,
    /\b(stars say|stars indicate|planets indicate)\b/gi,
    /\b(cosmic energy|cosmic influence)\b/gi,
    /\b(psychic|clairvoyant|spirit guide)\b/gi
  ],
  tr: [
    /\b(astroloji|astrolojik|astrolog)\b/gi,
    /\b(burç|burçlar|burç yorumu)\b/gi,
    /\b(doğum haritası|natal harita|yıldız haritası)\b/gi,
    /\b(merkür retrosu|gezegen etkisi)\b/gi,
    /\b(fal|falcılık|falcı)\b/gi,
    /\b(kehanet|öngörü)\b/gi,
    /\b(kader|kaderiniz|alın yazısı)\b/gi,
    /\b(geleceğiniz|olacak|gerçekleşecek)\b/gi,
    /\b(yıldızlar söylüyor|kozmik etki)\b/gi,
    /\b(medyum|durugörü)\b/gi
  ]
};

const SAFE_REPLACEMENTS = {
  'horoscope': 'daily reflection',
  'zodiac sign': 'personal style',
  'birth chart': 'personal profile',
  'prediction': 'insight',
  'destiny': 'journey',
  'fate': 'path',
  'your future': 'your potential',
  'will happen': 'may unfold',
  'stars say': 'patterns suggest',
  'burç': 'kişisel stil',
  'doğum haritası': 'kişisel profil',
  'kehanet': 'içgörü',
  'kader': 'yolculuk',
  'geleceğiniz': 'potansiyeliniz'
};

// ══════════════════════════════════════════════════════════════════════════
// SAFETY FILTER
// ══════════════════════════════════════════════════════════════════════════

function checkSafety(content, locale) {
  const patterns = FORBIDDEN_PATTERNS[locale] || FORBIDDEN_PATTERNS.en;
  const violations = [];

  for (const pattern of patterns) {
    pattern.lastIndex = 0;
    let match;
    while ((match = pattern.exec(content)) !== null) {
      violations.push(match[0]);
    }
  }

  return {
    safe: violations.length === 0,
    violations
  };
}

function sanitizeContent(content, locale) {
  let result = content;

  for (const [forbidden, safe] of Object.entries(SAFE_REPLACEMENTS)) {
    const regex = new RegExp(`\\b${forbidden}\\b`, 'gi');
    result = result.replace(regex, safe);
  }

  return result;
}

// ══════════════════════════════════════════════════════════════════════════
// API HELPERS
// ══════════════════════════════════════════════════════════════════════════

function makeRequest(options, data) {
  return new Promise((resolve, reject) => {
    const req = https.request(options, (res) => {
      let body = '';
      res.on('data', chunk => body += chunk);
      res.on('end', () => {
        try {
          resolve({ status: res.statusCode, data: JSON.parse(body) });
        } catch (e) {
          resolve({ status: res.statusCode, data: body });
        }
      });
    });
    req.on('error', reject);
    if (data) req.write(JSON.stringify(data));
    req.end();
  });
}

async function generateWithOpenAI(language, topic) {
  const options = {
    hostname: 'api.openai.com',
    path: '/v1/chat/completions',
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${OPENAI_API_KEY}`
    }
  };

  const prompt = language === 'en'
    ? `Generate a reflection prompt about: ${topic}`
    : `Şu konu hakkında bir yansıma önerisi üret: ${topic}`;

  const data = {
    model: 'gpt-4-turbo-preview',
    messages: [
      { role: 'system', content: SYSTEM_PROMPTS[language] },
      { role: 'user', content: prompt }
    ],
    temperature: 0.8,
    max_tokens: 150
  };

  const response = await makeRequest(options, data);

  if (response.status !== 200) {
    throw new Error(`OpenAI API error: ${response.status}`);
  }

  return response.data.choices[0]?.message?.content?.trim();
}

async function saveToSupabase(item) {
  const url = new URL(SUPABASE_URL);
  const options = {
    hostname: url.hostname,
    path: '/rest/v1/content_items',
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${SUPABASE_SERVICE_KEY}`,
      'apikey': SUPABASE_SERVICE_KEY,
      'Prefer': 'return=representation'
    }
  };

  const response = await makeRequest(options, item);
  return response;
}

async function logSafetyEvent(event) {
  const url = new URL(SUPABASE_URL);
  const options = {
    hostname: url.hostname,
    path: '/rest/v1/safety_events',
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${SUPABASE_SERVICE_KEY}`,
      'apikey': SUPABASE_SERVICE_KEY
    }
  };

  await makeRequest(options, event);
}

// ══════════════════════════════════════════════════════════════════════════
// MAIN GENERATOR
// ══════════════════════════════════════════════════════════════════════════

async function generateReflections(config) {
  const { language, count, topic } = config;
  const results = {
    generated: 0,
    passed: 0,
    rewritten: 0,
    blocked: 0,
    items: []
  };

  const topics = TOPICS[language] || TOPICS.en;
  const selectedTopic = topic || topics[Math.floor(Math.random() * topics.length)];

  console.log(`\n════════════════════════════════════════════════════════════════`);
  console.log(`  GENERATING ${count} ${language.toUpperCase()} REFLECTIONS`);
  console.log(`  Topic: ${selectedTopic}`);
  console.log(`════════════════════════════════════════════════════════════════\n`);

  for (let i = 0; i < count; i++) {
    try {
      console.log(`[${i + 1}/${count}] Generating...`);

      // Generate content
      const content = await generateWithOpenAI(language, selectedTopic);
      if (!content) {
        console.log(`  ⚠ Empty response, skipping`);
        continue;
      }

      results.generated++;

      // Safety check
      const safety = checkSafety(content, language);
      let finalContent = content;
      let safetyAction = 'pass';

      if (!safety.safe) {
        console.log(`  ⚠ Violations detected: ${safety.violations.join(', ')}`);

        // Try to sanitize
        finalContent = sanitizeContent(content, language);
        const recheckSafety = checkSafety(finalContent, language);

        if (recheckSafety.safe) {
          safetyAction = 'rewrite';
          results.rewritten++;
          console.log(`  ✓ Rewritten successfully`);
        } else {
          safetyAction = 'block';
          results.blocked++;
          console.log(`  ✗ Cannot sanitize, blocked`);

          // Log safety event
          await logSafetyEvent({
            event_type: 'block',
            source: 'content_generator',
            locale: language,
            violation_count: safety.violations.length,
            violation_categories: safety.violations
          });

          continue;
        }
      } else {
        results.passed++;
        console.log(`  ✓ Passed safety check`);
      }

      // Save to database
      const item = {
        locale: language,
        category: 'reflection',
        subcategory: selectedTopic.split(' ')[0].toLowerCase(),
        content: finalContent,
        original_content: safetyAction !== 'pass' ? content : null,
        safety_action: safetyAction,
        safety_violations: safety.violations.length,
        is_active: true,
        is_featured: false
      };

      const saveResult = await saveToSupabase(item);
      if (saveResult.status === 201) {
        results.items.push(saveResult.data);
        console.log(`  ✓ Saved to database`);
      } else {
        console.log(`  ✗ Save failed: ${saveResult.status}`);
      }

      // Rate limiting
      await new Promise(resolve => setTimeout(resolve, 500));

    } catch (error) {
      console.log(`  ✗ Error: ${error.message}`);
    }
  }

  // Summary
  console.log(`\n════════════════════════════════════════════════════════════════`);
  console.log(`  GENERATION COMPLETE`);
  console.log(`════════════════════════════════════════════════════════════════`);
  console.log(`  Generated: ${results.generated}`);
  console.log(`  Passed:    ${results.passed}`);
  console.log(`  Rewritten: ${results.rewritten}`);
  console.log(`  Blocked:   ${results.blocked}`);
  console.log(`════════════════════════════════════════════════════════════════\n`);

  return results;
}

// ══════════════════════════════════════════════════════════════════════════
// CLI ENTRY POINT
// ══════════════════════════════════════════════════════════════════════════

function parseArgs() {
  const args = process.argv.slice(2);
  const config = {
    language: 'en',
    count: 10,
    topic: null
  };

  for (const arg of args) {
    if (arg.startsWith('--language=')) {
      config.language = arg.split('=')[1];
    } else if (arg.startsWith('--count=')) {
      config.count = parseInt(arg.split('=')[1], 10);
    } else if (arg.startsWith('--topic=')) {
      config.topic = arg.split('=')[1];
    } else if (arg === '--help' || arg === '-h') {
      console.log(`
Usage: node generate-reflections.js [options]

Options:
  --language=LANG   Language code (en, tr) [default: en]
  --count=N         Number of prompts to generate [default: 10]
  --topic=TOPIC     Topic to focus on (optional)
  --help, -h        Show this help

Environment:
  SUPABASE_URL          Supabase project URL
  SUPABASE_SERVICE_KEY  Supabase service role key
  OPENAI_API_KEY        OpenAI API key

Examples:
  node generate-reflections.js --language=en --count=5
  node generate-reflections.js --language=tr --topic="gratitude"
`);
      process.exit(0);
    }
  }

  return config;
}

// Validate environment
function validateEnv() {
  const missing = [];
  if (!SUPABASE_URL) missing.push('SUPABASE_URL');
  if (!SUPABASE_SERVICE_KEY) missing.push('SUPABASE_SERVICE_KEY');
  if (!OPENAI_API_KEY) missing.push('OPENAI_API_KEY');

  if (missing.length > 0) {
    console.error(`Missing environment variables: ${missing.join(', ')}`);
    console.error('Set these variables before running the script.');
    process.exit(1);
  }
}

// Run
validateEnv();
const config = parseArgs();

generateReflections(config)
  .then(results => {
    console.log(JSON.stringify(results, null, 2));
    process.exit(0);
  })
  .catch(error => {
    console.error('Fatal error:', error);
    process.exit(1);
  });
