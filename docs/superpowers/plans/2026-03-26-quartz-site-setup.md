# tirellic.io Quartz Site Setup — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Set up a Quartz v4 static site in the tirellic.io repo, with a publish script that syncs `publish: true` notes from the Obsidian vault, Kinetic Whisper theme, and Cloudflare Pages deployment.

**Architecture:** Quartz v4 cloned into tirellic.io repo. A bash publish script scans `psychic-patterns/ml-code-companion/notes/` for `publish: true` frontmatter, rewrites `topic:` → `title:`, and copies to `content/`. Cloudflare Pages auto-builds on push.

**Tech Stack:** Quartz v4 (Node.js/TypeScript), Bash (publish script), Cloudflare Pages, GitHub

**Spec:** `docs/superpowers/specs/2026-03-26-quartz-site-design.md`

---

## File Map

| Action | Path | Responsibility |
|--------|------|----------------|
| Clone/init | `quartz/` | Quartz framework (from upstream clone) |
| Modify | `quartz.config.ts` | Site settings, theme, plugins |
| Modify | `quartz.layout.ts` | Page layout components (Kinetic Whisper visual elements) |
| Create | `quartz/styles/custom.scss` | Custom CSS for Kinetic Whisper visual details |
| Create | `content/index.md` | Landing page content |
| Create | `scripts/publish.sh` | Vault → content sync script |
| Create | `scripts/publish-test.sh` | Integration tests for publish script |
| Modify | `.gitignore` | Exclude build output, local dev artifacts |

---

### Task 1: Initialize Quartz repo

**Files:**
- The entire tirellic.io directory (re-initialized from Quartz clone)
- Preserve: `docs/`, `CLAUDE.md`, `.claude/`

- [ ] **Step 1: Backup existing files**

```bash
cd /Users/corrado/miei-repo
cp -r tirellic.io/docs /tmp/tirellic-docs-backup
cp tirellic.io/CLAUDE.md /tmp/tirellic-claude-backup
cp -r tirellic.io/.claude /tmp/tirellic-claude-dir-backup
```

- [ ] **Step 2: Clone Quartz into a temp directory**

```bash
git clone https://github.com/jackyzha0/quartz.git /tmp/quartz-fresh
```

- [ ] **Step 3: Move Quartz contents into tirellic.io**

```bash
rm -rf /Users/corrado/miei-repo/tirellic.io
mv /tmp/quartz-fresh /Users/corrado/miei-repo/tirellic.io
```

- [ ] **Step 4: Restore backed-up files**

```bash
cp -r /tmp/tirellic-docs-backup /Users/corrado/miei-repo/tirellic.io/docs
cp /tmp/tirellic-claude-backup /Users/corrado/miei-repo/tirellic.io/CLAUDE.md
cp -r /tmp/tirellic-claude-dir-backup /Users/corrado/miei-repo/tirellic.io/.claude
```

- [ ] **Step 5: Install dependencies**

```bash
cd /Users/corrado/miei-repo/tirellic.io
npm i
```

Expected: Clean install, no errors. Node v24 satisfies the v22+ requirement.

- [ ] **Step 6: Verify Quartz builds with default content**

```bash
npx quartz build
```

Expected: Build succeeds, `public/` directory created with HTML files.

- [ ] **Step 7: Clean up default content**

```bash
rm -rf content/*
```

- [ ] **Step 8: Update git remote to point to tirellic.io GitHub repo**

First create the repo on GitHub, then update the remote:

```bash
gh repo create cocosberlucens/tirellic.io --public --source=. --remote=origin
```

If the remote `origin` already exists (from the Quartz clone), update it:

```bash
git remote set-url origin https://github.com/cocosberlucens/tirellic.io.git
```

- [ ] **Step 9: Add .superpowers/ and tmp/ to .gitignore**

Append to `.gitignore`:

```
.superpowers/
tmp/
```

- [ ] **Step 10: Commit**

```bash
git add -A
git commit -m "standard.init(tirellic.io): initialize Quartz v4 site

Memory: Quartz v4 cloned and verified building
Tags: quartz, init, tirellic.io"
```

---

### Task 2: Configure Quartz theme and plugins

**Files:**
- Modify: `quartz.config.ts`

