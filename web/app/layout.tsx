import type { Metadata } from "next";
import "@/styles/globals.css";

export const metadata: Metadata = {
  metadataBase: new URL("https://innercycles.app"),
  title: {
    default: "InnerCycles - Personal Journal & Mood Tracker",
    template: "%s | InnerCycles",
  },
  description:
    "Track your moods, discover emotional patterns, and grow through daily self-awareness. A beautiful journaling companion for self-discovery and personal growth.",
  keywords: [
    "journal app",
    "mood tracker",
    "self-reflection",
    "personal growth",
    "dream journal",
    "emotional wellness",
    "daily journaling",
    "mindfulness",
    "self-awareness",
    "mood patterns",
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
    title: "InnerCycles - Personal Journal & Mood Tracker",
    description:
      "Track your moods, discover emotional patterns, and grow through daily self-awareness.",
    images: [
      {
        url: "/images/og/og-default.png",
        width: 1200,
        height: 630,
        alt: "InnerCycles - Personal Journal & Mood Tracker",
      },
    ],
  },
  twitter: {
    card: "summary_large_image",
    title: "InnerCycles - Personal Journal & Mood Tracker",
    description:
      "Track your moods, discover emotional patterns, and grow through daily journaling.",
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
                <a href="/privacy" className="text-cosmic-muted hover:text-cosmic-text transition-colors">
                  Privacy
                </a>
                <a href="/terms" className="text-cosmic-muted hover:text-cosmic-text transition-colors">
                  Terms
                </a>
                <a
                  href="https://apps.apple.com/app/innercycles/id6742044622"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="bg-cosmic-accent/10 border border-cosmic-accent/30 hover:bg-cosmic-accent/20 text-cosmic-accent px-4 py-1.5 rounded-full text-sm transition-colors"
                >
                  Get the App
                </a>
              </div>
            </div>
          </div>
        </nav>
        <main>{children}</main>
        <footer className="border-t border-cosmic-border bg-cosmic-surface mt-auto py-12">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
              <div>
                <h3 className="text-cosmic-accent font-display text-lg mb-4">InnerCycles</h3>
                <p className="text-cosmic-muted text-sm">
                  Your personal journaling companion for daily reflection, mood tracking,
                  and self-discovery. All content is reflective and growth-oriented.
                </p>
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
              <p>InnerCycles supports personal reflection and self-awareness through journaling.</p>
              <p className="mt-2">&copy; {new Date().getFullYear()} InnerCycles. All rights reserved.</p>
            </div>
          </div>
        </footer>
      </body>
    </html>
  );
}
