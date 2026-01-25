interface Env {
  ORDERS: KVNamespace;
}

interface GumroadPing {
  seller_id: string;
  product_id: string;
  product_name: string;
  permalink: string;
  short_product_id: string;
  email: string;
  price: number;
  gumroad_fee: number;
  currency: string;
  quantity: number;
  order_number: number;
  sale_id: string;
  sale_timestamp: string;
  refunded: string;
  disputed: string;
  dispute_won: string;
  test: string;
  custom_fields?: Record<string, string>;
}

interface OrderRecord {
  qt: string;
  saleId: string;
  email: string;
  variant: 'mini' | 'full';
  price: number;
  currency: string;
  status: 'pending' | 'paid' | 'blocked';
  refunded: boolean;
  disputed: boolean;
  createdAt: string;
  updatedAt: string;
  content?: object;
  deliveredAt?: string;
}

export const onRequestPost: PagesFunction<Env> = async (context) => {
  try {
    const formData = await context.request.formData();
    const data: Partial<GumroadPing> = {};

    for (const [key, value] of formData.entries()) {
      (data as any)[key] = value;
    }

    if (!data.sale_id || !data.email) {
      return new Response('Missing required fields', { status: 400 });
    }

    const qt = data.custom_fields?.qt ||
               new URL(context.request.url).searchParams.get('qt') ||
               '';

    if (!qt || qt.length < 32) {
      console.error('Invalid qt:', qt, 'sale_id:', data.sale_id);
      return new Response('Invalid qt', { status: 400 });
    }

    const isRefunded = data.refunded === 'true';
    const isDisputed = data.disputed === 'true';
    const isBlocked = isRefunded || isDisputed;

    const variant: 'mini' | 'full' =
      (data.permalink?.includes('detayli') || data.product_name?.toLowerCase().includes('detayli'))
        ? 'full'
        : 'mini';

    const existingRaw = await context.env.ORDERS.get(`qt:${qt}`);
    const existing: OrderRecord | null = existingRaw ? JSON.parse(existingRaw) : null;

    const order: OrderRecord = {
      qt,
      saleId: data.sale_id,
      email: data.email,
      variant,
      price: (data.price || 0) / 100,
      currency: data.currency || 'USD',
      status: isBlocked ? 'blocked' : 'paid',
      refunded: isRefunded,
      disputed: isDisputed,
      createdAt: existing?.createdAt || new Date().toISOString(),
      updatedAt: new Date().toISOString(),
      content: existing?.content,
      deliveredAt: existing?.deliveredAt,
    };

    await context.env.ORDERS.put(`qt:${qt}`, JSON.stringify(order), {
      expirationTtl: 60 * 60 * 24 * 90, // 90 days
    });

    await context.env.ORDERS.put(`sale:${data.sale_id}`, qt, {
      expirationTtl: 60 * 60 * 24 * 90,
    });

    console.log('Gumroad ping processed:', {
      qt,
      saleId: data.sale_id,
      status: order.status,
      variant,
    });

    return new Response('OK', { status: 200 });
  } catch (error) {
    console.error('Gumroad ping error:', error);
    return new Response('Internal error', { status: 500 });
  }
};