- [ ] **Step 1: Read the default quartz.config.ts**

Read the file to understand the default structure and plugin imports.

- [ ] **Step 2: Update site settings**

In `quartz.config.ts`, update the `configuration` object:

```typescript
configuration: {
  pageTitle: "tirellic.io",
  pageTitleSuffix: " — tirellic.io",
  enableSPA: true,
  enablePopovers: true,
  analytics: null,
  locale: "en-GB",
  baseUrl: "tirellic.io",
  ignorePatterns: ["private", "templates", ".obsidian"],
  defaultDateType: "modified",
  theme: {
    // updated in next step
  },
},
```

- [ ] **Step 3: Apply Kinetic Whisper color palette**

Update the `theme.colors` section. Both `light` and `dark` mode use the same palette (single-theme site):

```typescript
theme: {
  fontOrigin: "googleFonts",
  cdnCaching: true,
  typography: {
    header: "Space Grotesk",
    body: "Source Serif 4",
    code: "JetBrains Mono",
  },
  colors: {
    lightMode: {
      light: "#f5f3ef",
      lightgray: "#e0dbd3",
      gray: "#8a8580",
      darkgray: "#3a3530",
      dark: "#1a1a1e",
      secondary: "#e63946",
      tertiary: "#4a8fe7",
      highlight: "rgba(230,57,70,0.08)",
      textHighlight: "rgba(74,143,231,0.15)",
    },
    darkMode: {
      light: "#f5f3ef",
      lightgray: "#e0dbd3",
      gray: "#8a8580",
      darkgray: "#3a3530",
      dark: "#1a1a1e",
      secondary: "#e63946",
      tertiary: "#4a8fe7",
      highlight: "rgba(230,57,70,0.08)",
      textHighlight: "rgba(74,143,231,0.15)",
    },
  },
},
```

- [ ] **Step 4: Replace RemoveDrafts with ExplicitPublish in filters**

Find the `filters` array in the `plugins` section. Replace:

```typescript
// Before:
Plugin.RemoveDrafts(),

// After:
Plugin.ExplicitPublish(),
```

- [ ] **Step 5: Verify build with empty content**

```bash
npx quartz build
```

Expected: Build succeeds (no pages emitted since content is empty, but no errors).

- [ ] **Step 6: Commit**

```bash
git add quartz.config.ts
git commit -m "standard.configure(theme): apply Kinetic Whisper palette and ExplicitPublish

Kinetic Whisper: warm off-white, Space Grotesk headings, Source Serif 4 body,
red/blue accent system inspired by Kinetic Declaration design philosophy.
ExplicitPublish replaces RemoveDrafts to gate on publish: true frontmatter.

Memory: Quartz theme colors and typography configured, ExplicitPublish filter active
Tags: quartz, theme, kinetic-whisper, explicit-publish"
```

---

### Task 3: Apply Kinetic Whisper custom CSS

**Files:**
- Create: `quartz/styles/custom.scss`
- Modify: `quartz.layout.ts` (if nav bar gradient requires layout changes)

The Quartz color config handles base colors, but the spec's "Key Visual Elements" require custom CSS for the specific Kinetic Whisper details.

- [ ] **Step 1: Read the default Quartz styles and layout**

Read `quartz/styles/custom.scss` (if it exists) and `quartz.layout.ts` to understand the existing structure and available CSS variables.

- [ ] **Step 2: Create custom SCSS for Kinetic Whisper visual elements**

Add to `quartz/styles/custom.scss`:

```scss
// Kinetic Whisper — custom visual elements
// Ref: docs/superpowers/specs/2026-03-26-quartz-site-design.md

// Nav bar gradient accent line (red → blue → transparent)
header {
  border-bottom: 2px solid transparent;
  border-image: linear-gradient(90deg, #e63946, #4a8fe7, transparent 70%) 1;
}

// Links: subtle red underline
a.internal {
  text-decoration: none;
  border-bottom: 1px solid rgba(230, 57, 70, 0.3);
  &:hover {
    border-bottom-color: #e63946;
  }
}

// Math blocks: warm background with red left border
.math-display {
  background: #ebe5de;
  border-left: 3px solid #e63946;
  padding: 1rem 1.5rem;
  border-radius: 0 4px 4px 0;
}

// Tags: geometric sans-serif, uppercase, compact
a.tag-link {
  font-family: "Space Grotesk", sans-serif;
  text-transform: uppercase;
  letter-spacing: 1.5px;
  font-size: 0.7rem;
  font-weight: 500;
}

// Backlinks: blue pills
.backlinks a {
  color: #4a8fe7;
  background: rgba(74, 143, 231, 0.08);
  padding: 0.25rem 0.75rem;
  border-radius: 3px;
  border-bottom: none;
}

// Headings: tight letter-spacing
h1, h2, h3 {
  letter-spacing: -0.3px;
}
```

