interface Env {
  ORDERS: KVNamespace;
  ONESIGNAL_APP_ID?: string;
  ONESIGNAL_API_KEY?: string;
}

const PUSH_MESSAGES = [
  'Bugün rüyalar daha anlamlı olabilir',
  'Dünkü rüyanın mesajı devam ediyor olabilir',
  'Bilinçaltın yeni bir mesaj hazırlamış olabilir',
  'Rüya günlüğüne bakmak için iyi bir gün',
  'Gece gördüklerin gündüze ışık tutabilir',
];

export const onRequestPost: PagesFunction<Env> = async (context) => {
  if (!context.env.ONESIGNAL_APP_ID || !context.env.ONESIGNAL_API_KEY) {
    return Response.json({ error: 'OneSignal not configured' }, { status: 500 });
  }

  const authHeader = context.request.headers.get('Authorization');
  const expectedAuth = `Bearer ${context.env.ONESIGNAL_API_KEY}`;

  if (authHeader !== expectedAuth) {
    return Response.json({ error: 'Unauthorized' }, { status: 401 });
  }

  try {
    const now = new Date();
    const today = now.toISOString().split('T')[0];
    let sent = 0;
    let skipped = 0;

    // List all orders (in production, use cursor-based pagination)
    const list = await context.env.ORDERS.list({ prefix: 'qt:' });

    for (const key of list.keys) {
      const raw = await context.env.ORDERS.get(key.name);
      if (!raw) continue;

      const order = JSON.parse(raw);

      // Skip if no push ID
      if (!order.pushId) {
        skipped++;
        continue;
      }

      // Skip blocked orders
      if (order.status === 'blocked') {
        skipped++;
        continue;
      }

      // Skip if already pushed today
      if (order.lastPushAt?.startsWith(today)) {
        skipped++;
        continue;
      }

      // Send push
      const message = PUSH_MESSAGES[Math.floor(Math.random() * PUSH_MESSAGES.length)];

      const pushResult = await sendPush(
        context.env.ONESIGNAL_APP_ID,
        context.env.ONESIGNAL_API_KEY,
        order.pushId,
        message
      );

      if (pushResult) {
        // Update lastPushAt
        const updatedOrder = {
          ...order,
          lastPushAt: now.toISOString(),
        };

        await context.env.ORDERS.put(key.name, JSON.stringify(updatedOrder), {
          expirationTtl: 60 * 60 * 24 * 90,
        });

        sent++;
      }
    }

    return Response.json({ sent, skipped, total: list.keys.length });
  } catch (error) {
    console.error('Daily push error:', error);
    return Response.json({ error: 'Internal error' }, { status: 500 });
  }
};

async function sendPush(
  appId: string,
  apiKey: string,
  playerId: string,
  message: string
): Promise<boolean> {
  try {
    const response = await fetch('https://onesignal.com/api/v1/notifications', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Basic ${apiKey}`,
      },
      body: JSON.stringify({
        app_id: appId,
        include_player_ids: [playerId],
        contents: { tr: message, en: message },
        url: 'https://astrobobo.com/quiz',
      }),
    });

    return response.ok;
  } catch (error) {
    console.error('Push send error:', error);
    return false;
  }
}
