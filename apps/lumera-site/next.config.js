/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,

  // i18n configuration
  i18n: {
    locales: ['en', 'tr'],
    defaultLocale: 'en',
    localeDetection: true,
  },

  // Environment variables
  env: {
    NEXT_PUBLIC_APP_NAME: 'Lumera Space',
    NEXT_PUBLIC_APP_DESCRIPTION: 'Personal Reflection & Insight',
  },

  // Image optimization
  images: {
    domains: ['lumeraspace.com', 'app.lumeraspace.com'],
    formats: ['image/avif', 'image/webp'],
  },

  // Headers for security
  async headers() {
    return [
      {
        source: '/:path*',
        headers: [
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff',
          },
          {
            key: 'X-Frame-Options',
            value: 'DENY',
          },
          {
            key: 'X-XSS-Protection',
            value: '1; mode=block',
          },
          {
            key: 'Referrer-Policy',
            value: 'strict-origin-when-cross-origin',
          },
        ],
      },
    ];
  },

  // Redirects
  async redirects() {
    return [
      {
        source: '/app',
        destination: 'https://app.lumeraspace.com',
        permanent: false,
      },
    ];
  },
};

module.exports = nextConfig;
