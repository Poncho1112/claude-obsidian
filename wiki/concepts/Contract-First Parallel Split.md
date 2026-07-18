---
type: concept
title: "Contract-First Parallel Split"
address: c-000012
complexity: intermediate
domain: software-architecture
aliases:
  - "Frozen Contract Split"
  - "Split-then-Swarm"
created: 2026-07-18
updated: 2026-07-18
tags:
  - concept
  - multi-agent
  - refactoring
  - parallelism
status: developing
related:
  - "[[Verified Swarm Delegation]]"
  - "[[Ringer]]"
  - "[[ringer-case-ux-v2-session-2026-07-18]]"
sources:
  - "[[ringer-case-ux-v2-session-2026-07-18]]"
---

# Contract-First Parallel Split

A technique for making a single large file safe for many parallel workers: first split it into disjoint files under a **frozen contract**, then let independent workers each own a file. It converts a serialization bottleneck (everyone must edit one monolith) into a fan-out.

## The Problem

Parallel [[Verified Swarm Delegation]] requires disjoint file ownership: two workers editing the same file collide. A monolithic file (a 1,476-line `index.html` holding all markup, CSS, and JS) makes parallelism impossible. You cannot split ownership of one file across workers.

## The Move

Sequence the work into rounds:

1. **Round 0, one worker, mechanical split.** Move the CSS into `styles.css`, the JS into `app.js`, extract sub-features into their own files (`staff.js`, `wizard.js`, ...). Behavior-preserving; no redesign. This one worker also establishes the **contract**.
2. **Freeze the contract.** The contract is the machine-checkable interface later workers build against, and nothing else may change it:
   - **Mount points**: empty, uniquely-id'd DOM anchors (`#wizardRail`, `#staffToolbar`, `#confirmActions`) where later features attach.
   - **Events**: a small set of custom events the base dispatches (`cfl:submitted`, `cfl:form-shown`, `cfl:draft-resumed`) so additive layers hook behavior without editing the base.
   - **Shared names**: design tokens, global helper function names, agreed CSS class names (`.skeleton`, `.step-hidden`).
3. **Round 1, N workers in parallel.** Each owns one new file and builds against the frozen contract. Ownership is disjoint, so there are no collisions. Features feature-detect their mounts and bail silently if absent, keeping every layer independently droppable.

## Why It Works

- The contract is small, explicit, and verifiable by a check (grep for the mount ids, the event strings, the token names).
- Additive layers never touch the base or each other, so a failed or reverted worker cannot corrupt a sibling's work.
- The split itself is low-risk because it is mechanical and behavior-preserving, verified by the existing test suite plus a structural check that the inline blocks are gone and the new files are wired.

## Cost and When To Skip

The split round is pure overhead if only one worker will ever touch the file. Reach for this only when the payoff (parallel workers, independently revertible layers) is real. For a single-file, few-line change, edit it directly.

## Connections

See [[Verified Swarm Delegation]] for the delegation pattern this enables.
See [[Ringer]] for the worktrees mechanism that keeps each worker's edits isolated on disk.
See [[ringer-case-ux-v2-session-2026-07-18]] for the worked example (WP1 froze the contract; WP2 through WP6 built against it in parallel).
