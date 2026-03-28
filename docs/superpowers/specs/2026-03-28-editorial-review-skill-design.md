# Editorial Review Skill Design

## Purpose

A pre-publish review skill for tirellic.io notes. Invoked as `/editorial-review <note-name>` before running `publish.sh`. Combines mechanical checks (subagents) with a conversational review (correctness, flow, wikilink suggestions) — grounded in the ml-code-companion curriculum.

## Editorial Philosophy

Corrado is a learner, not an academic. The reviewer is a knowledgeable peer with access to his textbooks, not a professor with a red pen.

- **Slightly imperfect notes have value** — they signal thinking, limits, and progress
- **Never rewrite prose** — flag suggestions, never apply them silently
- **Respect the voice** — lowercase-i, em-dash, conversational register are signature, not errors
- **Assess relative to curriculum level** — correctness means "accurate for someone at the Phase 1→2 boundary studying from Cohen, ps4ds, Géron, and T&F", not "would survive a doctoral committee"
- **When something looks wrong:** say *"Cohen defines this differently on p.47 — is your formulation intentional?"* not *"This is incorrect."*

## Invocation

```
/editorial-review <note-name>
```

Example: `/editorial-review sum-and-product-rule-permutations-and-combinations`

The note must exist in `psychic-patterns/ml-code-companion/notes/`. The skill reads the note via the `/obsidian` CLI.

## Phase 1: Classify

### Actions

1. Read the note content via `/obsidian` CLI
2. Read current curriculum position from `ml-code-companion` progress files:
   - `ml-code-companion/.claude/skills/ml-code-companion/references/progress/overview.md`
   - Phase-specific progress files
   - Recent bite assessments
3. Classify the note into one of five types
4. Present classification to Corrado for confirmation

### Note Types

| Type | Description | Size signal | Review emphasis |
|------|-------------|-------------|-----------------|
| **atomic** | One concept, self-contained, exists to be wikilinked | Small is a *virtue* | Precision, completeness of the single concept, wikilinkability |
| **conceptual** | Builds intuition across connected ideas, progressive disclosure | Medium-long | Pedagogical flow, derivation soundness, curriculum grounding |
| **pattern** | Practical technique, "here's how and why to do X" | Medium | Correctness of technique, clarity, reproducibility, edge cases |
| **derivation** | Mathematical proof, worked calculation | Varies | Step validity, notation consistency, completeness |
| **reference** | Catch-up summary, to be decomposed into atomics later | Long (temporary) | Accuracy of syntax/API, coverage — but flag that these are not final form |

### Classification Prompt

The reviewer presents:

> *"This reads as an **atomic** note defining the Frobenius norm. I'll review it on those terms — is the definition precise, is it self-contained, can it be wikilinked cleanly? Sound right?"*

Wait for confirmation. Corrado may correct: *"Actually this one is trying to be more conceptual."*

## Phase 2: Review

Two tracks run after classification is confirmed.

### Subagent Track (mechanical, runs in background)

Deterministic checks dispatched as subagents. No judgment needed. Results reported once at the start of the conversation.

| Check | What it does | Flags |
|-------|-------------|-------|
| **Frontmatter** | Verifies `topic`, `publish`, `created`, `updated`, `tags` present and correctly typed | Missing or malformed properties |
| **LaTeX** | `$$` on own lines, blank lines around blocks, no `\begin{equation}` inside `$$` | Quartz-incompatible patterns |
| **Wikilinks (existing)** | Checks that `[[links]]` in the note resolve to existing notes in the vault | Dead links that would 404 on the site |
| **Formatting** | Consistent heading hierarchy, no orphaned/empty sections | Structural issues |

### Conversational Track (the interesting part)

Review criteria scaled to note type:

