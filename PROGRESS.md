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
- [x] Dispatch 004: Step 0b″ FINAL gate round — **GATE PASSED, NARROW** (results/STEP0B2_FINAL_REPORT.md): calibrated d′-partialed parcel-latent estimator passes all criteria at 200/200 (blind fresh-seed evaluation; CI honesty verified); 200/100 borderline-fails (by 0.011, main seed decisive), 100/100 fails clearly. **STEP 0 CLOSED.** Confirmatory pair: memory×vision only; other pairs descriptive with bias bands
- [x] Dispatch 005: Steps 1–2 REALDATA + transfer check — **006 CLEARED** (results/step2_REALDATA_transfer_check.md): real parcel reliabilities exceed simulation (memory 3.1×, vision 1.5× — conservative direction); level reliability 0.95–0.99 vs AUROC2 0.39–0.84; trials-needed for rel .7: level 7–15 vs AUROC2 ~110 (memory) / ~360 (vision); d′ split-half NEGATIVE outside memory (staircase artifact, documented). **FIREWALL HELD: no cross-domain quantity computed yet.**
- [ ] Dispatch 006: the confirmatory memory×vision thesis test (single shot, corrected d′-partialed parcel CFA per locked design) — cleared to dispatch
- [ ] Descriptive tier (other 5 pairs, bias bands) + Step 4 multilevel decomposition — after 006
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
| 7 | 2026-07-10 | Code | Dispatch 004 executed: Step 0b″ FINAL round (375770e; reports 67f3c40) — calibration (train) + blind fresh-seed evaluation (test) at 3 configs incl. 100/100. **GATE PASSED, NARROW** per pre-declared tree: 200/200 passes all criteria (CI honesty verified, coverage 28–30/30); 200/100 borderline-fails (−0.081 vs ±0.07, passes spot seed — main seed decisive); 100/100 fails clearly. **STEP 0 CLOSED**; Step 1+ design locked (STEP0B2_FINAL_REPORT.md §3). Remote push skipped (no URL, 4th reminder) |
| 8 | 2026-07-10 | Code | Dispatch 005 executed: Steps 1–2 REALDATA (77254c1) — measurement layer (exclusions ≤1.6%), reliabilities w/ CIs (level .95–.99; AUROC2 .84/.59/.47/.39; d′ NEGATIVE outside memory — staircase artifact), trials-needed curves (level 7–15 vs AUROC2 ~110/~360 for rel .7), transfer check → **006 CLEARED** (real parcel rel 1.5–3.1× sim, conservative). Firewall held — zero cross-domain quantities. Remote push skipped (no URL, 5th ask) |
