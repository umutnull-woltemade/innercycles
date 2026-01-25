# Dream Interpretation Funnel

Production-ready quiz + Gumroad payment + content delivery system for Astrobobo.

## Features

- **Quiz Flow**: Dream text input + 3 segmentation questions
- **Payment**: Gumroad integration with webhook verification
- **Content Delivery**: AI-generated Turkish dream interpretations
- **PDF Reports**: Browser print-to-PDF for full product
- **Email Delivery**: MailChannels API (free on Cloudflare)
- **Push Notifications**: OneSignal integration
- **Security**: qt token binding, rate limiting, idempotent delivery

## File Structure

```
dream-funnel/
├── quiz.html                    # Quiz page (public entry point)
├── thanks.html                  # Delivery page (post-purchase)
├── wrangler.toml               # Cloudflare config
├── README.md                   # This file
└── functions/
    ├── _middleware.ts          # CORS + rate limiting
    └── api/
        ├── gumroad/
        │   └── ping.ts         # Gumroad webhook receiver
        ├── order/
        │   ├── status.ts       # Check payment status
        │   ├── render.ts       # Generate + deliver content + email
        │   └── pdf.ts          # PDF HTML generation
        ├── quiz/
        │   └── save.ts         # Save quiz data before checkout
        └── push/
            ├── register.ts     # Store OneSignal player ID
            └── daily.ts        # Daily push cron endpoint
```

## Setup

### 1. Create KV Namespace

```bash
cd dream-funnel
wrangler kv:namespace create ORDERS
wrangler kv:namespace create ORDERS --preview
```

Copy the IDs from the output.

### 2. Update wrangler.toml

Replace placeholder values:
```toml
[[kv_namespaces]]
binding = "ORDERS"
id = "YOUR_ACTUAL_KV_ID"
preview_id = "YOUR_ACTUAL_PREVIEW_ID"
```

### 3. Configure Environment Variables

In Cloudflare Dashboard > Pages > Settings > Environment Variables:

| Variable | Description |
|----------|-------------|
| `SMTP_FROM` | Sender email (e.g., `noreply@astrobobo.com`) |
| `ONESIGNAL_APP_ID` | OneSignal App ID |
| `ONESIGNAL_API_KEY` | OneSignal REST API Key |

### 4. Update OneSignal App ID in thanks.html

Replace `YOUR_ONESIGNAL_APP_ID` in the OneSignal init:

```javascript
await OneSignal.init({
  appId: "YOUR_ACTUAL_ONESIGNAL_APP_ID",
  // ...
});
```

### 5. Deploy

```bash
wrangler pages deploy ./
```

### 6. Configure Gumroad

**Products:**
- `ruya-mini` - Mini Kisisel Yorum ($4.99)
- `ruya-detayli` - Detayli Kisisel Yorum + PDF ($9.99)

**Webhook URL:**
```
https://your-domain.pages.dev/api/gumroad/ping
```

**Custom Field:**
- Field name: `qt`
- Required: Yes

**Redirect After Purchase:**
```
https://your-domain.pages.dev/thanks?qt={qt}
```

### 7. Set Up Daily Push Cron (Optional)

Use Cloudflare Cron Triggers or external cron service to call:

```bash
curl -X POST https://your-domain.pages.dev/api/push/daily \
  -H "Authorization: Bearer YOUR_ONESIGNAL_API_KEY"
```

## Flow

```
1. User visits /quiz
2. UUID qt generated client-side
3. User completes quiz
4. Quiz data saved to KV via /api/quiz/save
5. User redirected to Gumroad with ?qt=...
6. User purchases on Gumroad
7. Gumroad sends webhook to /api/gumroad/ping
8. User redirected to /thanks?qt=...
9. Page polls /api/order/status
10. When status=paid, fetches /api/order/render
11. Content generated, cached, email sent (once)
12. Push notification prompt shown after content
```

## Security

| Feature | Implementation |
|---------|----------------|
| **Payment Verification** | Content only delivered after Gumroad webhook |
| **Token Binding** | qt links quiz → payment → delivery |
| **Idempotent Delivery** | Content generated once, cached in KV |
| **Rate Limiting** | 30 req/min on sensitive endpoints |
| **Abuse Prevention** | Refund/dispute sets status=blocked |
| **CORS** | Restricted to astrobobo.com + localhost |

## KV Keys

| Pattern | Description | TTL |
|---------|-------------|-----|
| `qt:{qt}` | Order record | 90 days |
| `quiz:{qt}` | Quiz data | 7 days |
| `sale:{sale_id}` | Maps Gumroad sale to qt | 90 days |
| `push:{pushId}` | Maps OneSignal ID to qt | 90 days |

## Local Development

```bash
# Start local dev server
wrangler pages dev ./ --kv ORDERS

# Test quiz flow
open http://localhost:8788/quiz
```

## Troubleshooting

**Content not delivered:**
- Check if payment webhook received (`wrangler tail`)
- Verify qt parameter matches between quiz and thanks page
- Check KV for order record: `wrangler kv:key get --binding ORDERS "qt:YOUR_QT"`

**Email not sent:**
- MailChannels requires domain verification for production
- Check logs for email send errors

**Push not working:**
- Verify OneSignal App ID in thanks.html
- Check browser notification permissions
- Verify ONESIGNAL_API_KEY in environment

## Products

### Mini Kisisel Yorum ($4.99)
- Kisisel ozet
- Sembol analizi
- Dikkat + oneri

### Detayli Kisisel Yorum + PDF ($9.99)
- Everything in Mini
- Psikolojik icgoru
- Ruhsal perspektif
- PDF rapor indirme
- Email teslimat
