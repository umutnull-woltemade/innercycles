const PUSH_TEMPLATES = [
  "Bugün rüyalar daha net olabilir. Uyanınca not almayı dene.",
  "Dünkü rüyanın teması tekrar edebilir. Dikkatli gözlemle.",
  "Bugün semboller daha anlamlı gelebilir.",
  "Bilinçaltın bugün mesaj vermek istiyor olabilir.",
  "Rüya günlüğüne yazmak için iyi bir gün.",
  "Bugün sezgilerin güçlü olabilir.",
  "Gece gördüklerin gündüze ışık tutabilir.",
  "Bugün iç sesin daha yüksek olabilir.",
  "Rüyalarındaki tekrar eden tema dikkat çekebilir.",
  "Bugün farkındalık pratiği için uygun bir gün.",
];

const DAILY_PROMPT = `Sen sakin bir rüya/içgörü asistanısın. Kesin ifade kullanma, gelecek tahmini yapma.
Bugün için kısa bir içgörü yaz. Türkçe. Format:
[BUGÜN] 1-2 cümle genel mesaj
[ODAK] 1 tema
[UYARI] 1 cümle
[ÖNERİ] 1 cümle
[DISCLAIMER] Bu içerik eğlence amaçlıdır.`;

export async function scheduled(event, env, ctx) {
  const cursor = await env.ORDERS.get('cron:daily:cursor') || '';
  const batchSize = 200;
  let processed = 0;
  let nextCursor = '';

  const list = await env.ORDERS.list({ prefix: 'sub:', cursor, limit: batchSize });

  for (const key of list.keys) {
    const sub = await env.ORDERS.get(key.name, 'json');
    if (!sub || sub.status !== 'active') continue;

    const today = new Date().toISOString().slice(0, 10);
    if (sub.lastDailySentAt?.startsWith(today)) continue;

    const dayOfWeek = new Date().getDay();
    const templateIndex = (dayOfWeek + processed) % PUSH_TEMPLATES.length;
    const pushMessage = PUSH_TEMPLATES[templateIndex];

    // Generate daily insight
    let insight = '';
    try {
      insight = await generateInsight(env);
    } catch (e) {
      insight = pushMessage;
    }

    // Send email
    if (sub.email) {
      await sendEmail(env, sub.email, 'Günlük İçgörün', insight);
    }

    // Send push
    if (sub.onesignalPlayerId) {
      await sendPush(env, sub.onesignalPlayerId, pushMessage);
    }

    sub.lastDailySentAt = new Date().toISOString();
    sub.lastPushTemplate = templateIndex;
    await env.ORDERS.put(key.name, JSON.stringify(sub));
    processed++;
  }

  nextCursor = list.list_complete ? '' : list.cursor;
  await env.ORDERS.put('cron:daily:cursor', nextCursor);

  return new Response(`Processed ${processed}`);
}

async function generateInsight(env) {
  if (!env.OPENAI_API_KEY) return PUSH_TEMPLATES[0];

  const res = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${env.OPENAI_API_KEY}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      model: 'gpt-4o-mini',
      max_tokens: 220,
      messages: [{ role: 'user', content: DAILY_PROMPT }],
    }),
  });

  const data = await res.json();
  return data.choices?.[0]?.message?.content || PUSH_TEMPLATES[0];
}

async function sendEmail(env, to, subject, body) {
  if (!env.SMTP_API_KEY) return;

  await fetch('https://api.mailchannels.net/tx/v1/send', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      personalizations: [{ to: [{ email: to }] }],
      from: { email: 'bildirim@astrobobo.com', name: 'Astrobobo' },
      subject,
      content: [{ type: 'text/plain', value: body }],
    }),
  });
}

async function sendPush(env, playerId, message) {
  if (!env.ONESIGNAL_APP_ID || !env.ONESIGNAL_API_KEY) return;

  await fetch('https://onesignal.com/api/v1/notifications', {
    method: 'POST',
    headers: {
      'Authorization': `Basic ${env.ONESIGNAL_API_KEY}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      app_id: env.ONESIGNAL_APP_ID,
      include_player_ids: [playerId],
      contents: { tr: message, en: message },
      headings: { tr: 'Astrobobo', en: 'Astrobobo' },
    }),
  });
}

export default { scheduled };
