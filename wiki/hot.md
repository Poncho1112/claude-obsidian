---
created: 2026-04-07
type: meta
title: "Hot Cache"
updated: 2026-07-15T21:15:00
tags:
  - meta
  - hot-cache
status: evergreen
related:
  - "[[index]]"
  - "[[log]]"
  - "[[Wiki Map]]"
  - "[[getting-started]]"
  - "[[DragonScale Memory]]"
---

# Recent Context

Navigation: [[index]] | [[log]] | [[overview]]

## Last Updated

2026-07-15 (evening, maintenance session). **Current shipped version: v1.9.2.**
Four commits landed this session, pushed to the `Poncho1112` fork only (see
Repo Locations). Latest local commit `c864e2c`.

## Plugin State

- **Version**: 1.9.2 (`.claude-plugin/plugin.json` + `marketplace.json` synced)
- **Skills**: 15 — wiki, wiki-ingest, wiki-query, wiki-lint, wiki-fold, save,
  autoresearch, canvas, defuddle, obsidian-bases, obsidian-markdown, wiki-cli,
  wiki-retrieve, wiki-mode, **think** (v1.9, skill #15).
- **Tests**: `make test` runs 9 hermetic suites. Zero ollama / zero network.
- **Hooks**: 4 (SessionStart [+ stale-lock reaper], PostCompact, PostToolUse
  [pathspec-scoped `wiki/ .raw/`], Stop).

## This Session (2026-07-15 evening)

- **mcpvault MCP registered** — `obsidian-vault` at user scope (`claude mcp`),
  `npx @bitbonsai/mcpvault@latest C:/Users/Poncho/claude-obsidian`, Status
  Connected. Third tier in the transport chain (CLI → mcp-obsidian → mcpvault →
  filesystem). Tools load next session; this session used filesystem transport.
- **ecosystem-research confirmed already-ingested** — source page + 6 entity
  pages + comparison already existed (8 pages). `.raw/.manifest.json` `sources`
  was empty, so `/wiki` misreported it "pending." Backfilled the delta record
  (`30b21f4`); no pages re-created.
- **Allocator Windows fix** (`2bf0946`) — `scripts/allocate-address.sh` relied on
  `flock` (absent in Git-Bash on Windows → exit 1, broke DragonScale addressing).
  Now falls back to an atomic `mkdir` mutex (5s timeout, `STALE_AFTER_SEC=30`
  stale reclaim, trap release); `flock` still preferred where present. Verified
  in Git-Bash; live counter untouched (still 3).
- **Lint reconcile filed** (`dbb2a9f`, 23 files) + **workspace.json/graph.json
  untracked + gitignored** (`c864e2c`; drops pre-configured graph view for fresh
  clones — accepted).

## DragonScale Mechanisms

All four shipped, opt-in, feature-gated: (1) fold operator, (2) deterministic
addresses (counter at 3; allocator now Windows-portable), (3) semantic tiling
lint, (4) boundary-first autoresearch.

## Style Preferences

- No em dashes (U+2014) or `--` as punctuation. Periods, commas, colons,
  parentheses. Hyphens in compound words are fine.
- Short, direct responses. No trailing summaries.
- Parallel tool calls when independent.

## Active Threads

- Working tree clean except 3 intentionally-tracked `.obsidian` config files
  (`app.json`, `appearance.json`, `core-plugins.json`) — left as-is.
- Deferred: semantic tiling (needs ollama), [[log]] milestone backfill.
- No PR to upstream (`AgriciDaniel`) — user chose fork-only.

## Repo Locations

- Working: `C:\Users\Poncho\claude-obsidian\`
- Push target: `mine` → https://github.com/Poncho1112/claude-obsidian (`main`
  tracks `mine/main`)
- Upstream: `origin` → https://github.com/AgriciDaniel/claude-obsidian
  (no write access for `Poncho1112`; 403 on push)
