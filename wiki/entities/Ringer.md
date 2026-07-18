---
type: entity
title: "Ringer"
address: c-000009
created: 2026-07-18
updated: 2026-07-18
tags:
  - tool
  - multi-agent
  - orchestration
  - verified-swarm
  - cli
status: current
related:
  - "[[Verified Swarm Delegation]]"
  - "[[Contract-First Parallel Split]]"
  - "[[ringer-case-ux-v2-session-2026-07-18]]"
sources:
  - "[[ringer-case-ux-v2-session-2026-07-18]]"
---

# Ringer

**Type**: Verified-swarm delegation tool (`ringer.py`)
**Interface**: CLI plus a live web dashboard ("Ringside") at `http://127.0.0.1:8700`
**Role**: Runs manifest-defined tasks in parallel across cheap CLI workers and verifies every task by executing a check command. The orchestrating model pays tokens only for specs, orchestration, and review; workers do the typing.

## Core Model

A **manifest** (JSON) lists tasks. Each task has a self-contained `spec` (the worker brief), an executable `check` (exit 0 is the only PASS), a `task_type`, an `engine`/`model`, and optional `expect_files`. Ringer spawns a worker per task, runs the check, and retries a failed task once with the check's actual failure output injected into the retry prompt. See [[Verified Swarm Delegation]] for the pattern.

- **The check is the product.** Checks must execute the artifact (run the build, run tests, grep required content) and print WHY they fail. `true`/`exit 0`/`echo done` are forbidden.
- **A single task is a one-task manifest.** No task is "too small for Ringer"; that thought is the trigger to write a manifest.
- **Runs are watched, not hidden.** Ringside goes on screen before work starts.

## Engines

Engines are config blocks (`[engines.<name>]`); the model is a per-task manifest field. Codex ships its own first-class harness; everything else runs through the `opencode` engine with the OpenRouter model in the task's `model` field. A local scoreboard (`ringer.py models`) aggregates every executed-check outcome per (model, task_type); `first_try_pass_rate` is the routing signal.

- **codex** (default): strongest general worker.
- **opencode**: universal lane, any OpenRouter model (default GLM 5.2).

## Worktrees Mode

`"worktrees": true` gives each task an isolated git worktree detached at HEAD. Consequences learned the hard way: passing tasks get their worktree deleted (deliverables must land outside, or the check exports a patch first); worker commits die with the worktree (workers leave changes uncommitted; the check runs `git add -A && git diff --cached > out.patch`); gitignored outputs vanish from patch exports. See [[Contract-First Parallel Split]] for how a single repo is partitioned across worktrees safely.

## On This Host

Runs inside WSL Ubuntu (`~/ringer/`), invoked as `wsl -e bash -lc 'cd ~/ringer && ./ringer.py <args>'`. Ringside is reachable from Windows browsers via WSL localhost forwarding.

## Template Library

Named patterns (`templates/`) cover the common swarm shapes: review-swarm, fix-swarm, focus-group, bakeoff, research-with-proof, repo-feature, migration-swarm, probe, and more. The pattern is chosen before a manifest is written.

## First Use in This Vault's Record

See [[ringer-case-ux-v2-session-2026-07-18]]: a 7-work-package UX overhaul routed through Ringer across two rounds. Codex went 6/6; a GLM audition lane never executed (OpenRouter credit exhaustion).
