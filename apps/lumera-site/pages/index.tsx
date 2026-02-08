import Head from 'next/head';
import { GetStaticProps } from 'next';

interface HomeProps {
  locale: string;
}

export default function Home({ locale }: HomeProps) {
  const content = {
    en: {
      title: 'Lumera Space - Personal Reflection & Insight',
      subtitle: 'Your daily space for mindful self-discovery',
      description: 'Explore thoughtful prompts, track patterns in your energy, and discover insights through guided reflection.',
      cta: 'Start Your Journey',
      features: [
        {
          title: 'Daily Reflections',
          description: 'Thoughtful prompts to guide your self-discovery journey',
        },
        {
          title: 'Pattern Recognition',
          description: 'Understand your energy cycles and emotional patterns',
        },
        {
          title: 'Personal Insights',
          description: 'AI-powered guidance that respects your unique path',
        },
      ],
      disclaimer: 'For entertainment and self-reflection purposes only.',
    },
    tr: {
      title: 'Lumera Space - Kişisel Yansıma ve İçgörü',
      subtitle: 'Bilinçli kendini keşfetme için günlük alanınız',
      description: 'Düşünceli öneriler keşfedin, enerjinizdeki kalıpları takip edin ve rehberli yansıma ile içgörüler keşfedin.',
      cta: 'Yolculuğunuza Başlayın',
      features: [
        {
          title: 'Günlük Yansımalar',
          description: 'Kendini keşfetme yolculuğunuza rehberlik eden düşünceli öneriler',
        },
        {
          title: 'Örüntü Tanıma',
          description: 'Enerji döngülerinizi ve duygusal kalıplarınızı anlayın',
        },
        {
          title: 'Kişisel İçgörüler',
          description: 'Benzersiz yolunuza saygı duyan AI destekli rehberlik',
        },
      ],
      disclaimer: 'Yalnızca eğlence ve öz-yansıma amaçlıdır.',
    },
  };

  const t = content[locale as keyof typeof content] || content.en;

  return (
    <>
      <Head>
        <title>{t.title}</title>
        <meta name="description" content={t.description} />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />

        {/* Open Graph */}
        <meta property="og:title" content={t.title} />
        <meta property="og:description" content={t.description} />
        <meta property="og:type" content="website" />
        <meta property="og:url" content="https://lumeraspace.com" />

        {/* Twitter */}
        <meta name="twitter:card" content="summary_large_image" />
        <meta name="twitter:title" content={t.title} />
        <meta name="twitter:description" content={t.description} />
      </Head>

      <main className="min-h-screen bg-gradient-to-b from-slate-900 to-slate-800">
        {/* Hero Section */}
        <section className="container mx-auto px-4 py-20 text-center">
          <h1 className="text-5xl font-bold text-white mb-6">
            Lumera Space
          </h1>
          <p className="text-xl text-slate-300 mb-4">
            {t.subtitle}
          </p>
          <p className="text-lg text-slate-400 max-w-2xl mx-auto mb-8">
            {t.description}
          </p>
          <a
            href="https://app.lumeraspace.com"
            className="inline-block bg-indigo-600 hover:bg-indigo-700 text-white font-semibold py-3 px-8 rounded-full transition-colors"
          >
            {t.cta}
          </a>
        </section>

        {/* Features Section */}
        <section className="container mx-auto px-4 py-16">
          <div className="grid md:grid-cols-3 gap-8">
            {t.features.map((feature, index) => (
              <div
                key={index}
                className="bg-slate-800/50 rounded-xl p-6 border border-slate-700"
              >
                <h3 className="text-xl font-semibold text-white mb-3">
                  {feature.title}
                </h3>
                <p className="text-slate-400">
                  {feature.description}
                </p>
              </div>
            ))}
          </div>
        </section>

        {/* Disclaimer */}
        <footer className="container mx-auto px-4 py-8 text-center">
          <p className="text-sm text-slate-500">
            {t.disclaimer}
          </p>
        </footer>
      </main>
    </>
  );
}

export const getStaticProps: GetStaticProps = async ({ locale }) => {
  return {
    props: {
      locale: locale || 'en',
    },
  };
};
