const DREAM_PROMPT = `SEO yazar + rüya yorumcusu. Kesin ifade kullanma. Türkçe.
Konu: {TOPIC}
Çıktı JSON:
{
  "slug": "ruyada-x-gormek",
  "title": "Rüyada X Görmek Ne Anlama Gelir?",
  "metaDesc": "max 155 karakter açıklama",
  "bullets": ["bullet1", "bullet2", "bullet3"],
  "summary": "1 paragraf özet",
  "sections": {
    "genel": "genel anlam",
    "psikolojik": "psikolojik yorum",
    "islami": "islami yorum (saygılı, nötr)",
    "varyasyonlar": ["var1", "var2", "var3", "var4", "var5"],
    "ciddiyet": "ne zaman ciddiye alınmalı",
    "benzer": ["slug1", "slug2", "slug3"]
  },
  "faqs": [
    {"q": "soru1", "a": "cevap1"},
    {"q": "soru2", "a": "cevap2"},
    {"q": "soru3", "a": "cevap3"},
    {"q": "soru4", "a": "cevap4"}
  ]
}`;

export async function onRequestPost(context) {
  const { request, env } = context;

  try {
    const body = await request.json();
    const topics = body.topics || [];

    if (!Array.isArray(topics) || topics.length === 0) {
      return Response.json({ error: 'No topics' }, { status: 400 });
    }

    const results = [];

    for (const topic of topics.slice(0, 10)) {
      const titleHash = await hash(topic);
      const existing = await env.ORDERS.get(`content:hash:${titleHash}`);
      if (existing) {
        results.push({ topic, status: 'duplicate' });
        continue;
      }

      const content = await generateContent(env, topic);
      if (!content) {
        results.push({ topic, status: 'error' });
        continue;
      }

      await env.ORDERS.put(`content:ruya:${content.slug}`, JSON.stringify({
        ...content,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
      }));

      await env.ORDERS.put(`content:hash:${titleHash}`, content.slug);

      results.push({ topic, status: 'created', slug: content.slug });
    }

    return Response.json({ results });
  } catch (e) {
    return Response.json({ error: e.message }, { status: 500 });
  }
}

async function generateContent(env, topic) {
  if (!env.OPENAI_API_KEY) return null;

  const prompt = DREAM_PROMPT.replace('{TOPIC}', topic);

  const res = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${env.OPENAI_API_KEY}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      model: 'gpt-4o-mini',
      max_tokens: 1500,
      messages: [{ role: 'user', content: prompt }],
      response_format: { type: 'json_object' },
    }),
  });

  const data = await res.json();
  const text = data.choices?.[0]?.message?.content;
  if (!text) return null;

  return JSON.parse(text);
}

async function hash(str) {
  const encoder = new TextEncoder();
  const data = encoder.encode(str.toLowerCase());
  const hashBuffer = await crypto.subtle.digest('SHA-256', data);
  return Array.from(new Uint8Array(hashBuffer)).map(b => b.toString(16).padStart(2, '0')).join('').slice(0, 16);
}
