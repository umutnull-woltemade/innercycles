-- ════════════════════════════════════════════════════════════════════════════
-- SAFETY EVENTS TABLE
-- ════════════════════════════════════════════════════════════════════════════
-- Privacy-safe logging of content safety filter events.
-- Logs only counts and categories, never actual content.
-- ════════════════════════════════════════════════════════════════════════════

-- Create safety_events table
CREATE TABLE IF NOT EXISTS safety_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Event type
  event_type TEXT NOT NULL CHECK (event_type IN ('pass', 'rewrite', 'block', 'review_trigger')),

  -- Context
  source TEXT NOT NULL, -- e.g., 'content_generator', 'ai_response', 'user_input'
  locale TEXT NOT NULL CHECK (locale IN ('en', 'tr', 'de', 'fr')),

  -- Privacy-safe metrics (no actual content logged)
  violation_count INTEGER DEFAULT 0,
  violation_categories TEXT[], -- Array of category names: ['prediction', 'fortune', 'zodiac']

  -- Session context (optional, anonymized)
  session_hash TEXT, -- SHA256 hash of session ID, not the actual ID

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_safety_events_created ON safety_events(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_safety_events_type ON safety_events(event_type);
CREATE INDEX IF NOT EXISTS idx_safety_events_source ON safety_events(source);
CREATE INDEX IF NOT EXISTS idx_safety_events_locale ON safety_events(locale);

-- Partition by month (optional, for high-volume scenarios)
-- CREATE TABLE safety_events_y2026m02 PARTITION OF safety_events
--   FOR VALUES FROM ('2026-02-01') TO ('2026-03-01');

-- Row Level Security
ALTER TABLE safety_events ENABLE ROW LEVEL SECURITY;

-- Only service role can access safety events (admin only)
CREATE POLICY "Service role has full access to safety events"
  ON safety_events FOR ALL
  USING (auth.role() = 'service_role');

-- Comments
COMMENT ON TABLE safety_events IS 'Privacy-safe content safety filter event log';
COMMENT ON COLUMN safety_events.violation_categories IS 'Array of violation category names (not actual content)';
COMMENT ON COLUMN safety_events.session_hash IS 'Anonymized session identifier for debugging';

-- ════════════════════════════════════════════════════════════════════════════
-- CONTENT GENERATION LOG TABLE
-- ════════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS content_generation_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Run metadata
  run_date DATE NOT NULL,
  locale TEXT NOT NULL CHECK (locale IN ('en', 'tr', 'de', 'fr')),
  topic TEXT,

  -- Counts
  generated_count INTEGER DEFAULT 0,
  passed_count INTEGER DEFAULT 0,
  rewritten_count INTEGER DEFAULT 0,
  blocked_count INTEGER DEFAULT 0,

  -- Performance
  duration_ms INTEGER,

  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_content_generation_log_date ON content_generation_log(run_date DESC);
CREATE INDEX IF NOT EXISTS idx_content_generation_log_locale ON content_generation_log(locale);

-- Row Level Security
ALTER TABLE content_generation_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Service role has full access to generation log"
  ON content_generation_log FOR ALL
  USING (auth.role() = 'service_role');

-- Comments
COMMENT ON TABLE content_generation_log IS 'Log of content generation runs with safety metrics';
