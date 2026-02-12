import type { Metadata } from "next";
import { zodiacSigns } from "@/content/zodiac/signs";

export const metadata: Metadata = {
  title: "Astrobobo - Reflective Astrology & Cosmic Self-Discovery",
  description:
    "Explore zodiac archetypes, birth chart insights, cosmic reflections, and educational astrology content. Understand yourself through the language of the stars.",
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
            Astrobobo
          </h1>
          <p className="text-xl md:text-2xl text-cosmic-text/80 max-w-2xl mx-auto mb-4">
            Explore zodiac archetypes and cosmic patterns through reflective, educational content.
          </p>
          <p className="text-cosmic-muted max-w-xl mx-auto">
            Discover insights about personality, relationships, and growth themes.
            No predictions. No fortune telling. Just self-understanding.
          </p>
        </div>
      </section>

      {/* Zodiac Grid */}
      <section className="max-w-7xl mx-auto px-4 py-16">
        <h2 className="cosmic-heading text-3xl text-center mb-12">
          The Twelve Zodiac Archetypes
        </h2>
        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
          {zodiacSigns.map((sign) => (
            <a
              key={sign.slug}
              href={`/zodiac/${sign.slug}`}
              className="cosmic-card text-center group"
            >
              <div className="text-5xl mb-3">{sign.symbol}</div>
              <h3 className="text-cosmic-text font-display text-lg group-hover:text-cosmic-accent transition-colors">
                {sign.name}
              </h3>
              <p className="text-cosmic-muted text-sm mt-1">{sign.dateRange}</p>
              <span className={`zodiac-${sign.element.toLowerCase()} zodiac-badge mt-3`}>
                {sign.element}
              </span>
            </a>
          ))}
        </div>
      </section>

      {/* Featured Content */}
      <section className="bg-cosmic-surface py-16 px-4">
        <div className="max-w-7xl mx-auto">
          <h2 className="cosmic-heading text-3xl text-center mb-12">
            Explore Cosmic Wisdom
          </h2>
          <div className="grid md:grid-cols-3 gap-8">
            <div className="cosmic-card">
              <h3 className="text-cosmic-accent font-display text-xl mb-3">Zodiac Profiles</h3>
              <p className="text-cosmic-muted text-sm">
                Deep personality insights, strengths, growth themes, and reflection prompts for each zodiac archetype.
              </p>
              <a href="/zodiac" className="text-cosmic-accent text-sm mt-4 inline-block hover:underline">
                Explore all signs &rarr;
              </a>
            </div>
            <div className="cosmic-card">
              <h3 className="text-cosmic-accent font-display text-xl mb-3">Educational Articles</h3>
              <p className="text-cosmic-muted text-sm">
                In-depth explorations of astrological concepts, planetary archetypes, elemental wisdom, and cosmic patterns.
              </p>
              <a href="/articles" className="text-cosmic-accent text-sm mt-4 inline-block hover:underline">
                Read articles &rarr;
              </a>
            </div>
            <div className="cosmic-card">
              <h3 className="text-cosmic-accent font-display text-xl mb-3">Daily Reflections</h3>
              <p className="text-cosmic-muted text-sm">
                Thoughtful prompts and affirmations inspired by cosmic archetypes to support your self-awareness journey.
              </p>
              <a href="/articles?category=reflections" className="text-cosmic-accent text-sm mt-4 inline-block hover:underline">
                Start reflecting &rarr;
              </a>
            </div>
          </div>
        </div>
      </section>

      {/* Mobile App CTA */}
      <section className="relative py-20 px-4 text-center bg-cosmic-gradient overflow-hidden">
        <div className="absolute inset-0 opacity-15">
          <div className="absolute top-1/3 right-1/3 w-72 h-72 rounded-full bg-cosmic-accent/20 blur-3xl animate-float" />
        </div>
        <div className="relative max-w-3xl mx-auto">
          <h2 className="cosmic-heading text-3xl md:text-4xl mb-4">
            Take Your Journey Mobile
          </h2>
          <p className="text-cosmic-text/80 text-lg mb-2">
            <span className="text-cosmic-accent font-display">InnerCycles</span> — your personal journaling companion for daily reflection, mood tracking, and self-discovery.
          </p>
          <p className="text-cosmic-muted text-sm mb-8 max-w-xl mx-auto">
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

      {/* SEO Content Block */}
      <section className="max-w-4xl mx-auto px-4 py-16">
        <div className="article-prose">
          <h2>What is Reflective Astrology?</h2>
          <p>
            Reflective astrology approaches zodiac archetypes as psychological frameworks for
            self-understanding rather than predictive tools. Each zodiac sign represents a
            constellation of personality traits, growth themes, and relational patterns that
            many people find insightful for self-reflection.
          </p>
          <p>
            At Astrobobo, all content is educational and reflective. We explore how archetypal
            patterns from astrology, mythology, and depth psychology can serve as mirrors for
            personal growth. Our approach emphasizes self-awareness, curiosity, and
            empowerment rather than dependency or deterministic claims.
          </p>
          <h2>How to Use This Resource</h2>
          <p>
            Browse zodiac profiles to explore personality archetypes. Read educational articles
            about planetary symbolism, elemental wisdom, and cosmic cycles. Use reflection
            prompts as journaling inspiration. Consider what resonates with your experience
            and what invites further exploration.
          </p>
        </div>
      </section>
    </div>
  );
}
