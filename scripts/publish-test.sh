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
  if [[ -f "$1" ]]; then PASS=$((PASS+1)); else echo "FAIL: expected $1 to exist"; FAIL=$((FAIL+1)); fi
}

assert_not_exists() {
  if [[ ! -f "$1" ]]; then PASS=$((PASS+1)); else echo "FAIL: expected $1 to NOT exist"; FAIL=$((FAIL+1)); fi
}

assert_contains() {
  if grep -q "$2" "$1" 2>/dev/null; then PASS=$((PASS+1)); else echo "FAIL: expected $1 to contain '$2'"; FAIL=$((FAIL+1)); fi
}

assert_not_contains() {
  if ! grep -q "$2" "$1" 2>/dev/null; then PASS=$((PASS+1)); else echo "FAIL: expected $1 to NOT contain '$2'"; FAIL=$((FAIL+1)); fi
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
topic: this is a body line that should stay
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

# --- Test 2: rewrites topic to title in frontmatter only ---
echo "Test 2: rewrites topic to title in frontmatter only"
assert_contains "$CONTENT/published-note.md" "title: a published note"
assert_contains "$CONTENT/published-note.md" "topic: this is a body line that should stay"

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

# --- Test 4b: wikilink embeds with aliases ---
echo "Test 4b: wikilink embeds with aliases"
setup
mkdir -p "$VAULT/attachments"
echo "wiki image" > "$VAULT/attachments/wiki-img.png"
echo "sized image" > "$VAULT/attachments/sized-img.png"
echo "orphan image" > "$VAULT/attachments/orphan.png"
cat > "$VAULT/alias-note.md" << 'EOF'
---
topic: note with aliased images
publish: true
created: 2026-01-01
tags: []
---
![[wiki-img.png]]
![[sized-img.png|300]]
EOF
VAULT_PATH="$VAULT" CONTENT_PATH="$CONTENT" "$PUBLISH" --sync-only
assert_exists "$CONTENT/attachments/wiki-img.png"
assert_exists "$CONTENT/attachments/sized-img.png"
assert_not_exists "$CONTENT/attachments/orphan.png"

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

# --- Test 7: zero-notes cleanup preserves index.md ---
echo "Test 7: zero-notes cleanup preserves index.md"
setup
mkdir -p "$CONTENT/attachments"
echo "stale image" > "$CONTENT/attachments/old.png"
echo "stale svg" > "$CONTENT/stale.svg"
echo "---\ntitle: landing\n---\nWelcome." > "$CONTENT/index.md"
cat > "$VAULT/draft-only.md" << 'EOF'
---
topic: only a draft
publish: false
created: 2026-01-01
tags: []
---
Draft content.
EOF
VAULT_PATH="$VAULT" CONTENT_PATH="$CONTENT" "$PUBLISH" --sync-only
assert_not_exists "$CONTENT/attachments/old.png"
assert_not_exists "$CONTENT/stale.svg"
assert_exists "$CONTENT/index.md"

# --- Summary ---
echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]] && echo "ALL TESTS PASSED" || exit 1
