#!/usr/bin/env node
/**
 * InnerCycles Self-Healing Execution Engine
 *
 * Monitors agent health, detects failures, retries, and escalates.
 * Runs alongside the tmux agent system.
 *
 * Usage: node scripts/self-heal.mjs
 */

import { readdir, readFile, writeFile, unlink, stat } from "fs/promises";
import { join } from "path";
import { execSync } from "child_process";

const PROJECT_DIR = new URL("..", import.meta.url).pathname.replace(/\/$/, "");
const HEALTH_DIR = join(PROJECT_DIR, "logs", "health");
const LOG_DIR = join(PROJECT_DIR, "logs", "agents");
const RETRY_DIR = join(PROJECT_DIR, "logs", "retries");
const OUTPUT_DIR = join(PROJECT_DIR, "outputs");

const MAX_RETRIES = 2;
const HEARTBEAT_TIMEOUT_SEC = 300; // 5 minutes
const CHECK_INTERVAL_MS = 30_000; // 30 seconds

// ─── Agent Registry ──────────────────────────────────────────

const AGENTS = [
  "competitor",
  "tool_gap",
  "content_architect",
  "multilang",
  "content_gen",
  "seo",
  "qa",
  "analytics",
  "revision",
  "monetization",
  "retention",
  "synthesis",
];

const AGENT_OUTPUTS = {
  competitor: "competitor.md",
  tool_gap: "tool_gap.md",
  content_architect: "content_architecture.md",
  multilang: "multilang.md",
  content_gen: "content_generated.md",
  seo: "seo.md",
  qa: "qa_validation.md",
  analytics: "analytics.md",
  revision: "revisions.md",
  monetization: "monetization.md",
  retention: "retention.md",
  synthesis: "master_domination_blueprint.md",
};

// ─── Health Check ────────────────────────────────────────────

async function checkAgentHealth(agent) {
  const runningFile = join(HEALTH_DIR, `${agent}.running`);
  const failedFile = join(HEALTH_DIR, `${agent}.failed`);
  const outputFile = join(OUTPUT_DIR, AGENT_OUTPUTS[agent]);

  const result = {
    agent,
    state: "unknown",
    hasOutput: false,
    outputSize: 0,
    lastHeartbeat: null,
    stale: false,
  };

  // Check if marked as failed
  try {
    await stat(failedFile);
    result.state = "failed";
    return result;
  } catch {}

  // Check if running
  try {
    const runningStat = await stat(runningFile);
    result.lastHeartbeat = runningStat.mtime;
    const ageSec = (Date.now() - runningStat.mtimeMs) / 1000;
    result.stale = ageSec > HEARTBEAT_TIMEOUT_SEC;
    result.state = result.stale ? "stale" : "running";
  } catch {
    result.state = "not_started";
  }

  // Check output file
  try {
    const outputStat = await stat(outputFile);
    result.hasOutput = true;
    result.outputSize = outputStat.size;
    if (result.outputSize > 100) {
      result.state = "completed";
    }
  } catch {}

  return result;
}

// ─── Retry Logic ─────────────────────────────────────────────

async function getRetryCount(agent) {
  const retryFile = join(RETRY_DIR, `${agent}.retries`);
  try {
    const content = await readFile(retryFile, "utf8");
    return parseInt(content.trim(), 10) || 0;
  } catch {
    return 0;
  }
}

async function incrementRetry(agent) {
  const retryFile = join(RETRY_DIR, `${agent}.retries`);
  const count = (await getRetryCount(agent)) + 1;
  await writeFile(retryFile, String(count));
  return count;
}

// ─── Recovery Actions ────────────────────────────────────────

async function recoverAgent(agent, healthResult) {
  const retries = await getRetryCount(agent);

  if (retries >= MAX_RETRIES) {
    console.log(`  [ESCALATE] ${agent}: Max retries (${MAX_RETRIES}) reached. Manual intervention required.`);
    await writeFile(join(HEALTH_DIR, `${agent}.failed`), JSON.stringify({
      agent,
      reason: "max_retries_exceeded",
      retries,
      timestamp: new Date().toISOString(),
    }));
    return "escalated";
  }

  const newRetryCount = await incrementRetry(agent);
  console.log(`  [RETRY ${newRetryCount}/${MAX_RETRIES}] ${agent}: Attempting recovery...`);

  // Touch the running file to reset heartbeat
  try {
    await writeFile(join(HEALTH_DIR, `${agent}.running`), "");
  } catch {}

  // Log the retry
  const retryLog = {
    agent,
    retry: newRetryCount,
    reason: healthResult.state,
    timestamp: new Date().toISOString(),
  };
  await writeFile(
    join(RETRY_DIR, `${agent}_retry_${newRetryCount}.json`),
    JSON.stringify(retryLog, null, 2)
  );

  return "retrying";
}

