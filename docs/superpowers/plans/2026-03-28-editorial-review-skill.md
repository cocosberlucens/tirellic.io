# Editorial Review Skill — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create a `/editorial-review` Claude Code skill that reviews notes before publishing to tirellic.io — combining mechanical checks (subagents) with a curriculum-grounded conversational review.

**Architecture:** A personal Claude Code skill (`~/.claude/skills/editorial-review/SKILL.md`) with reference files for review criteria. The skill prompt orchestrates Phase 1 (classify) and Phase 2 (mechanical subagents + conversational review). No code beyond the skill prompt and references.

**Tech Stack:** Claude Code skill system (SKILL.md), `/obsidian` CLI, `ml-code-companion` curriculum files

**Spec:** `docs/superpowers/specs/2026-03-28-editorial-review-skill-design.md`

---

## File Map

| Action | Path | Responsibility |
|--------|------|----------------|
| Create | `~/.claude/skills/editorial-review/SKILL.md` | Main skill prompt — Phase 1 + Phase 2 orchestration |
| Create | `~/.claude/skills/editorial-review/references/note-types.md` | Note type definitions and review criteria per type |
| Create | `~/.claude/skills/editorial-review/references/mechanical-checks.md` | Subagent prompt templates for formatting, LaTeX, frontmatter, wikilinks |
| Create | `~/.claude/skills/editorial-review/references/editorial-philosophy.md` | The editorial stance, voice rules, curriculum grounding approach |
| Modify | `~/miei-repo/tirellic.io/CLAUDE.md` | Reference the new skill |

---

### Task 1: Create the editorial philosophy reference

**Files:**
- Create: `~/.claude/skills/editorial-review/references/editorial-philosophy.md`

This file is loaded by the skill to set the reviewer's stance. It's separated from SKILL.md so it can be updated independently as Corrado's curriculum progresses.

- [ ] **Step 1: Create directory structure**

```bash
mkdir -p ~/.claude/skills/editorial-review/references
```

- [ ] **Step 2: Write the editorial philosophy reference**

Create `~/.claude/skills/editorial-review/references/editorial-philosophy.md`:

```markdown
# Editorial Philosophy

## The Reviewer's Stance

You are a knowledgeable peer with access to Corrado's textbooks, not a professor with a red pen.

## Core Principles

- **Slightly imperfect notes have value** — they signal thinking, limits, and progress
- **Never rewrite prose** — flag suggestions, never apply them silently
- **Respect the voice** — lowercase-i, em-dash, conversational register are signature, not errors
- **Assess relative to curriculum level** — correctness means "accurate for someone studying from Cohen, ps4ds, Géron, and T&F at the current phase", not "would survive a doctoral committee"

## How to Challenge

When something looks wrong, frame it as a question grounded in a source:

- DO: *"Cohen defines this differently on p.47 — is your formulation intentional?"*
- DO: *"The Product Rule derivation skips a step between lines 3 and 4 — was that deliberate for brevity?"*
- DON'T: *"This is incorrect."*
- DON'T: *"You should rewrite this section as..."*

## When Corrado Pushes Back

He may have a valid perspective that differs from the textbook. His independence score is 4.9/5 — he solves things himself and pushes back with evidence. If he explains his reasoning and it's coherent (even if unconventional), accept it. The notes are his.

## Curriculum Context Sources (in priority order)

1. **Git history** (most current): `git -C ~/miei-repo/ml-code-companion log --oneline -20` — reveals active work even before progress files update. Cross-reference the note's `created` date with recent commits.
2. **Progress files**: `~/miei-repo/ml-code-companion/.claude/skills/ml-code-companion/references/progress/` — phase, bites, assessments. May lag behind active work.
3. **Textbook indices**: `~/miei-repo/ml-code-companion/.claude/skills/ml-code-companion/books/` — verify claims against curriculum books.
4. **Textbook chapters (via NotebookLM)**: When indices aren't enough, ask Corrado to query NotebookLM for a chapter summary. Optional — use when needed.
5. **Notebook content**: `~/miei-repo/ml-code-companion/notebooks/` — what was covered, at what depth.
6. **Note corpus**: `~/miei-repo/psychic-patterns/ml-code-companion/notes/` — existing notes, graph context.
```

