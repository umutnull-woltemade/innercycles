export async function onRequestGet(context) {
  const { request, env } = context;
  const url = new URL(request.url);
  const token = url.searchParams.get('token');

  if (!token) {
    return Response.json({ error: 'Missing token' }, { status: 400 });
  }

  const subKey = await env.ORDERS.get(`email:${token}`) || `sub:${token}`;
  const sub = await env.ORDERS.get(subKey, 'json');

  if (!sub) {
    return Response.json({ found: false });
  }

  return Response.json({
    found: true,
    status: sub.status,
    startedAt: sub.startedAt,
    renewedAt: sub.renewedAt,
    canceledAt: sub.canceledAt,
    preferences: sub.preferences,
    hasPush: !!sub.onesignalPlayerId,
  });
}
