---
type: "ab_cron_system"
updated_at: "2026-01-25"
---

# Automated A/B Winner Selection — Cron System Design

## Overview
Weekly cron job that evaluates A/B title variants per EN page, selects winners based on performance data, and promotes winners automatically.

## Input Schema (per page)

```json
{
  "page_slug": "ruyada-dusmek",
  "variants": [
    {
      "id": "A",
      "title": "Dreaming of Falling — What Your Subconscious Is Trying to Tell You",
      "impressions": 2340,
      "clicks": 187,
      "ctr": 0.0799,
      "avg_time_on_page": 142
    },
    {
      "id": "B",
      "title": "Why Falling Dreams Feel So Real — And What They Reveal About Your Life",
      "impressions": 2180,
      "clicks": 218,
      "ctr": 0.1000,
      "avg_time_on_page": 128
    },
    {
      "id": "C",
      "title": "Falling Dreams Aren't Just About Fear — Here's What They Actually Mean",
      "impressions": 1950,
      "clicks": 156,
      "ctr": 0.0800,
      "avg_time_on_page": 155
    }
  ]
}
```

## Cron Logic — Pseudocode

```python
# ab_winner_selection.py
# Runs: Every Sunday at 03:00 UTC
# Frequency: Weekly

import json
from datetime import datetime

MINIMUM_IMPRESSIONS = 500
CTR_WEIGHT = 0.7
DWELL_WEIGHT = 0.3
MAX_DWELL_SECONDS = 300  # Cap for normalization

def normalize_dwell(seconds):
    """Normalize dwell time to 0-1 scale"""
    return min(seconds / MAX_DWELL_SECONDS, 1.0)

def calculate_score(variant):
    """Calculate weighted score for a variant"""
    ctr_score = variant["ctr"]
    dwell_score = normalize_dwell(variant.get("avg_time_on_page", 0))
    return (ctr_score * CTR_WEIGHT) + (dwell_score * DWELL_WEIGHT)

def select_winner(page_data):
    """Select winning variant for a page"""
    slug = page_data["page_slug"]
    variants = page_data["variants"]

    # Filter: require minimum impressions
    eligible = [v for v in variants if v["impressions"] >= MINIMUM_IMPRESSIONS]

    if len(eligible) < 2:
        return {
            "slug": slug,
            "status": "insufficient_data",
            "message": f"Only {len(eligible)} variants have {MINIMUM_IMPRESSIONS}+ impressions",
            "action": "keep_current"
        }

    # Score each eligible variant
    scored = []
    for v in eligible:
        score = calculate_score(v)
        scored.append({**v, "score": round(score, 6)})

    # Sort by score descending
    scored.sort(key=lambda x: x["score"], reverse=True)

    winner = scored[0]
    losers = scored[1:]

    return {
        "slug": slug,
        "status": "winner_selected",
        "winner": {
            "id": winner["id"],
            "title": winner["title"],
            "score": winner["score"],
            "ctr": winner["ctr"],
            "dwell": winner.get("avg_time_on_page", 0)
        },
        "losers": [
            {"id": l["id"], "title": l["title"], "score": l["score"]}
            for l in losers
        ],
        "action": "promote_winner"
    }

def promote_winner(result):
    """Apply winner title to the page"""
    if result["action"] != "promote_winner":
        return

    slug = result["slug"]
    new_title = result["winner"]["title"]

    # 1. Update content file frontmatter
    update_frontmatter(f"/content/en/{slug}.md", "title", new_title)

    # 2. Update HTML meta title
    update_html_title(f"/web/ruya/{slug}.html", new_title)

    # 3. Update sitemap lastmod
    update_sitemap_lastmod(slug, datetime.utcnow().isoformat())

    # 4. Archive result
    archive_result(slug, result)

def run_weekly_cron():
    """Main cron entry point"""
    pages = load_all_page_data()  # From analytics API
    results = []

    for page in pages:
        result = select_winner(page)
        results.append(result)

        if result["action"] == "promote_winner":
            promote_winner(result)
            log(f"[WINNER] {result['slug']}: "
                f"Variant {result['winner']['id']} "
                f"(score: {result['winner']['score']})")
        else:
            log(f"[SKIP] {result['slug']}: {result['message']}")

    # Generate weekly report
    generate_report(results)

    return results

# --- Helper Functions ---

def update_frontmatter(file_path, key, value):
    """Update YAML frontmatter in markdown file"""
    # Read file, parse frontmatter, update key, write back
    pass

def update_html_title(file_path, new_title):
    """Update <title> and og:title in HTML file"""
    # Read HTML, replace title tag content, write back
    pass

def update_sitemap_lastmod(slug, date_str):
    """Update lastmod for slug entry in sitemap.xml"""
    pass

def archive_result(slug, result):
    """Append result to /content/en/_ab_history.jsonl"""
    with open("/content/en/_ab_history.jsonl", "a") as f:
        entry = {
            "date": datetime.utcnow().isoformat(),
            "slug": slug,
            **result
        }
        f.write(json.dumps(entry) + "\n")

def generate_report(results):
    """Generate weekly A/B report"""
    winners = [r for r in results if r["action"] == "promote_winner"]
    skipped = [r for r in results if r["action"] == "keep_current"]

    report = {
        "date": datetime.utcnow().isoformat(),
        "total_pages": len(results),
        "winners_selected": len(winners),
        "skipped": len(skipped),
        "details": results
    }

    with open(f"/content/en/_ab_report_{datetime.utcnow().strftime('%Y%m%d')}.json", "w") as f:
        json.dump(report, f, indent=2)
```

