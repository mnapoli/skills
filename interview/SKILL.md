---
name: interview
description: Conduct a detailed interview about a specific feature or topic to gather information and create a specification.
argument-hint: <feature or topic>
disable-model-invocation: true
---

# Interview

**Topic**:

$ARGUMENTS

If no topic is given, ask the user for one.

## Phase 1: Context gathering

Before asking questions, explore relevant parts of the codebase to understand:
- Related existing features, models, and patterns
- Relevant domain concepts from the project's docs (e.g. `docs/`)

## Phase 2: Interview

Ask the user questions (with the `AskUserQuestion` tool in Claude Code) to conduct a free-form interview that starts as brainstorming and progressively converges toward an implementation plan.

**Approach:**
- Start from first principles—don't assume you understand the goal
- Challenge assumptions and probe for hidden complexity
- Ask about conflicts with existing features
- Explicitly clarify scope: what's in, what's explicitly out for later
- Explore edge cases, error states, permissions

**Cover these areas** (not necessarily in order):
- Core problem / why this feature
- Users and their goals
- Happy path and variations
- Edge cases and error handling
- Integration with existing features
- Data model implications
- Migration and backward compatibility (existing data, APIs, configuration)
- UI/UX flow and states
- Constraints and non-negotiables

Continue asking questions until you have absolutely everything needed to write a complete implementation plan. When you settle a minor point yourself, say so explicitly (e.g. "I'm going with X because Y") so the user can correct it. Never decide silently.

## Phase 3: Plan

Write the plan in your reply, including:

- **Summary**: One paragraph: what, why, and links to related issues or documentation
- **Scope**: What's included / explicitly excluded
- **Product requirements**: UI/UX and expected behavior
- **Technical plan**: Architecture, data model, implementation details

Then stop and wait for the user's go-ahead before implementing.

Ask the questions and write the plan in the same language as the user's input (e.g., if the user asked in French, use French).
