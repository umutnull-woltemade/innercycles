export async function onRequestGet(context) {
  const { params, env } = context;
  const slug = params.slug;

  const page = await env.ORDERS.get(`content:ruya:${slug}`, 'json');
  if (!page) {
    return new Response('Not found', { status: 404 });
  }

  const jsonLd = {
    '@context': 'https://schema.org',
    '@graph': [
      {
        '@type': 'Article',
        headline: page.title,
        description: page.metaDesc,
        author: { '@type': 'Organization', name: 'Astrobobo' },
        publisher: { '@type': 'Organization', name: 'Astrobobo' },
        datePublished: page.createdAt,
        dateModified: page.updatedAt,
        mainEntityOfPage: `https://astrobobo.com/ruya/${slug}`,
      },
      {
        '@type': 'FAQPage',
        mainEntity: page.faqs?.map(f => ({
          '@type': 'Question',
          name: f.q,
          acceptedAnswer: { '@type': 'Answer', text: f.a },
        })) || [],
      },
    ],
  };

  const html = `<!DOCTYPE html>
<html lang="tr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${page.title} - Astrobobo</title>
  <meta name="description" content="${page.metaDesc}">
  <link rel="canonical" href="https://astrobobo.com/ruya/${slug}">
  <meta property="og:title" content="${page.title}">
  <meta property="og:description" content="${page.metaDesc}">
  <meta property="og:type" content="article">
  <meta property="og:url" content="https://astrobobo.com/ruya/${slug}">
  <meta name="twitter:card" content="summary">
  <meta name="twitter:title" content="${page.title}">
  <meta name="twitter:description" content="${page.metaDesc}">
  <script type="application/ld+json">${JSON.stringify(jsonLd)}</script>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: system-ui, sans-serif; background: #0d0d1a; color: #f5f0e6; line-height: 1.6; }
    .container { max-width: 720px; margin: 0 auto; padding: 20px; }
    h1 { font-size: 28px; margin-bottom: 24px; }
    h2 { font-size: 20px; margin: 32px 0 16px; color: #a78bfa; }
    .bullets { background: rgba(167,139,250,0.1); border-radius: 12px; padding: 20px; margin-bottom: 24px; }
    .bullets li { margin-bottom: 8px; list-style: none; padding-left: 20px; position: relative; }
    .bullets li::before { content: "•"; position: absolute; left: 0; color: #a78bfa; }
    .summary { font-size: 18px; margin-bottom: 32px; }
    .section { margin-bottom: 24px; }
    .section p { margin-bottom: 12px; }
    .variations { display: flex; flex-wrap: wrap; gap: 8px; }
    .variations span { background: rgba(255,255,255,0.1); padding: 6px 12px; border-radius: 20px; font-size: 14px; }
    .related { margin-top: 40px; padding-top: 24px; border-top: 1px solid rgba(255,255,255,0.1); }
    .related a { display: inline-block; margin: 4px 8px 4px 0; color: #a78bfa; text-decoration: none; }
    .related a:hover { text-decoration: underline; }
    .faq { margin-top: 40px; }
    .faq-item { margin-bottom: 16px; }
    .faq-q { font-weight: 600; margin-bottom: 4px; }
    .faq-a { color: rgba(255,255,255,0.8); }
    .cta { background: linear-gradient(135deg, #8b5cf6, #6366f1); padding: 24px; border-radius: 12px; text-align: center; margin: 40px 0; }
    .cta a { color: white; text-decoration: none; font-weight: 600; }
    .footer { text-align: center; padding: 40px 0; font-size: 14px; color: rgba(255,255,255,0.5); }
    .disclaimer { font-size: 12px; color: rgba(255,255,255,0.4); margin-top: 40px; padding: 16px; background: rgba(255,255,255,0.03); border-radius: 8px; }
  </style>
</head>
<body>
  <div class="container">
    <h1>${page.title}</h1>

    <ul class="bullets">
      ${page.bullets?.map(b => `<li>${b}</li>`).join('') || ''}
    </ul>

    <p class="summary">${page.summary || ''}</p>

    <div class="section">
      <h2>Genel Anlam</h2>
      <p>${page.sections?.genel || ''}</p>
    </div>

    <div class="section">
      <h2>Psikolojik Yorum</h2>
      <p>${page.sections?.psikolojik || ''}</p>
    </div>

    <div class="section">
      <h2>Islami Yorum</h2>
      <p>${page.sections?.islami || ''}</p>
    </div>

    <div class="section">
      <h2>Sik Gorulen Varyasyonlar</h2>
      <div class="variations">
        ${page.sections?.varyasyonlar?.map(v => `<span>${v}</span>`).join('') || ''}
      </div>
    </div>

    <div class="section">
      <h2>Ne Zaman Ciddiye Alinmali?</h2>
      <p>${page.sections?.ciddiyet || ''}</p>
    </div>

    <div class="cta">
      <a href="/quiz.html">Ruyani Yorumlat</a>
    </div>

    <div class="faq">
      <h2>Sik Sorulan Sorular</h2>
      ${page.faqs?.map(f => `
        <div class="faq-item">
          <div class="faq-q">${f.q}</div>
          <div class="faq-a">${f.a}</div>
        </div>
      `).join('') || ''}
    </div>

    <div class="related">
      <h2>Benzer Ruyalar</h2>
      ${page.sections?.benzer?.map(s => `<a href="/ruya/${s}">${s}</a>`).join('') || ''}
    </div>

    <div class="disclaimer">
      Bu icerik eglence amaclidir ve profesyonel tavsiye yerine gecmez. Psikolojik destek icin uzmana basvurun.
    </div>

    <div class="footer">
      Ruya Izi — Astrobobo
    </div>
  </div>
</body>
</html>`;

  return new Response(html, {
    headers: { 'Content-Type': 'text/html; charset=utf-8' },
  });
}
