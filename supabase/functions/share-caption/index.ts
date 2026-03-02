// ════════════════════════════════════════════════════════════════════════════
// SUPABASE EDGE FUNCTION: Share Caption Generator
// ════════════════════════════════════════════════════════════════════════════
// Generates a viral, personalized caption for share cards.
// Takes card type + user context and returns an engaging caption.
// ════════════════════════════════════════════════════════════════════════════

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';

const OPENAI_API_KEY = Deno.env.get('OPENAI_API_KEY');

const SYSTEM_PROMPTS: Record<string, string> = {
  en: `You generate short, viral social media captions for a journaling app called InnerCycles. The user is sharing a personal insight card.

RULES:
1. NEVER mention astrology, horoscopes, zodiac, or predictions
2. Be warm, authentic, and slightly mysterious — make viewers curious
3. Include 1-2 relevant emojis naturally
4. End with a subtle call-to-action or reflective question
5. Keep under 120 characters (excluding hashtags)
6. Make it sound personal, not corporate
7. Output ONLY the caption text — no quotes, no explanation`,

  tr: `InnerCycles adlı günlük uygulaması için kısa, viral sosyal medya altyazıları üretiyorsun. Kullanıcı kişisel bir içgörü kartı paylaşıyor.

KURALLAR:
1. ASLA astroloji, burç veya tahminlerden bahsetme
2. Sıcak, samimi ve biraz gizemli ol — izleyenleri meraklandır
3. 1-2 ilgili emoji doğal şekilde kullan
4. İnce bir harekete geçirme veya düşündürücü soruyla bitir
5. 120 karakteri aşma (hashtag'ler hariç)
6. Kişisel ses kullan, kurumsal değil
7. SADECE altyazı metnini yaz — tırnak, açıklama yok`,
};

serve(async (req: Request) => {
  try {
    if (!OPENAI_API_KEY) {
      return new Response(
        JSON.stringify({ error: 'OPENAI_API_KEY not configured' }),
        { status: 503, headers: { 'Content-Type': 'application/json' } }
      );
    }

    const { cardType = '', headline = '', statValue = '', language = 'en' } = await req.json();

    const userMessage = language === 'tr'
      ? `Kart türü: ${cardType}
Başlık: ${headline}
${statValue ? `İstatistik: ${statValue}` : ''}

Bu paylaşım kartı için kişisel ve viral bir altyazı üret.`
      : `Card type: ${cardType}
Headline: ${headline}
${statValue ? `Stat: ${statValue}` : ''}

Generate a personal, viral caption for this share card.`;

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
        temperature: 0.9,
        max_tokens: 60,
      }),
    });

    if (!response.ok) {
      return new Response(
        JSON.stringify({ error: 'AI generation failed' }),
        { status: 502, headers: { 'Content-Type': 'application/json' } }
      );
    }

    const data = await response.json();
    let caption = data.choices[0]?.message?.content?.trim() || '';

    // Strip surrounding quotes
    if ((caption.startsWith('"') && caption.endsWith('"')) ||
        (caption.startsWith('\u201C') && caption.endsWith('\u201D'))) {
      caption = caption.slice(1, -1);
    }

    return new Response(
      JSON.stringify({ success: true, caption }),
      { headers: { 'Content-Type': 'application/json' } }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ error: (error as Error).message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
});
