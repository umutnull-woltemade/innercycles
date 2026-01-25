interface Env {
  ORDERS: KVNamespace;
}

interface OrderRecord {
  qt: string;
  saleId: string;
  variant: 'mini' | 'full';
  status: 'pending' | 'paid' | 'blocked';
  content?: {
    summary: string;
    symbols: string;
    psychology: string;
    spiritual: string;
    warning: string;
    recommendation: string;
    disclaimer: string;
  };
  dreamText?: string;
  pdfBase64?: string;
  pdfGeneratedAt?: string;
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
      return Response.json({ error: 'Order not found' }, { status: 404 });
    }

    const order: OrderRecord = JSON.parse(raw);

    if (order.status !== 'paid') {
      return Response.json({ error: 'Payment not verified' }, { status: 402 });
    }

    if (order.variant !== 'full') {
      return Response.json({ error: 'PDF only for full variant' }, { status: 403 });
    }

    if (!order.content) {
      return Response.json({ error: 'Content not generated' }, { status: 400 });
    }

    // Return cached PDF if exists
    if (order.pdfBase64) {
      const html = decodeURIComponent(escape(atob(order.pdfBase64)));
      return new Response(html, {
        headers: {
          'Content-Type': 'text/html; charset=utf-8',
          'Content-Disposition': 'inline; filename="ruya-yorumu.html"',
        },
      });
    }

    // Generate PDF HTML (fallback)
    const pdfHtml = generatePdfHtml(order);

    // Store for future use (idempotent)
    const pdfBase64 = btoa(unescape(encodeURIComponent(pdfHtml)));
    const updatedOrder = {
      ...order,
      pdfBase64,
      pdfGeneratedAt: new Date().toISOString(),
    };

    await context.env.ORDERS.put(`qt:${qt}`, JSON.stringify(updatedOrder), {
      expirationTtl: 60 * 60 * 24 * 90,
    });

    return new Response(pdfHtml, {
      headers: {
        'Content-Type': 'text/html; charset=utf-8',
        'Content-Disposition': 'inline; filename="ruya-yorumu.html"',
      },
    });
  } catch (error) {
    console.error('PDF error:', error);
    return Response.json({ error: 'Internal error' }, { status: 500 });
  }
};

function generatePdfHtml(order: OrderRecord): string {
  const c = order.content!;

  return `<!DOCTYPE html>
<html lang="tr">
<head>
<meta charset="UTF-8">
<title>Kisisel Ruya Analizi - Astrobobo</title>
<style>
@page{size:A4;margin:2cm}
@media print{body{-webkit-print-color-adjust:exact;print-color-adjust:exact}}
body{font-family:Times New Roman,Georgia,serif;max-width:700px;margin:0 auto;padding:40px 20px;color:#222;line-height:1.7;font-size:14px}
h1{text-align:center;font-size:22px;margin-bottom:5px;color:#1a1a2e}
.subtitle{text-align:center;color:#666;margin-bottom:30px;font-size:13px}
h2{font-size:15px;margin-top:25px;margin-bottom:10px;border-bottom:1px solid #ccc;padding-bottom:5px;color:#333}
p{margin:10px 0;text-align:justify}
.dream{font-style:italic;background:#f8f8f8;padding:15px;margin:20px 0;border-left:3px solid #9b59b6}
.warning{border-left:3px solid #c00;padding:15px;margin:20px 0;background:#fef5f5}
.recommendation{border-left:3px solid #090;padding:15px;margin:20px 0;background:#f5fef5}
.disclaimer{font-size:11px;color:#666;margin-top:40px;padding-top:20px;border-top:1px solid #ccc;text-align:center}
.footer{text-align:center;margin-top:20px;font-size:11px;color:#888}
.print-btn{display:block;text-align:center;margin:20px auto;padding:12px 30px;background:#9b59b6;color:#fff;border:none;border-radius:5px;font-size:14px;cursor:pointer}
@media print{.print-btn{display:none}}
</style>
</head>
<body>
<h1>Kisisel Ruya Analizi</h1>
<p class="subtitle">Detayli Yorum Raporu</p>
${order.dreamText ? `<div class="dream"><strong>Ruyan:</strong><br>"${escapeHtml(order.dreamText)}"</div>` : ''}
<h2>Kisisel Ozet</h2>
<p>${escapeHtml(c.summary)}</p>
<h2>Sembol Analizi</h2>
<p>${escapeHtml(c.symbols)}</p>
${c.psychology ? `<h2>Psikolojik Icgoru</h2><p>${escapeHtml(c.psychology)}</p>` : ''}
${c.spiritual ? `<h2>Ruhsal Perspektif</h2><p>${escapeHtml(c.spiritual)}</p>` : ''}
<div class="warning"><strong>Dikkat Edilmesi Gereken:</strong><br>${escapeHtml(c.warning)}</div>
<div class="recommendation"><strong>Oneri:</strong><br>${escapeHtml(c.recommendation)}</div>
<div class="disclaimer">${escapeHtml(c.disclaimer)}</div>
<div class="footer">astrobobo.com</div>
<button class="print-btn" onclick="window.print()">PDF Olarak Kaydet (Ctrl+P)</button>
</body>
</html>`;
}

function escapeHtml(text: string): string {
  return text
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}
