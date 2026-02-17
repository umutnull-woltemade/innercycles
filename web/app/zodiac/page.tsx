import type { Metadata } from "next";
import { zodiacSigns } from "@/content/zodiac/signs";

export const metadata: Metadata = {
  title: "All 12 Zodiac Signs - Personality, Traits & Cosmic Insights",
  description:
    "Explore all 12 zodiac archetypes with deep personality insights, strengths, growth themes, and reflection prompts. Educational astrology for self-understanding.",
  openGraph: {
    title: "All 12 Zodiac Signs | InnerCycles",
    description: "Explore zodiac archetypes with personality insights and cosmic wisdom.",
    url: "/zodiac",
  },
};

const elementColors: Record<string, string> = {
  Fire: "zodiac-fire",
  Earth: "zodiac-earth",
  Air: "zodiac-air",
  Water: "zodiac-water",
};

export default function ZodiacIndexPage() {
  return (
    <div className="max-w-7xl mx-auto px-4 py-12">
      <div className="text-center mb-16">
        <h1 className="text-4xl md:text-5xl font-display text-cosmic-accent mb-4">
          The Twelve Zodiac Archetypes
        </h1>
        <p className="text-cosmic-muted max-w-2xl mx-auto text-lg">
          Each zodiac sign represents a unique constellation of personality traits,
          growth themes, and relational patterns. Explore what resonates with you.
        </p>
      </div>

      {/* Element Filter */}
      <div className="flex justify-center gap-4 mb-12">
        {["All", "Fire", "Earth", "Air", "Water"].map((el) => (
          <span
            key={el}
            className={`zodiac-badge cursor-pointer ${
              el === "All"
                ? "bg-cosmic-accent/10 text-cosmic-accent border-cosmic-accent/30"
                : `zodiac-${el.toLowerCase()}`
            }`}
          >
            {el}
          </span>
        ))}
      </div>

      {/* Signs Grid */}
      <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
        {zodiacSigns.map((sign) => (
          <a
            key={sign.slug}
            href={`/zodiac/${sign.slug}`}
            className="cosmic-card group"
          >
            <div className="flex items-start justify-between mb-4">
              <div>
                <span className="text-4xl">{sign.symbol}</span>
                <h2 className="text-xl font-display text-cosmic-text group-hover:text-cosmic-accent transition-colors mt-2">
                  {sign.name}
                </h2>
                <p className="text-cosmic-muted text-sm">{sign.dateRange}</p>
              </div>
              <div className="flex flex-col gap-2 items-end">
                <span className={`zodiac-${sign.element.toLowerCase()} zodiac-badge`}>
                  {sign.element}
                </span>
                <span className="text-cosmic-muted text-xs">{sign.modality}</span>
              </div>
            </div>
            <p className="text-cosmic-muted text-sm line-clamp-3">
              {sign.overview}
            </p>
            <div className="mt-4 flex flex-wrap gap-2">
              {sign.keywords.slice(0, 4).map((kw) => (
                <span
                  key={kw}
                  className="text-xs bg-cosmic-surface px-2 py-1 rounded-md text-cosmic-muted"
                >
                  {kw}
                </span>
              ))}
            </div>
          </a>
        ))}
      </div>

      {/* SEO Content */}
      <section className="mt-20 max-w-3xl mx-auto article-prose">
        <h2>Understanding Zodiac Archetypes</h2>
        <p>
          The twelve zodiac signs form a complete cycle of archetypal energies,
          each representing a distinct approach to life, relationships, and personal
          growth. In reflective astrology, these signs serve as psychological
          frameworks rather than deterministic labels.
        </p>
        <p>
          The signs are organized by element (Fire, Earth, Air, Water) and modality
          (Cardinal, Fixed, Mutable), creating a rich tapestry of complementary
          energies. Understanding your zodiac archetype can offer valuable insight
          into your natural tendencies, communication style, and areas for growth.
        </p>
      </section>
    </div>
  );
}
