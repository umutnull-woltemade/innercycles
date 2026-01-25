interface Env {
  ORDERS: KVNamespace;
  SMTP_HOST?: string;
  SMTP_PORT?: string;
  SMTP_USER?: string;
  SMTP_PASS?: string;
  SMTP_FROM?: string;
}

interface QuizData {
  dreamText: string;
  answers: {
    emotion: 'fear' | 'curiosity' | 'relief';
    frequency: 'first' | 'sometimes' | 'often';
    clarity: 'blurry' | 'mid' | 'clear';
  };
  segment: 'low' | 'mid' | 'high';
}

interface InterpretationContent {
  summary: string;
  symbols: string;
  psychology: string;
  spiritual: string;
  warning: string;
  recommendation: string;
  disclaimer: string;
}

interface OrderRecord {
  qt: string;
  saleId: string;
  email: string;
  variant: 'mini' | 'full';
  status: 'pending' | 'paid' | 'blocked';
  content?: InterpretationContent;
  deliveredAt?: string;
  dreamText?: string;
  pdfBase64?: string;
  pdfGeneratedAt?: string;
  emailSentAt?: string;
  pushId?: string;
  lastPushAt?: string;
}

const EMOTION_TEXT: Record<string, string> = {
  fear: 'Rüyanda hissettiğin korku veya endişe, bilinçaltının dikkatini çekmeye çalıştığı bir alana işaret edebilir.',
  curiosity: 'Rüyandaki merak duygusu, yeni keşiflere ve içsel büyümeye olan açıklığını yansıtıyor olabilir.',
  relief: 'Hissettiğin rahatlama, içsel bir çözülmenin veya kabul sürecinin habercisi olabilir.',
};

const FREQUENCY_TEXT: Record<string, string> = {
  first: 'Bu rüyayı ilk kez görmen, hayatında yeni bir dönemin başladığına işaret edebilir.',
  sometimes: 'Ara sıra gördüğün bu tema, zaman zaman gündeme gelen bir iç meseleyi yansıtıyor olabilir.',
  often: 'Sık tekrarlayan bu rüya, bilinçaltının ısrarla dikkatini çekmeye çalıştığı önemli bir konuyu gösteriyor.',
};

const CLARITY_TEXT: Record<string, string> = {
  blurry: 'Bulanık hatırladığın detaylar, henüz tam olarak bilinç düzeyine çıkmamış duyguları temsil edebilir.',
  mid: 'Orta düzeyde netlikte hatırladığın rüya, bilinç ve bilinçaltı arasındaki köprüyü simgeliyor.',
  clear: 'Net ve detaylı hatırladığın bu rüya, bilinçaltının güçlü ve açık bir mesaj taşıdığını gösteriyor.',
};

const WARNINGS = [
  'Rüyanın tetiklediği duygulara takılıp kalmamaya dikkat et. Mesajı al, ama geçmişte kaybolma.',
  'Rüyayı olduğu gibi kabul et. Her detayı "çözmeye" çalışmak yerine, genel hissiyata odaklan.',
  'Bu yorumu kesin bir gerçeklik olarak değil, düşünce için bir başlangıç noktası olarak ele al.',
];

const RECOMMENDATIONS = [
  'Rüyanı yazdıktan sonra birkaç gün bekle ve tekrar oku. Zamanla farklı anlayışlar gelişebilir.',
  'Rüyandaki duyguyu günlük hayatında nerede hissettiğini fark etmeye çalış.',
  'Kendine nazik ol. Bilinçaltının mesajları yargılama değil, anlama içindir.',
];

