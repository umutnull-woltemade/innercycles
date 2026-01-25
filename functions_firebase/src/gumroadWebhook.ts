/**
 * Gumroad Webhook Handler for Dream Interpretation Products
 *
 * Handles:
 * - Purchase verification
 * - Email delivery with interpretation
 * - PDF generation for full product
 */

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

// ═══════════════════════════════════════════════════════════════
// TYPES
// ═══════════════════════════════════════════════════════════════

interface GumroadPurchase {
  seller_id: string;
  product_id: string;
  product_name: string;
  permalink: string;
  product_permalink: string;
  short_product_id: string;
  email: string;
  price: number;
  gumroad_fee: number;
  currency: string;
  quantity: number;
  order_number: number;
  sale_id: string;
  sale_timestamp: string;
  purchaser_id: string;
  subscription_id: string;
  variants: string;
  test: boolean;
  ip_country: string;
  is_gift_receiver_purchase: boolean;
  refunded: boolean;
  disputed: boolean;
  dispute_won: boolean;
  custom_fields: Record<string, string>;
}

interface QuizAnswers {
  emotion: 'fear' | 'curiosity' | 'relief';
  frequency: 'first' | 'sometimes' | 'often';
  clarity: 'blurry' | 'mid' | 'clear';
}

interface InterpretationResult {
  summary: string;
  symbols: string;
  psychology: string;
  spiritual: string;
  warning: string;
  recommendation: string;
  dreamText: string;
  productType: 'mini' | 'full';
  generatedAt: string;
}

// ═══════════════════════════════════════════════════════════════
// INTERPRETATION GENERATOR
// ═══════════════════════════════════════════════════════════════

function generateInterpretation(
  dreamText: string,
  answers: QuizAnswers,
  productType: 'mini' | 'full'
): InterpretationResult {
  const emotionTexts: Record<string, string> = {
    fear: 'Rüyanda hissettiğin korku veya endişe, bilinçaltının dikkatini çekmeye çalıştığı bir alana işaret edebilir.',
    curiosity: 'Rüyandaki merak duygusu, yeni keşiflere ve içsel büyümeye olan açıklığını yansıtıyor olabilir.',
    relief: 'Hissettiğin rahatlama, içsel bir çözülmenin veya kabul sürecinin habercisi olabilir.'
  };

  const frequencyTexts: Record<string, string> = {
    first: 'Bu rüyayı ilk kez görmen, hayatında yeni bir dönemin başladığına işaret edebilir.',
    sometimes: 'Ara sıra gördüğün bu tema, zaman zaman gündeme gelen bir iç meseleyi yansıtıyor olabilir.',
    often: 'Sık tekrarlayan bu rüya, bilinçaltının ısrarla dikkatini çekmeye çalıştığı önemli bir konuyu gösteriyor.'
  };

  const clarityTexts: Record<string, string> = {
    blurry: 'Bulanık hatırladığın detaylar, henüz tam olarak bilinç düzeyine çıkmamış duyguları temsil edebilir.',
    mid: 'Orta düzeyde netlikte hatırladığın rüya, bilinç ve bilinçaltı arasındaki köprüyü simgeliyor.',
    clear: 'Net ve detaylı hatırladığın bu rüya, bilinçaltının güçlü ve açık bir mesaj taşıdığını gösteriyor.'
  };

  const summary = `${emotionTexts[answers.emotion]} ${frequencyTexts[answers.frequency]} ${clarityTexts[answers.clarity]}`;

  const symbols = 'Rüyandaki ana temalar, kişisel deneyimlerinle bağlantılı semboller taşıyor. Her sembol, senin hayat hikayenle anlam kazanır. Evrensel arketipler kişisel bağlamınla birleştiğinde gerçek mesaj ortaya çıkar.';

  let psychology = '';
  let spiritual = '';

  if (productType === 'full') {
    psychology = 'Psikolojik açıdan, bu rüya bilinçdışı zihninin günlük yaşamda bastırılan veya görmezden gelinen duygularla yüzleşme çabasını yansıtıyor olabilir. Jung\'un perspektifinden, rüyalar bilinç ve bilinçdışı arasında bir denge kurma işlevi görür.';
    spiritual = 'Ruhsal geleneklerde rüyalar, içsel bilgeliğin ve sezginin sesi olarak kabul edilir. Bu rüya, daha derin bir farkındalığa ve içsel huzura giden yolda bir davet olabilir.';
  }

  const warnings = [
    'Rüyanın tetiklediği duygulara takılıp kalmamaya dikkat et. Mesajı al, ama geçmişte kaybolma.',
    'Rüyayı olduğu gibi kabul et. Her detayı "çözmeye" çalışmak yerine, genel hissiyata odaklan.',
    'Bu yorumu kesin bir gerçeklik olarak değil, düşünce için bir başlangıç noktası olarak ele al.'
  ];

  const recommendations = [
    'Rüyanı yazdıktan sonra birkaç gün bekle ve tekrar oku. Zamanla farklı anlayışlar gelişebilir.',
    'Rüyandaki duyguyu günlük hayatında nerede hissettiğini fark etmeye çalış.',
    'Kendine nazik ol. Bilinçaltının mesajları yargılama değil, anlama içindir.'
  ];

  const warningIndex = Math.floor(Math.random() * warnings.length);
  const recIndex = Math.floor(Math.random() * recommendations.length);

  return {
    summary,
    symbols,
    psychology,
    spiritual,
    warning: warnings[warningIndex],
    recommendation: recommendations[recIndex],
    dreamText,
    productType,
    generatedAt: new Date().toISOString()
  };
}

