import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { zodiacSigns } from "@/content/zodiac/signs";

interface PageProps {
  params: Promise<{ sign: string }>;
}

export async function generateStaticParams() {
  return zodiacSigns.map((s) => ({ sign: s.slug }));
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { sign: slug } = await params;
  const sign = zodiacSigns.find((s) => s.slug === slug);
  if (!sign) return {};

  return {
    title: `${sign.name} (${sign.symbol}) - Personality, Traits & Growth Themes`,
    description: sign.overview.slice(0, 155) + "...",
    openGraph: {
      title: `${sign.name} Zodiac Profile | InnerCycles`,
      description: `Explore ${sign.name} personality insights, strengths, growth themes, and reflection prompts.`,
      url: `/zodiac/${sign.slug}`,
      images: [{ url: `/images/zodiac/${sign.slug}-og.png`, width: 1200, height: 630 }],
    },
    alternates: { canonical: `/zodiac/${sign.slug}` },
  };
}

export default async function ZodiacSignPage({ params }: PageProps) {
  const { sign: slug } = await params;
  const sign = zodiacSigns.find((s) => s.slug === slug);
  if (!sign) notFound();

  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "Article",
    headline: `${sign.name} Zodiac Sign - Personality & Cosmic Insights`,
    description: sign.overview,
    author: { "@type": "Organization", name: "InnerCycles" },
    publisher: { "@type": "Organization", name: "InnerCycles" },
    mainEntityOfPage: { "@type": "WebPage", "@id": `https://innercycles.app/zodiac/${sign.slug}` },
  };

  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />
      <article className="max-w-4xl mx-auto px-4 py-12">
        {/* Header */}
        <header className="text-center mb-12">
          <div className="text-7xl mb-4">{sign.symbol}</div>
          <h1 className="text-4xl md:text-5xl font-display text-cosmic-accent mb-2">
            {sign.name}
          </h1>
          <p className="text-cosmic-muted text-lg">{sign.dateRange}</p>
          <div className="flex justify-center gap-3 mt-4">
            <span className={`zodiac-${sign.element.toLowerCase()} zodiac-badge`}>
              {sign.element}
            </span>
            <span className="zodiac-badge bg-cosmic-surface border-cosmic-border text-cosmic-muted">
              {sign.modality}
            </span>
            <span className="zodiac-badge bg-cosmic-surface border-cosmic-border text-cosmic-muted">
              {sign.rulingPlanet}
            </span>
          </div>
          <div className="flex flex-wrap justify-center gap-2 mt-4">
            {sign.keywords.map((kw) => (
              <span key={kw} className="text-xs bg-cosmic-card px-3 py-1 rounded-full text-cosmic-muted">
                {kw}
              </span>
            ))}
          </div>
        </header>

        {/* Overview */}
        <section className="cosmic-card mb-8">
          <h2 className="cosmic-heading text-2xl mb-4">Overview</h2>
          <p className="text-cosmic-text/90 leading-relaxed">{sign.overview}</p>
        </section>

        {/* Personality */}
        <section className="cosmic-card mb-8">
          <h2 className="cosmic-heading text-2xl mb-4">Personality Insights</h2>
          <p className="text-cosmic-text/90 leading-relaxed">{sign.personality}</p>
        </section>

        {/* Strengths */}
        <section className="cosmic-card mb-8">
          <h2 className="cosmic-heading text-2xl mb-4">Key Strengths</h2>
          <ul className="grid md:grid-cols-2 gap-3">
            {sign.strengths.map((s, i) => (
              <li key={i} className="flex items-start gap-3 text-cosmic-text/90">
                <span className="text-cosmic-accent mt-1">&#x2726;</span>
                <span>{s}</span>
              </li>
            ))}
          </ul>
        </section>

        {/* Growth Themes */}
        <section className="cosmic-card mb-8">
          <h2 className="cosmic-heading text-2xl mb-4">Growth Themes</h2>
          <ul className="space-y-3">
            {sign.growthThemes.map((g, i) => (
              <li key={i} className="flex items-start gap-3 text-cosmic-text/90">
                <span className="text-cosmic-purple mt-1">&#x27A4;</span>
                <span>{g}</span>
              </li>
            ))}
          </ul>
        </section>

        {/* Reflection Prompts */}
        <section className="cosmic-card mb-8 bg-gradient-to-br from-cosmic-card to-cosmic-purple/5">
          <h2 className="cosmic-heading text-2xl mb-4">Reflection Prompts</h2>
          <ol className="space-y-4">
            {sign.reflectionPrompts.map((p, i) => (
              <li key={i} className="flex items-start gap-4">
                <span className="text-cosmic-accent font-display text-lg min-w-[2rem]">
                  {i + 1}.
                </span>
                <p className="text-cosmic-text/90 italic">{p}</p>
              </li>
            ))}
          </ol>
        </section>

        {/* Compatibility */}
        <section className="cosmic-card mb-8">
          <h2 className="cosmic-heading text-2xl mb-4">Relational Dynamics</h2>
          <p className="text-cosmic-text/90 leading-relaxed">{sign.compatibilityNotes}</p>
        </section>

        {/* Daily Inspiration */}
        <section className="cosmic-card mb-8">
          <h2 className="cosmic-heading text-2xl mb-4">Daily Inspirations</h2>
          <div className="space-y-3">
            {sign.dailyInspiration.map((d, i) => (
              <blockquote
                key={i}
                className="border-l-4 border-cosmic-accent/50 pl-4 text-cosmic-text/80 italic"
              >
                {d}
              </blockquote>
            ))}
          </div>
        </section>

        {/* Cosmic Explanation */}
        <section className="cosmic-card">
          <h2 className="cosmic-heading text-2xl mb-4">Cosmic Context</h2>
          <p className="text-cosmic-text/90 leading-relaxed">{sign.cosmicExplanation}</p>
        </section>

        {/* Navigation */}
        <nav className="mt-12 flex justify-between text-sm">
          {zodiacSigns.map((s, i) => {
            if (s.slug === sign.slug) {
              const prev = zodiacSigns[i - 1];
              const next = zodiacSigns[i + 1];
              return (
                <div key={s.slug} className="flex justify-between w-full">
                  {prev ? (
                    <a href={`/zodiac/${prev.slug}`} className="text-cosmic-accent hover:underline">
                      &larr; {prev.name}
                    </a>
                  ) : <span />}
                  {next ? (
                    <a href={`/zodiac/${next.slug}`} className="text-cosmic-accent hover:underline">
                      {next.name} &rarr;
                    </a>
                  ) : <span />}
                </div>
              );
            }
            return null;
          })}
        </nav>
      </article>
    </>
  );
}
