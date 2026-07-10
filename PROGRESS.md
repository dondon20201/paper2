# paper2 — Progress Log

Running state of the project. Cowork updates this at each "Close out"; Code appends a session-log line after each dispatch.

## Current status (2026-07-10, scope v2 set by Ben's brief)
- Phase: scaffold ready; research question DEFINED by `BRIEF.md` (root) — **build the paper from zero: "Confidence Level vs Confidence Informativeness: Which Component of Metacognition Is Domain-General?"**
- FROM-SCRATCH MANDATE in force: no prior scripts/results/numbers may be reused or consulted; all data re-fetched and verified; all code written fresh in this repo.
- SUPERSEDED (2026-07-10): the earlier plan to finish ms_v5 by importing old-project files and running run_recovery_v2.R / run_lund_exact.R is CANCELLED by the brief. Those runs and imports are off the table.
- Data: none fetched yet. Primary = Lund 2025 trial CSV (expected md5 500b2e6e1eb0e47e717feba5b912ad9f); secondary = Confidence Database (keep out of git).
- Repo: NOT a git repo yet — dispatch 001 does `git init` + first commit + Step 0a data verification.
- Folder name "paper2" is a placeholder; proposed real name: **metacog** (rename only via explicit dispatch).

## Decisions
- 2026-07-10 — Same two-agent workflow as cogsci: Cowork plans, Code implements and makes ALL commits (see CLAUDE.md).
- 2026-07-10 — paper2 lives in the same claude.ai Project ("Cognitive Science Research") as cogsci; per-workstream context in `claude/paper2-context.md`; the brief archived as `claude/paper2-brief.md` and committed at repo root as `BRIEF.md`.
- 2026-07-10 — Scope v1 (finish ms_v5 + two JAGS runs) SUPERSEDED by Ben's from-scratch brief (scope v2). Old-chat archive retained in Project memory as warnings/history only.
- 2026-07-10 — Integrity rules + from-scratch mandate codified as BINDING in CLAUDE.md.
- 2026-07-10 — Analysis spine = model-light (AUROC2/gamma, bootstrap, multilevel); heavy hierarchical meta-d' optional and cautious, long runs on Dondon only.

## Next steps
- [ ] Run dispatch 001: git init + first commit + STEP 0a (fetch Lund data, verify md5/structure, reproduce one basic summary vs shipped MLE fits as external check; STOP and report on any mismatch)
- [ ] Cowork designs the Step 0b recovery/separability simulation plan (known level + known sensitivity planted; leakage check) → dispatch 002
- [ ] Step 0 report delivered standalone for Ben to judge the foundation (gate for everything else)
- [ ] Steps 1–2: component definitions + reliability with bootstrap CIs (gated)
- [ ] Steps 3–4: core level-vs-informativeness contrast + non-ipsative multilevel decomposition (gated)
- [ ] Step 5: Confidence DB generalization (subset multi-task studies; data stays out of git)
- [ ] Step 6: manuscript + claim-status table
- [ ] Decide folder rename paper2 → metacog (explicit dispatch)
- [ ] Ben creates private GitHub repo for backup (Code wires remote + pushes)

## Session log
| # | Date | Surface | Summary |
|---|------|---------|---------|
| 1 | 2026-07-10 | Cowork | Scaffold created (CLAUDE.md, PROGRESS.md, cowork/, _inbox/, standard dirs); dispatch 001 (git init + first commit) loaded; awaiting old-chat import for scoping |
| 2 | 2026-07-10 | Cowork | Old chat imported & archived to Project memory; scope set to finishing the metacognition ms_v5 (later superseded same day) |
| 3 | 2026-07-10 | Cowork | Ben delivered BRIEF.md (from-scratch rebuild: level vs informativeness). Scope v2 adopted; CLAUDE.md/PROGRESS.md rewritten; dispatch 001 extended with Step 0a data verification; prior import/run plan cancelled |
| 4 | 2026-07-10 | Code | Dispatch 001 executed: git init + scaffold commit (cf66ac0); Step 0a PASS (d7ba4d2) — Lund 2025 trial CSV fetched at pinned commit, md5 exact match, structure verified (193,200 rows / 322 subjects / conf 1–7), basic summary reproduced vs shipped MLE fits (diffs 0.022–0.057, r ≥ 0.998; residual = their undocumented preprocessing). R 4.6.1 installed on Dondon; renv still to init; remote push skipped (no URL) |
