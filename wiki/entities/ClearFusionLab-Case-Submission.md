---
type: entity
title: "ClearFusionLab Case Submission App"
address: c-000010
created: 2026-07-18
updated: 2026-07-18
tags:
  - project
  - web-app
  - express
  - dental-lab
  - cross-project
status: current
related:
  - "[[Ringer]]"
  - "[[ringer-case-ux-v2-session-2026-07-18]]"
  - "[[Contract-First Parallel Split]]"
sources:
  - "[[ringer-case-ux-v2-session-2026-07-18]]"
---

# ClearFusionLab Case Submission App

**Type**: Web application (Node.js + Express, CommonJS, no frontend framework)
**Purpose**: Lets dental-practice front-desk staff submit lab cases to ClearFusionLab with zero training, and lab staff triage them.
**Repo**: `C:\Users\Poncho\Claude\Projects\Case Submission` (project `mvp-form/`). Separate from this vault; recorded here as a cross-project reference.

## Shape

- **Backend**: `mvp-form/server.js`, one Express app. Two submit lanes selected by `SUBMIT_TARGET`: a CRM lane (DLCPM `Cases/Add`) and a Hub lane (Digital Gateway `AddCase` + `AddCaseDocument`, which carries scan files). Live writes gated OFF by default (`DLCPM_CASE_WRITE_ENABLED` / `HUB_CASE_WRITE_ENABLED`).
- **Frontend**: originally a single static `public/index.html` (~1,476 lines, inline CSS + JS). The UX v2 work split it into `styles.css` + `app.js` + `staff.js` + feature files (`wizard`, `confirm`, `theme`, `staff`, `print`). No build step.
- **Deploy variant**: a `cloudflare/` wrapper runs the same Express app in a Cloudflare Container behind a Worker proxy (`cases.clearfusionlab.com`).
- **Tests**: `mvp-form/test/` via `node --test` (DLCPM fully stubbed, no live calls). Went from 62 to 110 tests during UX v2.

## UX v2 (2026-07-18)

The current frontend and staff surfaces were rebuilt via a [[Ringer]] verified swarm. See [[ringer-case-ux-v2-session-2026-07-18]] for the full account and [[Contract-First Parallel Split]] for the split technique that made parallel work possible: a section stepper, token-driven visual system with dark mode, upgraded staff intake dashboard, printable confirmation slip, and additive server config/email enablers. Server validation, submit lanes, idempotency, and write gates were left untouched.

## Notable Constraints

- No PHI in logs, localStorage, or emails beyond the existing audit policy.
- Server-side validation is authoritative; client changes are presentation only.
- Ships as static files plus one Express app; the zero-build single-file-ish frontend is a deliberate deployment choice.
