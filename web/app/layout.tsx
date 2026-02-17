import type { Metadata } from "next";
import "@/styles/globals.css";

export const metadata: Metadata = {
  metadataBase: new URL("https://innercycles.app"),
  title: {
    default: "InnerCycles - Reflective Astrology & Cosmic Self-Discovery",
    template: "%s | InnerCycles",
  },
  description:
    "Explore zodiac archetypes, birth chart insights, cosmic reflections, and educational astrology content. Understand yourself through the language of the stars.",
  keywords: [
    "astrology",
    "zodiac signs",
    "birth chart",
    "horoscope",
    "natal chart",
    "zodiac compatibility",
    "astrology education",
    "cosmic self-discovery",
    "archetype psychology",
    "zodiac personality",
  ],
  authors: [{ name: "InnerCycles" }],
  creator: "InnerCycles",
  publisher: "InnerCycles",
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      "max-video-preview": -1,
      "max-image-preview": "large",
      "max-snippet": -1,
    },
  },
  openGraph: {
    type: "website",
    locale: "en_US",
    url: "https://innercycles.app",
    siteName: "InnerCycles",
    title: "InnerCycles - Reflective Astrology & Cosmic Self-Discovery",
    description:
      "Explore zodiac archetypes, birth chart insights, and educational astrology content.",
    images: [
      {
        url: "/images/og/og-default.png",
        width: 1200,
        height: 630,
        alt: "InnerCycles - Cosmic Self-Discovery",
      },
    ],
  },
  twitter: {
    card: "summary_large_image",
    title: "InnerCycles - Reflective Astrology",
    description:
      "Explore zodiac archetypes and cosmic self-discovery through educational astrology.",
    images: ["/images/og/og-default.png"],
    creator: "@innercycles",
  },
  alternates: {
    canonical: "https://innercycles.app",
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className="dark">
      <head>
        <link rel="icon" href="/favicon.ico" sizes="any" />
        <link rel="icon" href="/images/icons/icon.svg" type="image/svg+xml" />
        <link rel="apple-touch-icon" href="/images/icons/apple-touch-icon.png" />
        <link rel="manifest" href="/manifest.json" />
        <meta name="theme-color" content="#0D0D1A" />
      </head>
      <body className="bg-cosmic-bg text-cosmic-text antialiased font-body min-h-screen">
        <nav className="border-b border-cosmic-border bg-cosmic-surface/80 backdrop-blur-md sticky top-0 z-50">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="flex items-center justify-between h-16">
              <a href="/" className="text-cosmic-accent font-display text-xl font-bold">
                InnerCycles
              </a>
              <div className="hidden md:flex items-center space-x-8">
                <a href="/zodiac" className="text-cosmic-muted hover:text-cosmic-text transition-colors">
                  Zodiac Signs
                </a>
                <a href="/articles" className="text-cosmic-muted hover:text-cosmic-text transition-colors">
                  Articles
                </a>
                <a href="/archetype" className="text-cosmic-muted hover:text-cosmic-text transition-colors">
                  Archetypes
                </a>
                <a
                  href="https://apps.apple.com/app/innercycles/id6742044622"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="bg-cosmic-accent/10 border border-cosmic-accent/30 hover:bg-cosmic-accent/20 text-cosmic-accent px-4 py-1.5 rounded-full text-sm transition-colors"
                >
                  Get InnerCycles App
                </a>
              </div>
            </div>
          </div>
        </nav>
        <main>{children}</main>
        <footer className="border-t border-cosmic-border bg-cosmic-surface mt-auto py-12">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
              <div>
                <h3 className="text-cosmic-accent font-display text-lg mb-4">InnerCycles</h3>
                <p className="text-cosmic-muted text-sm">
                  Educational astrology content for self-reflection and cosmic exploration.
                  All content is reflective and non-predictive.
                </p>
              </div>
              <div>
                <h4 className="text-cosmic-text font-semibold mb-4">Explore</h4>
                <ul className="space-y-2 text-sm text-cosmic-muted">
                  <li><a href="/zodiac" className="hover:text-cosmic-text">Zodiac Signs</a></li>
                  <li><a href="/articles" className="hover:text-cosmic-text">Articles</a></li>
                  <li><a href="/archetype" className="hover:text-cosmic-text">Archetypes</a></li>
                </ul>
              </div>
              <div>
                <h4 className="text-cosmic-text font-semibold mb-4">Mobile App</h4>
                <p className="text-cosmic-muted text-sm mb-3">
                  Journal, reflect, and track your well-being with InnerCycles.
                </p>
                <a
                  href="https://apps.apple.com/app/innercycles/id6742044622"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-cosmic-accent text-sm hover:underline"
                >
                  Download on App Store &rarr;
                </a>
              </div>
              <div>
                <h4 className="text-cosmic-text font-semibold mb-4">Legal</h4>
                <ul className="space-y-2 text-sm text-cosmic-muted">
                  <li><a href="/privacy" className="hover:text-cosmic-text">Privacy Policy</a></li>
                  <li><a href="/terms" className="hover:text-cosmic-text">Terms of Service</a></li>
                  <li><a href="/editorial-policy" className="hover:text-cosmic-text">Editorial Policy</a></li>
                </ul>
              </div>
            </div>
            <div className="mt-8 pt-8 border-t border-cosmic-border text-center text-cosmic-muted text-xs">
              <p>Content is educational and reflective. InnerCycles does not make predictions or guarantees.</p>
              <p className="mt-2">&copy; {new Date().getFullYear()} InnerCycles. All rights reserved.</p>
            </div>
          </div>
        </footer>
      </body>
    </html>
  );
}
