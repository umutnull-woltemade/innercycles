// ML Rollout Trainer Edge Function
// Trains logistic regression model weekly for rollout risk prediction
// Requires minimum 100 samples, validates on holdout (F1 > 0.6 required)
// Does NOT auto-activate - requires manual approval

import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface TrainingSnapshot {
  id: string
  flag_name: string
  snapshot_timestamp: string
  current_rollout_percentage: number
  time_since_last_step_hours: number
  total_exposed_users: number
  crash_rate_delta_24h: number
  error_rate_delta_24h: number
  churn_rate_exposed_vs_control: number
  conversion_rate_exposed: number
  engagement_delta_exposed: number
  retention_d1_exposed: number
  platform_ios_ratio: number
  platform_android_ratio: number
  had_incident_within_24h: boolean
  incident_type: string | null
}

interface ModelMetrics {
  f1_score: number
  precision: number
  recall: number
  auc_roc: number
  training_samples: number
  holdout_samples: number
}

const FEATURE_NAMES = [
  'current_rollout_percentage',
  'time_since_last_step_hours',
  'total_exposed_users_log',
  'crash_rate_delta_24h',
  'error_rate_delta_24h',
  'churn_rate_exposed_vs_control',
  'conversion_rate_exposed',
  'engagement_delta_exposed',
  'retention_d1_exposed',
  'platform_ios_ratio',
  'platform_android_ratio',
]