// ─── Compliance Spot Check ───────────────────────────────────

async function spotCheckCompliance(agent) {
  const outputFile = join(OUTPUT_DIR, AGENT_OUTPUTS[agent]);
  try {
    const content = await readFile(outputFile, "utf8");

    const BANNED_PHRASES = [
      "will happen",
      "predict",
      "forecast",
      "your future",
      "guaranteed",
      "cure",
      "diagnose",
      "medical advice",
      "financial advice",
      "act now",
      "don't miss",
      "limited time",
    ];

    const violations = [];
    for (const phrase of BANNED_PHRASES) {
      if (content.toLowerCase().includes(phrase)) {
        violations.push(phrase);
      }
    }

    if (violations.length > 0) {
      console.log(`  [COMPLIANCE ALERT] ${agent}: Found banned phrases: ${violations.join(", ")}`);
      return { passed: false, violations };
    }

    return { passed: true, violations: [] };
  } catch {
    return { passed: true, violations: [] }; // No output yet
  }
}

// ─── Main Health Loop ────────────────────────────────────────

async function runHealthCheck() {
  const timestamp = new Date().toISOString().slice(11, 19);
  console.log(`\n[HEALTH CHECK] ${timestamp}`);
  console.log("─".repeat(60));

  let healthy = 0;
  let failed = 0;
  let stale = 0;
  let completed = 0;

  for (const agent of AGENTS) {
    const health = await checkAgentHealth(agent);

    switch (health.state) {
      case "completed":
        completed++;
        const compliance = await spotCheckCompliance(agent);
        const complianceStr = compliance.passed ? "CLEAN" : `VIOLATIONS: ${compliance.violations.length}`;
        console.log(`  [OK] ${agent.padEnd(20)} | output: ${(health.outputSize / 1024).toFixed(1)}KB | compliance: ${complianceStr}`);
        break;

      case "running":
        healthy++;
        console.log(`  [..] ${agent.padEnd(20)} | running`);
        break;

      case "stale":
        stale++;
        console.log(`  [!!] ${agent.padEnd(20)} | STALE (no heartbeat > ${HEARTBEAT_TIMEOUT_SEC}s)`);
        await recoverAgent(agent, health);
        break;

      case "failed":
        failed++;
        console.log(`  [XX] ${agent.padEnd(20)} | FAILED - escalated`);
        break;

      case "not_started":
        console.log(`  [--] ${agent.padEnd(20)} | not started`);
        break;

      default:
        console.log(`  [??] ${agent.padEnd(20)} | unknown state`);
    }
  }

  console.log("─".repeat(60));
  console.log(`  Summary: ${completed} completed | ${healthy} running | ${stale} stale | ${failed} failed`);

  if (completed === AGENTS.length) {
    console.log("\n  ALL AGENTS COMPLETE. Content domination pipeline finished.");
    return true;
  }

  return false;
}

// ─── Entry Point ─────────────────────────────────────────────

async function main() {
  console.log("=========================================");
  console.log("  SELF-HEALING ENGINE ONLINE");
  console.log("=========================================");
  console.log(`  Check interval: ${CHECK_INTERVAL_MS / 1000}s`);
  console.log(`  Heartbeat timeout: ${HEARTBEAT_TIMEOUT_SEC}s`);
  console.log(`  Max retries per agent: ${MAX_RETRIES}`);
  console.log(`  Monitoring ${AGENTS.length} agents`);
  console.log("");

  // Run immediately, then on interval
  const done = await runHealthCheck();
  if (done) return;

  const interval = setInterval(async () => {
    const allDone = await runHealthCheck();
    if (allDone) {
      clearInterval(interval);
      console.log("\nSelf-healing engine shutting down. All agents complete.");
    }
  }, CHECK_INTERVAL_MS);
}

main().catch(console.error);
