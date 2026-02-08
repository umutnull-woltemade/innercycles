-- ════════════════════════════════════════════════════════════════════════════
-- CONTENT ITEMS TABLE
-- ════════════════════════════════════════════════════════════════════════════
-- Stores AI-generated content (reflections, prompts, insights)
-- with safety filter metadata.
-- ════════════════════════════════════════════════════════════════════════════

-- Create content_items table
CREATE TABLE IF NOT EXISTS content_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Locale and category
  locale TEXT NOT NULL CHECK (locale IN ('en', 'tr', 'de', 'fr')),
  category TEXT NOT NULL CHECK (category IN (
    'reflection', 'prompt', 'insight', 'pattern',
    'guidance', 'check_in', 'affirmation', 'daily'
  )),
  subcategory TEXT,

  -- Content
  content TEXT NOT NULL,
  original_content TEXT, -- Before safety filter (if modified)

  -- Safety metadata
  safety_action TEXT CHECK (safety_action IN ('pass', 'rewrite', 'block')),
  safety_violations INTEGER DEFAULT 0,

  -- Engagement metrics
  display_count INTEGER DEFAULT 0,
  like_count INTEGER DEFAULT 0,
  share_count INTEGER DEFAULT 0,

  -- Status
  is_active BOOLEAN DEFAULT TRUE,
  is_featured BOOLEAN DEFAULT FALSE,
  is_seed_content BOOLEAN DEFAULT FALSE, -- Pre-seeded for App Store review

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  -- Full-text search
  search_vector TSVECTOR GENERATED ALWAYS AS (
    setweight(to_tsvector('english', coalesce(content, '')), 'A') ||
    setweight(to_tsvector('english', coalesce(subcategory, '')), 'B')
  ) STORED
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_content_items_locale ON content_items(locale);
CREATE INDEX IF NOT EXISTS idx_content_items_category ON content_items(category);
CREATE INDEX IF NOT EXISTS idx_content_items_subcategory ON content_items(subcategory);
CREATE INDEX IF NOT EXISTS idx_content_items_created ON content_items(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_content_items_active ON content_items(is_active) WHERE is_active = TRUE;
CREATE INDEX IF NOT EXISTS idx_content_items_featured ON content_items(is_featured) WHERE is_featured = TRUE;
CREATE INDEX IF NOT EXISTS idx_content_items_seed ON content_items(is_seed_content) WHERE is_seed_content = TRUE;
CREATE INDEX IF NOT EXISTS idx_content_items_search ON content_items USING GIN(search_vector);

-- Updated at trigger
CREATE OR REPLACE FUNCTION update_content_items_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_content_items_updated_at
  BEFORE UPDATE ON content_items
  FOR EACH ROW
  EXECUTE FUNCTION update_content_items_updated_at();

-- Row Level Security
ALTER TABLE content_items ENABLE ROW LEVEL SECURITY;

-- Public can read active content
CREATE POLICY "Public can read active content"
  ON content_items FOR SELECT
  USING (is_active = TRUE);

-- Service role has full access
CREATE POLICY "Service role has full access to content"
  ON content_items FOR ALL
  USING (auth.role() = 'service_role');

-- Comments
COMMENT ON TABLE content_items IS 'AI-generated content with safety filter metadata';
COMMENT ON COLUMN content_items.original_content IS 'Original content before safety filter modification';
COMMENT ON COLUMN content_items.safety_action IS 'Action taken by safety filter: pass, rewrite, or block';
COMMENT ON COLUMN content_items.is_seed_content IS 'Pre-seeded content for App Store review mode';
