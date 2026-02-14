/**
 * InnerCycles Content Domination — Inter-Agent Communication Protocol
 *
 * Standard JSON format for agent-to-agent data exchange.
 * Supports 13-agent autonomous pipeline with self-healing.
 */

// ─── Agent Identity ─────────────────────────────────────────

export type AgentName =
  | "orchestrator"
  | "competitor_intelligence"
  | "tool_gap"
  | "content_architect"
  | "multi_language"
  | "content_generation"
  | "seo_optimization"
  | "qa_validation"
  | "analytics"
  | "revision"
  | "monetization_alignment"
  | "retention"
  | "final_synthesis";

// ─── Content Categories ─────────────────────────────────────

export type ContentCategory =
  | "daily_insight"
  | "weekly_deep_dive"
  | "archetype_expansion"
  | "seasonal_content"
  | "dream_module"
  | "ritual_module"
  | "educational_module"
  | "compatibility_expansion"
  | "reflection"
  | "affirmation"
  | "seo_page"
  | "blog_post"
  | "push_notification"
  | "app_store_metadata"
  | "compliance_result"
  | "cost_report"
  | "analytics_report"
  | "revision_report";

// ─── Languages ──────────────────────────────────────────────

export type SupportedLanguage = "en" | "tr" | "de" | "fr" | "es";

// ─── Core Message Protocol ──────────────────────────────────

export interface AgentMessage {
  id: string;
  source_agent: AgentName;
  target_agent?: AgentName;
  category: ContentCategory;
  language: SupportedLanguage;
  content: string;
  risk_score: number; // 0-10, 0 = safe
  duplication_score: number; // 0.0-1.0, < 0.7 required
  quality_score: number; // 1-5, >= 3 required
  compliance_passed: boolean;
  metadata?: Record<string, unknown>;
  created_at: string;
}

// ─── Batch Processing ───────────────────────────────────────

export interface AgentBatch {
  batch_id: string;
  agent_name: AgentName;
  started_at: string;
  completed_at?: string;
  items: AgentMessage[];
  total_tokens: number;
  total_cost_usd: number;
  status: "queued" | "running" | "completed" | "failed" | "retrying" | "escalated";
  retry_count: number;
  max_retries: number;
  errors: string[];
  health_check?: HealthStatus;
}

// ─── Agent Configuration ────────────────────────────────────

export interface AgentConfig {
  name: AgentName;
  window: number;
  batch_size: number;
  retry_limit: number;
  max_concurrent: number;
  model_preference: "local" | "cloud" | "hybrid";
  cost_limit_usd: number;
  depends_on: AgentName[];
  output_file: string;
  health_check_interval_sec: number;
}

// ─── Self-Healing ───────────────────────────────────────────

export type HealthState = "healthy" | "degraded" | "failed" | "recovering";

export interface HealthStatus {
  agent_name: AgentName;
  state: HealthState;
  last_heartbeat: string;
  consecutive_failures: number;
  last_error?: string;
  recovery_action?: "retry" | "restart" | "escalate" | "skip";
}

export interface EscalationEvent {
  source_agent: AgentName;
  error_type: "token_exceeded" | "incomplete_output" | "compliance_violation" | "qa_failure" | "timeout" | "cost_exceeded";
  error_detail: string;
  retry_count: number;
  timestamp: string;
  resolution?: string;
}

// ─── Pipeline Orchestration ─────────────────────────────────

export interface PipelineStage {
  stage: number;
  agents: AgentName[];
  parallel: boolean;
  gate_condition?: string;
}

export const PIPELINE_STAGES: PipelineStage[] = [
  { stage: 1, agents: ["competitor_intelligence", "tool_gap"], parallel: true },
  { stage: 2, agents: ["content_architect"], parallel: false, gate_condition: "stage_1_complete" },
  { stage: 3, agents: ["multi_language", "seo_optimization"], parallel: true, gate_condition: "stage_2_complete" },
  { stage: 4, agents: ["content_generation"], parallel: false, gate_condition: "stage_3_complete" },
  { stage: 5, agents: ["qa_validation"], parallel: false, gate_condition: "stage_4_complete" },
  { stage: 6, agents: ["analytics", "revision", "monetization_alignment", "retention"], parallel: true, gate_condition: "stage_5_complete" },
  { stage: 7, agents: ["final_synthesis"], parallel: false, gate_condition: "stage_6_complete" },
];

// ─── 13-Agent Configuration Registry ────────────────────────

