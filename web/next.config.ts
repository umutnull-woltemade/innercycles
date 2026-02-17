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
    // Legacy astrology routes → home
    {
      source: "/horoscope/:sign",
      destination: "/",
      permanent: true,
    },
    {
      source: "/burc/:sign",
      destination: "/",
      permanent: true,
    },
    {
      source: "/horoscope",
      destination: "/",
      permanent: true,
    },
    {
      source: "/zodiac/:path*",
      destination: "/",
      permanent: true,
    },
    {
      source: "/zodiac",
      destination: "/",
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
      destination: "/",
      permanent: true,
    },
    {
      source: "/monthly-horoscope",
      destination: "/",
      permanent: true,
    },
    {
      source: "/yearly-horoscope",
      destination: "/",
      permanent: true,
    },
    // Legacy Turkish dream pages → home
    {
      source: "/ruya/:path*",
      destination: "/",
      permanent: false,
    },
    // Legacy internal pages
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
