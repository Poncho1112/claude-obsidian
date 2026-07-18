---
type: source
title: "Ringer-Routed Case Submission UX v2 Session"
address: c-000008
created: 2026-07-18
updated: 2026-07-18
tags:
  - session
  - ringer
  - verified-swarm
  - multi-agent
  - cross-project
status: current
related:
  - "[[Ringer]]"
  - "[[ClearFusionLab-Case-Submission]]"
  - "[[Verified Swarm Delegation]]"
  - "[[Contract-First Parallel Split]]"
raw_file: "(session, not a .raw file)"
---

# Source: Ringer-Routed Case Submission UX v2 Session

**Type**: Working session (cross-project reference)
**Date**: 2026-07-18
**Repo worked**: ClearFusionLab Case Submission (`C:\Users\Poncho\Claude\Projects\Case Submission`), a separate project from this vault.
**Orchestrator**: Claude Fable 5. **Workers**: Codex (GPT-5.5) and one GLM 5.2 audition lane, routed through [[Ringer]].

## Summary

A "dramatically improve the UX" request on a dental-lab case-submission web app, executed entirely as [[Ringer]] manifests rather than hand-editing. The orchestrator wrote specs and executable checks; parallel sandboxed workers typed the code. The single monolithic 1,476-line `public/index.html` was split into separate files under a frozen contract (see [[Contract-First Parallel Split]]), after which five workers edited disjoint files in parallel. Result: shipped in two Ringer rounds plus a re-route, merged as PR #3, verified 110/110 tests.

## What was built (7 work packages)

- WP1: split `index.html` into `styles.css` + `app.js` + `staff.js` + six stub files; froze the contract (mount points `#wizardRail` / `#staffToolbar` / `#confirmActions`, three `cfl:*` CustomEvents, shared tokens).
- WP7: additive `/api/config` keys + rush/impression email lines + new tests (server lane, ran parallel to WP1).
- WP2: product-row combobox ARIA, inline favorite naming (removed `prompt()`/`alert()`), aria-live toast, autosave status, skeletons.
- WP3: additive "section stepper" over the five form sections plus a Review step; feature-detected, no new submit handlers.
- WP4: staff intake dashboard (filter chips with live counts, search, refresh, relative times, per-row save/retry). GLM audition lane; re-routed to Codex.
- WP5: token-driven visual system, dark mode via `prefers-color-scheme`, mobile 16px inputs, sticky safe-area submit bar.
- WP6: structured confirmation summary and a print-only one-page lab slip.

## Key Findings

1. **The prior UX backlog was already shipped.** Reading git first showed the repo's own `UX_IMPROVEMENTS.md` had landed in an earlier commit; "dramatic improvement" therefore meant a v2 redesign, not wiring unused APIs. Read history before planning.
2. **Contract-first split unlocks parallelism.** One monolith file cannot host parallel workers. Splitting it once and freezing a machine-readable contract (mounts + events + tokens) let five workers own disjoint files with zero collisions. See [[Contract-First Parallel Split]].
3. **Codex was the reliable code-feature lane: 6/6 passed.** GLM 5.2's audition never executed (OpenRouter `402 Insufficient credits`), which is not a capability signal and must not trigger a demotion.
4. **Two "failures" were harness artifacts, not worker defects.** The sandbox blocks Express `listen()` with `EPERM`, so any in-worktree check that boots the server reads as FAIL even when the code is correct; verify server lanes by applying the patch and testing outside the sandbox. A worker test run also leaked `data/*.json` runtime artifacts into the exported patch (filter on apply).
5. **Stale git worktrees cause instant phantom errors.** A re-run that ERRORs at ~0 tokens / 0.0s is almost always a `git worktree add` collision with a leftover worktree; `git worktree prune` + `remove --force` clears it. This cost two wasted attempts before diagnosis.

## Pages Created from This Source

- [[Ringer]] entity page
- [[ClearFusionLab-Case-Submission]] entity page
- [[Verified Swarm Delegation]] concept page
- [[Contract-First Parallel Split]] concept page

## Relevance to This Vault

This vault's own tooling faces the same multi-writer problem Ringer solves: the `wiki-ingest` sub-agents write pages in parallel and rely on `wiki-lock` advisory locking for safety. Ringer's disjoint-ownership + executed-check discipline is a stricter cousin of that pattern. See [[Verified Swarm Delegation]] for the connection.
