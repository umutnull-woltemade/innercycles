/**
 * PDF Generator for Dream Interpretation Reports
 *
 * Generates styled PDF reports for the "Detaylı" (full) product.
 * Uses PDFKit for generation.
 */

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import PDFDocument from 'pdfkit';

if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();
const storage = admin.storage();

// ═══════════════════════════════════════════════════════════════
// TYPES
// ═══════════════════════════════════════════════════════════════

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
// PDF GENERATION
// ═══════════════════════════════════════════════════════════════

async function generatePdf(
  interpretation: InterpretationResult,
  orderId: string
): Promise<Buffer> {
  return new Promise((resolve, reject) => {
    const chunks: Buffer[] = [];
    const doc = new PDFDocument({
      size: 'A4',
      margins: { top: 60, bottom: 60, left: 50, right: 50 },
      info: {
        Title: 'Rüya Yorumu - Astrobobo',
        Author: 'Astrobobo',
        Subject: 'Kişisel Rüya Yorumu',
        Keywords: 'rüya, yorum, bilinçaltı'
      }
    });

    doc.on('data', (chunk) => chunks.push(chunk));
    doc.on('end', () => resolve(Buffer.concat(chunks)));
    doc.on('error', reject);

    // Colors
    const colors = {
      primary: '#FFD700',
      secondary: '#C9B8FF',
      text: '#333333',
      lightText: '#666666',
      warning: '#E74C3C',
      success: '#2ECC71',
      background: '#F8F8F8'
    };

    // Header
    doc.rect(0, 0, doc.page.width, 100).fill('#0D0D1A');
    doc.fillColor(colors.primary)
      .fontSize(28)
      .font('Helvetica-Bold')
      .text('Rüya Yorumun', 50, 35, { align: 'center' });
    doc.fillColor('#FFFFFF')
      .fontSize(12)
      .font('Helvetica')
      .text('Detaylı Kişisel Analiz', 50, 70, { align: 'center' });

    doc.moveDown(3);

    // Order info
    doc.fillColor(colors.lightText)
      .fontSize(10)
      .text(`Sipariş: ${orderId} | ${new Date().toLocaleDateString('tr-TR')}`, { align: 'right' });

    doc.moveDown(2);

    // Dream Text Section
    if (interpretation.dreamText) {
      doc.fillColor(colors.secondary)
        .fontSize(14)
        .font('Helvetica-Bold')
        .text('Senin Rüyan');
      doc.moveDown(0.5);
      doc.rect(50, doc.y, doc.page.width - 100, 0.5).fill(colors.secondary);
      doc.moveDown(0.5);
      doc.fillColor(colors.lightText)
        .fontSize(11)
        .font('Helvetica-Oblique')
        .text(`"${interpretation.dreamText}"`, { align: 'left' });
      doc.moveDown(1.5);
    }

    // Personal Summary
    doc.fillColor(colors.secondary)
      .fontSize(14)
      .font('Helvetica-Bold')
      .text('Kişisel Özet');
    doc.moveDown(0.5);
    doc.rect(50, doc.y, doc.page.width - 100, 0.5).fill(colors.secondary);
    doc.moveDown(0.5);
    doc.fillColor(colors.text)
      .fontSize(11)
      .font('Helvetica')
      .text(interpretation.summary, { align: 'justify', lineGap: 4 });
    doc.moveDown(1.5);

    // Symbol Analysis
    doc.fillColor(colors.secondary)
      .fontSize(14)
      .font('Helvetica-Bold')
      .text('Sembol Analizi');
    doc.moveDown(0.5);
    doc.rect(50, doc.y, doc.page.width - 100, 0.5).fill(colors.secondary);
    doc.moveDown(0.5);
    doc.fillColor(colors.text)
      .fontSize(11)
      .font('Helvetica')
      .text(interpretation.symbols, { align: 'justify', lineGap: 4 });
    doc.moveDown(1.5);

    // Psychological Insight (Full only)
    if (interpretation.psychology) {
      doc.fillColor(colors.secondary)
        .fontSize(14)
        .font('Helvetica-Bold')
        .text('Psikolojik İçgörü');
      doc.moveDown(0.5);
      doc.rect(50, doc.y, doc.page.width - 100, 0.5).fill(colors.secondary);
      doc.moveDown(0.5);
      doc.fillColor(colors.text)
        .fontSize(11)
        .font('Helvetica')
        .text(interpretation.psychology, { align: 'justify', lineGap: 4 });
      doc.moveDown(1.5);
    }

    // Spiritual Perspective (Full only)
    if (interpretation.spiritual) {
      doc.fillColor(colors.secondary)
        .fontSize(14)
        .font('Helvetica-Bold')
        .text('Ruhsal Perspektif');
      doc.moveDown(0.5);
      doc.rect(50, doc.y, doc.page.width - 100, 0.5).fill(colors.secondary);
      doc.moveDown(0.5);
      doc.fillColor(colors.text)
        .fontSize(11)
        .font('Helvetica')
        .text(interpretation.spiritual, { align: 'justify', lineGap: 4 });
      doc.moveDown(1.5);
    }

    // Warning Box
    const warningY = doc.y;
    doc.rect(50, warningY, doc.page.width - 100, 60)
      .fillAndStroke('#FDF2F2', colors.warning);
    doc.fillColor(colors.warning)
      .fontSize(12)
      .font('Helvetica-Bold')
      .text('Dikkat Edilmesi Gereken', 60, warningY + 10);
    doc.fillColor(colors.text)
      .fontSize(10)
      .font('Helvetica')
      .text(interpretation.warning, 60, warningY + 28, {
        width: doc.page.width - 120
      });
    doc.y = warningY + 70;
    doc.moveDown(1);

    // Recommendation Box
    const recY = doc.y;
    doc.rect(50, recY, doc.page.width - 100, 60)
      .fillAndStroke('#F0FDF4', colors.success);
    doc.fillColor(colors.success)
      .fontSize(12)
      .font('Helvetica-Bold')
      .text('Öneri', 60, recY + 10);
    doc.fillColor(colors.text)
      .fontSize(10)
      .font('Helvetica')
      .text(interpretation.recommendation, 60, recY + 28, {
        width: doc.page.width - 120
      });
    doc.y = recY + 70;

    // Footer
    doc.moveDown(2);
    doc.rect(50, doc.y, doc.page.width - 100, 0.5).fill('#E0E0E0');
    doc.moveDown(1);
    doc.fillColor(colors.lightText)
      .fontSize(9)
      .font('Helvetica')
      .text(
        'Bu yorum eğlence ve kişisel keşif amaçlıdır. Profesyonel psikolojik danışmanlık, tıbbi tavsiye veya gelecek tahmini içermez. Kararlarınızı bu yoruma dayandırmayınız.',
        { align: 'center', lineGap: 3 }
      );
    doc.moveDown(1);
    doc.fillColor(colors.secondary)
      .fontSize(10)
      .text('astrobobo.com', { align: 'center', link: 'https://astrobobo.com' });

    doc.end();
  });
}

