-- ════════════════════════════════════════════════════════════════════════════
-- CONTENT TOPICS TABLE
-- ════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS content_topics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Identity
  locale TEXT NOT NULL CHECK (locale IN ('en', 'tr', 'de', 'fr')),
  name TEXT NOT NULL,
  slug TEXT NOT NULL,
  description TEXT,

  -- Metrics
  content_count INTEGER DEFAULT 0,

  -- Status
  is_active BOOLEAN DEFAULT TRUE,

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  -- Unique constraint
  UNIQUE(locale, slug)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_content_topics_locale ON content_topics(locale);
CREATE INDEX IF NOT EXISTS idx_content_topics_active ON content_topics(is_active) WHERE is_active = TRUE;

-- Row Level Security
ALTER TABLE content_topics ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public can read active topics"
  ON content_topics FOR SELECT
  USING (is_active = TRUE);

CREATE POLICY "Service role has full access to topics"
  ON content_topics FOR ALL
  USING (auth.role() = 'service_role');

-- ════════════════════════════════════════════════════════════════════════════
-- SEED DEFAULT TOPICS
-- ════════════════════════════════════════════════════════════════════════════

INSERT INTO content_topics (locale, name, slug, description) VALUES
  -- English topics
  ('en', 'Morning Intention', 'morning-intention', 'Start your day with purpose'),
  ('en', 'Emotional Awareness', 'emotional-awareness', 'Explore your feelings'),
  ('en', 'Personal Growth', 'personal-growth', 'Reflect on your journey'),
  ('en', 'Relationship Patterns', 'relationship-patterns', 'Understand your connections'),
  ('en', 'Work-Life Balance', 'work-life-balance', 'Find your equilibrium'),
  ('en', 'Creative Expression', 'creative-expression', 'Tap into your creativity'),
  ('en', 'Self-Compassion', 'self-compassion', 'Be kind to yourself'),
  ('en', 'Mindfulness Moments', 'mindfulness-moments', 'Present moment awareness'),
  ('en', 'Gratitude Practice', 'gratitude-practice', 'Appreciate what you have'),
  ('en', 'Boundary Setting', 'boundary-setting', 'Protect your energy'),

  -- Turkish topics
  ('tr', 'Sabah Niyeti', 'sabah-niyeti', 'Gününüze amaçla başlayın'),
  ('tr', 'Duygusal Farkındalık', 'duygusal-farkindalik', 'Duygularınızı keşfedin'),
  ('tr', 'Kişisel Gelişim', 'kisisel-gelisim', 'Yolculuğunuzu düşünün'),
  ('tr', 'İlişki Kalıpları', 'iliski-kaliplari', 'Bağlantılarınızı anlayın'),
  ('tr', 'İş-Yaşam Dengesi', 'is-yasam-dengesi', 'Dengenizi bulun'),
  ('tr', 'Yaratıcı İfade', 'yaratici-ifade', 'Yaratıcılığınıza dokunun'),
  ('tr', 'Öz-Şefkat', 'oz-sefkat', 'Kendinize nazik olun'),
  ('tr', 'Farkındalık Anları', 'farkindalik-anlari', 'Şimdiki an farkındalığı'),
  ('tr', 'Şükran Pratiği', 'sukran-pratigi', 'Sahip olduklarınızı takdir edin'),
  ('tr', 'Sınır Belirleme', 'sinir-belirleme', 'Enerjinizi koruyun')
ON CONFLICT (locale, slug) DO NOTHING;

-- ════════════════════════════════════════════════════════════════════════════
-- DAILY STATS MATERIALIZED VIEW
-- ════════════════════════════════════════════════════════════════════════════

CREATE MATERIALIZED VIEW IF NOT EXISTS content_daily_stats AS
SELECT
  DATE(created_at) as date,
  locale,
  category,
  COUNT(*) as total_items,
  COUNT(*) FILTER (WHERE safety_action = 'pass') as clean_items,
  COUNT(*) FILTER (WHERE safety_action = 'rewrite') as rewritten_items,
  COUNT(*) FILTER (WHERE safety_action = 'block') as blocked_items,
  COALESCE(SUM(display_count), 0) as total_displays,
  COALESCE(SUM(like_count), 0) as total_likes,
  COALESCE(SUM(share_count), 0) as total_shares
FROM content_items
WHERE is_active = TRUE
GROUP BY DATE(created_at), locale, category;

-- Unique index for concurrent refresh
CREATE UNIQUE INDEX IF NOT EXISTS idx_content_daily_stats_unique
  ON content_daily_stats(date, locale, category);

-- Function to refresh the materialized view
CREATE OR REPLACE FUNCTION refresh_content_daily_stats()
RETURNS void AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY content_daily_stats;
END;
$$ LANGUAGE plpgsql;

-- ════════════════════════════════════════════════════════════════════════════
-- SAFETY STATS MATERIALIZED VIEW
-- ════════════════════════════════════════════════════════════════════════════

CREATE MATERIALIZED VIEW IF NOT EXISTS safety_daily_stats AS
SELECT
  DATE(created_at) as date,
  locale,
  source,
  event_type,
  COUNT(*) as event_count,
  COALESCE(SUM(violation_count), 0) as total_violations
FROM safety_events
GROUP BY DATE(created_at), locale, source, event_type;

CREATE UNIQUE INDEX IF NOT EXISTS idx_safety_daily_stats_unique
  ON safety_daily_stats(date, locale, source, event_type);

-- ════════════════════════════════════════════════════════════════════════════
-- OBSERVATORY QUERIES (Views)
-- ════════════════════════════════════════════════════════════════════════════

-- Content overview by locale
CREATE OR REPLACE VIEW content_overview AS
SELECT
  locale,
  category,
  COUNT(*) as total,
  COUNT(*) FILTER (WHERE created_at > NOW() - INTERVAL '7 days') as last_7d,
  COUNT(*) FILTER (WHERE created_at > NOW() - INTERVAL '30 days') as last_30d,
  COUNT(*) FILTER (WHERE is_featured) as featured_count
FROM content_items
WHERE is_active = TRUE
GROUP BY locale, category
ORDER BY locale, total DESC;

-- Safety summary (24h)
CREATE OR REPLACE VIEW safety_summary_24h AS
SELECT
  event_type,
  locale,
  COUNT(*) as count,
  SUM(violation_count) as total_violations
FROM safety_events
WHERE created_at > NOW() - INTERVAL '24 hours'
GROUP BY event_type, locale
ORDER BY count DESC;

-- Safety summary (7d)
CREATE OR REPLACE VIEW safety_summary_7d AS
SELECT
  event_type,
  locale,
  COUNT(*) as count,
  SUM(violation_count) as total_violations
FROM safety_events
WHERE created_at > NOW() - INTERVAL '7 days'
GROUP BY event_type, locale
ORDER BY count DESC;

-- Comments
COMMENT ON MATERIALIZED VIEW content_daily_stats IS 'Daily aggregated content statistics';
COMMENT ON MATERIALIZED VIEW safety_daily_stats IS 'Daily aggregated safety event statistics';
COMMENT ON VIEW content_overview IS 'Content overview by locale and category';
COMMENT ON VIEW safety_summary_24h IS 'Safety event summary for last 24 hours';
