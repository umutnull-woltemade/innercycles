import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface SlackAlertPayload {
  error_type: string;
  message: string;
  platform?: string;
  app_version?: string;
  stack_trace?: string;
}

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const payload: SlackAlertPayload = await req.json()
    const { error_type, message, platform, app_version, stack_trace } = payload

    const slackUrl = Deno.env.get('SLACK_WEBHOOK_URL')
    if (!slackUrl) {
      console.error('SLACK_WEBHOOK_URL not configured')
      return new Response(
        JSON.stringify({ error: 'SLACK_WEBHOOK_URL not configured' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const severity = error_type === 'fatal' ? '🔴 FATAL CRASH' : '🟡 Non-Fatal Issue'
    const timestamp = new Date().toISOString()

    const blocks = [
      {
        type: "header",
        text: { type: "plain_text", text: `${severity} — Astrobobo`, emoji: true }
      },
      {
        type: "section",
        fields: [
          { type: "mrkdwn", text: `*Error:*\n${message.substring(0, 200)}` },
          { type: "mrkdwn", text: `*Platform:*\n${platform || 'unknown'}` },
          { type: "mrkdwn", text: `*Version:*\n${app_version || 'unknown'}` },
          { type: "mrkdwn", text: `*Time:*\n${timestamp}` }
        ]
      }
    ]

    // Add stack trace if available (truncated)
    if (stack_trace) {
      blocks.push({
        type: "section",
        text: { type: "mrkdwn", text: `*Stack Trace:*\n\`\`\`${stack_trace.substring(0, 500)}\`\`\`` }
      } as any)
    }

    const slackResponse = await fetch(slackUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ blocks })
    })

    if (!slackResponse.ok) {
      console.error('Slack webhook failed:', slackResponse.status)
      return new Response(
        JSON.stringify({ error: 'Slack webhook failed' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    return new Response(
      JSON.stringify({ success: true }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    console.error('Error processing request:', error)
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})
