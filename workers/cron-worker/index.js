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

const DAILY_PROMPT = `Sen sakin bir rüya asistanısın. Kesin ifade kullanma. Türkçe. Format:
[BUGÜN] 1-2 cümle
[ODAK] 1 tema
[UYARI] 1 cümle
[ÖNERİ] 1 cümle
[DISCLAIMER] Bu içerik eğlence amaçlıdır.`;

export default {
  async scheduled(event, env, ctx) {
    const cronType = event.cron === "0 0 * * 0" ? "weekly" : "daily";

    if (cronType === "weekly") {
      return await runWeekly(env);
    }
    return await runDaily(env);
  },
};

async function runDaily(env) {
  const cursor = (await env.ORDERS.get("cron:daily:cursor")) || "";
  const list = await env.ORDERS.list({ prefix: "sub:", cursor, limit: 200 });
  let processed = 0;

  for (const key of list.keys) {
    const sub = await env.ORDERS.get(key.name, "json");
    if (!sub || sub.status !== "active") continue;

    const today = new Date().toISOString().slice(0, 10);
    if (sub.lastDailySentAt?.startsWith(today)) continue;

    const templateIndex = (new Date().getDay() + processed) % PUSH_TEMPLATES.length;
    const pushMessage = PUSH_TEMPLATES[templateIndex];

    let insight = pushMessage;
    if (env.OPENAI_API_KEY) {
      try {
        const res = await fetch("https://api.openai.com/v1/chat/completions", {
          method: "POST",
          headers: {
            Authorization: `Bearer ${env.OPENAI_API_KEY}`,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            model: "gpt-4o-mini",
            max_tokens: 220,
            messages: [{ role: "user", content: DAILY_PROMPT }],
          }),
        });
        const data = await res.json();
        insight = data.choices?.[0]?.message?.content || pushMessage;
      } catch (e) {}
    }

    if (sub.email) {
      await sendEmail(env, sub.email, "Günlük İçgörün", insight);
    }

    if (sub.onesignalPlayerId && env.ONESIGNAL_APP_ID && env.ONESIGNAL_API_KEY) {
      await sendPush(env, sub.onesignalPlayerId, pushMessage);
    }

    sub.lastDailySentAt = new Date().toISOString();
    await env.ORDERS.put(key.name, JSON.stringify(sub));
    processed++;
  }

  const nextCursor = list.list_complete ? "" : list.cursor;
  await env.ORDERS.put("cron:daily:cursor", nextCursor);
  return processed;
}

async function runWeekly(env) {
  const list = await env.ORDERS.list({ prefix: "content:ruya:", limit: 50 });
  const now = new Date().toISOString();
  let updated = 0;

  for (const key of list.keys) {
    const page = await env.ORDERS.get(key.name, "json");
    if (!page) continue;
    page.updatedAt = now;
    await env.ORDERS.put(key.name, JSON.stringify(page));
    updated++;
  }
  return updated;
}

async function sendEmail(env, to, subject, body) {
  try {
    await fetch("https://api.mailchannels.net/tx/v1/send", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        personalizations: [{ to: [{ email: to }] }],
        from: { email: "bildirim@astrobobo.com", name: "Astrobobo" },
        subject,
        content: [{ type: "text/plain", value: body }],
      }),
    });
  } catch (e) {}
}

async function sendPush(env, playerId, message) {
  try {
    await fetch("https://onesignal.com/api/v1/notifications", {
      method: "POST",
      headers: {
        Authorization: `Basic ${env.ONESIGNAL_API_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        app_id: env.ONESIGNAL_APP_ID,
        include_player_ids: [playerId],
        contents: { tr: message, en: message },
        headings: { tr: "Astrobobo", en: "Astrobobo" },
      }),
    });
  } catch (e) {}
}
