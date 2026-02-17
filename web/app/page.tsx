import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "InnerCycles - Personal Journal & Mood Tracker",
  description:
    "Track your moods, discover emotional patterns, and grow through daily self-awareness. A beautiful journaling companion for self-discovery and personal growth.",
};

export default function HomePage() {
  return (
    <div className="min-h-screen">
      {/* Hero */}
      <section className="relative py-24 px-4 text-center bg-cosmic-gradient overflow-hidden">
        <div className="absolute inset-0 opacity-20">
          <div className="absolute top-1/4 left-1/4 w-64 h-64 rounded-full bg-cosmic-purple/20 blur-3xl animate-float" />
          <div className="absolute bottom-1/3 right-1/4 w-48 h-48 rounded-full bg-cosmic-accent/10 blur-3xl animate-float" style={{ animationDelay: "2s" }} />
        </div>
        <div className="relative max-w-4xl mx-auto">
          <h1 className="text-5xl md:text-7xl font-display text-cosmic-accent mb-6">
            InnerCycles
          </h1>
          <p className="text-xl md:text-2xl text-cosmic-text/80 max-w-2xl mx-auto mb-4">
            Your personal journaling companion for daily reflection, mood tracking, and self-discovery.
          </p>
          <p className="text-cosmic-muted max-w-xl mx-auto mb-8">
            Capture your thoughts, notice patterns in your well-being, and grow through guided reflection prompts.
          </p>
          <a
            href="https://apps.apple.com/app/innercycles/id6742044622"
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-3 bg-cosmic-accent/10 border border-cosmic-accent/30 hover:bg-cosmic-accent/20 text-cosmic-accent px-8 py-4 rounded-2xl transition-all hover:scale-105"
          >
            <svg className="w-8 h-8" viewBox="0 0 24 24" fill="currentColor">
              <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.8-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z" />
            </svg>
            <div className="text-left">
              <div className="text-xs text-cosmic-muted">Download on the</div>
              <div className="text-lg font-semibold leading-tight">App Store</div>
            </div>
          </a>
        </div>
      </section>

      {/* Features Grid */}
      <section className="max-w-7xl mx-auto px-4 py-16">
        <h2 className="cosmic-heading text-3xl text-center mb-12">
          What You Can Do
        </h2>
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
          <div className="cosmic-card text-center">
            <div className="text-4xl mb-4">&#x1F4D3;</div>
            <h3 className="text-cosmic-text font-display text-lg mb-2">Daily Journal</h3>
            <p className="text-cosmic-muted text-sm">
              Record your thoughts, moods, and experiences with guided reflection prompts designed to deepen self-awareness.
            </p>
          </div>
          <div className="cosmic-card text-center">
            <div className="text-4xl mb-4">&#x1F4CA;</div>
            <h3 className="text-cosmic-text font-display text-lg mb-2">Pattern Insights</h3>
            <p className="text-cosmic-muted text-sm">
              Discover emotional patterns over time. See trends in your moods, energy levels, and focus areas.
            </p>
          </div>
          <div className="cosmic-card text-center">
            <div className="text-4xl mb-4">&#x1F4AD;</div>
            <h3 className="text-cosmic-text font-display text-lg mb-2">Dream Journal</h3>
            <p className="text-cosmic-muted text-sm">
              Record and explore your dreams with a dedicated dream journal and symbol glossary.
            </p>
          </div>
          <div className="cosmic-card text-center">
            <div className="text-4xl mb-4">&#x2728;</div>
            <h3 className="text-cosmic-text font-display text-lg mb-2">Daily Prompts</h3>
            <p className="text-cosmic-muted text-sm">
              Get thoughtful reflection prompts and affirmations to guide your daily journaling practice.
            </p>
          </div>
          <div className="cosmic-card text-center">
            <div className="text-4xl mb-4">&#x1F512;</div>
            <h3 className="text-cosmic-text font-display text-lg mb-2">Private & Secure</h3>
            <p className="text-cosmic-muted text-sm">
              Your journal entries stay on your device. No accounts required. Optional iCloud backup with Apple Sign In.
            </p>
          </div>
          <div className="cosmic-card text-center">
            <div className="text-4xl mb-4">&#x1F30D;</div>
            <h3 className="text-cosmic-text font-display text-lg mb-2">Multilingual</h3>
            <p className="text-cosmic-muted text-sm">
              Available in English, Turkish, German, and French. Journal in the language that feels most natural to you.
            </p>
          </div>
        </div>
      </section>

      {/* CTA */}
      <section className="relative py-20 px-4 text-center bg-cosmic-gradient overflow-hidden">
        <div className="absolute inset-0 opacity-15">
          <div className="absolute top-1/3 right-1/3 w-72 h-72 rounded-full bg-cosmic-accent/20 blur-3xl animate-float" />
        </div>
        <div className="relative max-w-3xl mx-auto">
          <h2 className="cosmic-heading text-3xl md:text-4xl mb-4">
            Start Your Journaling Journey
          </h2>
          <p className="text-cosmic-text/80 text-lg mb-8">
            Free to use. No sign-up required. Begin reflecting today.
          </p>
          <a
            href="https://apps.apple.com/app/innercycles/id6742044622"
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-2 bg-cosmic-accent/10 border border-cosmic-accent/30 hover:bg-cosmic-accent/20 text-cosmic-accent px-8 py-4 rounded-2xl transition-all hover:scale-105 text-lg"
          >
            Download InnerCycles &rarr;
          </a>
        </div>
      </section>

      {/* About */}
      <section className="max-w-4xl mx-auto px-4 py-16">
        <div className="article-prose">
          <h2>About InnerCycles</h2>
          <p>
            InnerCycles is a personal journaling app designed to help you build a daily
            reflection habit. Whether you want to track your moods, explore your dreams,
            or simply write down your thoughts, InnerCycles provides a beautiful, private
            space for self-discovery.
          </p>
          <p>
            Our approach emphasizes self-awareness and personal growth. All content --
            including reflection prompts, mood insights, and dream symbol definitions --
            is designed to encourage thoughtful self-exploration rather than making
            predictions or claims about the future.
          </p>
        </div>
      </section>
    </div>
  );
}
