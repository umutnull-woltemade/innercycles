// Edge Function: set-secrets-demo
// Exposes two POST endpoints:
//  - /setsecretsdemo/openai -> forwards { prompt } to OpenAI-compatible API using OPENAI_API_KEY
//  - /setsecretsdemo/slack  -> posts { text } to SLACK_WEBHOOK_URL
// Follows Supabase Edge Function guidelines (Deno.serve, Web APIs)

Deno.serve(async (req: Request) => {
  try {
    const url = new URL(req.url);
    const pathname = url.pathname;

    if (req.method !== 'POST') return new Response(JSON.stringify({ error: 'Only POST allowed' }), { status: 405, headers: { 'Content-Type': 'application/json' } });

    if (pathname.endsWith('/openai')) {
      // Read body
      const body = await req.json().catch(() => null);
      const prompt = body?.prompt;
      if (!prompt) return new Response(JSON.stringify({ error: 'Missing prompt in JSON body' }), { status: 400, headers: { 'Content-Type': 'application/json' } });

      const apiKey = Deno.env.get('OPENAI_API_KEY');
      if (!apiKey) return new Response(JSON.stringify({ error: 'OPENAI_API_KEY not set in environment' }), { status: 500, headers: { 'Content-Type': 'application/json' } });

      // Call OpenAI-compatible API (OpenAI v1/chat/completions)
      const openaiResp = await fetch('https://api.openai.com/v1/chat/completions', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${apiKey}`,
        },
        body: JSON.stringify({
          model: 'gpt-3.5-turbo',
          messages: [{ role: 'user', content: prompt }],
          max_tokens: 300,
        }),
      });

      const openaiJson = await openaiResp.json().catch(() => ({ error: 'Invalid JSON from OpenAI' }));
      return new Response(JSON.stringify({ ok: true, openai: openaiJson }), { status: openaiResp.ok ? 200 : 502, headers: { 'Content-Type': 'application/json' } });
    }

    if (pathname.endsWith('/slack')) {
      const body = await req.json().catch(() => null);
      const text = body?.text;
      if (!text) return new Response(JSON.stringify({ error: 'Missing text in JSON body' }), { status: 400, headers: { 'Content-Type': 'application/json' } });

      const webhook = Deno.env.get('SLACK_WEBHOOK_URL');
      if (!webhook) return new Response(JSON.stringify({ error: 'SLACK_WEBHOOK_URL not set in environment' }), { status: 500, headers: { 'Content-Type': 'application/json' } });

      const slackResp = await fetch(webhook, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ text }),
      });

      const slackText = await slackResp.text();
      return new Response(JSON.stringify({ ok: slackResp.ok, slack_response: slackText }), { status: slackResp.ok ? 200 : 502, headers: { 'Content-Type': 'application/json' } });
    }

    return new Response(JSON.stringify({ error: 'Not found' }), { status: 404, headers: { 'Content-Type': 'application/json' } });
  } catch (err) {
    console.error(err);
    return new Response(JSON.stringify({ error: 'Internal server error', details: String(err) }), { status: 500, headers: { 'Content-Type': 'application/json' } });
  }
});
