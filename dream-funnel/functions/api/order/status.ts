interface Env {
  ORDERS: KVNamespace;
}

interface OrderRecord {
  status: 'pending' | 'paid' | 'blocked';
}

export const onRequestGet: PagesFunction<Env> = async (context) => {
  const url = new URL(context.request.url);
  const qt = url.searchParams.get('qt');

  if (!qt || qt.length < 32) {
    return Response.json({ error: 'Invalid qt' }, { status: 400 });
  }

  try {
    const raw = await context.env.ORDERS.get(`qt:${qt}`);

    if (!raw) {
      return Response.json({ status: 'pending' });
    }

    const order: OrderRecord = JSON.parse(raw);
    return Response.json({ status: order.status });
  } catch (error) {
    console.error('Status check error:', error);
    return Response.json({ error: 'Internal error' }, { status: 500 });
  }
};
