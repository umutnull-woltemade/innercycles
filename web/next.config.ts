import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: "standalone",

  images: {
    formats: ["image/avif", "image/webp"],
    deviceSizes: [640, 750, 828, 1080, 1200, 1920],
    imageSizes: [16, 32, 48, 64, 96, 128, 256],
    minimumCacheTTL: 31536000,
    remotePatterns: [
      {
        protocol: "https",
        hostname: "innercycles.app",
      },
    ],
  },

  headers: async () => [
    {
      source: "/(.*)",
      headers: [
        { key: "X-Content-Type-Options", value: "nosniff" },
        { key: "X-Frame-Options", value: "DENY" },
        { key: "X-XSS-Protection", value: "1; mode=block" },
        { key: "Referrer-Policy", value: "strict-origin-when-cross-origin" },
      ],
    },
    {
      source: "/images/(.*)",
      headers: [
        {
          key: "Cache-Control",
          value: "public, max-age=31536000, immutable",
        },
      ],
    },
    {
      source: "/fonts/(.*)",
      headers: [
        {
          key: "Cache-Control",
          value: "public, max-age=31536000, immutable",
        },
      ],
    },
  ],

  redirects: async () => [
    // Legacy sign routes → new zodiac routes
    {
      source: "/horoscope/:sign",
      destination: "/zodiac/:sign",
      permanent: true,
    },
    {
      source: "/burc/:sign",
      destination: "/zodiac/:sign",
      permanent: true,
    },
    // Legacy tool pages → home (preserve backlink equity)
    {
      source: "/horoscope",
      destination: "/zodiac",
      permanent: true,
    },
    {
      source: "/birth-chart",
      destination: "/",
      permanent: true,
    },
    {
      source: "/synastry",
      destination: "/",
      permanent: true,
    },
    {
      source: "/composite",
      destination: "/",
      permanent: true,
    },
    {
      source: "/solar-return",
      destination: "/",
      permanent: true,
    },
    {
      source: "/progressions",
      destination: "/",
      permanent: true,
    },
    {
      source: "/transits",
      destination: "/",
      permanent: true,
    },
    {
      source: "/vedic",
      destination: "/",
      permanent: true,
    },
    {
      source: "/draconic",
      destination: "/",
      permanent: true,
    },
    {
      source: "/tarot",
      destination: "/",
      permanent: true,
    },
    {
      source: "/numerology",
      destination: "/",
      permanent: true,
    },
    {
      source: "/dreams",
      destination: "/",
      permanent: true,
    },
    {
      source: "/chakra",
      destination: "/",
      permanent: true,
    },
    {
      source: "/rituals",
      destination: "/",
      permanent: true,
    },
    {
      source: "/glossary",
      destination: "/",
      permanent: true,
    },
    {
      source: "/celebrities",
      destination: "/",
      permanent: true,
    },
    {
      source: "/saturn-return",
      destination: "/",
      permanent: true,
    },
    {
      source: "/timing",
      destination: "/",
      permanent: true,
    },
    {
      source: "/year-ahead",
      destination: "/",
      permanent: true,
    },
    {
      source: "/weekly-horoscope",
      destination: "/zodiac",
      permanent: true,
    },
    {
      source: "/monthly-horoscope",
      destination: "/zodiac",
      permanent: true,
    },
    {
      source: "/yearly-horoscope",
      destination: "/zodiac",
      permanent: true,
    },
    // Legacy Turkish dream pages → home (will redirect to /tr/ruyalar/ when built)
    {
      source: "/ruya/:path*",
      destination: "/",
      permanent: false, // 302 — will change to proper TR route later
    },
    // Legacy internal pages — no SEO value, redirect to home
    {
      source: "/premium",
      destination: "/",
      permanent: true,
    },
    {
      source: "/settings",
      destination: "/",
      permanent: true,
    },
    {
      source: "/profile",
      destination: "/",
      permanent: true,
    },
    {
      source: "/kozmoz",
      destination: "/",
      permanent: true,
    },
    {
      source: "/sub",
      destination: "/",
      permanent: true,
    },
    // Legacy .html extension URLs
    {
      source: "/quiz.html",
      destination: "/",
      permanent: true,
    },
    {
      source: "/thanks.html",
      destination: "/",
      permanent: true,
    },
    {
      source: "/support.html",
      destination: "/",
      permanent: true,
    },
  ],

  experimental: {
    optimizePackageImports: ["fuse.js"],
  },
};

export default nextConfig;
