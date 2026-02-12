import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { articles } from "@/content/articles";

interface PageProps {
  params: Promise<{ slug: string }>;
}

export async function generateStaticParams() {
  return articles.map((a) => ({ slug: a.slug }));
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { slug } = await params;
  const article = articles.find((a) => a.slug === slug);
  if (!article) return {};

  return {
    title: article.title,
    description: article.description,
    openGraph: {
      title: `${article.title} | Astrobobo`,
      description: article.description,
      type: "article",
      url: `/articles/${article.slug}`,
      publishedTime: article.publishedAt,
    },
    alternates: { canonical: `/articles/${article.slug}` },
  };
}

export default async function ArticlePage({ params }: PageProps) {
  const { slug } = await params;
  const article = articles.find((a) => a.slug === slug);
  if (!article) notFound();

  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "Article",
    headline: article.title,
    description: article.description,
    author: { "@type": "Organization", name: "Astrobobo" },
    publisher: { "@type": "Organization", name: "Astrobobo" },
    datePublished: article.publishedAt,
    mainEntityOfPage: {
      "@type": "WebPage",
      "@id": `https://astrobobo.com/articles/${article.slug}`,
    },
  };

  // Simple markdown-to-sections converter
  const sections = article.content.split("\n\n").map((block, i) => {
    if (block.startsWith("### ")) {
      return <h3 key={i} className="text-cosmic-text font-display text-xl mt-6 mb-3">{block.slice(4)}</h3>;
    }
    if (block.startsWith("## ")) {
      return <h2 key={i} className="text-cosmic-accent font-display text-2xl mt-8 mb-4">{block.slice(3)}</h2>;
    }
    if (block.startsWith("- ")) {
      const items = block.split("\n").filter((l) => l.startsWith("- "));
      return (
        <ul key={i} className="list-disc list-inside mb-4 space-y-1">
          {items.map((item, j) => (
            <li key={j}>{item.slice(2)}</li>
          ))}
        </ul>
      );
    }
    if (block.startsWith("> ")) {
      return (
        <blockquote key={i} className="border-l-4 border-cosmic-accent/50 pl-4 italic text-cosmic-muted my-4">
          {block.slice(2)}
        </blockquote>
      );
    }
    return <p key={i} className="mb-4">{block}</p>;
  });

  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />
      <article className="max-w-3xl mx-auto px-4 py-12">
        <header className="mb-10">
          <span className="zodiac-badge bg-cosmic-surface border-cosmic-border text-cosmic-muted text-xs capitalize mb-4 inline-block">
            {article.category}
          </span>
          <h1 className="text-3xl md:text-4xl font-display text-cosmic-accent mb-4">
            {article.title}
          </h1>
          <div className="flex items-center gap-4 text-sm text-cosmic-muted">
            <span>{article.readingTime} min read</span>
            <span>{new Date(article.publishedAt).toLocaleDateString()}</span>
          </div>
          <div className="flex flex-wrap gap-2 mt-4">
            {article.tags.map((tag) => (
              <span
                key={tag}
                className="text-xs bg-cosmic-card px-2 py-1 rounded-md text-cosmic-muted"
              >
                {tag}
              </span>
            ))}
          </div>
        </header>

        <div className="article-prose">{sections}</div>

        {article.relatedSigns && article.relatedSigns.length > 0 && (
          <aside className="mt-12 cosmic-card">
            <h3 className="cosmic-heading text-lg mb-3">Related Zodiac Signs</h3>
            <div className="flex flex-wrap gap-3">
              {article.relatedSigns.map((sign) => (
                <a
                  key={sign}
                  href={`/zodiac/${sign}`}
                  className="text-cosmic-accent hover:underline capitalize"
                >
                  {sign}
                </a>
              ))}
            </div>
          </aside>
        )}
      </article>
    </>
  );
}
