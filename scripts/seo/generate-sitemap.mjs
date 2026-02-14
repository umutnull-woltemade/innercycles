#!/usr/bin/env node

/**
 * InnerCycles Sitemap Generator
 *
 * Generates sitemap.xml from content files.
 * Focused on dream meanings, journal prompts, and mood patterns.
 *
 * Usage:
 *   node scripts/seo/generate-sitemap.mjs
 *   node scripts/seo/generate-sitemap.mjs --output public/sitemap.xml
 */

import { writeFile, mkdir, readdir } from "node:fs/promises";
import { join, dirname, basename } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = join(__dirname, "../..");

const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL || "https://innercycles.app";
const args = process.argv.slice(2);
const outputIdx = args.indexOf("--output");
const outputPath = outputIdx !== -1 ? args[outputIdx + 1] : "public/sitemap.xml";

// Dream meaning slugs from content directory
const DREAM_SLUGS = [
  "falling", "water", "recurring", "running", "losing-someone",
  "flying", "darkness", "someone-from-past", "searching", "voiceless",
  "lost", "unable-to-fly",
];

// Journal prompt categories for programmatic SEO
const JOURNAL_CATEGORIES = [
  "self-reflection", "gratitude", "anxiety", "relationships",
  "career", "creativity", "mindfulness", "sleep",
];

// Mood pattern topics
const MOOD_TOPICS = [
  "emotional-cycles", "mood-tracking", "energy-patterns",
  "stress-management", "self-awareness",
];

async function getDreamContentSlugs() {
  try {
    const contentDir = join(ROOT, "content/en");
    const files = await readdir(contentDir);
    return files
      .filter((f) => f.startsWith("ruyada-") && f.endsWith(".md"))
      .map((f) => basename(f, ".md").replace("ruyada-", "dream-meaning-"));
  } catch {
    return [];
  }
}

async function generateSitemap() {
  const now = new Date().toISOString().split("T")[0];
  const dynamicDreamSlugs = await getDreamContentSlugs();

  const pages = [
    // Core pages
    { url: "/", freq: "weekly", priority: "1.0" },
    { url: "/journal", freq: "daily", priority: "0.9" },
    { url: "/dream-interpretation", freq: "weekly", priority: "0.9" },
    { url: "/articles", freq: "daily", priority: "0.8" },
    { url: "/dream-glossary", freq: "monthly", priority: "0.8" },

    // Dream meaning pages (high SEO value)
    ...DREAM_SLUGS.map((s) => ({
      url: `/dreams/${s}`,
      freq: "monthly",
      priority: "0.8",
    })),

    // Dynamic dream content from content/ directory
    ...dynamicDreamSlugs.map((s) => ({
      url: `/dreams/${s}`,
      freq: "monthly",
      priority: "0.7",
    })),

    // Journal prompt pages
    ...JOURNAL_CATEGORIES.map((c) => ({
      url: `/journal-prompts/${c}`,
      freq: "weekly",
      priority: "0.7",
    })),

    // Mood pattern pages
    ...MOOD_TOPICS.map((t) => ({
      url: `/mood-patterns/${t}`,
      freq: "monthly",
      priority: "0.6",
    })),

    // Static pages
    { url: "/privacy", freq: "yearly", priority: "0.3" },
    { url: "/terms", freq: "yearly", priority: "0.3" },
  ];

  return `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
        xmlns:image="http://www.google.com/schemas/sitemap-image/1.1">
${pages
  .map(
    (p) => `  <url>
    <loc>${SITE_URL}${p.url}</loc>
    <lastmod>${now}</lastmod>
    <changefreq>${p.freq}</changefreq>
    <priority>${p.priority}</priority>
  </url>`
  )
  .join("\n")}
</urlset>`;
}

async function run() {
  console.log("=== INNERCYCLES SITEMAP GENERATOR ===\n");

  const sitemap = await generateSitemap();
  const fullPath = join(ROOT, outputPath);

  await mkdir(dirname(fullPath), { recursive: true });
  await writeFile(fullPath, sitemap);

  console.log(`Sitemap generated: ${outputPath}`);
  console.log(`URL count: ${sitemap.split("<url>").length - 1}`);
  console.log(`Site URL: ${SITE_URL}`);
}

run().catch((err) => {
  console.error("Sitemap error:", err);
  process.exit(1);
});
