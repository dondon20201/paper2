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
- [x] Dispatch 001: git init + STEP 0a — PASSED (md5 exact, structure verified)
- [x] Dispatch 002: STEP 0b recovery/separability simulation — **GATE FAILED** (see results/STEP0_REPORT.md): level measurement validated (r 0.99, no leakage), but AUROC2 recovery 0.59 < 0.7 at 200 trials, gamma leaks set-point (r −0.18), and the null scenario produces a spurious raw level-vs-sensitivity gap (raw Step-3 contrast invalid as designed)
- [x] Dispatch 003: Step 0b′ latent-estimator gate — **FAILED per preregistration, narrowly** (results/STEP0B_PRIME_REPORT.md): d′-partialed parcel CFA passes ALL criteria at 200/200 but misses null-gap bias at 200/100 by 0.012 (+0.082 vs ±0.07, replicated seed 2); d′-partialing now mandatory for any sensitivity claim (raw latent converts d′ correlation into spurious ρ_sens); 0% non-convergence in 480 fits
- [ ] **DECISION NEEDED (Ben/Cowork):** path forward — (1) floor reframe (level + measurement-limits + two spurious-gap demos), (2) one more preregistered gate round with bias-corrected latent estimator incl. 100/100 config, or (3) scope-restricted design (strong claims from 200/200 pair only, bias bands elsewhere)
- [ ] Ben reads results/STEP0_REPORT.md + STEP0B_PRIME_REPORT.md and rules on direction
- [ ] Steps 1–2: component definitions + reliability with bootstrap CIs (gated — do not start)
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
| 5 | 2026-07-10 | Code | Dispatch 002 executed: renv init (655bcb2); Step 0b simulation (252dd48) — **GATE FAILED** per preregistered criteria (3d80ec7 = STEP0_REPORT.md): level recovery 0.99/no leakage PASS, but AUROC2 recovery 0.59 < 0.7 @200 trials (reliability-capped, not a bug — exact vs brute force, 0.82 @5000 trials), gamma leaks set-point (−0.18), null scenario yields spurious raw gap 0.27–0.31 (raw Step-3 contrast invalid). Steps 1+ blocked pending Step 0b′ design; remote push skipped (no URL) |
| 6 | 2026-07-10 | Code | Dispatch 003 executed: Step 0b′ latent gate (819a149; report 4086ce9) — **FAILED per prereg, narrowly**: d′-partialed exchangeable-parcel CFA (0% bad in 480 fits) passes all criteria @200/200, fails only NULL-gap bias @200/100 (+0.082 vs ±0.07, seed-2 +0.096); raw variant fails DCONF (d′→spurious ρ_sens 0.10) so d′-partialing now mandatory; 002 trait-deviation explained benign (99.2th pctile draw). Decision needed: floor reframe vs bias-corrected round-2 vs scope-restriction. Remote push skipped (no URL) |
