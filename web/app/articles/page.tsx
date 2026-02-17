import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Wellness Articles - Journaling, Mindfulness & Personal Growth",
  description:
    "Explore articles about journaling practices, mindfulness, emotional wellness, and personal growth. Reflective content for self-understanding.",
};

export default function ArticlesPage() {
  return (
    <div className="max-w-7xl mx-auto px-4 py-12">
      <div className="text-center mb-16">
        <h1 className="text-4xl md:text-5xl font-display text-cosmic-accent mb-4">
          Wellness Articles
        </h1>
        <p className="text-cosmic-muted max-w-2xl mx-auto text-lg">
          Thoughtful explorations of journaling practices, mindfulness techniques,
          and personal growth for self-reflection and well-being.
        </p>
      </div>

      <div className="max-w-2xl mx-auto text-center cosmic-card">
        <p className="text-cosmic-muted">
          Articles are coming soon. In the meantime, explore the InnerCycles app
          for daily reflection prompts, mood tracking, and dream journaling.
        </p>
        <a
          href="https://apps.apple.com/app/innercycles/id6742044622"
          target="_blank"
          rel="noopener noreferrer"
          className="inline-block mt-6 text-cosmic-accent hover:underline"
        >
          Download InnerCycles &rarr;
        </a>
      </div>
    </div>
  );
}