| Criterion | atomic | conceptual | pattern | derivation | reference |
|-----------|--------|-----------|---------|------------|-----------|
| **Factual correctness** | Definition checked against curriculum sources | Claims and formulas checked | Technique correctness verified | Mathematical steps verified | API/syntax accuracy |
| **Completeness** | Does it fully capture the one concept? | Does it build the full intuition? | Is the pattern self-contained and reproducible? | Are all steps shown? | Common cases covered? |
| **Pedagogical flow** | N/A (atomic = one idea) | Simple → complex progression | Problem → solution → why | Premises → conclusion | Logical grouping |
| **Curriculum grounding** | Where does this concept appear in the curriculum? | References relevant bites/textbooks | Connects to where it was learned | Level-appropriate rigor | Organized by curriculum topic |

### Conversation Rhythm

1. **Mechanical results** — quick: *"Frontmatter is clean. One LaTeX issue on line 34 — `$$` needs a blank line above it."*
2. **Correctness** — this is where Corrado's perspective matters most. The reviewer presents findings, Corrado may push back with his reasoning.
3. **Flow/completeness** — lighter touch, suggestions not mandates. Scaled to note type.
4. **Wikilink suggestions** — see dedicated section below.
5. **Summary** — ready to publish, or here's what to revisit.

## Wikilink Suggestions

After the content review, the reviewer searches the vault for concepts mentioned in the note that already have their own atomic notes. Uses `/obsidian` CLI search and backlinks.

### Mechanism

1. Extract key concepts/terms from the note
2. Search the vault: `$OBS search query="<concept>" vault="psychic-patterns"`
3. Check backlinks: `$OBS backlinks file="<note>" vault="psychic-patterns"`
4. Present suggestions:

> *"You mention 'Frobenius norm' on line 12 — there's a `[[frobenius-norm-and-trace]]` note for that. Want me to add the wikilink?"*

### Rules

- **Suggest, never auto-link** — wait for Corrado's approval (consistent with `/obsidian` skill's link-weaving protocol)
- **Only suggest links to existing notes** — don't suggest creating new notes (that's a different workflow)
- **Quality over quantity** — suggest the 2-3 most meaningful connections, not every possible match
- **Bidirectional awareness** — if linking A→B, mention that B would gain a backlink from A

## Curriculum Grounding

The reviewer must always consult the curriculum before assessing correctness:

### Sources (in priority order)

1. **Progress files**: `ml-code-companion/.claude/skills/ml-code-companion/references/progress/` — current phase, completed bites, assessment scores, flagged concepts
2. **Textbook indices**: `ml-code-companion/.claude/skills/ml-code-companion/books/` — verify claims against the books Corrado is actually studying from
3. **Notebook content**: `ml-code-companion/notebooks/` — what was actually covered, at what depth
4. **Note corpus**: `psychic-patterns/ml-code-companion/notes/` — what other notes exist, how this one fits in the graph

### Level Calibration

The reviewer anchors to Corrado's demonstrated level:
- **Conceptual average**: 4.4–4.75/5 across Phases 0–1
- **Independence**: 4.9/5 — he solves things himself, pushes back with evidence
- **Current position**: End of Phase 1, transitioning to Phase 2
- **Active detours**: ps4ds Ch. 2–3 (probability foundations)

This means: don't flag a note for lacking Phase 4 concepts (MLE without closed form) — he hasn't gotten there yet. Do flag if a Phase 1 concept is misrepresented.

## Skill Dependencies

| Skill/Tool | Used for |
|------------|----------|
| `/obsidian` | Read note content, search vault, check backlinks, verify wikilinks |
| `ml-code-companion` progress files | Curriculum level, phase, assessment context |
| `ml-code-companion` textbook indices | Factual correctness cross-reference |
| Subagents | Mechanical checks (formatting, LaTeX, frontmatter, wikilink resolution) |

## Output

The skill produces no artifact — it's a conversation. The outcome is one of:

- **Ready to publish** — no issues, or issues discussed and resolved
- **Revisit suggested** — Corrado decides what (if anything) to change, on his own terms

After the review, Corrado runs `publish.sh` if satisfied. The skill never publishes on its own.

## Future Considerations (not in scope)

- Batch review of multiple notes
- Review history tracking (which notes have been reviewed, when)
- Automatic quality metrics over time
- Integration with a note-taking companion skill (writing-time feedback)
