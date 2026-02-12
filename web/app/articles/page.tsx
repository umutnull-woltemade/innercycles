import type { Metadata } from "next";
import { articles } from "@/content/articles";

export const metadata: Metadata = {
  title: "Astrology Articles - Educational Insights & Cosmic Wisdom",
  description:
    "In-depth educational articles about zodiac signs, planetary archetypes, birth charts, elements, and cosmic psychology. Reflective astrology for self-understanding.",
};

export default function ArticlesPage() {
  const sortedArticles = [...articles].sort(
    (a, b) => new Date(b.publishedAt).getTime() - new Date(a.publishedAt).getTime()
  );

  const categories = [...new Set(articles.map((a) => a.category))];

  return (
    <div className="max-w-7xl mx-auto px-4 py-12">
      <div className="text-center mb-16">
        <h1 className="text-4xl md:text-5xl font-display text-cosmic-accent mb-4">
          Astrology Articles
        </h1>
        <p className="text-cosmic-muted max-w-2xl mx-auto text-lg">
          Educational explorations of astrological concepts, planetary symbolism,
          and archetypal psychology for self-reflection and growth.
        </p>
      </div>

      {/* Category Filter */}
      <div className="flex flex-wrap justify-center gap-3 mb-12">
        {categories.map((cat) => (
          <span
            key={cat}
            className="zodiac-badge bg-cosmic-surface border-cosmic-border text-cosmic-muted cursor-pointer hover:border-cosmic-accent/30 capitalize"
          >
            {cat}
          </span>
        ))}
      </div>

      {/* Articles Grid */}
      <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
        {sortedArticles.map((article) => (
          <a
            key={article.slug}
            href={`/articles/${article.slug}`}
            className="cosmic-card group flex flex-col"
          >
            <span className="zodiac-badge bg-cosmic-surface border-cosmic-border text-cosmic-muted text-xs w-fit capitalize mb-3">
              {article.category}
            </span>
            <h2 className="text-lg font-display text-cosmic-text group-hover:text-cosmic-accent transition-colors mb-2">
              {article.title}
            </h2>
            <p className="text-cosmic-muted text-sm flex-grow line-clamp-3">
              {article.description}
            </p>
            <div className="mt-4 flex items-center justify-between text-xs text-cosmic-muted">
              <span>{article.readingTime} min read</span>
              <span>{new Date(article.publishedAt).toLocaleDateString()}</span>
            </div>
          </a>
        ))}
      </div>
    </div>
  );
}