export const AGENT_CONFIGS: AgentConfig[] = [
  {
    name: "orchestrator",
    window: 0,
    batch_size: 0,
    retry_limit: 0,
    max_concurrent: 1,
    model_preference: "local",
    cost_limit_usd: 0,
    depends_on: [],
    output_file: "logs/agents/orchestrator.log",
    health_check_interval_sec: 30,
  },
  {
    name: "competitor_intelligence",
    window: 1,
    batch_size: 10,
    retry_limit: 2,
    max_concurrent: 2,
    model_preference: "cloud",
    cost_limit_usd: 3.0,
    depends_on: [],
    output_file: "outputs/competitor.md",
    health_check_interval_sec: 60,
  },
  {
    name: "tool_gap",
    window: 2,
    batch_size: 15,
    retry_limit: 2,
    max_concurrent: 2,
    model_preference: "cloud",
    cost_limit_usd: 2.0,
    depends_on: [],
    output_file: "outputs/tool_gap.md",
    health_check_interval_sec: 60,
  },
  {
    name: "content_architect",
    window: 3,
    batch_size: 25,
    retry_limit: 2,
    max_concurrent: 4,
    model_preference: "hybrid",
    cost_limit_usd: 3.0,
    depends_on: ["competitor_intelligence", "tool_gap"],
    output_file: "outputs/content_architecture.md",
    health_check_interval_sec: 45,
  },
  {
    name: "multi_language",
    window: 4,
    batch_size: 25,
    retry_limit: 2,
    max_concurrent: 5,
    model_preference: "cloud",
    cost_limit_usd: 4.0,
    depends_on: ["content_architect"],
    output_file: "outputs/multilang.md",
    health_check_interval_sec: 60,
  },
  {
    name: "content_generation",
    window: 5,
    batch_size: 25,
    retry_limit: 3,
    max_concurrent: 4,
    model_preference: "hybrid",
    cost_limit_usd: 5.0,
    depends_on: ["content_architect", "multi_language"],
    output_file: "outputs/content_generated.md",
    health_check_interval_sec: 30,
  },
  {
    name: "seo_optimization",
    window: 6,
    batch_size: 25,
    retry_limit: 2,
    max_concurrent: 4,
    model_preference: "local",
    cost_limit_usd: 1.0,
    depends_on: ["content_architect"],
    output_file: "outputs/seo.md",
    health_check_interval_sec: 60,
  },
  {
    name: "qa_validation",
    window: 7,
    batch_size: 25,
    retry_limit: 2,
    max_concurrent: 2,
    model_preference: "cloud",
    cost_limit_usd: 2.0,
    depends_on: ["content_generation"],
    output_file: "outputs/qa_validation.md",
    health_check_interval_sec: 30,
  },
  {
    name: "analytics",
    window: 8,
    batch_size: 10,
    retry_limit: 2,
    max_concurrent: 2,
    model_preference: "local",
    cost_limit_usd: 0.5,
    depends_on: ["qa_validation"],
    output_file: "outputs/analytics.md",
    health_check_interval_sec: 120,
  },
  {
    name: "revision",
    window: 9,
    batch_size: 10,
    retry_limit: 2,
    max_concurrent: 2,
    model_preference: "hybrid",
    cost_limit_usd: 2.0,
    depends_on: ["qa_validation", "analytics"],
    output_file: "outputs/revisions.md",
    health_check_interval_sec: 60,
  },
  {
    name: "monetization_alignment",
    window: 10,
    batch_size: 10,
    retry_limit: 2,
    max_concurrent: 1,
    model_preference: "cloud",
    cost_limit_usd: 1.0,
    depends_on: ["qa_validation"],
    output_file: "outputs/monetization.md",
    health_check_interval_sec: 120,
  },
  {
    name: "retention",
    window: 11,
    batch_size: 10,
    retry_limit: 2,
    max_concurrent: 2,
    model_preference: "hybrid",
    cost_limit_usd: 1.5,
    depends_on: ["qa_validation", "analytics"],
    output_file: "outputs/retention.md",
    health_check_interval_sec: 60,
  },
  {
    name: "final_synthesis",
    window: 12,
    batch_size: 1,
    retry_limit: 2,
    max_concurrent: 1,
    model_preference: "cloud",
    cost_limit_usd: 3.0,
    depends_on: [
      "competitor_intelligence",
      "tool_gap",
      "content_architect",
      "multi_language",
      "content_generation",
      "seo_optimization",
      "qa_validation",
      "analytics",
      "revision",
      "monetization_alignment",
      "retention",
    ],
    output_file: "outputs/master_domination_blueprint.md",
    health_check_interval_sec: 120,
  },
];

// ─── Cost Tracking ──────────────────────────────────────────

export interface CostEntry {
  agent_name: AgentName;
  model: string;
  input_tokens: number;
  output_tokens: number;
  cost_usd: number;
  timestamp: string;
}

export const COST_LIMITS = {
  per_agent: 5.0,
  per_cycle: 25.0,
  per_week: 100.0,
  per_month: 400.0,
};

// ─── Self-Healing Decision Tree ─────────────────────────────

export function resolveFailure(event: EscalationEvent): string {
  if (event.retry_count < 2) return "retry";
  switch (event.error_type) {
    case "token_exceeded":
      return "reduce_batch_size_and_retry";
    case "incomplete_output":
      return "retry_with_simplified_prompt";
    case "compliance_violation":
      return "escalate_to_orchestrator";
    case "qa_failure":
      return event.retry_count < 3 ? "retry_generation" : "escalate_to_orchestrator";
    case "timeout":
      return "restart_agent";
    case "cost_exceeded":
      return "pause_and_escalate";
    default:
      return "escalate_to_orchestrator";
  }
}
