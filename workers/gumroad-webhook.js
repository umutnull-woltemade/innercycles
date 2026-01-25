/**
 * Cloudflare Worker - Gumroad Webhook Handler
 * Deploy: wrangler deploy
 */

export default {
  async fetch(request, env) {
    if (request.method === 'OPTIONS') {
      return new Response(null, {
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'POST, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type',
        },
      });
    }

    if (request.method !== 'POST') {
      return new Response('Method not allowed', { status: 405 });
    }

    try {
      const formData = await request.formData();
      const data = Object.fromEntries(formData);

      // Validate Gumroad webhook
      if (!data.seller_id || !data.product_id) {
        return new Response('Invalid webhook', { status: 400 });
      }

      const order = {
        orderId: data.sale_id,
        email: data.email,
        product: data.product_permalink?.includes('detayli') ? 'full' : 'mini',
        price: data.price,
        timestamp: new Date().toISOString(),
        customerName: data.full_name || 'Misafir',
      };

      // Store in KV (optional - for order lookup)
      if (env.ORDERS) {
        await env.ORDERS.put(`order:${order.orderId}`, JSON.stringify(order), {
          expirationTtl: 86400 * 30, // 30 days
        });
      }

      // Log for debugging
      console.log('Gumroad order received:', order);

      return new Response(JSON.stringify({ success: true, orderId: order.orderId }), {
        headers: { 'Content-Type': 'application/json' },
      });
    } catch (error) {
      console.error('Webhook error:', error);
      return new Response('Server error', { status: 500 });
    }
  },
};
