#!/usr/bin/env bash
# Fetches all unresolved inline review threads for the PR on the current branch.
# Outputs JSON array of threads with: id, path, line, startLine, isOutdated, and comments.
set -euo pipefail

OWNER=$(gh repo view --json owner -q .owner.login)
REPO=$(gh repo view --json name -q .name)
PR=$(gh pr view --json number -q .number)

QUERY='query($owner: String!, $repo: String!, $pr: Int!) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $pr) {
      reviewThreads(first: 100) {
        nodes {
          id
          isResolved
          isOutdated
          path
          line
          startLine
          comments(first: 100) {
            nodes {
              author { login }
              body
              url
            }
          }
        }
      }
    }
  }
}'

gh api graphql -f query="$QUERY" -f owner="$OWNER" -f repo="$REPO" -F pr="$PR" \
  --jq '[.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false)]'