const MIN_TRAINING_SAMPLES = 100
const MIN_F1_SCORE = 0.6
const TRAINING_WINDOW_DAYS = 90
const HOLDOUT_RATIO = 0.2
const LEARNING_RATE = 0.01
const MAX_ITERATIONS = 1000

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const supabase = createClient(supabaseUrl, supabaseServiceKey)

    console.log('[ML Trainer] Starting weekly model training...')

    // Fetch training data from last 90 days
    const windowStart = new Date()
    windowStart.setDate(windowStart.getDate() - TRAINING_WINDOW_DAYS)

    const { data: trainingData, error: fetchError } = await supabase
      .from('rollout_training_data')
      .select('*')
      .gte('snapshot_timestamp', windowStart.toISOString())
      .order('snapshot_timestamp', { ascending: true })

    if (fetchError) {
      throw new Error(`Failed to fetch training data: ${fetchError.message}`)
    }

    if (!trainingData || trainingData.length < MIN_TRAINING_SAMPLES) {
      console.log(
        `[ML Trainer] Insufficient training data: ${trainingData?.length ?? 0} < ${MIN_TRAINING_SAMPLES}`
      )
      return new Response(
        JSON.stringify({
          success: false,
          reason: 'insufficient_data',
          samples: trainingData?.length ?? 0,
          required: MIN_TRAINING_SAMPLES,
        }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    console.log(`[ML Trainer] Processing ${trainingData.length} training samples`)

    // Shuffle and split data
    const shuffled = shuffleArray([...trainingData])
    const holdoutSize = Math.floor(shuffled.length * HOLDOUT_RATIO)
    const trainSet = shuffled.slice(holdoutSize)
    const holdoutSet = shuffled.slice(0, holdoutSize)

    // Extract features and labels
    const trainFeatures = trainSet.map(extractFeatures)
    const trainLabels = trainSet.map((s) => s.had_incident_within_24h)
    const holdoutFeatures = holdoutSet.map(extractFeatures)
    const holdoutLabels = holdoutSet.map((s) => s.had_incident_within_24h)

    // Train logistic regression
    console.log('[ML Trainer] Training logistic regression model...')
    const weights = trainLogisticRegression(trainFeatures, trainLabels)

    // Evaluate on holdout
    const predictions = holdoutFeatures.map((f) => predict(f, weights) > 0.5)
    const metrics = calculateMetrics(predictions, holdoutLabels)

    console.log(
      `[ML Trainer] Model metrics - F1: ${metrics.f1_score.toFixed(3)}, ` +
        `Precision: ${metrics.precision.toFixed(3)}, Recall: ${metrics.recall.toFixed(3)}`
    )

    // Check quality threshold
    if (metrics.f1_score < MIN_F1_SCORE) {
      console.log(
        `[ML Trainer] Model does not meet quality threshold: ${metrics.f1_score.toFixed(3)} < ${MIN_F1_SCORE}`
      )

      // Log audit entry for failed training
      await supabase.from('ml_model_audit').insert({
        model_version: `v${Date.now()}_failed`,
        action: 'training_failed',
        actor_type: 'system',
        metrics: metrics,
        feature_importance: calculateFeatureImportance(weights),
      })

      return new Response(
        JSON.stringify({
          success: false,
          reason: 'quality_threshold_not_met',
          f1_score: metrics.f1_score,
          required: MIN_F1_SCORE,
          metrics,
        }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Calculate feature importance
    const featureImportance = calculateFeatureImportance(weights)

    // Generate version
    const version = `v${new Date().toISOString().slice(0, 10).replace(/-/g, '')}_${Date.now()}`

    // Store model (NOT auto-activated)
    const { error: insertError } = await supabase.from('ml_rollout_models').insert({
      version,
      model_type: 'logistic_regression',
      weights,
      feature_names: FEATURE_NAMES,
      feature_importance: featureImportance,
      training_samples: trainSet.length,
      metrics: {
        f1_score: metrics.f1_score,
        precision: metrics.precision,
        recall: metrics.recall,
        holdout_samples: holdoutSet.length,
      },
      status: 'trained',
      is_active: false, // Requires manual activation
    })

    if (insertError) {
      throw new Error(`Failed to store model: ${insertError.message}`)
    }

    // Log audit entry
    await supabase.from('ml_model_audit').insert({
      model_version: version,
      action: 'model_trained',
      actor_type: 'system',
      metrics: metrics,
      feature_importance: featureImportance,
    })

    console.log(`[ML Trainer] Model ${version} trained successfully. Awaiting manual activation.`)

    return new Response(
      JSON.stringify({
        success: true,
        version,
        metrics,
        feature_importance: featureImportance,
        status: 'trained_pending_activation',
        message: 'Model trained successfully. Manual activation required.',
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    console.error('[ML Trainer] Error:', error)
    return new Response(
      JSON.stringify({
        success: false,
        error: error.message,
      }),
      {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      }
    )
  }
})

function extractFeatures(snapshot: TrainingSnapshot): number[] {
  return [
    snapshot.current_rollout_percentage,
    snapshot.time_since_last_step_hours,
    snapshot.total_exposed_users > 0 ? Math.log(snapshot.total_exposed_users) : 0,
    snapshot.crash_rate_delta_24h,
    snapshot.error_rate_delta_24h,
    snapshot.churn_rate_exposed_vs_control,
    snapshot.conversion_rate_exposed,
    snapshot.engagement_delta_exposed,
    snapshot.retention_d1_exposed,
    snapshot.platform_ios_ratio,
    snapshot.platform_android_ratio,
  ]
}

function trainLogisticRegression(
  features: number[][],
  labels: boolean[]
): Record<string, number> {
  const n = features.length
  const m = FEATURE_NAMES.length

  // Initialize weights
  const weights: Record<string, number> = { bias: 0 }
  for (const name of FEATURE_NAMES) {
    weights[name] = 0
  }

  // Gradient descent
  for (let iter = 0; iter < MAX_ITERATIONS; iter++) {
    const gradients: Record<string, number> = { bias: 0 }
    for (const name of FEATURE_NAMES) {
      gradients[name] = 0
    }

    for (let i = 0; i < n; i++) {
      // Compute prediction
      let z = weights.bias
      for (let j = 0; j < m; j++) {
        z += weights[FEATURE_NAMES[j]] * features[i][j]
      }
      z = Math.max(-500, Math.min(500, z)) // Clamp to prevent overflow
      const prediction = 1 / (1 + Math.exp(-z))

      // Compute error
      const error = prediction - (labels[i] ? 1 : 0)

      // Accumulate gradients
      gradients.bias += error
      for (let j = 0; j < m; j++) {
        gradients[FEATURE_NAMES[j]] += error * features[i][j]
      }
    }

    // Update weights
    weights.bias -= (LEARNING_RATE * gradients.bias) / n
    for (const name of FEATURE_NAMES) {
      weights[name] -= (LEARNING_RATE * gradients[name]) / n
    }
  }

  return weights
}

function predict(features: number[], weights: Record<string, number>): number {
  let z = weights.bias
  for (let i = 0; i < FEATURE_NAMES.length; i++) {
    z += weights[FEATURE_NAMES[i]] * features[i]
  }
  z = Math.max(-500, Math.min(500, z))
  return 1 / (1 + Math.exp(-z))
}

function calculateMetrics(
  predictions: boolean[],
  labels: boolean[]
): ModelMetrics {
  let tp = 0,
    fp = 0,
    fn = 0,
    tn = 0

  for (let i = 0; i < labels.length; i++) {
    if (predictions[i] && labels[i]) tp++
    else if (predictions[i] && !labels[i]) fp++
    else if (!predictions[i] && labels[i]) fn++
    else tn++
  }

  const precision = tp + fp > 0 ? tp / (tp + fp) : 0
  const recall = tp + fn > 0 ? tp / (tp + fn) : 0
  const f1 = precision + recall > 0 ? (2 * precision * recall) / (precision + recall) : 0

  // Simplified AUC-ROC (not true AUC, but indicator)
  const sensitivity = recall
  const specificity = tn + fp > 0 ? tn / (tn + fp) : 0
  const auc = (sensitivity + specificity) / 2

  return {
    f1_score: f1,
    precision,
    recall,
    auc_roc: auc,
    training_samples: labels.length,
    holdout_samples: labels.length,
  }
}

function calculateFeatureImportance(
  weights: Record<string, number>
): Record<string, number> {
  const importance: Record<string, number> = {}
  let total = 0

  for (const name of FEATURE_NAMES) {
    importance[name] = Math.abs(weights[name])
    total += importance[name]
  }

  // Normalize to sum to 1
  if (total > 0) {
    for (const name of FEATURE_NAMES) {
      importance[name] /= total
    }
  }

  return importance
}

function shuffleArray<T>(array: T[]): T[] {
  for (let i = array.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1))
    ;[array[i], array[j]] = [array[j], array[i]]
  }
  return array
}
