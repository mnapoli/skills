---
name: implement
description: Implement a Linear issue
argument-hint: <Linear issue ID or URL>
disable-model-invocation: true
---

**Linear issue** (e.g. `ENG-123`, or a `linear.app/...` issue URL):

$ARGUMENTS

If no issue is given, ask the user for one.

Whenever this skill says to ask the user, ask one question at a time (with the `AskUserQuestion` tool in Claude Code).

1. Fetch the Linear issue using the Linear MCP, including its comments, parent issue, sub-issues, attachments, and linked documents or designs.
2. Fetch related issues and the Linear project (description, documents, milestones) if applicable.
3. Move the issue to the team's started status (usually "In Progress").
4. Create a new branch from the up-to-date default branch. Name it after the branch name Linear suggests for the issue (`gitBranchName`), or else the lowercase issue identifier (e.g. `eng-123`). If the working tree has uncommitted changes, ask the user what to do first.
5. Explore the code related to the issue, so that you don't ask questions the code already answers.
6. Clarify the specs:
    - Make no assumptions: keep asking the user about anything the Linear issue or the code doesn't answer, until you have no questions left.
    - If the issue has sub-issues, ask which ones are in scope.
    - Once the specs are clear, update the Linear issue description with the detailed specs and move on to the next step.
7. Design the high-level architecture. The goal of this step is to catch a design going down the wrong path early.
    - If the issue came with an implementation plan, even partial (in its original description or in a comment), start from it instead of designing from scratch: only go through what it leaves open or unclear, and what the clarified specs changed.
    - For small changes, state the approach in one sentence and move on.
    - Otherwise, go through the design with the user one decision at a time, instead of presenting the whole design at once. The user must approve any significant change to the existing architecture before you write code.
8. Implement the issue. Make sure to write tests. When relevant, test in a sandbox or staging environment. If you are stuck, ask the user for help or clarification.
    - If the issue is large in scope, you can break it down and delegate to sub-agents or use a workflow.
9. Open a pull request. In the description, reference the issue with `Fixes ENG-123` so that Linear closes it on merge, or `Part of ENG-123` if the PR only covers part of the issue.
10. Monitor the PR for build failures or review comments.
11. When you are done, give the user the PR link and flag anything that may need their action: decisions you made on your own, deviations from the specs, what you could not test, and the Linear issues you created. Keep it short and leave out anything that needs no action.

All along this process, if you find issues in the product that are not related to your work (or tooling that could help you), record them in new Linear issues. Search for duplicates first, create them in the same team, and link them to the current issue as related.
