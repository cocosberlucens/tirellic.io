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
[[ -d "$VAULT_PATH" ]] || { echo "Error: vault not found at $VAULT_PATH"; exit 1; }
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
  if awk 'BEGIN{found=0} /^---$/{n++; next} n==1 && /^publish: *true/{found=1; exit} n>=2{exit} END{exit (found==0)}' "$file"; then
    # Copy with topic → title rewrite in frontmatter only
    awk 'BEGIN{fm=0} /^---$/{fm++} fm==1{sub(/^topic:/,"title:")} {print}' "$file" > "$CONTENT_PATH/$basename"
    published_files+=("$basename")
  fi
done

# --- Copy only referenced attachments ---
# Parse published notes for image references: ![[file]] and ![](attachments/file)
# Using perl instead of grep -oP for macOS compatibility
referenced_attachments=()
if [[ ${#published_files[@]} -gt 0 ]]; then
  for pub in "${published_files[@]}"; do
    while IFS= read -r ref; do
      [[ -n "$ref" ]] && referenced_attachments+=("$ref")
    done < <(
      # Match ![[filename.ext]] (Obsidian wikilink embeds)
      perl -ne 'print "$1\n" while /!\[\[([^\]|]+)(?:\|[^\]]+)?\]\]/g' "$CONTENT_PATH/$pub" 2>/dev/null
      # Match ![...](attachments/filename.ext)
      perl -ne 'print "$1\n" while /!\[.*?\]\(attachments\/([^)]+)\)/g' "$CONTENT_PATH/$pub" 2>/dev/null
    )
  done
fi

# Deduplicate referenced attachments
if [[ ${#referenced_attachments[@]} -gt 0 ]]; then
  IFS=$'\n' read -r -d '' -a referenced_attachments < <(printf '%s\n' "${referenced_attachments[@]}" | sort -u; printf '\0') || true
fi

if [[ -d "$VAULT_PATH/attachments" ]] && [[ ${#referenced_attachments[@]} -gt 0 ]]; then
  mkdir -p "$CONTENT_PATH/attachments"
  # Remove stale attachments first
  find "$CONTENT_PATH/attachments" -mindepth 1 -delete 2>/dev/null || true
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
  if [[ ${#published_files[@]} -gt 0 ]]; then
    for pub in "${published_files[@]}"; do
      [[ "$pub" == "$basename" ]] && found=true && break
    done
  fi

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
