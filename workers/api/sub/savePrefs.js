export async function onRequestPost(context) {
  const { request, env } = context;

  try {
    const body = await request.json();
    const { token, playerId, time } = body;

    if (!token) {
      return Response.json({ error: 'Missing token' }, { status: 400 });
    }

    const subKey = await env.ORDERS.get(`email:${token}`) || `sub:${token}`;
    const sub = await env.ORDERS.get(subKey, 'json');

    if (!sub) {
      return Response.json({ error: 'Not found' }, { status: 404 });
    }

    if (playerId) sub.onesignalPlayerId = playerId;
    if (time && ['morning', 'evening'].includes(time)) {
      sub.preferences = { ...sub.preferences, time };
    }

    await env.ORDERS.put(subKey, JSON.stringify(sub), { expirationTtl: 86400 * 365 });

    return Response.json({ success: true });
  } catch (e) {
    return Response.json({ error: 'Invalid' }, { status: 400 });
  }
}
