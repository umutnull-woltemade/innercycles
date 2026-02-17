import { NextResponse } from "next/server";

const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL || "https://innercycles.app";

export async function GET() {
  const robots = `# InnerCycles - ${SITE_URL}

User-agent: *
Allow: /

# Block internal routes
Disallow: /api/
Disallow: /_next/
Disallow: /admin/
Disallow: /preview/

# Block query parameter duplicates
Disallow: /*?sort=
Disallow: /*?filter=
Disallow: /*?page=
Disallow: /*?utm_*
Disallow: /*?ref=

# Block legacy static HTML
Disallow: /*.html$

# Sitemap
Sitemap: ${SITE_URL}/api/sitemap

# Google
User-agent: Googlebot
Allow: /
Crawl-delay: 0

# Bing
User-agent: Bingbot
Allow: /
Crawl-delay: 1

# Block aggressive crawlers
User-agent: AhrefsBot
Disallow: /

User-agent: SemrushBot
Disallow: /

User-agent: MJ12bot
Disallow: /

User-agent: DotBot
Disallow: /

User-agent: GPTBot
Disallow: /

User-agent: CCBot
Disallow: /
`;

  return new NextResponse(robots, {
    headers: {
      "Content-Type": "text/plain",
      "Cache-Control": "public, s-maxage=86400, stale-while-revalidate=604800",
    },
  });
}
