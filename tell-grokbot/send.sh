#!/usr/bin/env bash
# Sends a message (read from stdin) to the Grok bot routine webhook.
# Usage: send.sh <<'EOF' ... EOF
# Exit codes: 0 = sent, 1 = request failed, 2 = configuration missing or incomplete
set -euo pipefail

CONFIG="$HOME/.config/grokbot/webhook.env"

if [ ! -f "$CONFIG" ]; then
  echo "Configuration not found: $CONFIG" >&2
  exit 2
fi

# Read KEY=value lines without sourcing the file (URLs can contain shell characters like &)
read_config() {
  sed -n "s/^$1=//p" "$CONFIG" | tail -n 1 | sed -e 's/^"\(.*\)"$/\1/' -e "s/^'\(.*\)'$/\1/"
}

URL="$(read_config GROKBOT_WEBHOOK_URL)"
KEY="$(read_config GROKBOT_WEBHOOK_KEY)"

if [ -z "$URL" ] || [ -z "$KEY" ]; then
  echo "GROKBOT_WEBHOOK_URL and GROKBOT_WEBHOOK_KEY must be set in $CONFIG" >&2
  exit 2
fi

MESSAGE="$(cat)"
if [ -z "${MESSAGE//[[:space:]]/}" ]; then
  echo "The message is empty" >&2
  exit 1
fi

PAYLOAD="$(jq -n --arg message "$MESSAGE" '{message: $message}')"

RESPONSE="$(mktemp)"
trap 'rm -f "$RESPONSE"' EXIT

if ! STATUS="$(curl -sS --max-time 30 -o "$RESPONSE" -w '%{http_code}' -X POST "$URL" \
  -H "Authorization: Bearer $KEY" \
  -H "Content-Type: application/json" \
  --data-binary "$PAYLOAD")"; then
  echo "Request failed (network error)" >&2
  exit 1
fi

if [[ "$STATUS" == 2* ]]; then
  echo "Sent (HTTP $STATUS)"
else
  echo "Request failed (HTTP $STATUS):" >&2
  cat "$RESPONSE" >&2
  echo >&2
  exit 1
fi
