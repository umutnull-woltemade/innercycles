// ════════════════════════════════════════════════════════════════════════════
// SUPABASE EDGE FUNCTION: Generate Reflections
// ════════════════════════════════════════════════════════════════════════════
//
// Generates safe, Apple-compliant reflection content using OpenAI.
// Can be invoked via HTTP or scheduled with pg_cron.
//
// USAGE:
//   POST /functions/v1/generate-reflections
//   Body: { "language": "en", "count": 5 }
// ════════════════════════════════════════════════════════════════════════════

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

// ══════════════════════════════════════════════════════════════════════════
// CONFIGURATION
// ══════════════════════════════════════════════════════════════════════════

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
const OPENAI_API_KEY = Deno.env.get('OPENAI_API_KEY')!;

// Topics per language
const TOPICS: Record<string, string[]> = {
  en: [
    'morning intention setting',
    'emotional awareness',
    'personal growth',
    'self-compassion',
    'mindfulness moments',
    'gratitude practice',
  ],
  tr: [
    'sabah niyeti belirleme',
    'duygusal farkındalık',
    'kişisel gelişim',
    'öz-şefkat',
    'farkındalık anları',
    'şükran pratiği',
  ],
};

// System prompts
const SYSTEM_PROMPTS: Record<string, string> = {
  en: `You are a mindful reflection prompt generator. Generate thoughtful, open-ended prompts that encourage self-reflection.

STRICT RULES:
1. NEVER mention astrology, horoscopes, zodiac, birth charts, or planetary influences
2. NEVER make predictions about the future
3. NEVER use fortune-telling language
4. Focus on present-moment awareness and personal growth
5. Keep prompts to 1-2 sentences`,

  tr: `Sen düşünceli yansıma önerileri üreten bir asistansın.

KATI KURALLAR:
1. ASLA astroloji, burç, doğum haritası veya gezegen etkilerinden bahsetme
2. ASLA gelecek hakkında tahmin yapma
3. ASLA fal dili kullanma
4. Şimdiki an farkındalığına ve kişisel gelişime odaklan
5. Önerileri 1-2 cümle ile sınırla`,
};

// Forbidden patterns
const FORBIDDEN_PATTERNS: Record<string, RegExp[]> = {
  en: [
    /\b(astrology|horoscope|zodiac|birth chart|natal chart)\b/gi,
    /\b(prediction|prophecy|fortune|destiny|fate)\b/gi,
    /\b(your future|will happen|stars say)\b/gi,
  ],
  tr: [
    /\b(astroloji|burç|doğum haritası|yıldız haritası)\b/gi,
    /\b(kehanet|fal|kader|alın yazısı)\b/gi,
    /\b(geleceğiniz|olacak|yıldızlar söylüyor)\b/gi,
  ],
};

// ══════════════════════════════════════════════════════════════════════════
// HELPERS
// ══════════════════════════════════════════════════════════════════════════

function isSafe(content: string, language: string): boolean {
  const patterns = FORBIDDEN_PATTERNS[language] || FORBIDDEN_PATTERNS.en;
  for (const pattern of patterns) {
    pattern.lastIndex = 0;
    if (pattern.test(content)) {
      return false;
    }
  }
  return true;
}

async function generateWithOpenAI(
  language: string,
  topic: string
): Promise<string | null> {
  const response = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${OPENAI_API_KEY}`,
    },
    body: JSON.stringify({
      model: 'gpt-4-turbo-preview',
      messages: [
        { role: 'system', content: SYSTEM_PROMPTS[language] || SYSTEM_PROMPTS.en },
        {
          role: 'user',
          content:
            language === 'en'
              ? `Generate a reflection prompt about: ${topic}`
              : `Şu konu hakkında bir yansıma önerisi üret: ${topic}`,
        },
      ],
      temperature: 0.8,
      max_tokens: 150,
    }),
  });

  if (!response.ok) {
    console.error('OpenAI error:', response.status);
    return null;
  }

  const data = await response.json();
  return data.choices[0]?.message?.content?.trim() || null;
}

// ══════════════════════════════════════════════════════════════════════════
// MAIN HANDLER
// ══════════════════════════════════════════════════════════════════════════

serve(async (req: Request) => {
  try {
    // Parse request
    const { language = 'en', count = 5, topic } = await req.json();

    // Validate
    if (!['en', 'tr'].includes(language)) {
      return new Response(
        JSON.stringify({ error: 'Invalid language. Use "en" or "tr".' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Create Supabase client
    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

    // Results
    const results = {
      generated: 0,
      passed: 0,
      blocked: 0,
      items: [] as any[],
    };

    // Select topic
    const topics = TOPICS[language] || TOPICS.en;
    const selectedTopic = topic || topics[Math.floor(Math.random() * topics.length)];

    // Generate content
    for (let i = 0; i < count; i++) {
      const content = await generateWithOpenAI(language, selectedTopic);
      if (!content) continue;

      results.generated++;

      // Safety check
      if (!isSafe(content, language)) {
        results.blocked++;

        // Log safety event
        await supabase.from('safety_events').insert({
          event_type: 'block',
          source: 'edge_function',
          locale: language,
          violation_count: 1,
          violation_categories: ['detected_by_edge_function'],
        });

        continue;
      }

      results.passed++;

      // Save to database
      const { data, error } = await supabase
        .from('content_items')
        .insert({
          locale: language,
          category: 'reflection',
          subcategory: selectedTopic.split(' ')[0].toLowerCase(),
          content,
          safety_action: 'pass',
          safety_violations: 0,
          is_active: true,
        })
        .select()
        .single();

      if (error) {
        console.error('Insert error:', error);
      } else {
        results.items.push(data);
      }

      // Rate limit
      await new Promise((resolve) => setTimeout(resolve, 200));
    }

    // Log generation run
    await supabase.from('content_generation_log').insert({
      run_date: new Date().toISOString().split('T')[0],
      locale: language,
      topic: selectedTopic,
      generated_count: results.generated,
      passed_count: results.passed,
      blocked_count: results.blocked,
    });

    return new Response(JSON.stringify({ success: true, ...results }), {
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Error:', error);
    return new Response(
      JSON.stringify({ error: (error as Error).message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
});
