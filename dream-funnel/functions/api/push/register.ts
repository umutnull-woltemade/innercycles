interface Env {
  ORDERS: KVNamespace;
}

interface RegisterRequest {
  qt: string;
  pushId: string;
}

export const onRequestPost: PagesFunction<Env> = async (context) => {
  try {
    const { qt, pushId }: RegisterRequest = await context.request.json();

    if (!qt || qt.length < 32) {
      return Response.json({ error: 'Invalid qt' }, { status: 400 });
    }

    if (!pushId || pushId.length < 10) {
      return Response.json({ error: 'Invalid pushId' }, { status: 400 });
    }

    const raw = await context.env.ORDERS.get(`qt:${qt}`);

    if (!raw) {
      return Response.json({ error: 'Order not found' }, { status: 404 });
    }

    const order = JSON.parse(raw);

    if (order.status === 'blocked') {
      return Response.json({ error: 'Order blocked' }, { status: 403 });
    }

    // Update order with pushId
    const updatedOrder = {
      ...order,
      pushId,
    };

    await context.env.ORDERS.put(`qt:${qt}`, JSON.stringify(updatedOrder), {
      expirationTtl: 60 * 60 * 24 * 90,
    });

    // Store reverse lookup
    await context.env.ORDERS.put(`push:${pushId}`, qt, {
      expirationTtl: 60 * 60 * 24 * 90,
    });

    return Response.json({ success: true });
  } catch (error) {
    console.error('Push register error:', error);
    return Response.json({ error: 'Internal error' }, { status: 500 });
  }
};
