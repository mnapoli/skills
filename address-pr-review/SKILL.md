---
name: address-pr-review
description: Look at the pull request review comments and address any issues raised.
disable-model-invocation: true
context: fork
allowed-tools: Bash(bash ~/.claude/skills/address-pr-review/*)
---

## Step 1: Fetch unresolved review threads and CI status

Run both helper scripts:

```bash
bash ./get-unresolved-threads.sh
```

```bash
bash ./get-failing-ci.sh
```

The first returns a JSON array of unresolved threads. Each thread has:
- `id` — thread ID (needed to reply)
- `path` — file path
- `line` / `startLine` — line numbers in the diff
- `isOutdated` — whether the diff has changed since the comment
- `comments.nodes[]` — the comment thread (first = original comment, rest = replies), each with `author.login`, `body`, and `url`

The second checks CI status and outputs failure details if any jobs failed (exit code 1 = failures, 0 = all passed).

If there are no unresolved threads and CI is green, stop here.

## Step 2: Address each issue

If there are many items, create one task per item to keep things organized.

For each unresolved review thread:

1. Read the comment thread to understand the issue
2. Determine if a code change is needed, or if no change is needed (e.g. the comment is invalid or the suggestion is not appropriate)
3. If a change is needed, make the necessary code changes

For each CI failure:

1. Read the failure output to understand what broke
2. Fix the code or tests to make CI pass

## Step 3: Commit and push changes

After addressing all review comments and CI failures, commit your changes and push.

## Step 4: Reply to each review thread

After addressing each comment, reply using the helper script:

```bash
bash ./reply-to-thread.sh "<thread_id>" "<body>" [--resolve]
```

- If the code was fixed as mentioned in the thread, reply with simply: "Fixed as suggested." and pass `--resolve` to mark the thread as resolved.
- If no change was applied, briefly explain why and keep the thread unresolved (omit `--resolve`) so the reviewer can reply if they disagree.
- Don't be unnecessarily verbose.