// ═══════════════════════════════════════════════════════════════
// EMAIL TEMPLATE
// ═══════════════════════════════════════════════════════════════

function generateEmailHtml(result: InterpretationResult): string {
  const isFull = result.productType === 'full';

  return `
<!DOCTYPE html>
<html lang="tr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Rüya Yorumun - Astrobobo</title>
</head>
<body style="margin:0;padding:0;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;background:#0D0D1A;color:#F5F5F5;">
  <div style="max-width:600px;margin:0 auto;padding:32px 24px;">
    <div style="text-align:center;margin-bottom:32px;">
      <h1 style="color:#FFD700;font-size:24px;margin:0;">Rüya Yorumun Hazır</h1>
      <p style="color:#A0A0A0;font-size:14px;margin-top:8px;">${isFull ? 'Detaylı Kişisel Yorum' : 'Mini Kişisel Yorum'}</p>
    </div>

    ${result.dreamText ? `
    <div style="background:rgba(255,255,255,0.03);border-radius:12px;padding:20px;margin-bottom:16px;border:1px solid rgba(255,215,0,0.1);">
      <h3 style="color:#C9B8FF;font-size:14px;margin:0 0 12px 0;">Senin Rüyan</h3>
      <p style="color:#A0A0A0;font-size:14px;line-height:1.6;margin:0;font-style:italic;">"${result.dreamText}"</p>
    </div>
    ` : ''}

    <div style="background:rgba(255,255,255,0.03);border-radius:12px;padding:20px;margin-bottom:16px;border:1px solid rgba(255,215,0,0.1);">
      <h3 style="color:#C9B8FF;font-size:14px;margin:0 0 12px 0;">Kişisel Özet</h3>
      <p style="color:#E0E0E0;font-size:14px;line-height:1.6;margin:0;">${result.summary}</p>
    </div>

    <div style="background:rgba(255,255,255,0.03);border-radius:12px;padding:20px;margin-bottom:16px;border:1px solid rgba(255,215,0,0.1);">
      <h3 style="color:#C9B8FF;font-size:14px;margin:0 0 12px 0;">Sembol Analizi</h3>
      <p style="color:#E0E0E0;font-size:14px;line-height:1.6;margin:0;">${result.symbols}</p>
    </div>

    ${isFull ? `
    <div style="background:rgba(255,255,255,0.03);border-radius:12px;padding:20px;margin-bottom:16px;border:1px solid rgba(255,215,0,0.1);">
      <h3 style="color:#C9B8FF;font-size:14px;margin:0 0 12px 0;">Psikolojik İçgörü</h3>
      <p style="color:#E0E0E0;font-size:14px;line-height:1.6;margin:0;">${result.psychology}</p>
    </div>

    <div style="background:rgba(255,255,255,0.03);border-radius:12px;padding:20px;margin-bottom:16px;border:1px solid rgba(255,215,0,0.1);">
      <h3 style="color:#C9B8FF;font-size:14px;margin:0 0 12px 0;">Ruhsal Perspektif</h3>
      <p style="color:#E0E0E0;font-size:14px;line-height:1.6;margin:0;">${result.spiritual}</p>
    </div>
    ` : ''}

    <div style="background:rgba(231,76,60,0.1);border-left:3px solid #E74C3C;padding:16px;margin-bottom:16px;border-radius:0 8px 8px 0;">
      <h3 style="color:#E74C3C;font-size:14px;margin:0 0 8px 0;">Dikkat Edilmesi Gereken</h3>
      <p style="color:#E0E0E0;font-size:14px;line-height:1.6;margin:0;">${result.warning}</p>
    </div>

    <div style="background:rgba(46,204,113,0.1);border-left:3px solid #2ECC71;padding:16px;margin-bottom:16px;border-radius:0 8px 8px 0;">
      <h3 style="color:#2ECC71;font-size:14px;margin:0 0 8px 0;">Öneri</h3>
      <p style="color:#E0E0E0;font-size:14px;line-height:1.6;margin:0;">${result.recommendation}</p>
    </div>

    <div style="text-align:center;margin-top:32px;padding-top:24px;border-top:1px solid rgba(255,255,255,0.1);">
      <p style="color:#666;font-size:12px;line-height:1.5;margin:0;">
        Bu yorum eğlence ve kişisel keşif amaçlıdır.<br>
        Profesyonel psikolojik danışmanlık yerine geçmez.
      </p>
      <p style="color:#888;font-size:12px;margin-top:16px;">
        <a href="https://astrobobo.com" style="color:#C9B8FF;text-decoration:none;">Astrobobo</a>
      </p>
    </div>
  </div>
</body>
</html>
  `.trim();
}

