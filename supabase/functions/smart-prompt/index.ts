// ════════════════════════════════════════════════════════════════════════════
// SUPABASE EDGE FUNCTION: Smart Daily Prompt
// ════════════════════════════════════════════════════════════════════════════
// Generates a personalized daily journal prompt based on the user's recent
// entries, patterns, and focus areas. Returns a single question.
//
// USAGE:
//   POST /functions/v1/smart-prompt
//   Headers: Authorization: Bearer <user_jwt>
//   Body: {
//     "recentEntries": [...],
//     "weakestArea": "energy",
//     "currentStreak": 5,
//     "language": "en"
//   }
// ════════════════════════════════════════════════════════════════════════════

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';

const OPENAI_API_KEY = Deno.env.get('OPENAI_API_KEY');

const SYSTEM_PROMPTS: Record<string, string> = {
  en: `You are a journaling prompt designer. Generate ONE personalized journal question for the user based on their recent entries and patterns.

STRICT RULES:
1. NEVER mention astrology, horoscopes, zodiac, birth charts, or planetary influences
2. NEVER make predictions about the future
3. NEVER use fortune-telling language
4. The question should be thought-provoking, personal, and draw from their recent patterns
5. Reference specific themes from their recent entries (focus areas, mood trends)
6. Match the depth to their engagement — deep for active journalers, gentle for newcomers
7. Output ONLY the question — no preamble, no explanation, no quotes
8. Keep under 25 words
9. Make it feel like a wise friend who knows them well is asking`,

  tr: `Sen bir günlük sorusu tasarımcısısın. Kullanıcının son girişlerine ve örüntülerine dayalı TEK bir kişiselleştirilmiş günlük sorusu üret.

KATI KURALLAR:
1. ASLA astroloji, burç, doğum haritası veya gezegen etkilerinden bahsetme
2. ASLA gelecek hakkında tahmin yapma
3. ASLA fal dili kullanma
4. Soru düşündürücü, kişisel ve son örüntülerinden ilham alan olmalı
5. Son girişlerinden belirli temalara değin (odak alanları, ruh hali trendleri)
6. Derinliği katılımlarına göre ayarla — aktif yazanlar için derin, yeni başlayanlar için nazik
7. SADECE soruyu yaz — giriş, açıklama veya tırnak işareti yok
8. 25 kelimeyi aşma
9. Onları iyi tanıyan bilge bir arkadaş soruyormuş gibi hissettir`,
};

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

    const { recentEntries = [], weakestArea, currentStreak = 0, language = 'en' } = await req.json();

    // Build context
    const recentSummary = recentEntries
      .slice(0, 7)
      .map((e: any, i: number) => {
        const daysAgo = i === 0 ? 'yesterday' : `${i + 1} days ago`;
        return `- ${daysAgo}: ${e.focusArea} (${e.rating}/5)${e.note ? ` — "${e.note.substring(0, 80)}"` : ''}`;
      })
      .join('\n');

    const userMessage = language === 'tr'
      ? `Kullanıcının son girişleri:
${recentSummary || 'Henüz giriş yok — genel bir soru üret'}

${weakestArea ? `En düşük alan: ${weakestArea}` : ''}
${currentStreak > 3 ? `Günlük serisi: ${currentStreak} gün (tutarlılığını fark et)` : ''}

Bu kullanıcı için kişisel bir günlük sorusu üret.`
      : `User's recent entries:
${recentSummary || 'No entries yet — generate a general introspective question'}

${weakestArea ? `Weakest focus area: ${weakestArea}` : ''}
${currentStreak > 3 ? `Current streak: ${currentStreak} days (acknowledge their consistency)` : ''}

Generate a personalized journal question for this user.`;

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
        temperature: 0.85,
        max_tokens: 80,
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
    let prompt = data.choices[0]?.message?.content?.trim();

    if (!prompt) {
      return new Response(
        JSON.stringify({ error: 'Empty response from AI' }),
        { status: 502, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Clean up: remove surrounding quotes if present
    if ((prompt.startsWith('"') && prompt.endsWith('"')) ||
        (prompt.startsWith('\u201C') && prompt.endsWith('\u201D'))) {
      prompt = prompt.slice(1, -1);
    }

    // Safety check
    if (!isSafe(prompt)) {
      return new Response(
        JSON.stringify({ error: 'Response failed safety check', prompt: null }),
        { status: 200, headers: { 'Content-Type': 'application/json' } }
      );
    }

    return new Response(
      JSON.stringify({ success: true, prompt }),
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