- [ ] **Step 3: Verify locally**

```bash
npx quartz build --serve
```

Expected: The site shows the gradient accent line on the nav, styled math blocks, uppercase tags, and blue backlink pills.

- [ ] **Step 4: Commit**

```bash
git add quartz/styles/custom.scss quartz.layout.ts
git commit -m "standard.style(kinetic-whisper): add custom CSS for visual elements

Nav gradient accent line, math block styling, uppercase geometric tags,
blue backlink pills, tight heading letter-spacing.

Memory: Custom CSS extends Quartz theme config for Kinetic Whisper details
Tags: css, kinetic-whisper, visual-identity"
```

---

### Task 4: Write the publish script

**Files:**
- Create: `scripts/publish.sh`
- Create: `scripts/publish-test.sh`

- [ ] **Step 1: Write the integration test**

Create `scripts/publish-test.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Integration tests for publish.sh
# Uses a temporary vault and content directory

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PUBLISH="$SCRIPT_DIR/publish.sh"
TEMP_DIR=$(mktemp -d)
VAULT="$TEMP_DIR/vault"
CONTENT="$TEMP_DIR/content"
PASS=0
FAIL=0

cleanup() { rm -rf "$TEMP_DIR"; }
trap cleanup EXIT

setup() {
  rm -rf "$VAULT" "$CONTENT"
  mkdir -p "$VAULT" "$CONTENT"
}

assert_exists() {
  if [[ -f "$1" ]]; then ((PASS++)); else echo "FAIL: expected $1 to exist"; ((FAIL++)); fi
}

assert_not_exists() {
  if [[ ! -f "$1" ]]; then ((PASS++)); else echo "FAIL: expected $1 to NOT exist"; ((FAIL++)); fi
}

assert_contains() {
  if grep -q "$2" "$1" 2>/dev/null; then ((PASS++)); else echo "FAIL: expected $1 to contain '$2'"; ((FAIL++)); fi
}

assert_not_contains() {
  if ! grep -q "$2" "$1" 2>/dev/null; then ((PASS++)); else echo "FAIL: expected $1 to NOT contain '$2'"; ((FAIL++)); fi
}

# --- Test 1: copies publish:true notes ---
echo "Test 1: copies publish:true notes"
setup
cat > "$VAULT/published-note.md" << 'EOF'
---
topic: a published note
publish: true
created: 2026-01-01
tags:
  - test
---
Some content here.
EOF
cat > "$VAULT/draft-note.md" << 'EOF'
---
topic: a draft note
publish: false
created: 2026-01-01
tags: []
---
Draft content.
EOF

VAULT_PATH="$VAULT" CONTENT_PATH="$CONTENT" "$PUBLISH" --sync-only
assert_exists "$CONTENT/published-note.md"
assert_not_exists "$CONTENT/draft-note.md"

# --- Test 2: rewrites topic to title ---
echo "Test 2: rewrites topic to title"
assert_contains "$CONTENT/published-note.md" "title: a published note"
assert_not_contains "$CONTENT/published-note.md" "topic:"

# --- Test 3: un-publishes removed notes ---
echo "Test 3: un-publishes removed notes"
setup
cat > "$VAULT/note-a.md" << 'EOF'
---
topic: note a
publish: true
created: 2026-01-01
tags: []
---
Content A.
EOF
VAULT_PATH="$VAULT" CONTENT_PATH="$CONTENT" "$PUBLISH" --sync-only
assert_exists "$CONTENT/note-a.md"

# Now set publish to false
cat > "$VAULT/note-a.md" << 'EOF'
---
topic: note a
publish: false
created: 2026-01-01
tags: []
---
Content A.
EOF
VAULT_PATH="$VAULT" CONTENT_PATH="$CONTENT" "$PUBLISH" --sync-only
assert_not_exists "$CONTENT/note-a.md"

# --- Test 4: copies only referenced attachments, not orphans ---
echo "Test 4: copies only referenced attachments"
setup
mkdir -p "$VAULT/attachments"
echo "used image" > "$VAULT/attachments/screenshot.png"
echo "orphan image" > "$VAULT/attachments/old-paste.png"
cat > "$VAULT/with-image.md" << 'EOF'
---
topic: note with image
publish: true
created: 2026-01-01
tags: []
---
![](attachments/screenshot.png)
EOF
VAULT_PATH="$VAULT" CONTENT_PATH="$CONTENT" "$PUBLISH" --sync-only
assert_exists "$CONTENT/attachments/screenshot.png"
assert_not_exists "$CONTENT/attachments/old-paste.png"

# --- Test 5: copies co-located non-markdown files ---
echo "Test 5: copies co-located non-markdown files"
setup
echo "svg data" > "$VAULT/diagram.svg"
cat > "$VAULT/note.md" << 'EOF'
---
topic: note with svg
publish: true
created: 2026-01-01
tags: []
---
Content.
EOF
VAULT_PATH="$VAULT" CONTENT_PATH="$CONTENT" "$PUBLISH" --sync-only
assert_exists "$CONTENT/diagram.svg"

# --- Test 6: skips empty/malformed files ---
echo "Test 6: skips empty/malformed files"
setup
touch "$VAULT/empty.md"
cat > "$VAULT/good.md" << 'EOF'
---
topic: good note
publish: true
created: 2026-01-01
tags: []
---
Content.
EOF
VAULT_PATH="$VAULT" CONTENT_PATH="$CONTENT" "$PUBLISH" --sync-only
assert_not_exists "$CONTENT/empty.md"
assert_exists "$CONTENT/good.md"

# --- Summary ---
echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]] && echo "ALL TESTS PASSED" || exit 1
```

