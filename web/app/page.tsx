import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "InnerCycles - Emotional Cycle Mapping",
  description:
    "Map the emotional cycles you repeat without realizing it. Recurrence detection, dream archaeology, and archetype progression in one journaling system.",
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
            You keep repeating the same emotional patterns. This app shows you which ones, and when.
          </p>
          <p className="text-cosmic-muted max-w-xl mx-auto mb-8">
            Not a mood diary. A recurrence detection system that maps the cycles you live inside and surfaces your past entries when patterns repeat.
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

      {/* How It Works */}
      <section className="max-w-7xl mx-auto px-4 py-16">
        <h2 className="cosmic-heading text-3xl text-center mb-4">
          How It Actually Works
        </h2>
        <p className="text-cosmic-muted text-center max-w-2xl mx-auto mb-12">
          Every entry you write feeds a pattern engine. When you re-enter familiar emotional territory, InnerCycles surfaces what you wrote last time you were there.
        </p>
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
          <div className="cosmic-card">
            <div className="text-4xl mb-4">&#128260;</div>
            <h3 className="text-cosmic-text font-display text-lg mb-2">Recurrence Detection</h3>
            <p className="text-cosmic-muted text-sm">
              The engine identifies when emotional patterns repeat across weeks and months. &quot;This feeling has appeared 4 times since October&quot; -- that kind of thing.
            </p>
          </div>
          <div className="cosmic-card">
            <div className="text-4xl mb-4">&#127769;</div>
            <h3 className="text-cosmic-text font-display text-lg mb-2">Dream Archaeology</h3>
            <p className="text-cosmic-muted text-sm">
              Track recurring dream symbols, story arcs, and shadow themes across your entire dream history. See which symbols keep coming back.
            </p>
          </div>
          <div className="cosmic-card">
            <div className="text-4xl mb-4">&#128200;</div>
            <h3 className="text-cosmic-text font-display text-lg mb-2">Cycle Position Reports</h3>
            <p className="text-cosmic-muted text-sm">
              Weekly and monthly reports that show where you are in your recurring patterns. Not predictions -- observations from your own writing.
            </p>
          </div>
          <div className="cosmic-card">
            <div className="text-4xl mb-4">&#128161;</div>
            <h3 className="text-cosmic-text font-display text-lg mb-2">Archetype Progression</h3>
            <p className="text-cosmic-muted text-sm">
              Your dominant personality archetype evolves as you write. The system tracks shifts -- from Seeker to Explorer, from Builder to Visionary.
            </p>
          </div>
          <div className="cosmic-card">
            <div className="text-4xl mb-4">&#127763;</div>
            <h3 className="text-cosmic-text font-display text-lg mb-2">Shadow-Light Integration</h3>
            <p className="text-cosmic-muted text-sm">
              Tracks your relationship with difficult emotions over time. Measures how fear themes, anxiety patterns, and nightmares evolve through journaling.
            </p>
          </div>
          <div className="cosmic-card">
            <div className="text-4xl mb-4">&#128274;</div>
            <h3 className="text-cosmic-text font-display text-lg mb-2">Private by Architecture</h3>
            <p className="text-cosmic-muted text-sm">
              All cycle data stays on your device. No account required. Optional Apple Sign In for encrypted backup. We never read your entries.
            </p>
          </div>
        </div>
      </section>

      {/* Who It's For */}
      <section className="relative py-20 px-4 text-center bg-cosmic-gradient overflow-hidden">
        <div className="absolute inset-0 opacity-15">
          <div className="absolute top-1/3 right-1/3 w-72 h-72 rounded-full bg-cosmic-accent/20 blur-3xl animate-float" />
        </div>
        <div className="relative max-w-3xl mx-auto">
          <h2 className="cosmic-heading text-3xl md:text-4xl mb-4">
            For People Who Notice They Repeat Things
          </h2>
          <p className="text-cosmic-text/80 text-lg mb-4">
            If you have ever thought &quot;I have been here before&quot; about an emotion, a conflict, or a mood -- InnerCycles shows you the pattern.
          </p>
          <p className="text-cosmic-muted mb-8">
            Free to start. No sign-up. Your first cycle report generates after 7 days of entries.
          </p>
          <a
            href="https://apps.apple.com/app/innercycles/id6742044622"
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-2 bg-cosmic-accent/10 border border-cosmic-accent/30 hover:bg-cosmic-accent/20 text-cosmic-accent px-8 py-4 rounded-2xl transition-all hover:scale-105 text-lg"
          >
            Map Your Cycles &rarr;
          </a>
        </div>
      </section>

      {/* About */}
      <section className="max-w-4xl mx-auto px-4 py-16">
        <div className="article-prose">
          <h2>What InnerCycles Is Not</h2>
          <p>
            It is not a mood tracker with a chart. It is not a gratitude journal with prompts.
            It is a system that detects when emotional patterns recur -- and shows you what
            you wrote the last time they did.
          </p>
          <p>
            All insights come from your own entries. The app does not predict anything.
            It does not claim to know your future. It maps what has already happened, so
            you can decide what to do differently. That is the entire idea.
          </p>
        </div>
      </section>
    </div>
  );
}
