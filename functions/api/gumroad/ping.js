export async function onRequestPost(context) {
  const { request, env } = context;

  try {
    const formData = await request.formData();
    const data = Object.fromEntries(formData);

    if (!data.seller_id || !data.email) {
      return new Response('Invalid', { status: 400 });
    }

    const email = data.email.toLowerCase();
    const emailHash = await hashEmail(email);
    const isSubscription = data.is_recurring_billing === 'true';
    const isRefund = data.refunded === 'true';
    const isDispute = data.disputed === 'true';
    const isCancel = data.cancelled_at != null;
    const now = new Date().toISOString();

    if (isSubscription) {
      const subKey = `sub:${data.subscription_id || data.sale_id}`;
      const existing = await env.ORDERS.get(subKey, 'json') || {};

      let status = 'active';
      if (isRefund || isDispute) status = 'blocked';
      else if (isCancel) status = 'canceled';

      const sub = {
        ...existing,
        email,
        emailHash,
        subId: data.subscription_id || data.sale_id,
        saleId: data.sale_id,
        status,
        productName: data.product_name,
        startedAt: existing.startedAt || now,
        renewedAt: isCancel ? existing.renewedAt : now,
        canceledAt: isCancel ? now : null,
        refundedAt: isRefund ? now : null,
        blockedAt: (isRefund || isDispute) ? now : null,
        lastDailySentAt: existing.lastDailySentAt || null,
        onesignalPlayerId: existing.onesignalPlayerId || null,
        preferences: existing.preferences || { language: 'TR', time: 'morning' },
      };

      await env.ORDERS.put(subKey, JSON.stringify(sub), { expirationTtl: 86400 * 365 });
      await env.ORDERS.put(`email:${emailHash}`, subKey, { expirationTtl: 86400 * 365 });

      return Response.json({ success: true, type: 'subscription', status: sub.status });
    }

    // One-time purchase
    const product = data.product_permalink?.includes('detayli') ? 'full' : 'mini';
    const order = {
      orderId: data.sale_id,
      email,
      emailHash,
      product,
      price: data.price,
      timestamp: now,
      customerName: data.full_name || 'Misafir',
      refunded: isRefund,
    };

    await env.ORDERS.put(`order:${data.sale_id}`, JSON.stringify(order), { expirationTtl: 86400 * 90 });

    return Response.json({ success: true, type: 'purchase', product });
  } catch (e) {
    return new Response('Error', { status: 500 });
  }
}

async function hashEmail(email) {
  const encoder = new TextEncoder();
  const data = encoder.encode(email.toLowerCase());
  const hash = await crypto.subtle.digest('SHA-256', data);
  return Array.from(new Uint8Array(hash)).map(b => b.toString(16).padStart(2, '0')).join('').slice(0, 16);
}
