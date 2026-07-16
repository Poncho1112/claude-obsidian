---
created: 2026-04-07
type: meta
title: "Hot Cache"
updated: 2026-07-15T00:00:00
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

2026-07-15 (cache refresh). Rewrote this file from the actual repo state — the
prior cache was stale at v1.7.1 and had grown to ~1600 words (a journal, not a
cache). **Current shipped version: v1.9.2**, promoted to public canonical on
`main` (`00213b7`), latest commit `cb93ff6` (1280x640 social preview card,
2026-05-28). All versions v1.6.0 → v1.9.2 are now git-tagged; the old "no tags
created locally" note is obsolete.

## Plugin State

- **Version**: 1.9.2 (`.claude-plugin/plugin.json` + `marketplace.json` synced)
- **Repo**: origin `https://github.com/AgriciDaniel/claude-obsidian` (public
  canonical). Migrated through AI-Marketing-Hub during the v1.9.0 cycle.
- **Skills**: 15 — wiki, wiki-ingest, wiki-query, wiki-lint, wiki-fold, save,
  autoresearch, canvas, defuddle, obsidian-bases, obsidian-markdown, wiki-cli,
  wiki-retrieve, wiki-mode, **think** (v1.9, skill #15).
- **Tests**: `make test` runs 9 hermetic suites (added `test_wiki_mode.py` v1.8,
  `test_contextual_prefix.py` v1.9.2). Zero ollama / zero network dependency.
- **Hooks**: 4 (SessionStart [+ stale-lock reaper], PostCompact, PostToolUse
  [pathspec-scoped, opt-out via `.vault-meta/auto-commit.disabled`], Stop).

## Release Arc Since Last Cache

- **v1.7.x** — Compound Vault refoundation: transport detection, opt-in hybrid
  retrieval, multi-writer wiki locks; SSS+ convergence (v1.7.2).
- **v1.8.0** — Methodology modes (generic / LYT / PARA / Zettelkasten) via
  `bash bin/setup-mode.sh`; consumed by ingest / save / autoresearch routing.
- **v1.9.0** — 10-principle thinking framework: `/think` skill + a "How to think"
  appendix on all 14 prior skills; first-public-release hygiene (CONTRIBUTING,
  CODE_OF_CONDUCT, SECURITY, CI, issue/PR templates).
- **v1.9.1** — Audit hardening: 6 HIGH/MEDIUM + 3 LOW closed; single-tenant
  threat model in SECURITY.md; symlink canonicalization in wiki-lock.
- **v1.9.2** — Prompt-cache hardening in `scripts/contextual-prefix.py` (Haiku
  16 KB cache floor, `cache_control_for()`, cache telemetry, clean exit codes
  2/3 for bad page paths). API payload + observability only; no retrieval change.

## DragonScale Mechanisms

All four shipped, opt-in, feature-gated: (1) fold operator, (2) deterministic
addresses (`.vault-meta/address-counter.txt` at 3), (3) semantic tiling lint,
(4) boundary-first autoresearch.

## Style Preferences

- No em dashes (U+2014) or `--` as punctuation. Periods, commas, colons,
  parentheses. Hyphens in compound words are fine.
- Short, direct responses. No trailing summaries.
- Parallel tool calls when independent.

## Active Threads

- **Lint reconcile done 2026-07-15** ([[lint-report-2026-07-15]]): [[index]] header
  corrected to 49 pages / 1 source, `References` section added (orphans 2→0),
  frontmatter gaps 15→0, 4 `?`-broken wikilinks + 6 Cat-E dead links fixed. Residual
  by design: canvas/base false positives, `[[Foo]]` examples, Category C cross-plugin
  links. Deferred: semantic tiling (needs ollama), [[log]] milestone backfill.
- Local working tree: only `.obsidian/*.json` UI-state files modified (noise).

## Repo Locations

- Working: `C:\Users\Poncho\claude-obsidian\`
- Public: https://github.com/AgriciDaniel/claude-obsidian
