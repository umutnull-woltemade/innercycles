const RATE_LIMIT_WINDOW = 60 * 1000; // 1 minute
const RATE_LIMIT_MAX = 30; // requests per window

interface RateLimitEntry {
  count: number;
  resetAt: number;
}

const rateLimitMap = new Map<string, RateLimitEntry>();

function getRateLimitKey(request: Request): string {
  const ip = request.headers.get('cf-connecting-ip') ||
             request.headers.get('x-forwarded-for')?.split(',')[0] ||
             'unknown';
  return `rate:${ip}`;
}

function checkRateLimit(key: string): { allowed: boolean; remaining: number } {
  const now = Date.now();
  let entry = rateLimitMap.get(key);

  if (!entry || now > entry.resetAt) {
    entry = { count: 0, resetAt: now + RATE_LIMIT_WINDOW };
    rateLimitMap.set(key, entry);
  }

  entry.count++;

  if (entry.count > RATE_LIMIT_MAX) {
    return { allowed: false, remaining: 0 };
  }

  return { allowed: true, remaining: RATE_LIMIT_MAX - entry.count };
}

export const onRequest: PagesFunction = async (context) => {
  const url = new URL(context.request.url);

  // Skip rate limiting for static assets
  if (!url.pathname.startsWith('/api/')) {
    return context.next();
  }

  // CORS headers - allow localhost for development
  const origin = context.request.headers.get('Origin') || '';
  const allowedOrigins = [
    'https://astrobobo.com',
    'https://www.astrobobo.com',
    'http://localhost:8788',
    'http://127.0.0.1:8788',
  ];
  const allowOrigin = allowedOrigins.includes(origin) ? origin : 'https://astrobobo.com';

  const corsHeaders = {
    'Access-Control-Allow-Origin': allowOrigin,
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    'Access-Control-Max-Age': '86400',
  };

  // Handle preflight
  if (context.request.method === 'OPTIONS') {
    return new Response(null, { status: 204, headers: corsHeaders });
  }

  // Rate limiting for sensitive endpoints
  const sensitiveEndpoints = ['/api/order/render', '/api/order/pdf'];
  if (sensitiveEndpoints.some(ep => url.pathname.startsWith(ep))) {
    const key = getRateLimitKey(context.request);
    const { allowed, remaining } = checkRateLimit(key);

    if (!allowed) {
      return new Response(JSON.stringify({ error: 'Rate limit exceeded' }), {
        status: 429,
        headers: {
          ...corsHeaders,
          'Content-Type': 'application/json',
          'Retry-After': '60',
        },
      });
    }
  }

  // Continue to handler
  const response = await context.next();

  // Add CORS headers to response
  const newHeaders = new Headers(response.headers);
  Object.entries(corsHeaders).forEach(([key, value]) => {
    newHeaders.set(key, value);
  });

  return new Response(response.body, {
    status: response.status,
    statusText: response.statusText,
    headers: newHeaders,
  });
};
