"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.crashlyticsNonfatalAlert = exports.crashlyticsFatalAlert = void 0;
const crashlytics_1 = require("firebase-functions/v2/alerts/crashlytics");
const params_1 = require("firebase-functions/params");
const SLACK_WEBHOOK_URL = (0, params_1.defineString)("SLACK_CRASHLYTICS_WEBHOOK");
async function postToSlack(issueTitle, appVersion, platform, issueId, isFatal) {
    const url = SLACK_WEBHOOK_URL.value();
    if (!url) {
        console.error("SLACK_CRASHLYTICS_WEBHOOK not set");
        return;
    }
    const severity = isFatal ? "🔴 FATAL CRASH" : "🟡 Non-Fatal Issue";
    const consoleUrl = `https://console.firebase.google.com/project/celestial-95a95/crashlytics`;
    const blocks = [
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
exports.crashlyticsFatalAlert = (0, crashlytics_1.onNewFatalIssuePublished)(async (event) => {
    const { issue } = event.data.payload;
    await postToSlack(issue.title, issue.appVersion, event.appId ?? "unknown", issue.id, true);
});
exports.crashlyticsNonfatalAlert = (0, crashlytics_1.onNewNonfatalIssuePublished)(async (event) => {
    const { issue } = event.data.payload;
    await postToSlack(issue.title, issue.appVersion, event.appId ?? "unknown", issue.id, false);
});
//# sourceMappingURL=crashlytics-slack.js.map