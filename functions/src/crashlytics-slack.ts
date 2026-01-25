import { onNewFatalIssuePublished, onNewNonfatalIssuePublished } from "firebase-functions/v2/alerts/crashlytics";
import { defineString } from "firebase-functions/params";

const SLACK_WEBHOOK_URL = defineString("SLACK_CRASHLYTICS_WEBHOOK");

interface SlackBlock {
  type: string;
  text?: { type: string; text: string; emoji?: boolean };
  elements?: Array<{ type: string; text?: { type: string; text: string }; url?: string }>;
  fields?: Array<{ type: string; text: string }>;
}

async function postToSlack(
  issueTitle: string,
  appVersion: string,
  platform: string,
  issueId: string,
  isFatal: boolean,
) {
  const url = SLACK_WEBHOOK_URL.value();
  if (!url) {
    console.error("SLACK_CRASHLYTICS_WEBHOOK not set");
    return;
  }

  const severity = isFatal ? "🔴 FATAL CRASH" : "🟡 Non-Fatal Issue";
  const consoleUrl = `https://console.firebase.google.com/project/celestial-95a95/crashlytics`;

  const blocks: SlackBlock[] = [
    {
      type: "header",
      text: { type: "plain_text", text: `${severity} — Astrobobo`, emoji: true },
    },
    {
      type: "section",
      fields: [
        { type: "mrkdwn", text: `*Issue:*\n${issueTitle}` },
        { type: "mrkdwn", text: `*Platform:*\n${platform}` },
        { type: "mrkdwn", text: `*App Version:*\n${appVersion}` },
        { type: "mrkdwn", text: `*Issue ID:*\n${issueId}` },
      ],
    },
    {
      type: "actions",
      elements: [
        {
          type: "button",
          text: { type: "plain_text", text: "View in Crashlytics Console" },
          url: consoleUrl,
        },
      ],
    },
  ];

  await fetch(url, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ blocks }),
  });
}

export const crashlyticsFatalAlert = onNewFatalIssuePublished(async (event) => {
  const { issue } = event.data.payload;
  await postToSlack(
    issue.title,
    issue.appVersion,
    event.appId ?? "unknown",
    issue.id,
    true,
  );
});

export const crashlyticsNonfatalAlert = onNewNonfatalIssuePublished(async (event) => {
  const { issue } = event.data.payload;
  await postToSlack(
    issue.title,
    issue.appVersion,
    event.appId ?? "unknown",
    issue.id,
    false,
  );
});
