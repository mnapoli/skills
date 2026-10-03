---
name: tell-grokbot
description: Send a message to the user's Grok bot primary agent through a routine webhook, e.g. to delegate a task or pass on information for later. Use only when the user explicitly asks to tell, notify, or send something to Grok bot.
argument-hint: <message>
allowed-tools: Bash(bash ~/.claude/skills/tell-grokbot/*), Bash(bash .claude/skills/tell-grokbot/*)
---

**Request**:

$ARGUMENTS

Send a message to the user's primary Grok bot agent. Only do this when the user explicitly asked for it.

## Step 1: Write the message

Grok bot has no access to this conversation or to the repository, so the message must be self-contained:

- the project or product it is about
- what happened, or what Grok bot should do
- useful links (pull request, issue, documentation, feature URL)

Write it in the user's language. If the user dictated the content, keep their words. Don't ask the user to review the message: send it directly.

## Step 2: Send it

Run the helper script located in this skill's directory (the directory containing this SKILL.md), with the message on stdin:

```bash
bash <skill-directory>/send.sh <<'EOF'
<message>
EOF
```

- Exit code 0: Grok bot received the message.
- Exit code 2: the configuration is missing or incomplete. Follow the setup below, then send again.
- Exit code 1: the request failed. Do not retry, as the message could arrive twice.

If a sandbox blocks network access, ask the user for permission to run the script outside the sandbox.

## Step 3: Report

Show the user the message you sent and the result. If the request failed, include the error printed by the script.

## Setup

The webhook URL and Bearer key are stored in `~/.config/grokbot/webhook.env`.

Ask the user for them. In Grok bot, they are in the routine's panel: open the agent's name at the top of the chat → Tasks → the routine → Webhook section. If the user has no routine yet, tell them to create one with a webhook trigger.

Then create the file, readable only by the user:

```bash
mkdir -p ~/.config/grokbot
touch ~/.config/grokbot/webhook.env
chmod 600 ~/.config/grokbot/webhook.env
cat > ~/.config/grokbot/webhook.env <<'EOF'
GROKBOT_WEBHOOK_URL=<url>
GROKBOT_WEBHOOK_KEY=<key>
EOF
```