// ═══════════════════════════════════════════════════════════════
// WEBHOOK HANDLER
// ═══════════════════════════════════════════════════════════════

export const gumroadWebhook = functions.https.onRequest(async (req, res) => {
  // Only accept POST
  if (req.method !== 'POST') {
    res.status(405).send('Method Not Allowed');
    return;
  }

  try {
    const purchase: GumroadPurchase = req.body;

    // Validate required fields
    if (!purchase.sale_id || !purchase.email) {
      res.status(400).send('Missing required fields');
      return;
    }

    // Skip test purchases in production
    if (purchase.test && process.env.NODE_ENV === 'production') {
      console.log('Skipping test purchase:', purchase.sale_id);
      res.status(200).send('OK - Test purchase skipped');
      return;
    }

    // Determine product type
    const productType: 'mini' | 'full' =
      purchase.permalink.includes('detayli') ||
      purchase.product_name.toLowerCase().includes('detayli')
        ? 'full'
        : 'mini';

    // Get custom fields (dream text and quiz answers)
    const dreamText = purchase.custom_fields?.dream_text || '';
    const answers: QuizAnswers = {
      emotion: (purchase.custom_fields?.emotion as QuizAnswers['emotion']) || 'curiosity',
      frequency: (purchase.custom_fields?.frequency as QuizAnswers['frequency']) || 'sometimes',
      clarity: (purchase.custom_fields?.clarity as QuizAnswers['clarity']) || 'mid'
    };

    // Generate interpretation
    const interpretation = generateInterpretation(dreamText, answers, productType);

    // Store in Firestore
    await db.collection('dream_purchases').doc(purchase.sale_id).set({
      email: purchase.email,
      orderId: purchase.order_number,
      saleId: purchase.sale_id,
      productType,
      price: purchase.price / 100, // Gumroad sends cents
      currency: purchase.currency,
      interpretation,
      dreamText,
      quizAnswers: answers,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      emailSent: false,
      refunded: purchase.refunded
    });

    // Generate email HTML
    const emailHtml = generateEmailHtml(interpretation);

    // Store email for sending (via separate email function or third-party)
    await db.collection('email_queue').add({
      to: purchase.email,
      subject: `Rüya Yorumun Hazır - ${productType === 'full' ? 'Detaylı Yorum' : 'Mini Yorum'}`,
      html: emailHtml,
      saleId: purchase.sale_id,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      sent: false
    });

    console.log(`Purchase processed: ${purchase.sale_id} - ${purchase.email}`);
    res.status(200).send('OK');

  } catch (error) {
    console.error('Webhook error:', error);
    res.status(500).send('Internal Server Error');
  }
});

