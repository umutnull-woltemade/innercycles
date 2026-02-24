#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# InnerCycles — Supabase Setup Script
# ═══════════════════════════════════════════════════════════════
# Run this after: supabase login
# Creates project, links, pushes migration, updates .env
# ═══════════════════════════════════════════════════════════════

set -e
cd "$(dirname "$0")/.."

echo "═══════════════════════════════════════════════════"
echo "  InnerCycles — Supabase Setup"
echo "═══════════════════════════════════════════════════"

# Check login
echo ""
echo "→ Checking Supabase CLI auth..."
if ! supabase projects list > /dev/null 2>&1; then
  echo "✗ Not logged in. Running supabase login..."
  supabase login
fi

echo "✓ Authenticated"
echo ""

# List projects
echo "→ Your Supabase projects:"
supabase projects list
echo ""

# Check if we're already linked
if [ -f "supabase/.temp/project-ref" ]; then
  PROJECT_REF=$(cat supabase/.temp/project-ref)
  echo "→ Already linked to project: $PROJECT_REF"
else
  echo "→ Enter your Supabase project ref (or 'new' to create one):"
  read -r PROJECT_REF

  if [ "$PROJECT_REF" = "new" ]; then
    echo "→ Creating new project 'innercycles'..."
    supabase projects create innercycles --region us-east-1 --plan free
    echo "→ Waiting 30s for project to initialize..."
    sleep 30
    echo "→ Enter the new project ref from above:"
    read -r PROJECT_REF
  fi

  echo "→ Linking project $PROJECT_REF..."
  supabase link --project-ref "$PROJECT_REF"
fi

# Push migration
echo ""
echo "→ Pushing database migration..."
supabase db push
echo "✓ Migration applied"

# Get project URL and anon key
echo ""
echo "→ Fetching project API keys..."
API_KEYS=$(supabase projects api-keys --project-ref "$PROJECT_REF" 2>/dev/null || true)
echo "$API_KEYS"

echo ""
echo "═══════════════════════════════════════════════════"
echo "  NEXT STEP: Update assets/.env with:"
echo "  SUPABASE_URL=https://${PROJECT_REF}.supabase.co"
echo "  SUPABASE_ANON_KEY=<anon key from above>"
echo "═══════════════════════════════════════════════════"
echo ""
echo "Then run: flutter run"
