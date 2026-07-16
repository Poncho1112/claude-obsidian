---
type: meta
title: "Lint Report 2026-07-15"
created: 2026-07-15
updated: 2026-07-15
tags: [meta, lint]
status: resolved
---

# Lint Report: 2026-07-15

Scope: full filesystem scan (no Obsidian CLI on this host).

> [!done] Fixes applied 2026-07-15 (operator-approved)
> - Index header corrected (34→49 pages, 2→1 source, date → 2026-07-15) + new
>   `References` section → **orphans 2→0**.
> - `?` stripped from the 4 real `[[How does the LLM Wiki pattern work]]` wikilinks.
> - `created:` backfilled on 14 pages + full frontmatter on the tiling report →
>   **frontmatter gaps 15→0**.
> - Category E: 5 dead `related:` pointers dropped from session notes, 1 retargeted
>   ([[Karpathy LLM Wiki Pattern]]→[[LLM Wiki Pattern]]), dead canvas link removed
>   from [[overview]].
> - **Left as-is by design:** canvas/base false positives, intentional `[[Foo]]` /
>   `[[Three laws of motion]]` examples, Category C cross-plugin links.
> - **Deferred:** semantic tiling (needs ollama), [[log]] milestone backfill.

## Summary

- Pages scanned: 49 (`.md` under `wiki/`)
- Index header claims: 34 pages / 2 sources / updated 2026-04-15 — **all three stale**
- Dead wikilinks (raw): 35 across 20 targets — triaged below
- Frontmatter gaps: 14 pages missing `created` (+1 with no frontmatter)
- Orphan pages (non-meta): 2

## Core drift (the reconcile target)

The wiki content layer stopped tracking plugin dev around late April while the
plugin shipped through v1.9.2. Concrete symptoms:

1. **[[index]] header is stale.** Says `Total pages: 34 | Sources ingested: 2 |
   Last updated: 2026-04-15`. Actual: 49 pages, 1 source page in `wiki/sources/`
   (the "2" was never true against its own list). Fix: correct the header line.
2. **[[log]] is frozen at 2026-04-24.** Append-only log's top entry predates every
   v1.6.1 → v1.9.2 release. Not auto-fixable retroactively (append-only), but new
   milestone entries should resume.
3. **`wiki/references/` pages are uncatalogued and orphaned** (see Orphans).
4. **No `References` or `Folds` section in the index** despite both folders having
   content (`transport-fallback.md`, `methodology-modes.md`, `fold-k3-...`).

## Orphan Pages

- [[transport-fallback]] (`wiki/references/`): referenced only from CLAUDE.md +
  SKILL files (outside `wiki/`), nothing inside the wiki links to it. Suggest: add
  a `References` section to [[index]] and link from [[LLM Wiki Pattern]].
- [[methodology-modes]] (`wiki/references/`): same situation. Suggest: link from
  the index References section + from [[DragonScale Memory]] / a modes concept.

## Dead Links (triaged)

**A. Real, fixable now — `?` in filename mismatch (4 refs)**
- [[How does the LLM Wiki pattern work?]] → file is `How does the LLM Wiki pattern
  work.md` (no `?`; Windows disallows `?`). Referenced with the `?` from [[log]]
  and 3 others. Fix: strip the `?` from those wikilinks.

**B. False positives — link targets are canvas/base files, which exist**
- [[Wiki Map]] (6 refs) → `wiki/Wiki Map.canvas` ✓ exists
- [[dashboard.base]] (2 refs) → `wiki/meta/dashboard.base` ✓ exists
- [[claude-obsidian-presentation]] (1 ref) → `wiki/canvases/…canvas` ✓ exists
- No action. Obsidian resolves these; the flat `.md`-only scan can't.

**C. Cross-plugin links — target lives outside `wiki/` (in `skills/`, `docs/`, templates)**
- [[wiki-cli]], [[wiki-fold]] (×3), [[wiki-mode]] (×2), [[fold-template]],
  [[mcp-setup]], [[methodology-modes-guide]] (×2). These point at SKILL.md / doc /
  template files whose basenames don't match the link text, so they dead-end as
  wikilinks. Low priority (they sit in reference/fold pages describing the system).
  Fix options: convert to relative markdown links, or leave as intentional
  system-doc pointers.

**D. Intentional placeholder examples — leave as-is**
- [[Foo]], [[notes/Foo]] (×2), [[Three laws of motion]] — illustrative examples
  inside [[DragonScale Memory]] and [[Persistent Wiki Artifact]]. Flag only.

**E. Genuinely missing content pages (8 refs)**
- [[E-commerce SEO]] (×2, from [[Claude SEO]]), [[Claude Canvas]], [[Claude
  Obsidian]], [[Karpathy LLM Wiki Pattern]], [[Rankenstein]], [[wikilinks]],
  [[AI Marketing Hub Cover Images Canvas]] — mostly from the
  `2026-04-10-backlink-empire-session` note. Suggest: create stubs or drop the
  links. Needs judgement per link (some are one-off session references).

## Frontmatter Gaps

14 pages miss `created:` (mostly system/meta pages that predate the convention):
`index.md`, `log.md`, `hot.md`, `getting-started.md`, `dashboard.md`, both
`_index.md` files, and 6 `wiki/meta/` session notes. `retrieval-benchmark-v1.7.md`
also misses `tags`; `transport-fallback.md` + `methodology-modes.md` miss
`created`+`updated`/`tags`. **`tiling-report-2026-04-24.md` has no frontmatter at
all** (it's a generated report — acceptable, or add a minimal block). Safe to
backfill `created` from git first-commit dates or file mtime.

## Address Validation (DragonScale M2)

- Counter state (`.vault-meta/address-counter.txt`): 3
- Only [[DragonScale Memory]] carries `c-000001`. All other content pages predate
  the 2026-04-23 rollout baseline → **legacy, backfill not required** (informational).
- No format errors, no collisions, no counter drift observed.

## Semantic Tiling (DragonScale M3)

- Skipped: requires local ollama + `nomic-embed-text`. `obsidian`/ollama not
  provisioned on this host. Re-run `./scripts/tiling-check.py --report` where
  ollama is available.

## Recommended fix set (awaiting go)

Safe / high-value:
1. Fix [[index]] header counts + `updated` date (→ 49 pages, 1 source, 2026-07-15).
2. Add a `References` section to [[index]] listing `transport-fallback` +
   `methodology-modes` (de-orphans both).
3. Strip `?` from the 4 [[How does the LLM Wiki pattern work?]] wikilinks.

Needs your call:
4. Backfill missing `created:` frontmatter (from git/mtime).
5. Category E missing pages: create stubs vs. drop links (per-link judgement).
6. Category C cross-plugin links: convert to markdown links vs. leave.
