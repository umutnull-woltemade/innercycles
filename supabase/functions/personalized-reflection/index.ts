// ════════════════════════════════════════════════════════════════════════════
// SUPABASE EDGE FUNCTION: Personalized Reflection
// ════════════════════════════════════════════════════════════════════════════
// Generates a personalized AI reflection after a user saves a journal entry.
// Takes the current entry + recent 7-day context and returns insight.
//
// USAGE:
//   POST /functions/v1/personalized-reflection
//   Headers: Authorization: Bearer <user_jwt>
//   Body: {
//     "entry": { "focusArea": "energy", "rating": 4, "note": "..." },
//     "recentEntries": [...],
//     "language": "en",
//     "userName": "Jane"
//   }
// ════════════════════════════════════════════════════════════════════════════

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';

const OPENAI_API_KEY = Deno.env.get('OPENAI_API_KEY');

// Safe language system prompts
const SYSTEM_PROMPTS: Record<string, string> = {
  en: `You are a compassionate journaling companion. The user just saved a journal entry. Generate a short, personalized reflection (2-3 sentences) based on their entry and recent patterns.

STRICT RULES:
1. NEVER mention astrology, horoscopes, zodiac, birth charts, or planetary influences
2. NEVER make predictions about the future
3. NEVER use fortune-telling language
4. Reference specific details from their entry to feel personal
5. Use warm, encouraging language — like a supportive friend
6. If you notice patterns in their recent entries, mention them gently
7. End with a reflective question or gentle suggestion
8. Keep under 80 words`,

  tr: `Sen şefkatli bir günlük arkadaşısın. Kullanıcı az önce bir günlük kaydı kaydetti. Girişlerine ve son örüntülerine dayalı kısa, kişiselleştirilmiş bir yansıma (2-3 cümle) üret.

KATI KURALLAR:
1. ASLA astroloji, burç, doğum haritası veya gezegen etkilerinden bahsetme
2. ASLA gelecek hakkında tahmin yapma
3. ASLA fal dili kullanma
4. Kişisel hissettirmek için girişlerinden belirli ayrıntılara değin
5. Sıcak, cesaretlendirici bir dil kullan — destekleyici bir arkadaş gibi
6. Son girişlerinde bir örüntü fark edersen nazikçe bahset
7. Düşündürücü bir soru veya nazik bir öneriyle bitir
8. 80 kelimeyi aşma`,
};

// Forbidden patterns
const FORBIDDEN: RegExp[] = [
  /\b(astrology|horoscope|zodiac|birth chart|natal chart)\b/gi,
  /\b(prediction|prophecy|fortune|destiny|fate)\b/gi,
  /\b(your future|will happen|stars say|planets)\b/gi,
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

    const { entry, recentEntries = [], language = 'en', userName } = await req.json();

    if (!entry) {
      return new Response(
        JSON.stringify({ error: 'Missing entry data' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Build context from recent entries
    const recentSummary = recentEntries
      .slice(0, 7)
      .map((e: any, i: number) => {
        const daysAgo = i === 0 ? 'today' : `${i} day(s) ago`;
        return `- ${daysAgo}: ${e.focusArea} (${e.rating}/5)${e.note ? ` — "${e.note.substring(0, 100)}"` : ''}`;
      })
      .join('\n');

    const userMessage = language === 'tr'
      ? `Kullanıcı adı: ${userName || 'Kullanıcı'}
Son giriş: ${entry.focusArea} alanında ${entry.rating}/5 puanla.${entry.note ? `\nNot: "${entry.note.substring(0, 300)}"` : ''}

Son 7 gün:
${recentSummary || 'İlk giriş'}

Bu girişe göre kişisel bir yansıma üret.`
      : `User name: ${userName || 'Friend'}
Latest entry: ${entry.focusArea} area rated ${entry.rating}/5.${entry.note ? `\nNote: "${entry.note.substring(0, 300)}"` : ''}

Recent 7 days:
${recentSummary || 'First entry'}

Generate a personalized reflection based on this entry.`;

    const response = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${OPENAI_API_KEY}`,
      },
      body: JSON.stringify({
        model: 'gpt-4o-mini',
        messages: [
          { role: 'system', content: SYSTEM_PROMPTS[language] || SYSTEM_PROMPTS.en },
          { role: 'user', content: userMessage },
        ],
        temperature: 0.7,
        max_tokens: 200,
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
    const reflection = data.choices[0]?.message?.content?.trim();

    if (!reflection) {
      return new Response(
        JSON.stringify({ error: 'Empty response from AI' }),
        { status: 502, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Safety check
    if (!isSafe(reflection)) {
      return new Response(
        JSON.stringify({ error: 'Response failed safety check', reflection: null }),
        { status: 200, headers: { 'Content-Type': 'application/json' } }
      );
    }

    return new Response(
      JSON.stringify({ success: true, reflection }),
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
