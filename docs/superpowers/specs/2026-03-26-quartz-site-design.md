# tirellic.io — Quartz Site Design

## Vision

A digital garden and living curriculum vitae at `tirellic.io`. Not segmented by audience, not a blog — a space for interconnected thinking across ML, healthcare analytics, and whatever else emerges. The graph view is central: it demonstrates how the author thinks, and readers follow any thread that interests them.

Primary language is English (tech's lingua franca); occasional pieces in Italian when voice matters more than reach.

## Repository & Content Architecture

```
tirellic.io/                    ← Quartz repo, pushed to GitHub
├── content/                    ← published notes (tracked in git)
├── quartz.config.ts            ← site config, theme, plugins
├── quartz.layout.ts            ← page layout components
├── scripts/
│   └── publish.sh              ← syncs publish:true notes from vault
├── quartz/                     ← Quartz framework
└── public/                     ← build output (gitignored)

psychic-patterns/               ← Obsidian vault (separate repo, unchanged)
└── ml-code-companion/
    └── notes/                  ← single content source
```

### Content Flow

1. Edit notes in Obsidian (psychic-patterns vault)
2. Set `publish: true` in frontmatter when ready
3. Run `./scripts/publish.sh` — copies `publish: true` notes to `content/`, commits, pushes
4. Cloudflare Pages detects push → builds → deploys to `tirellic.io`

Content from `refactored-umbrella` (work projects, e.g. CCI vs rowstore comparison) is handled manually — translated to English, sanitized of real DB object names, then placed in `psychic-patterns/ml-code-companion/notes/` with `publish: true`.

### Content Source Constraint

Only `psychic-patterns/ml-code-companion/notes/` is a content source. No other vault directories are published.

## Quartz Configuration

### Plugins

- **Filter**: `ExplicitPublish` — only renders notes with `publish: true` in frontmatter (safety net on top of the publish script)
- **Transformers**: defaults (Frontmatter, LaTeX, SyntaxHighlighting, ObsidianFlavoredMarkdown for wikilinks)
- **Emitters**: defaults (ContentPage, TagPage, Graph, RSS)

### Site Settings

| Setting | Value | Rationale |
|---------|-------|-----------|
| `pageTitle` | `"tirellic.io"` | |
| `baseUrl` | `"tirellic.io"` | |
| `locale` | `"en-GB"` | English with European date formatting |
| `enableSPA` | `true` | smooth navigation |
| `enablePopovers` | `true` | hover preview on wikilinks — core to the garden feel |
| `defaultDateType` | `"modified"` | shows when a note was last touched |

## Visual Identity: Kinetic Whisper

Inspired by the "Kinetic Declaration" design philosophy — a light, readable theme where bold geometric details carry forward momentum through subtlety rather than drama. Energy felt, not shouted.

### Color Palette

| Token | Hex | Role |
|-------|-----|------|
| `light` | `#f5f3ef` | warm off-white background |
| `lightgray` | `#e0dbd3` | borders, dividers |
| `gray` | `#8a8580` | muted text, dates |
| `darkgray` | `#3a3530` | body text |
| `dark` | `#1a1a1e` | headings, nav bar background |
| `secondary` | `#e63946` | links, primary accent (the force lines) |
| `tertiary` | `#4a8fe7` | hover states, backlinks, exploration accent (the triangle) |
| `highlight` | `rgba(230,57,70,0.08)` | subtle red wash on highlights |
| `textHighlight` | `rgba(74,143,231,0.15)` | search/selection highlight |

### Typography

| Role | Font | Character |
|------|------|-----------|
| **header** | Space Grotesk | geometric sans-serif, carries the Kinetic DNA |
| **body** | Source Serif 4 | clean, readable serif for screens and math-adjacent text |
| **code** | JetBrains Mono | |

### Key Visual Elements

- **Nav bar**: dark (`#1a1a1e`) with gradient accent line (red → blue → transparent)
- **Links**: red (`#e63946`) with subtle red underline
- **Backlinks**: blue (`#4a8fe7`) on light blue background pills
- **Math blocks**: warm background (`#ebe5de`) with red left border
- **Tags**: geometric sans-serif, uppercase, compact — dark or red background
- **Headings**: Space Grotesk, bold weight, tight letter-spacing

## Landing Page Structure

1. **Personal intro**: name, one-line identity ("poet, coder, data architect."), brief description, link to graph
2. **Recent notes**: list of recently updated notes with dates
3. **Start here**: hand-picked curated notes that showcase best thinking — red/blue left-border cards
4. **Graph link**: invitation to explore the knowledge map

## Cloudflare Pages Deployment

| Setting | Value |
|---------|-------|
| **Source** | `tirellic.io` GitHub repo |
| **Production branch** | `v4` |
| **Framework preset** | None |
| **Build command** | `git fetch --unshallow && npx quartz build` |
| **Output directory** | `public` |
| **Custom domain** | `tirellic.io` (already on Cloudflare, DNS automatic) |

The `git fetch --unshallow` ensures git timestamps work correctly for the "updated" dates displayed on notes.

## Publish Script (`scripts/publish.sh`)

### Behavior

- Scans `$VAULT_PATH/*.md` (default: `../psychic-patterns/ml-code-companion/notes`) for `publish: true` in frontmatter
- Copies matching `.md` files to `content/`
- During copy, rewrites `topic:` → `title:` in frontmatter (vault originals keep `topic`, Quartz expects `title`)
- Copies non-markdown files (`.svg`, `.png`, etc.) from the same source directory only if they are co-located with published notes
- Removes files from `content/` whose source no longer has `publish: true` (un-publishing)

### Flags

| Flag | Behavior |
|------|----------|
| (none) | Copy, commit, push to GitHub |
| `--preview` | Copy only, then run `npx quartz serve` for local preview |

### Configuration

`VAULT_PATH` defaults to `../psychic-patterns/ml-code-companion/notes`. Configurable via environment variable or script constant.

## Frontmatter Contract

Notes in the vault use this frontmatter structure:

```yaml
---
topic: conditional probability and Bayes' rule
publish: false          # flip to true when ready
created: 2026-02-14
updated: 2026-03-07
tags:
  - probability
  - bayes
---
```

The vault uses `topic` as the title field (Obsidian convention). The publish script rewrites this to `title` during copy, since Quartz's Frontmatter transformer expects `title` by default. Vault originals are never modified. The `publish` field is the sole gating mechanism.

## Non-Markdown Assets

Quartz emits all non-markdown files regardless of the ExplicitPublish filter. The vault uses an `attachments/` subdirectory pattern (enforced via Obsidian settings: "In subfolder under current folder", subfolder name `attachments`). This means:

- Source structure: `ml-code-companion/notes/attachments/` holds all images/screenshots for notes in that directory
- Co-located files (e.g. `scipy_stats_oo_architecture.svg` currently sits alongside the notes) are also possible
- The publish script parses published notes for image references (`![[file]]` and `![](attachments/file)`) and copies **only referenced** attachments to `content/attachments/` — orphaned images from paste-then-delete workflows in Obsidian are excluded
- Co-located non-markdown files are copied alongside published notes
- Quartz resolves `![[image.png]]` and `![](attachments/image.png)` references relative to content root

## Future Considerations (not in scope)

- Marimo notebook publishing via Cloudflare (see https://docs.marimo.io/guides/publishing/cloudflare/)
- Claude Code skill for editorial review workflow — assist with polish while keeping Corrado's voice and intellectual ownership intact
- Automatic git hook in psychic-patterns to trigger publish
- Analytics integration
