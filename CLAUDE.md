# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**tirellic.io** is Corrado's personal portfolio and knowledge-sharing site, hosted at `tirellic.io`. It publishes selected ML learning notes and healthcare analytics project writeups from the Obsidian vault **psychic-patterns**.

## Technical Stack (planned)

- **Static site generator**: Quartz (purpose-built for Obsidian vaults — supports `[[wikilinks]]`, backlinks, graph view, LaTeX)
- **Hosting**: Cloudflare Pages (free tier, auto-builds on push)
- **Domain**: `tirellic.io` — purchased and managed via Cloudflare Registrar (DNSSEC enabled, 2FA configured)
- **Content sources**:
  - `psychic-patterns/ml-code-companion/notes/` — ML curriculum notes (gated by `publish: true` frontmatter)
  - `refactored-umbrella/projects/` — applied DB/BI work at the LHA (e.g. CCI vs rowstore comparison, ambulatory pipeline rebuild)

## Architecture

The deployment pipeline is: push to GitHub repo → Cloudflare Pages watches repo → auto-build → served at `tirellic.io`. No GitHub Actions or YAML workflows needed.

Content is selectively published from the Obsidian vault — not the entire vault. A Claude Code skill for managing publication workflow is planned.

## Related Repositories

- **psychic-patterns**: Obsidian knowledge vault containing the source notes (ML curriculum notes, practical ML project docs)
- **ml-code-companion**: The structured ML learning curriculum that produces the notes published here
