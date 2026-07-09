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
  # Extract the log, strip the job/step/timestamp prefix, then print from the
  # failure separator (────) through the summary line (Tests:/Duration:/errors found)
  gh run view --job "$JOB_ID" --log 2>&1 \
    | awk -F'\t' '/────|FAILED|ERROR|errors found/{found=1} found{print $3} /Tests:|Duration:|errors found/{if(found) exit}' \
    | sed -E 's/^[0-9T:.Z+-]+ //' \
    || echo "(could not extract relevant output)"
  echo ""
done

exit 1