function generateInterpretation(
  dreamText: string,
  answers: QuizData['answers'],
  segment: string,
  variant: 'mini' | 'full'
): InterpretationContent {
  const emotion = answers?.emotion || 'curiosity';
  const frequency = answers?.frequency || 'sometimes';
  const clarity = answers?.clarity || 'mid';

  const summary = [
    EMOTION_TEXT[emotion],
    FREQUENCY_TEXT[frequency],
    CLARITY_TEXT[clarity],
  ].join(' ');

  const symbols = 'Rüyandaki ana temalar, kişisel deneyimlerinle bağlantılı semboller taşıyor. Her sembol, senin hayat hikayenle anlam kazanır. Evrensel arketipler kişisel bağlamınla birleştiğinde gerçek mesaj ortaya çıkar.';

  let psychology = '';
  let spiritual = '';

  if (variant === 'full') {
    psychology = 'Psikolojik açıdan, bu rüya bilinçdışı zihninin günlük yaşamda bastırılan veya görmezden gelinen duygularla yüzleşme çabasını yansıtıyor olabilir. Jung\'un perspektifinden, rüyalar bilinç ve bilinçdışı arasında bir denge kurma işlevi görür.';
    spiritual = 'Ruhsal geleneklerde rüyalar, içsel bilgeliğin ve sezginin sesi olarak kabul edilir. Bu rüya, daha derin bir farkındalığa ve içsel huzura giden yolda bir davet olabilir.';
  }

  const warningIdx = Math.floor(Math.random() * WARNINGS.length);
  const recIdx = Math.floor(Math.random() * RECOMMENDATIONS.length);

  return {
    summary,
    symbols,
    psychology,
    spiritual,
    warning: WARNINGS[warningIdx],
    recommendation: RECOMMENDATIONS[recIdx],
    disclaimer: 'Bu yorum eğlence ve kişisel keşif amaçlıdır. Profesyonel psikolojik danışmanlık, tıbbi tavsiye veya gelecek tahmini içermez.',
  };
}