- [ ] **Step 3: Commit**

```bash
git -C ~/miei-repo/tirellic.io add -A
git -C ~/miei-repo/tirellic.io commit -m "standard.feat(editorial-review): add editorial philosophy reference

Memory: Editorial philosophy reference defines reviewer stance and curriculum sources
Tags: skill, editorial-review"
```

---

### Task 2: Create the note types reference

**Files:**
- Create: `~/.claude/skills/editorial-review/references/note-types.md`

- [ ] **Step 1: Write the note types reference**

Create `~/.claude/skills/editorial-review/references/note-types.md`:

```markdown
# Note Types and Review Criteria

## Classification

Read the note and classify it into one of these types before reviewing.

### atomic
**What it is:** One concept, self-contained, exists to be wikilinked into other notes.
**Size signal:** Small is a *virtue* — a 46-line note that perfectly answers "what is the Frobenius norm?" is excellent.
**Examples:** frobenius-norm-and-trace, np.searchsorted

**Review criteria:**
- **Correctness:** Is the definition/formula accurate? Check against curriculum sources.
- **Completeness:** Does it fully capture the one concept? Nothing more, nothing less.
- **Self-containment:** Can a reader understand this without reading another note?
- **Wikilinkability:** Is the title/topic descriptive enough to be linked meaningfully?
- **Pedagogical flow:** N/A — atomic = one idea.

### conceptual
**What it is:** Builds intuition across connected ideas with progressive disclosure.
**Size signal:** Medium to long.
**Examples:** conditional-probability-and-bayes-rule, dot-product-and-law-of-cosines

**Review criteria:**
- **Correctness:** Are definitions, claims, and formulas accurate?
- **Completeness:** Does it build the full intuition it sets out to build?
- **Pedagogical flow:** Does it progress from simple → complex? Does it build on itself?
- **Curriculum grounding:** Does it reference or connect to relevant bites/textbooks?
- **Examples:** Are examples worked through, not just stated?

### pattern
**What it is:** Practical technique — "here's how and why to do X."
**Size signal:** Medium.
**Examples:** PMF dictionary comparison (future), searchsorted ECDF pattern

**Review criteria:**
- **Correctness:** Does the technique actually work? Are there edge cases?
- **Completeness:** Is the pattern self-contained and reproducible?
- **Pedagogical flow:** Problem → solution → why it works.
- **Curriculum grounding:** Where was this learned? What bite/detour produced it?

### derivation
**What it is:** Mathematical proof or worked-through calculation.
**Size signal:** Varies.
**Examples:** orthogonal-decomposition

**Review criteria:**
- **Correctness:** Are all mathematical steps valid?
- **Completeness:** Are all steps shown? No gaps in the chain of reasoning?
- **Notation:** Consistent throughout? Matches curriculum conventions?
- **Pedagogical flow:** Premises → conclusion.

### reference
**What it is:** Catch-up summary, to be decomposed into atomics later. These are NOT the final form.
**Size signal:** Long.
**Examples:** numpy.md, pandas.md, matplotlib.md, scipy-stats.md

**Review criteria:**
- **Accuracy:** Are syntax/API descriptions correct?
- **Coverage:** Are the common cases covered?
- **Decomposition readiness:** Flag that this note is a candidate for atomic decomposition.
- **Light touch:** These are temporary — don't invest heavily in flow critique.

## Classification Prompt Template

Present to Corrado:

> *"This reads as a **[type]** note about [brief description]. I'll review it on those terms — [1-sentence review focus]. Sound right?"*

Wait for confirmation before proceeding. Corrado may correct the classification.
```

- [ ] **Step 2: Commit**

