export async function onRequestGet(context) {
  const { env } = context;
  const baseUrl = 'https://astrobobo.com';

  const staticPages = [
    { loc: '/', priority: '1.0' },
    { loc: '/quiz.html', priority: '0.9' },
    { loc: '/sub.html', priority: '0.7' },
  ];

  const list = await env.ORDERS.list({ prefix: 'content:ruya:', limit: 1000 });
  const dreamPages = [];

  for (const key of list.keys) {
    const page = await env.ORDERS.get(key.name, 'json');
    if (page?.slug) {
      dreamPages.push({
        loc: `/ruya/${page.slug}`,
        lastmod: page.updatedAt?.slice(0, 10),
        priority: '0.8',
      });
    }
  }

  const allPages = [...staticPages, ...dreamPages];

  const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${allPages.map(p => `  <url>
    <loc>${baseUrl}${p.loc}</loc>
    ${p.lastmod ? `<lastmod>${p.lastmod}</lastmod>` : ''}
    <priority>${p.priority}</priority>
  </url>`).join('\n')}
</urlset>`;

  return new Response(xml, {
    headers: { 'Content-Type': 'application/xml' },
  });
}
