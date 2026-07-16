---
created: 2026-04-07
type: meta
title: "Hot Cache"
updated: 2026-07-15T22:55:00
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

2026-07-15 (evening, lint follow-up session). **Current shipped version: v1.9.2.**
Five commits landed this session, pushed to the `Poncho1112` fork only. Latest
local commit `bcddf0c`.

## Plugin State

- **Version**: 1.9.2 (`.claude-plugin/plugin.json` + `marketplace.json` synced)
- **Skills**: 15 — wiki, wiki-ingest, wiki-query, wiki-lint, wiki-fold, save,
  autoresearch, canvas, defuddle, obsidian-bases, obsidian-markdown, wiki-cli,
  wiki-retrieve, wiki-mode, think.
- **Tests**: `make test` runs 9 hermetic suites. Zero ollama / zero network.
- **Hooks**: 4 (SessionStart [+ stale-lock reaper], PostCompact, PostToolUse
  [pathspec-scoped `wiki/ .raw/`], Stop).

## This Session (2026-07-15 evening, lint follow-up)

- **Transport corrected**: `detect-transport.sh` false-positived on the
  Obsidian Electron app launcher as `obsidian-cli` (no real CLI binary on
  host). `.vault-meta/transport.json` (local, gitignored) now prefers
  `mcp_obsidian` — verified working via `get_vault_stats`.
- **[[lint-report-2026-07-15]] fully resolved**: found + fixed a DragonScale
  address gap the prior pass missed (5 post-rollout pages, `c-000003`–
  `c-000007` assigned, counter now 8); fixed 9 Category C dead cross-plugin
  wikilinks (full vault-path + alias, e.g. `[[skills/wiki-cli/SKILL|wiki-cli]]`);
  confirmed Category E already clean; empty-section heuristic found only
  false positives, skipped.
- **`.gitattributes` added** pinning `.obsidian/*.json` to LF — fixes
  recurring false-dirty git status from `core.autocrlf=true` (pure line-ending
  noise, no real content changes).
- **Semantic tiling (DragonScale M3) shipped and run**: installed Ollama +
  `nomic-embed-text` in WSL Ubuntu (host Python lacks `fcntl`; WSL2 NAT can't
  reach Windows-bound Ollama on loopback, so installed fresh in WSL rather
  than reconfigure networking). Report: [[tiling-report-2026-07-15]]. 2
  error-band pairs found, both manually reviewed as false positives
  (deliberately split companion pages; standard source→synthesis pair) — no
  merge needed.

## DragonScale Mechanisms

All four shipped and now exercised end-to-end: (1) fold operator, (2)
deterministic addresses (counter at 8, Windows-portable allocator), (3)
semantic tiling lint (ran successfully via WSL this session), (4)
boundary-first autoresearch.

## Style Preferences

- No em dashes (U+2014) or `--` as punctuation. Periods, commas, colons,
  parentheses. Hyphens in compound words are fine.
- Short, direct responses. No trailing summaries.
- Parallel tool calls when independent.
- WSL commands that need interactive sudo must be run by the user directly
  in their own terminal (not via the `!` prefix or Bash tool) — password
  can't be relayed through either.

## Active Threads

- Working tree clean. No open lint items.
- Tiling thresholds (0.80/0.90) are uncalibrated defaults and run hot for
  this vault's style (companion pages, source/synthesis pairs cluster near
  0.90). Full calibration pass (label ~50 pairs) not done, offered but not
  requested.
- No PR to upstream (`AgriciDaniel`) — user chose fork-only.

## Repo Locations

- Working: `C:\Users\Poncho\claude-obsidian\`
- Push target: `mine` → https://github.com/Poncho1112/claude-obsidian (`main`
  tracks `mine/main`)
- Upstream: `origin` → https://github.com/AgriciDaniel/claude-obsidian
  (no write access for `Poncho1112`; 403 on push)