## Winner Selection Rules Summary

| Rule | Value |
|------|-------|
| Minimum impressions per variant | 500 |
| CTR weight | 70% |
| Dwell time weight | 30% |
| Dwell time normalization cap | 300 seconds |
| Evaluation frequency | Weekly (Sunday 03:00 UTC) |
| Tie-breaking | Higher CTR wins |
| Insufficient data | Keep current title |
| Archive format | JSONL append |
| Sitemap update | lastmod refreshed on winner promotion |

## Cloudflare Worker Integration

For deployment on the existing Cloudflare Workers infrastructure:

```javascript
// workers/api/cron/ab-winner.js
export default {
  async scheduled(event, env, ctx) {
    const pages = await getAllPageData(env);

    for (const page of pages) {
      const result = selectWinner(page);

      if (result.action === 'promote_winner') {
        await env.CONTENT_KV.put(
          `title:en:${result.slug}`,
          result.winner.title
        );
        await env.CONTENT_KV.put(
          `ab_history:${result.slug}`,
          JSON.stringify(result),
          { metadata: { date: new Date().toISOString() } }
        );
      }
    }
  }
};

function selectWinner(pageData) {
  const MIN_IMPRESSIONS = 500;
  const CTR_WEIGHT = 0.7;
  const DWELL_WEIGHT = 0.3;

  const eligible = pageData.variants.filter(v => v.impressions >= MIN_IMPRESSIONS);
  if (eligible.length < 2) return { slug: pageData.page_slug, action: 'keep_current' };

  const scored = eligible.map(v => ({
    ...v,
    score: (v.ctr * CTR_WEIGHT) + (Math.min(v.avg_time_on_page / 300, 1) * DWELL_WEIGHT)
  }));

  scored.sort((a, b) => b.score - a.score);

  return {
    slug: pageData.page_slug,
    action: 'promote_winner',
    winner: scored[0],
    losers: scored.slice(1)
  };
}
```

## No Manual Intervention Required

- System runs autonomously every week
- Winners are promoted automatically
- Losers are archived for historical analysis
- Sitemap is updated to signal freshness to crawlers
- Reports are generated for optional review
