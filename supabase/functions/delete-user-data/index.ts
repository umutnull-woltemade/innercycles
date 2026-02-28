import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // Verify the user is authenticated
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return new Response(
        JSON.stringify({ error: "No authorization header" }),
        { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Create Supabase client with user's JWT
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabaseAnonKey = Deno.env.get("SUPABASE_ANON_KEY")!;

    // User client to get the authenticated user
    const userClient = createClient(supabaseUrl, supabaseAnonKey, {
      global: { headers: { Authorization: authHeader } },
    });

    const { data: { user }, error: userError } = await userClient.auth.getUser();

    if (userError || !user) {
      return new Response(
        JSON.stringify({ error: "Unauthorized" }),
        { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const userId = user.id;

    // Admin client for deletion operations
    const adminClient = createClient(supabaseUrl, supabaseServiceKey);

    // Delete from all user data tables (order matters for foreign keys)
    const tables = [
      "note_reminders",
      "sync_metadata",
      "birthday_contacts",
      "cycle_period_logs",
      "life_events",
      "notes_to_self",
      "mood_entries",
      "dream_entries",
      "journal_entries",
      "user_profiles",
    ];

    const deletionResults: Record<string, string> = {};

    for (const table of tables) {
      const { error } = await adminClient
        .from(table)
        .delete()
        .eq("user_id", userId);

      deletionResults[table] = error ? `error: ${error.message}` : "deleted";
    }

    // Delete referral codes if table exists
    try {
      await adminClient
        .from("referral_codes")
        .delete()
        .eq("user_id", userId);
      deletionResults["referral_codes"] = "deleted";
    } catch {
      deletionResults["referral_codes"] = "skipped (table may not exist)";
    }

    // Delete error logs
    try {
      await adminClient
        .from("error_logs")
        .delete()
        .eq("user_id", userId);
      deletionResults["error_logs"] = "deleted";
    } catch {
      deletionResults["error_logs"] = "skipped";
    }

    // Delete the auth user account
    const { error: deleteAuthError } = await adminClient.auth.admin.deleteUser(userId);

    if (deleteAuthError) {
      return new Response(
        JSON.stringify({
          error: "Data deleted but auth account removal failed",
          details: deleteAuthError.message,
          deletionResults,
        }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    return new Response(
      JSON.stringify({
        success: true,
        message: "Account and all associated data permanently deleted",
        deletionResults,
      }),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