function generatePdfHtml(content: InterpretationContent, dreamText: string): string {
  return `<!DOCTYPE html>
<html lang="tr">
<head>
<meta charset="UTF-8">
<title>Kisisel Ruya Analizi</title>
<style>
body{font-family:Times New Roman,serif;margin:40px;line-height:1.6;color:#222}
h1{text-align:center;font-size:24px;margin-bottom:30px}
h2{font-size:16px;margin-top:25px;margin-bottom:10px;border-bottom:1px solid #ccc;padding-bottom:5px}
p{margin:10px 0;text-align:justify}
.dream{font-style:italic;background:#f5f5f5;padding:15px;margin:20px 0}
.warning{border-left:3px solid #c00;padding-left:15px;margin:20px 0}
.recommendation{border-left:3px solid #090;padding-left:15px;margin:20px 0}
.disclaimer{font-size:12px;color:#666;margin-top:40px;padding-top:20px;border-top:1px solid #ccc;text-align:center}
.footer{text-align:center;margin-top:30px;font-size:12px;color:#888}
</style>
</head>
<body>
<h1>Kisisel Ruya Analizi</h1>
${dreamText ? `<div class="dream"><strong>Ruyan:</strong><br>"${escapeHtml(dreamText)}"</div>` : ''}
<h2>Kisisel Ozet</h2>
<p>${escapeHtml(content.summary)}</p>
<h2>Sembol Analizi</h2>
<p>${escapeHtml(content.symbols)}</p>
${content.psychology ? `<h2>Psikolojik Icgoru</h2><p>${escapeHtml(content.psychology)}</p>` : ''}
${content.spiritual ? `<h2>Ruhsal Perspektif</h2><p>${escapeHtml(content.spiritual)}</p>` : ''}
<div class="warning"><strong>Dikkat:</strong><br>${escapeHtml(content.warning)}</div>
<div class="recommendation"><strong>Oneri:</strong><br>${escapeHtml(content.recommendation)}</div>
<div class="disclaimer">${escapeHtml(content.disclaimer)}</div>
<div class="footer">astrobobo.com</div>
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

function generateEmailText(content: InterpretationContent, dreamText: string, variant: 'mini' | 'full', pdfAvailable: boolean): string {
  let text = `Merhaba,

Ruya yorumun hazir!

`;

  if (dreamText) {
    text += `RUYAN:
"${dreamText}"

`;
  }

  text += `KISISEL OZET:
${content.summary}

SEMBOL ANALIZI:
${content.symbols}

`;

  if (variant === 'full' && content.psychology) {
    text += `PSIKOLOJIK ICGORU:
${content.psychology}

RUHSAL PERSPEKTIF:
${content.spiritual}

`;
  }

  text += `DIKKAT:
${content.warning}

ONERI:
${content.recommendation}

`;

  if (pdfAvailable) {
    text += `PDF raporunu indirmek icin siteyi ziyaret et:
https://astrobobo.com/thanks?qt=YOUR_QT

`;
  }

  text += `---
${content.disclaimer}

Yeni ruya yorumlari icin: https://astrobobo.com/quiz

Sevgilerle,
Astrobobo`;

  return text;
}

async function sendEmail(
  env: Env,
  to: string,
  subject: string,
  body: string
): Promise<boolean> {
  if (!env.SMTP_HOST || !env.SMTP_USER || !env.SMTP_PASS) {
    console.log('SMTP not configured, skipping email');
    return false;
  }

  try {
    // Using MailChannels API (free on Cloudflare Workers)
    const response = await fetch('https://api.mailchannels.net/tx/v1/send', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        personalizations: [{ to: [{ email: to }] }],
        from: { email: env.SMTP_FROM || 'noreply@astrobobo.com', name: 'Astrobobo' },
        subject,
        content: [{ type: 'text/plain', value: body }],
      }),
    });

    return response.ok;
  } catch (error) {
    console.error('Email send error:', error);
    return false;
  }
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

    if (order.status === 'blocked') {
      return Response.json({ error: 'Order blocked' }, { status: 403 });
    }

    if (order.status !== 'paid') {
      return Response.json({ error: 'Payment not verified' }, { status: 402 });
    }

    // Idempotent: return cached content if exists
    if (order.content && order.deliveredAt) {
      return Response.json({
        qt: order.qt,
        saleId: order.saleId,
        variant: order.variant,
        dreamText: order.dreamText || '',
        content: order.content,
        deliveredAt: order.deliveredAt,
        hasPdf: order.variant === 'full' && !!order.pdfBase64,
      });
    }

    // Fetch quiz data from KV
    const quizRaw = await context.env.ORDERS.get(`quiz:${qt}`);
    const quizData: QuizData = quizRaw
      ? JSON.parse(quizRaw)
      : {
          dreamText: '',
          answers: { emotion: 'curiosity', frequency: 'sometimes', clarity: 'mid' },
          segment: 'mid',
        };

    const content = generateInterpretation(
      quizData.dreamText,
      quizData.answers,
      quizData.segment,
      order.variant
    );

    // Generate PDF for full variant (idempotent)
    let pdfBase64: string | undefined;
    let pdfGeneratedAt: string | undefined;

    if (order.variant === 'full' && !order.pdfBase64) {
      const pdfHtml = generatePdfHtml(content, quizData.dreamText);
      // Store HTML as base64 for client-side print
      pdfBase64 = btoa(unescape(encodeURIComponent(pdfHtml)));
      pdfGeneratedAt = new Date().toISOString();
    }

    const now = new Date().toISOString();

    // Update order with generated content
    const updatedOrder: OrderRecord = {
      ...order,
      content,
      dreamText: quizData.dreamText,
      deliveredAt: now,
      pdfBase64: pdfBase64 || order.pdfBase64,
      pdfGeneratedAt: pdfGeneratedAt || order.pdfGeneratedAt,
    };

    // Send email (once only)
    if (!order.emailSentAt && order.email) {
      const emailBody = generateEmailText(
        content,
        quizData.dreamText,
        order.variant,
        order.variant === 'full'
      ).replace('YOUR_QT', qt);

      const emailSent = await sendEmail(
        context.env,
        order.email,
        'Kisisel Ruya Yorumun Hazir',
        emailBody
      );

      if (emailSent) {
        updatedOrder.emailSentAt = now;
      }
    }

    await context.env.ORDERS.put(`qt:${qt}`, JSON.stringify(updatedOrder), {
      expirationTtl: 60 * 60 * 24 * 90,
    });

    console.log('Content delivered:', {
      qt,
      saleId: order.saleId,
      variant: order.variant,
      pdfGenerated: !!pdfBase64,
      emailSent: !!updatedOrder.emailSentAt,
    });

    return Response.json({
      qt: updatedOrder.qt,
      saleId: updatedOrder.saleId,
      variant: updatedOrder.variant,
      dreamText: updatedOrder.dreamText,
      content: updatedOrder.content,
      deliveredAt: updatedOrder.deliveredAt,
      hasPdf: order.variant === 'full' && !!(pdfBase64 || order.pdfBase64),
    });
  } catch (error) {
    console.error('Render error:', error);
    return Response.json({ error: 'Internal error' }, { status: 500 });
  }
};
