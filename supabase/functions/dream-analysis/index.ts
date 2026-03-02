// ════════════════════════════════════════════════════════════════════════════
// SUPABASE EDGE FUNCTION: Dream Analysis
// ════════════════════════════════════════════════════════════════════════════
// Generates a rich, 7-dimensional AI dream interpretation using GPT-4o-mini.
// Takes the dream text, detected symbols, emotional tone, and moon phase.
// Returns structured JSON matching FullDreamInterpretation model.
//
// USAGE:
//   POST /functions/v1/dream-analysis
//   Headers: Authorization: Bearer <user_jwt>
//   Body: {
//     "dreamText": "...",
//     "emotion": "korku",
//     "isRecurring": false,
//     "moonPhase": "Yeni Ay",
//     "detectedSymbols": ["su", "uçmak"],
//     "language": "tr"
//   }
// ════════════════════════════════════════════════════════════════════════════

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';

const OPENAI_API_KEY = Deno.env.get('OPENAI_API_KEY');

const SYSTEM_PROMPTS: Record<string, string> = {
  tr: `Sen modern bir rüya analistisin. Jung, Campbell ve derinlik psikolojisinin bakış açısıyla rüyaları 7 boyutta analiz eder, şiirsel ama derin içgörüler sunarsın.

KATI KURALLAR:
1. ASLA astroloji, burç, doğum haritası veya gezegen etkilerinden bahsetme
2. ASLA gelecek tahmini yapma veya kehanet dili kullanma
3. ASLA tıbbi veya psikolojik teşhis koyma
4. Ezotetik ama bilimsel görünümlü ol
5. Her yorumu kişiselleştir
6. Şiirsel ama pratik ol
7. Türkçe zengin, akıcı, derin kullan
8. JSON formatında yanıt ver`,

  en: `You are a modern dream analyst. You analyze dreams through 7 dimensions using Jung, Campbell, and depth psychology perspectives, offering poetic yet deep insights.

STRICT RULES:
1. NEVER mention astrology, horoscopes, zodiac, birth charts, or planetary influences
2. NEVER make predictions about the future or use fortune-telling language
3. NEVER provide medical or psychological diagnoses
4. Be esoteric but grounded in psychology
5. Personalize every interpretation
6. Be poetic but practical
7. Use rich, flowing language
8. Respond in JSON format`,
};

const FORBIDDEN: RegExp[] = [
  /\b(astrology|horoscope|zodiac|birth chart|natal chart)\b/gi,
  /\b(prediction|prophecy|fortune|destiny|fate)\b/gi,
  /\b(astroloji|burç|doğum haritası|yıldız haritası|kehanet|fal|kader)\b/gi,
];

function isSafe(text: string): boolean {
  for (const pattern of FORBIDDEN) {
    pattern.lastIndex = 0;
    if (pattern.test(text)) return false;
  }
  return true;
}

serve(async (req: Request) => {
  try {
    if (!OPENAI_API_KEY) {
      return new Response(
        JSON.stringify({ error: 'OPENAI_API_KEY not configured' }),
        { status: 503, headers: { 'Content-Type': 'application/json' } }
      );
    }

    const {
      dreamText,
      emotion = '',
      wakingFeeling = '',
      isRecurring = false,
      recurringCount,
      moonPhase = '',
      detectedSymbols = [],
      language = 'tr',
    } = await req.json();

    if (!dreamText || dreamText.length < 10) {
      return new Response(
        JSON.stringify({ error: 'Dream text too short' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    const symbolList = detectedSymbols.join(', ') || 'none detected';

    const jsonSchema = `{
  "ancientIntro": "3-4 sentence mythological/poetic opening",
  "coreMessage": "single powerful insight sentence",
  "symbols": [{ "symbol": "name", "symbolEmoji": "emoji", "universalMeaning": "...", "personalContext": "...", "shadowAspect": "...", "lightAspect": "..." }],
  "archetypeName": "Shadow|Anima|Animus|Hero|Wise Old Man|etc",
  "archetypeConnection": "2-3 sentences about the archetype's message",
  "emotionalReading": { "dominantEmotion": "...", "surfaceMessage": "...", "deeperMeaning": "...", "shadowQuestion": "...", "integrationPath": "..." },
  "timingMessage": "why this dream came now",
  "whyNow": "seasonal/life-stage reflection",
  "lightShadow": { "lightMessage": "positive potential", "shadowMessage": "awareness needed", "integrationPath": "...", "archetype": "..." },
  "guidance": { "todayAction": "...", "reflectionQuestion": "...", "weeklyFocus": "...", "avoidance": "..." },
  "whisperQuote": "one memorable aphorism",
  "shareCard": { "emoji": "...", "quote": "10-15 word shareable quote", "category": "wisdom|shadow|light|action" }
}`;

    const userMessage = language === 'tr'
      ? `RÜYA: "${dreamText.substring(0, 1000)}"

DUYGUSAL TON: ${emotion || 'belirtilmedi'}
UYANIŞ HİSSİ: ${wakingFeeling || 'belirtilmedi'}
TEKRARLAYAN: ${isRecurring ? `Evet (${recurringCount || '?'} kez)` : 'Hayır'}
AY FAZI: ${moonPhase || 'belirtilmedi'}
TESPİT EDİLEN SEMBOLLER: ${symbolList}

Bu rüyayı 7 boyutlu analiz et. JSON formatında yanıt ver:
${jsonSchema}`
      : `DREAM: "${dreamText.substring(0, 1000)}"

EMOTIONAL TONE: ${emotion || 'not specified'}
WAKING FEELING: ${wakingFeeling || 'not specified'}
RECURRING: ${isRecurring ? `Yes (${recurringCount || '?'} times)` : 'No'}
MOON PHASE: ${moonPhase || 'not specified'}
DETECTED SYMBOLS: ${symbolList}

Analyze this dream across 7 dimensions. Respond in JSON:
${jsonSchema}`;

    const response = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${OPENAI_API_KEY}`,
      },
      body: JSON.stringify({
        model: 'gpt-4o-mini',
        messages: [
          { role: 'system', content: SYSTEM_PROMPTS[language] || SYSTEM_PROMPTS.tr },
          { role: 'user', content: userMessage },
        ],
        temperature: 0.8,
        max_tokens: 1500,
        response_format: { type: 'json_object' },
      }),
    });

    if (!response.ok) {
      const error = await response.text();
      console.error('OpenAI error:', response.status, error);
      return new Response(
        JSON.stringify({ error: 'AI generation failed', status: response.status }),
        { status: 502, headers: { 'Content-Type': 'application/json' } }
      );
    }

    const data = await response.json();
    const content = data.choices[0]?.message?.content?.trim();

    if (!content) {
      return new Response(
        JSON.stringify({ error: 'Empty response from AI' }),
        { status: 502, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Safety check on raw text
    if (!isSafe(content)) {
      return new Response(
        JSON.stringify({ error: 'Response failed safety check' }),
        { status: 200, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Parse and return structured response
    const interpretation = JSON.parse(content);
    return new Response(
      JSON.stringify({ success: true, interpretation }),
      { headers: { 'Content-Type': 'application/json' } }
    );
  } catch (error) {
    console.error('Error:', error);
    return new Response(
      JSON.stringify({ error: (error as Error).message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
});
