#!/usr/bin/env bash
# Checks CI status for the PR on the current branch.
# If all checks pass, prints "All checks passed." and exits 0.
# If checks fail, prints the failure details and exits 1.
set -euo pipefail

PR=$(gh pr view --json number -q .number)

# Get failing checks (exclude skipping)
FAILING=$(gh pr checks "$PR" --json name,state,link --jq '[.[] | select(.state == "FAILURE")]')

if [ "$FAILING" = "[]" ]; then
  echo "All checks passed."
  exit 0
fi

echo "Failing checks:"
echo "$FAILING" | jq -r '.[] | "  - \(.name): \(.link)"'
echo ""

echo "$FAILING" | jq -r '.[].link' | while read -r LINK; do
  JOB_ID=$(echo "$LINK" | grep -oE '[0-9]+$')
  JOB_NAME=$(echo "$FAILING" | jq -r ".[] | select(.link == \"$LINK\") | .name")

  echo "=== $JOB_NAME ==="
  # Logs of the failed steps, without the job/step/timestamp prefix and the colors
  LOG=$(gh run view --job "$JOB_ID" --log-failed 2>/dev/null \
    | cut -f3- \
    | sed -E -e $'s/^\xef\xbb\xbf//' -e 's/^[0-9T:.Z+-]+ //' -e $'s/\x1b\\[[0-9;]*[A-Za-z]//g') || LOG=""
  if [ -z "$LOG" ]; then
    echo "(could not fetch the logs: $LINK)"
    echo ""
    continue
  fi
  # Stop at the last error reported by the runner (##[error]): the job's cleanup steps come after it
  LAST_ERROR=$(grep -n '^##\[error\]' <<< "$LOG" | tail -n 1 | cut -d: -f1 || true)
  if [ -n "$LAST_ERROR" ]; then
    LOG=$(head -n "$LAST_ERROR" <<< "$LOG")
  fi
  # Whatever the tool (tests, linter, compiler), the failures and the summary are at the end
  LINES=$(wc -l <<< "$LOG" | tr -d ' ')
  if [ "$LINES" -gt 150 ]; then
    echo "(last 150 of $LINES lines, full log: gh run view --job $JOB_ID --log-failed)"
  fi
  tail -n 150 <<< "$LOG"
  echo ""
done

exit 1