```bash
git -C ~/miei-repo/tirellic.io add -A
git -C ~/miei-repo/tirellic.io commit -m "standard.feat(editorial-review): add note types and review criteria reference

Five types: atomic, conceptual, pattern, derivation, reference.
Each with specific review criteria scaled to purpose.

Memory: Note types reference defines how to assess different kinds of notes
Tags: skill, editorial-review"
```

---

### Task 3: Create the mechanical checks reference

**Files:**
- Create: `~/.claude/skills/editorial-review/references/mechanical-checks.md`

- [ ] **Step 1: Write the mechanical checks reference**

Create `~/.claude/skills/editorial-review/references/mechanical-checks.md`:

```markdown
# Mechanical Checks — Subagent Prompts

These checks run as background subagents during Phase 2. They are deterministic — no editorial judgment needed. Report results once at the start of the conversational review.

## Frontmatter Check

Verify the note has all required properties with correct types:

| Property | Required | Expected type | Notes |
|----------|----------|---------------|-------|
| `topic` | Yes | text | Becomes `title:` via publish.sh rewrite |
| `publish` | Yes | checkbox (boolean) | Must be `true` for publishing |
| `created` | Yes | date | YYYY-MM-DD format |
| `updated` | Yes | date | YYYY-MM-DD format |
| `tags` | Yes | list | At least one tag |

**How to check:**
```bash
OBS="/Applications/Obsidian.app/Contents/MacOS/Obsidian"
$OBS properties file="<note-name>" vault="psychic-patterns"
```

Or read the file directly and parse YAML frontmatter between `---` delimiters.

## LaTeX Compatibility Check

Quartz KaTeX is stricter than Obsidian. Check for:

1. **Display math delimiters:** `$$` must be on their own lines
   - FAIL: `text $$formula$$ text` (inline display math)
   - PASS: blank line, `$$` on own line, formula, `$$` on own line, blank line

2. **Blank lines around blocks:** Must have blank lines above and below `$$` blocks
   - FAIL: `text\n$$\nformula\n$$\ntext`
   - PASS: `text\n\n$$\nformula\n$$\n\ntext`

3. **No `\begin{equation}` inside `$$`:** Redundant and breaks KaTeX
   - FAIL: `$$\begin{equation}...\end{equation}$$`
   - PASS: `$$...\tag{N}$$`

**How to check:** Read the file content and scan with regex patterns.

## Wikilink Resolution Check

Verify all `[[wikilinks]]` in the note resolve to existing notes in the vault.

**How to check:**
```bash
OBS="/Applications/Obsidian.app/Contents/MacOS/Obsidian"
$OBS unresolved vault="psychic-patterns" verbose
```

Or extract `[[link-name]]` patterns from the note and check each against the vault.

## Formatting Check

- Heading hierarchy: no jumps (e.g., `##` followed by `####` without `###`)
- No empty sections (heading followed immediately by another heading)
- Consistent heading style (all lowercase or all title case — follow existing note conventions)
```

- [ ] **Step 2: Commit**

```bash
git -C ~/miei-repo/tirellic.io add -A
git -C ~/miei-repo/tirellic.io commit -m "standard.feat(editorial-review): add mechanical checks subagent reference

Frontmatter, LaTeX, wikilink, and formatting checks with exact commands.

Memory: Mechanical checks are deterministic, run as subagents in background
Tags: skill, editorial-review"
```

---

### Task 4: Create the main SKILL.md

**Files:**
- Create: `~/.claude/skills/editorial-review/SKILL.md`

This is the core deliverable — the skill prompt that orchestrates everything.

- [ ] **Step 1: Write SKILL.md**

Create `~/.claude/skills/editorial-review/SKILL.md`:

```markdown
---
name: editorial-review
description: Pre-publish review for tirellic.io notes. Use this skill whenever Corrado wants to review a note before publishing, check note quality, verify LaTeX formatting for Quartz, get wikilink suggestions, or validate content correctness against the ml-code-companion curriculum. Invoke as /editorial-review <note-name>. Also use when Corrado mentions "review before publishing", "is this ready to publish", "check this note", or "editorial review".
---

