import { NextResponse } from "next/server";
import { zodiacSigns } from "@/content/zodiac/signs";
import { articles } from "@/content/articles";

const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL || "https://innercycles.app";

export async function GET() {
  const now = new Date().toISOString().split("T")[0];

  const staticPages = [
    { url: "/", changefreq: "weekly", priority: "1.0" },
    { url: "/zodiac", changefreq: "weekly", priority: "0.9" },
    { url: "/articles", changefreq: "daily", priority: "0.9" },
    { url: "/archetype", changefreq: "monthly", priority: "0.7" },
    { url: "/privacy", changefreq: "yearly", priority: "0.3" },
    { url: "/terms", changefreq: "yearly", priority: "0.3" },
  ];

  const zodiacPages = zodiacSigns.map((s) => ({
    url: `/zodiac/${s.slug}`,
    changefreq: "weekly",
    priority: "0.8",
  }));

  const articlePages = articles.map((a) => ({
    url: `/articles/${a.slug}`,
    changefreq: "monthly",
    priority: "0.7",
    lastmod: a.publishedAt.split("T")[0],
  }));

  const allPages = [...staticPages, ...zodiacPages, ...articlePages];

  const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${allPages
  .map(
    (p) => `  <url>
    <loc>${SITE_URL}${p.url}</loc>
    <lastmod>${("lastmod" in p && p.lastmod) || now}</lastmod>
    <changefreq>${p.changefreq}</changefreq>
    <priority>${p.priority}</priority>
  </url>`
  )
  .join("\n")}
</urlset>`;

  return new NextResponse(xml, {
    headers: {
      "Content-Type": "application/xml",
      "Cache-Control": "public, s-maxage=3600, stale-while-revalidate=86400",
    },
  });
}