- [ ] **Step 2: Make test executable and run it (expect failure)**

```bash
chmod +x scripts/publish-test.sh
./scripts/publish-test.sh
```

Expected: Fails because `scripts/publish.sh` doesn't exist yet.

- [ ] **Step 3: Write the publish script**

Create `scripts/publish.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

VAULT_PATH="${VAULT_PATH:-$REPO_ROOT/../psychic-patterns/ml-code-companion/notes}"
CONTENT_PATH="${CONTENT_PATH:-$REPO_ROOT/content}"

SYNC_ONLY=false
PREVIEW=false

for arg in "$@"; do
  case "$arg" in
    --sync-only) SYNC_ONLY=true ;;
    --preview)   PREVIEW=true ;;
    *) echo "Unknown flag: $arg"; exit 1 ;;
  esac
done

# Resolve absolute paths
VAULT_PATH="$(cd "$VAULT_PATH" && pwd)"
mkdir -p "$CONTENT_PATH"

# --- Sync publish:true notes ---
# Collect published filenames for un-publish step
published_files=()

for file in "$VAULT_PATH"/*.md; do
  [[ -f "$file" ]] || continue
  basename="$(basename "$file")"

  # Skip empty files
  [[ -s "$file" ]] || continue

  # Check for publish: true in frontmatter
  if awk '/^---$/{n++; next} n==1 && /^publish:\s*true/{found=1; exit} n>=2{exit} END{exit !found}' "$file"; then
    # Copy with topic → title rewrite in frontmatter
    # topic: only appears in frontmatter, so a global replace is safe
    sed 's/^topic:/title:/' "$file" > "$CONTENT_PATH/$basename"
    published_files+=("$basename")
  fi
done

# --- Copy only referenced attachments ---
# Parse published notes for image references: ![[file]] and ![](attachments/file)
referenced_attachments=()
for pub in "${published_files[@]}"; do
  while IFS= read -r ref; do
    referenced_attachments+=("$ref")
  done < <(
    # Match ![[filename.ext]] (Obsidian wikilink embeds)
    grep -oP '!\[\[\K[^\]]+' "$CONTENT_PATH/$pub" 2>/dev/null
    # Match ![...](attachments/filename.ext)
    grep -oP '!\[.*?\]\(attachments/\K[^)]+' "$CONTENT_PATH/$pub" 2>/dev/null
  )
done

if [[ -d "$VAULT_PATH/attachments" ]] && [[ ${#referenced_attachments[@]} -gt 0 ]]; then
  mkdir -p "$CONTENT_PATH/attachments"
  # Remove stale attachments first
  rm -rf "$CONTENT_PATH/attachments/"*
  for ref in "${referenced_attachments[@]}"; do
    if [[ -f "$VAULT_PATH/attachments/$ref" ]]; then
      cp "$VAULT_PATH/attachments/$ref" "$CONTENT_PATH/attachments/$ref"
    fi
  done
elif [[ -d "$CONTENT_PATH/attachments" ]]; then
  # No referenced attachments — clean up
  rm -rf "$CONTENT_PATH/attachments"
fi

# --- Copy co-located non-markdown files (only if notes are published) ---
if [[ ${#published_files[@]} -gt 0 ]]; then
  for file in "$VAULT_PATH"/*; do
    [[ -f "$file" ]] || continue
    basename="$(basename "$file")"
    [[ "$basename" == *.md ]] && continue
    cp "$file" "$CONTENT_PATH/$basename"
  done
fi

# --- Un-publish: remove stale content ---
# Remove markdown files no longer publish:true
for file in "$CONTENT_PATH"/*.md; do
  [[ -f "$file" ]] || continue
  basename="$(basename "$file")"
  [[ "$basename" == "index.md" ]] && continue  # never remove landing page

  found=false
  for pub in "${published_files[@]}"; do
    [[ "$pub" == "$basename" ]] && found=true && break
  done

  if [[ "$found" == false ]]; then
    rm "$file"
  fi
done

# If no notes are published, clean up assets too
if [[ ${#published_files[@]} -eq 0 ]]; then
  rm -rf "$CONTENT_PATH/attachments"
  find "$CONTENT_PATH" -maxdepth 1 -type f ! -name "index.md" -delete
fi

# Count published
count=${#published_files[@]}

if [[ "$SYNC_ONLY" == true ]]; then
  echo "Synced $count note(s) to $CONTENT_PATH"
  exit 0
fi

if [[ "$PREVIEW" == true ]]; then
  echo "Synced $count note(s). Starting local preview..."
  cd "$REPO_ROOT"
  npx quartz build --serve
  exit 0
fi

# --- Commit and push ---
cd "$REPO_ROOT"
git add content/
if git diff --cached --quiet; then
  echo "No changes to publish."
  exit 0
fi

git commit -m "standard.publish(content): sync $count note(s) from vault

Memory: Published $count notes via publish.sh
Tags: publish, content-sync"

git push
echo "Published $count note(s) and pushed to remote."
```