// ═══════════════════════════════════════════════════════════════
// CLOUD FUNCTION
// ═══════════════════════════════════════════════════════════════

export const generateDreamPdf = functions.https.onRequest(async (req, res) => {
  // CORS
  res.set('Access-Control-Allow-Origin', 'https://astrobobo.com');
  res.set('Access-Control-Allow-Methods', 'POST, GET');
  res.set('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    return;
  }

  try {
    const orderId = req.query.order_id as string || req.body?.orderId;

    if (!orderId) {
      res.status(400).json({ error: 'Missing order ID' });
      return;
    }

    // Get purchase data
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

    if (purchaseData?.productType !== 'full') {
      res.status(403).json({ error: 'PDF only available for full product' });
      return;
    }

    const interpretation = purchaseData?.interpretation as InterpretationResult;

    if (!interpretation) {
      res.status(404).json({ error: 'Interpretation not found' });
      return;
    }

    // Check if PDF already exists
    const bucket = storage.bucket();
    const pdfPath = `dream-pdfs/${orderId}.pdf`;
    const file = bucket.file(pdfPath);
    const [exists] = await file.exists();

    let pdfUrl: string;

    if (exists) {
      // Return existing PDF URL
      const [signedUrl] = await file.getSignedUrl({
        action: 'read',
        expires: Date.now() + 24 * 60 * 60 * 1000 // 24 hours
      });
      pdfUrl = signedUrl;
    } else {
      // Generate new PDF
      const pdfBuffer = await generatePdf(interpretation, orderId);

      // Upload to Storage
      await file.save(pdfBuffer, {
        metadata: {
          contentType: 'application/pdf',
          metadata: {
            orderId,
            generatedAt: new Date().toISOString()
          }
        }
      });

      // Get signed URL
      const [signedUrl] = await file.getSignedUrl({
        action: 'read',
        expires: Date.now() + 24 * 60 * 60 * 1000 // 24 hours
      });
      pdfUrl = signedUrl;

      // Update purchase record
      await purchaseDoc.ref.update({
        pdfGenerated: true,
        pdfPath,
        pdfGeneratedAt: admin.firestore.FieldValue.serverTimestamp()
      });
    }

    res.status(200).json({ url: pdfUrl });

  } catch (error) {
    console.error('PDF generation error:', error);
    res.status(500).json({ error: 'Failed to generate PDF' });
  }
});

// ═══════════════════════════════════════════════════════════════
// TRIGGERED PDF GENERATION
// ═══════════════════════════════════════════════════════════════

export const onPurchaseCreated = functions.firestore
  .document('dream_purchases/{purchaseId}')
  .onCreate(async (snap, context) => {
    const purchase = snap.data();
    const purchaseId = context.params.purchaseId;

    // Only generate PDF for full product
    if (purchase.productType !== 'full') {
      console.log(`Skipping PDF for mini product: ${purchaseId}`);
      return null;
    }

    try {
      const interpretation = purchase.interpretation as InterpretationResult;

      if (!interpretation) {
        console.error(`No interpretation found for: ${purchaseId}`);
        return null;
      }

      // Generate PDF
      const pdfBuffer = await generatePdf(interpretation, purchaseId);

      // Upload to Storage
      const bucket = storage.bucket();
      const pdfPath = `dream-pdfs/${purchaseId}.pdf`;
      const file = bucket.file(pdfPath);

      await file.save(pdfBuffer, {
        metadata: {
          contentType: 'application/pdf',
          metadata: {
            orderId: purchaseId,
            generatedAt: new Date().toISOString()
          }
        }
      });

      // Update purchase record
      await snap.ref.update({
        pdfGenerated: true,
        pdfPath,
        pdfGeneratedAt: admin.firestore.FieldValue.serverTimestamp()
      });

      console.log(`PDF generated for: ${purchaseId}`);
      return null;

    } catch (error) {
      console.error(`PDF generation failed for ${purchaseId}:`, error);
      await snap.ref.update({
        pdfError: String(error),
        pdfGeneratedAt: admin.firestore.FieldValue.serverTimestamp()
      });
      return null;
    }
  });
