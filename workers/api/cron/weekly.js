export async function scheduled(event, env, ctx) {
  const list = await env.ORDERS.list({ prefix: 'content:ruya:', limit: 50 });
  const now = new Date().toISOString();
  let updated = 0;

  for (const key of list.keys) {
    const page = await env.ORDERS.get(key.name, 'json');
    if (!page) continue;

    page.updatedAt = now;
    page.updateCount = (page.updateCount || 0) + 1;

    await env.ORDERS.put(key.name, JSON.stringify(page));
    updated++;
  }

  return new Response(`Updated ${updated} pages`);
}

export default { scheduled };
