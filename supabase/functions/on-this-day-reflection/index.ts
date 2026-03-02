// ════════════════════════════════════════════════════════════════════════════
// SUPABASE EDGE FUNCTION: On This Day — AI Theme Recall
// ════════════════════════════════════════════════════════════════════════════
// Compares a past journal entry with the user's current state/trends
// and generates a brief, meaningful "then vs now" reflection.
// ════════════════════════════════════════════════════════════════════════════

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';

const OPENAI_API_KEY = Deno.env.get('OPENAI_API_KEY');

const SYSTEM_PROMPTS: Record<string, string> = {
  en: `You are a warm, insightful journaling companion for the app InnerCycles. The user had a journal entry on this exact date in a previous year. Generate a brief, meaningful reflection comparing then and now.

RULES:
1. NEVER mention astrology, horoscopes, zodiac, or predictions
2. Be warm and insightful — highlight growth, patterns, or interesting contrasts
3. Keep it to 1-2 sentences (max 120 characters)
4. Focus on themes of self-awareness and personal growth
5. Use "you" to address the user directly
6. Output ONLY the reflection — no quotes, no labels`,

  tr: `InnerCycles uygulaması için sıcak ve içgörülü bir günlük arkadaşısın. Kullanıcının önceki yıllarda aynı tarihte bir günlük kaydı var. O zaman ve şimdi arasını karşılaştıran kısa, anlamlı bir yansıma üret.

KURALLAR:
1. ASLA astroloji, burç veya tahminlerden bahsetme
2. Sıcak ve içgörülü ol — büyümeyi, kalıpları veya ilginç kontrastları vurgula
3. 1-2 cümle ile sınırlı tut (max 120 karakter)
4. Öz farkındalık ve kişisel gelişim temalarına odaklan
5. Kullanıcıya "sen" diye hitap et
6. SADECE yansıma metnini yaz — tırnak, etiket yok`,
};

serve(async (req: Request) => {
  try {
    if (!OPENAI_API_KEY) {
      return new Response(
        JSON.stringify({ error: 'OPENAI_API_KEY not configured' }),
        { status: 503, headers: { 'Content-Type': 'application/json' } }
      );
    }

    const {
      pastNote = '',
      pastFocusArea = '',
      pastRating = 0,
      yearsAgo = 1,
      currentFocusArea = '',
      currentMoodTrend = '',
      language = 'en',
    } = await req.json();

    const userMessage = language === 'tr'
      ? `${yearsAgo} yıl önce bugün:
- Odak: ${pastFocusArea}
- Puan: ${pastRating}/5
${pastNote ? `- Not: "${pastNote.substring(0, 200)}"` : ''}

Şimdiki durum:
- Odak eğilimi: ${currentFocusArea || 'bilinmiyor'}
- Ruh hali trendi: ${currentMoodTrend || 'stabil'}

Kısa bir "o zaman vs şimdi" yansıması üret.`
      : `${yearsAgo} year${yearsAgo === 1 ? '' : 's'} ago today:
- Focus: ${pastFocusArea}
- Rating: ${pastRating}/5
${pastNote ? `- Note: "${pastNote.substring(0, 200)}"` : ''}

Current state:
- Focus trend: ${currentFocusArea || 'unknown'}
- Mood trend: ${currentMoodTrend || 'stable'}

Generate a brief "then vs now" reflection.`;

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
        temperature: 0.8,
        max_tokens: 80,
      }),
    });

    if (!response.ok) {
      return new Response(
        JSON.stringify({ error: 'AI generation failed' }),
        { status: 502, headers: { 'Content-Type': 'application/json' } }
      );
    }

    const data = await response.json();
    let reflection = data.choices[0]?.message?.content?.trim() || '';

    // Strip surrounding quotes
    if ((reflection.startsWith('"') && reflection.endsWith('"')) ||
        (reflection.startsWith('\u201C') && reflection.endsWith('\u201D'))) {
      reflection = reflection.slice(1, -1);
    }

    return new Response(
      JSON.stringify({ success: true, reflection }),
      { headers: { 'Content-Type': 'application/json' } }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ error: (error as Error).message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
});