# Editorial Review

Pre-publish review for tirellic.io notes. Combines mechanical checks with a curriculum-grounded conversational review.

> **References:**
> - Editorial philosophy: `~/.claude/skills/editorial-review/references/editorial-philosophy.md`
> - Note types & criteria: `~/.claude/skills/editorial-review/references/note-types.md`
> - Mechanical checks: `~/.claude/skills/editorial-review/references/mechanical-checks.md`

## Invocation

```
/editorial-review <note-name>
```

The note must exist in `psychic-patterns/ml-code-companion/notes/`.

## Before You Begin

Read the editorial philosophy reference. Internalize the stance: you are a knowledgeable peer, not a professor. Corrado's voice and intellectual ownership are non-negotiable.

---

## Phase 1: Classify

### Step 1: Read the note

```bash
OBS="/Applications/Obsidian.app/Contents/MacOS/Obsidian"
$OBS read file="<note-name>" vault="psychic-patterns"
```

### Step 2: Read curriculum context

Gather the learning context for this note:

```bash
# What is Corrado currently working on?
git -C ~/miei-repo/ml-code-companion log --oneline -20

# Current curriculum position
cat ~/miei-repo/ml-code-companion/.claude/skills/ml-code-companion/references/progress/overview.md
```

Cross-reference the note's `created` date with git history to understand what bite/detour produced it.

### Step 3: Classify the note

Read the note types reference (`references/note-types.md`). Classify as: **atomic**, **conceptual**, **pattern**, **derivation**, or **reference**.

### Step 4: Present classification

Tell Corrado:

> *"This reads as a **[type]** note about [brief description]. I'll review it on those terms — [1-sentence review focus]. Sound right?"*

**STOP and wait for confirmation.** Corrado may correct the classification. Do not proceed to Phase 2 until he confirms.

---

## Phase 2: Review

After classification is confirmed, run both tracks.

### Track A: Mechanical checks (background subagents)

Dispatch subagents for the four mechanical checks defined in `references/mechanical-checks.md`:

1. **Frontmatter** — required properties present and correctly typed
2. **LaTeX** — Quartz-compatible display math formatting
3. **Wikilinks** — all `[[links]]` resolve in the vault
4. **Formatting** — heading hierarchy, no empty sections

Run these in parallel via the Agent tool. Collect results.

### Track B: Conversational review

While subagents run, begin the content review. Follow this rhythm:

**1. Present mechanical results**

Quick summary when subagent results arrive:
> *"Frontmatter is clean. One LaTeX issue on line 34 — `$$` needs a blank line above it. Wikilinks all resolve. No formatting issues."*

**2. Correctness review**

This is the core. Consult curriculum sources (see editorial philosophy reference for priority order). For each finding:

- Ground it in a specific source: *"Cohen p.47 defines..."*, *"In Bite 3 this was covered as..."*
- Frame as a question, not a verdict: *"Is your formulation intentional?"*
- If Corrado pushes back with reasoning, accept it if coherent

Scale to note type (see note types reference for criteria per type).

**3. Flow and completeness review**

Lighter touch. Scaled to note type:
- **atomic**: Is it self-contained? Can it stand alone when wikilinked?
- **conceptual**: Does it build from simple → complex?
- **pattern**: Problem → solution → why it works?
- **derivation**: Are all steps shown?
- **reference**: Light touch — these are temporary.

**4. Wikilink suggestions**

Search the vault for concepts mentioned in the note that have their own atomic notes:

```bash
OBS="/Applications/Obsidian.app/Contents/MacOS/Obsidian"
$OBS search query="<concept>" vault="psychic-patterns"
$OBS backlinks file="<note-name>" vault="psychic-patterns"
```