- [ ] **Step 4: Make executable and run tests**

```bash
chmod +x scripts/publish.sh
./scripts/publish-test.sh
```

Expected: `ALL TESTS PASSED`

- [ ] **Step 5: Commit**

```bash
git add scripts/publish.sh scripts/publish-test.sh
git commit -m "standard.feat(publish): add vault-to-content sync script with tests

publish.sh scans vault for publish:true notes, rewrites topic→title,
copies with attachments, handles un-publishing. Flags: --preview, --sync-only.
6 integration tests covering core sync, rewrite, un-publish, and asset flows.

Memory: publish.sh is the single entry point for content management
Tags: publish, bash, content-pipeline"
```

---

### Task 5: Create landing page

**Files:**
- Create: `content/index.md`

- [ ] **Step 1: Create the landing page content**

Create `content/index.md`:

```markdown
---
title: tirellic.io
publish: true
---

**Corrado Tirelli** — poet, coder, data architect.

healthcare analytics, machine learning, and the connections between things. this is where i think out loud.

[explore the graph →](/graph)

## recent

*This section will populate automatically as notes are published.*

## start here

*Curated picks will be added as the garden grows.*
```

Note: Quartz renders `index.md` as the landing page automatically. The "recent" and "start here" sections are placeholder text for now — they can be replaced with actual links as content is published, or enhanced with Quartz components later.

- [ ] **Step 2: Verify local build with landing page**

```bash
npx quartz build --serve
```