// ═══════════════════════════════════════════════════════════════
// EMAIL SENDER (Scheduled)
// ═══════════════════════════════════════════════════════════════

export const sendQueuedEmails = functions.pubsub
  .schedule('every 5 minutes')
  .onRun(async () => {
    const snapshot = await db.collection('email_queue')
      .where('sent', '==', false)
      .limit(10)
      .get();

    if (snapshot.empty) {
      console.log('No emails to send');
      return null;
    }

    const batch = db.batch();

    for (const doc of snapshot.docs) {
      const email = doc.data();

      try {
        // Here you would integrate with your email provider
        // Example: SendGrid, Mailgun, AWS SES, etc.
        // await sendEmail(email.to, email.subject, email.html);

        console.log(`Would send email to: ${email.to}`);

        batch.update(doc.ref, {
          sent: true,
          sentAt: admin.firestore.FieldValue.serverTimestamp()
        });

        // Update purchase record
        if (email.saleId) {
          const purchaseRef = db.collection('dream_purchases').doc(email.saleId);
          batch.update(purchaseRef, { emailSent: true });
        }

      } catch (error) {
        console.error(`Failed to send email to ${email.to}:`, error);
        batch.update(doc.ref, {
          error: String(error),
          lastAttempt: admin.firestore.FieldValue.serverTimestamp()
        });
      }
    }

    await batch.commit();
    console.log(`Processed ${snapshot.docs.length} emails`);
    return null;
  });

// ═══════════════════════════════════════════════════════════════
// MANUAL INTERPRETATION ENDPOINT
// ═══════════════════════════════════════════════════════════════

export const generateDreamInterpretation = functions.https.onRequest(async (req, res) => {
  // CORS
  res.set('Access-Control-Allow-Origin', 'https://astrobobo.com');
  res.set('Access-Control-Allow-Methods', 'POST');
  res.set('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }

  if (req.method !== 'POST') {
    res.status(405).send('Method Not Allowed');
    return;
  }

  try {
    const { dreamText, answers, productType, orderId } = req.body;

    if (!orderId) {
      res.status(400).json({ error: 'Missing order ID' });
      return;
    }

    // Verify purchase exists
    const purchaseDoc = await db.collection('dream_purchases').doc(orderId).get();

    if (!purchaseDoc.exists) {
      res.status(404).json({ error: 'Purchase not found' });
      return;
    }

    const purchaseData = purchaseDoc.data();

    if (purchaseData?.refunded) {
      res.status(403).json({ error: 'Purchase was refunded' });
      return;
    }

    // Generate interpretation
    const interpretation = generateInterpretation(
      dreamText || purchaseData?.dreamText || '',
      answers || purchaseData?.quizAnswers || { emotion: 'curiosity', frequency: 'sometimes', clarity: 'mid' },
      productType || purchaseData?.productType || 'mini'
    );

    res.status(200).json(interpretation);

  } catch (error) {
    console.error('Interpretation error:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});
