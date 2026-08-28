# Agent skills

## Unslop

Two agent skills that **detect and remove AI-sounding writing patterns** ("slop") from text, then rewrite it with a genuine human voice. Inspired by [Cursor's unslop skill](https://github.com/cursor/plugins/blob/main/pstack/skills/unslop/SKILL.md).

- [`unslop`](./unslop/SKILL.md) — for English text
- [`unslop-fr`](./unslop-fr/SKILL.md) — for French text

```bash
npx skills add -g mnapoli/skills/unslop
npx skills add -g mnapoli/skills/unslop-fr
```

Usage:

```
/unslop <file or text>
/unslop-fr <file or text>
```

### Example

Before:

> The reviewer's comment is not only right — it points at something deeper. The `retry` flag isn't just a configuration option; it's load-bearing: the scheduler, the plugin API, and the CI integration all rely on it to decide whether a failed task should propagate. Removing it would mean threading an explicit policy through three call sites, and that's the whole cost — no schema change, no migration. That said, keeping it as-is is also defensible: the current behavior is battle-tested, and the ambiguity only surfaces in edge cases. Ultimately, the right move depends on how much you value explicitness over backward compatibility.

After:

> The reviewer is right. The `retry` flag is not a plain configuration option: the scheduler, the plugin API, and the CI integration all read it to decide whether a failed task propagates. Removing it means changing those three call sites, with no schema change and no migration. The current behavior works and the ambiguity only shows up in edge cases, so I recommend keeping the flag and documenting the propagation rule.

## Address PR review

An agent skill that **reads pull request comments and CI failures and fixes them automatically**.

```bash
# install via https://skills.sh in the project
npx skills add mnapoli/skills/address-pr-review
# or install globally with `-g`
npx skills add -g mnapoli/skills/address-pr-review
```

Usage:

```
/address-pr-review
```

Your agent will:

- Fix CI failures
- Read inline PR comments (ignores resolved comments)
- Make code changes, push and reply to each thread

```mermaid
flowchart LR
    A[Open PR] --> B[GitHub code review]
    B --> C[`/address-pr-review`]
    C --> B
    B --> D[Merge PR]
```

![](./art/address-pr-review.png)

### Prerequisites

- [GitHub CLI](https://cli.github.com/) (`gh`) installed and authenticated
- [`jq`](https://jqlang.org/) (used by the CI check script)

### Tips

1. Run Claude Code's [code review in GitHub Actions](https://code.claude.com/docs/en/github-actions) for automatic reviews on every push
2. Run [Codex code review](https://developers.openai.com/codex/integrations/github/) as well
3. Review Claude and Codex's comments and "mark as resolved" those that don't make sense
4. Review the code yourself: open comments inline the PR diff
5. Launch `/address-pr-review` locally so that all comments are addressed
6. Repeat until the PR is ready to merge