Expected: Site builds and serves locally. Opening `http://localhost:8080` shows the landing page with the Kinetic Whisper theme.

- [ ] **Step 3: Commit**

```bash
git add content/index.md
git commit -m "standard.feat(landing): add landing page with intro and placeholder sections

Memory: index.md is the landing page, will be enriched as content grows
Tags: landing-page, content"
```

---

### Task 6: End-to-end test with a real note

**Files:**
- Modify: one note in `psychic-patterns/ml-code-companion/notes/` (temporarily set `publish: true`)

- [ ] **Step 1: Set one note to publish:true in the vault**

Edit `psychic-patterns/ml-code-companion/notes/conditional-probability-and-bayes-rule.md` — change `publish: false` to `publish: true`.

- [ ] **Step 2: Run publish script in preview mode**

```bash
cd /Users/corrado/miei-repo/tirellic.io
./scripts/publish.sh --preview
```

Expected: Output says "Synced 1 note(s). Starting local preview..." and Quartz serves the site.

- [ ] **Step 3: Verify in browser**

Open `http://localhost:8080`. Check:
- Landing page renders with Kinetic Whisper theme (warm background, Space Grotesk headings)
- Navigate to the Bayes note — title shows "conditional probability and Bayes' rule"
- LaTeX renders correctly (the P(A|B) formula)
- Graph view shows the note as a node
- Popovers work on any wikilinks

- [ ] **Step 4: Revert the vault note back to publish:false**

Edit `psychic-patterns/ml-code-companion/notes/conditional-probability-and-bayes-rule.md` — change `publish: true` back to `publish: false`.

- [ ] **Step 5: Commit the verified content state**

```bash
cd /Users/corrado/miei-repo/tirellic.io
git add -A
git commit -m "knowledge.verify(e2e): end-to-end publish flow verified with real note

Tested: publish.sh sync, topic→title rewrite, Kinetic Whisper theme rendering,
LaTeX math, graph view, popovers. All working.

Memory: Full publish pipeline verified locally
Tags: e2e-test, verification"
```

---

### Task 7: Deploy to Cloudflare Pages

**Files:**
- No file changes — this is infrastructure setup

- [ ] **Step 1: Push to GitHub**

```bash
cd /Users/corrado/miei-repo/tirellic.io
git push -u origin v4
```

Expected: Code pushed to `cocosberlucens/tirellic.io` repo on GitHub.

- [ ] **Step 2: Connect Cloudflare Pages**

In the Cloudflare dashboard:
1. Go to Workers & Pages → Create → Pages → Connect to Git
2. Select the `cocosberlucens/tirellic.io` repository
3. Configure:
   - **Production branch**: `v4`
   - **Framework preset**: None
   - **Build command**: `git fetch --unshallow && npx quartz build`
   - **Build output directory**: `public`
4. Deploy

- [ ] **Step 3: Configure custom domain**

In Cloudflare Pages project settings:
1. Go to Custom domains
2. Add `tirellic.io`
3. DNS should auto-configure since the domain is on Cloudflare

- [ ] **Step 4: Verify deployment**

Open `https://tirellic.io` in a browser.

Expected: The landing page renders with the Kinetic Whisper theme. The site is live.

- [ ] **Step 5: Commit any final adjustments**

If the deployment reveals any issues (e.g., base URL mismatch), fix and commit.

---

### Task 8: Update CLAUDE.md

**Files:**
- Modify: `CLAUDE.md`

- [ ] **Step 1: Update CLAUDE.md with build commands and architecture**

Now that the site is set up, update CLAUDE.md to reflect the actual commands and structure for future Claude sessions.

Key additions:
- Build: `npx quartz build`
- Preview: `npx quartz build --serve`
- Publish: `./scripts/publish.sh` (flags: `--preview`, `--sync-only`)
- Test: `./scripts/publish-test.sh`
- Content source: only `psychic-patterns/ml-code-companion/notes/`
- Theme: Kinetic Whisper (reference spec for details)

- [ ] **Step 2: Commit**

```bash
git add CLAUDE.md
git commit -m "meta.docs(claude-md): update with build commands and architecture

Memory: CLAUDE.md now reflects actual Quartz setup and publish workflow
Tags: docs, claude-md"
```
