---
type: concept
title: "Verified Swarm Delegation"
address: c-000011
complexity: intermediate
domain: multi-agent
aliases:
  - "Verified Swarm"
  - "Ringer Pattern"
created: 2026-07-18
updated: 2026-07-18
tags:
  - concept
  - multi-agent
  - orchestration
  - verification
status: developing
related:
  - "[[Ringer]]"
  - "[[Contract-First Parallel Split]]"
  - "[[ringer-case-ux-v2-session-2026-07-18]]"
sources:
  - "[[ringer-case-ux-v2-session-2026-07-18]]"
---

# Verified Swarm Delegation

A delegation pattern where an orchestrating model spawns many cheap workers in parallel and trusts none of them: every unit of work is verified by **executing a check command**, and exit 0 is the only definition of PASS. The orchestrator's job is specs, checks, routing, and review. The workers type. Implemented by [[Ringer]].

## The Two Roles

- **Orchestrator (expensive model)**: writes a self-contained brief per task, writes an executable check, picks the worker engine, reads results, integrates. Pays tokens only for this.
- **Worker (cheap CLI model)**: reads the brief, edits files, leaves changes uncommitted. Stateless; cannot ask questions, so the brief must be complete.

The separation is the point: the same worker never both finds and fixes an issue, and no result is believed until a check executes the artifact.

## Why "Verified"

The check is the product, not the prose. A trustworthy check:

- **Executes the artifact.** Runs the build, runs the tests, greps the file for required content, runs the produced code. Existence (`test -f`) is not correctness.
- **Prints why it fails.** The failure text feeds both the human review and the automatic single retry (the retry prompt is re-issued with the check's actual output injected).
- **Is strict on substance, tolerant on format.** Verify what must be TRUE; use flexible matching for structure. A wall of format-nitpick failures reads as a broken system, not a careful one.
- **Can actually fail.** `true` / `exit 0` / `echo done` are banned. A check that cannot fail is just trust with extra steps.

## Failure Modes Observed

From [[ringer-case-ux-v2-session-2026-07-18]]:

- **Environment false-negatives.** A sandbox that blocks `listen()` (`EPERM`) fails any check that boots a server, even when the code is correct. Fix the check (syntax + structural asserts in-sandbox; run the real suite outside), not the worker.
- **Artifact leakage.** A worker's own test run can create runtime files (`data/*.json`) that get swept into `git add -A` and pollute the exported patch. The check must clean them, or the integrator filters on apply.
- **Phantom instant errors.** A stale git worktree makes a re-run die at ~0 tokens with an ERROR verdict (worktree-add collision), which masquerades as an engine outage. Prune worktrees before retrying.
- **Aborted auditions are not signals.** A worker that never executes (for example an OpenRouter `402`) teaches the scoreboard nothing and must not be recorded as a capability failure.

## Relation to This Vault

The vault's own `wiki-ingest` runs parallel sub-agents that write pages concurrently, guarded by `wiki-lock` advisory locking (per-file, age-based staleness). That is the same multi-writer safety problem, solved with locking instead of disjoint-ownership manifests. Verified Swarm Delegation is the stricter cousin: instead of locking a shared tree, it partitions ownership up front (see [[Contract-First Parallel Split]]) and gates every result on an executed check.

## Connections

See [[Ringer]] for the tool that implements this.
See [[Contract-First Parallel Split]] for how a single shared file is made safe for parallel workers.
See [[Compounding Knowledge]] for the analogous idea that verified, durable artifacts beat ephemeral output.