Present the 2-3 most meaningful connections:
> *"You mention 'Frobenius norm' on line 12 — there's a `[[frobenius-norm-and-trace]]` note for that. Want me to add the wikilink?"*

Rules:
- Suggest, never auto-link — wait for approval
- Only suggest links to existing notes
- Quality over quantity — 2-3 best matches
- Mention bidirectional benefit: "B would gain a backlink from A"

**5. Summary**

Close with one of:
- **Ready to publish** — no issues, or all issues discussed and resolved
- **Revisit suggested** — list what to consider changing, but Corrado decides

The skill never publishes on its own. After the review, Corrado runs `./scripts/publish.sh` if satisfied.
```

- [ ] **Step 2: Verify the skill is discoverable**

```bash
ls ~/.claude/skills/editorial-review/SKILL.md
```

Expected: file exists. Claude Code should discover it as `/editorial-review`.

- [ ] **Step 3: Commit**

```bash
git -C ~/miei-repo/tirellic.io add -A
git -C ~/miei-repo/tirellic.io commit -m "standard.feat(editorial-review): add main SKILL.md — skill is live

Two-phase review: classify note type, then mechanical subagents + conversational
review with wikilink suggestions. Grounded in ml-code-companion curriculum.

Memory: /editorial-review skill is now available
Tags: skill, editorial-review"
```

---

### Task 5: Test with a real note

**Files:**
- No new files — this is a verification step

- [ ] **Step 1: Invoke the skill on a published note**

Run `/editorial-review conditional-probability-and-bayes-rule` — this is the highest-quality note, so the review should find minimal issues and demonstrate the positive flow.

- [ ] **Step 2: Verify Phase 1 works**

Check that the skill:
- Reads the note via obsidian CLI
- Checks git history and progress files
- Classifies the note (should be **conceptual**)
- Presents classification and waits for confirmation

- [ ] **Step 3: Verify Phase 2 works**

Check that:
- Mechanical subagents run (frontmatter, LaTeX, wikilinks, formatting)
- Conversational review covers correctness, flow, wikilinks
- Wikilink suggestions are offered for concepts that have atomic notes
- Summary is presented

- [ ] **Step 4: Invoke on an atomic note**

Run `/editorial-review frobenius-norm-and-trace` — verify the review scales down appropriately for an atomic note (no flow critique, focus on precision).

- [ ] **Step 5: Commit any adjustments**

If testing reveals issues with the skill prompts, fix and commit:

```bash
git -C ~/miei-repo/tirellic.io add -A
git -C ~/miei-repo/tirellic.io commit -m "knowledge.verify(editorial-review): tested on real notes, adjustments applied

Tags: skill, editorial-review, verification"
```

---

### Task 6: Update CLAUDE.md and documentation

**Files:**
- Modify: `~/miei-repo/tirellic.io/CLAUDE.md`

- [ ] **Step 1: Add editorial review to CLAUDE.md**

Add to the Content Management section in CLAUDE.md:

```markdown
## Editorial Review

Before publishing, review notes with `/editorial-review <note-name>`:

1. Phase 1: classifies note type (atomic, conceptual, pattern, derivation, reference)
2. Phase 2: mechanical checks (subagents) + conversational review (correctness, flow, wikilink suggestions)

The review is grounded in the ml-code-companion curriculum. See `docs/superpowers/specs/2026-03-28-editorial-review-skill-design.md` for the full design.
```

- [ ] **Step 2: Update local README.md**

Add to the workflow cheat sheet:

```markdown
## Editorial review (before publishing)

```bash
/editorial-review <note-name>
```

Reviews formatting, correctness, and suggests wikilinks. Run before `publish.sh`.
```

- [ ] **Step 3: Commit**

```bash
git -C ~/miei-repo/tirellic.io add CLAUDE.md
git -C ~/miei-repo/tirellic.io commit -m "meta.docs(claude-md): add editorial review skill reference

Tags: docs, claude-md, editorial-review"
```
